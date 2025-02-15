#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages(p: [ p.requests ])"

import argparse
from dataclasses import dataclass
from datetime import datetime, timezone, timedelta
import requests
from urllib.parse import quote_plus
from typing import List, Dict, Optional
import sys
import logging
import argparse
from contextlib import redirect_stdout


@dataclass
class GitHubIssue:
    title: str
    url: str
    created_at: datetime


@dataclass
class ChannelRevision:
    channel: str
    revision: str
    status: str
    github_url: str


@dataclass
class ChannelUpdate:
    channel: str
    timestamp: datetime


@dataclass
class HydraJob:
    channel: str
    project: str
    jobset: str
    job: str
    history: List[bool]
    hydra_url: str
    current: bool


@dataclass
class CombinedChannelData:
    channel: str
    revision: str
    short_revision: str
    github_url: str
    status: str
    update_time: datetime
    update_age: str
    hydra_job: HydraJob
    status_labels: List[str]


class GitHubClient:
    def __init__(self, base_url: str = "https://api.github.com"):
        self.base_url = base_url

    def fetch_channel_blockers(self, repo: str = "NixOS/nixpkgs") -> List[GitHubIssue]:
        url = f"{self.base_url}/repos/{repo}/issues"
        params = {"labels": "1.severity: channel blocker"}
        response = requests.get(url, params=params)
        response.raise_for_status()
        return [
            GitHubIssue(
                title=issue["title"],
                url=issue["html_url"],
                created_at=datetime.fromisoformat(
                    issue["created_at"].rstrip("Z")
                ).astimezone(timezone.utc),
            )
            for issue in response.json()
        ]


class PrometheusClient:
    def __init__(self, base_url: str = "https://prometheus.nixos.org/api/v1"):
        self.base_url = base_url

    def _query(self, endpoint: str, params: Dict) -> List[Dict]:
        url = f"{self.base_url}/{endpoint}"
        response = requests.get(url, params=params)
        response.raise_for_status()
        return response.json()["data"]["result"]

    def get_channel_revisions(self) -> List[ChannelRevision]:
        result = self._query("query", {"query": "channel_revision"})
        return [
            ChannelRevision(
                channel=metric["metric"]["channel"],
                revision=metric["metric"]["revision"],
                status=metric["metric"].get("status", ""),
                github_url=f"https://github.com/NixOS/nixpkgs/commit/{metric['metric']['revision']}",
            )
            for metric in result
        ]

    def get_channel_updates(self) -> List[ChannelUpdate]:
        result = self._query("query", {"query": "channel_update_time"})
        updates = []
        for metric in result:
            try:
                timestamp = datetime.fromtimestamp(
                    float(metric["value"][1]), tz=timezone.utc
                )
                updates.append(
                    ChannelUpdate(
                        channel=metric["metric"]["channel"], timestamp=timestamp
                    )
                )
            except (KeyError, ValueError):
                continue
        return updates

    def get_hydra_jobs(self, days: int = 30) -> List[HydraJob]:
        now = datetime.now(timezone.utc)
        start = now - timedelta(days=days)
        params = {
            "query": "hydra_job_failed",
            "start": start.isoformat(),
            "end": now.isoformat(),
            "step": "1h",
        }
        result = self._query("query_range", params)
        jobs = []
        for metric in result:
            try:
                jobs.append(
                    HydraJob(
                        channel=metric["metric"]["channel"],
                        project=metric["metric"]["project"],
                        jobset=metric["metric"]["jobset"],
                        job=metric["metric"]["exported_job"],
                        history=[float(val[1]) == 0 for val in metric["values"]],
                        hydra_url=f"https://hydra.nixos.org/job/{metric['metric']['project']}/"
                        f"{metric['metric']['jobset']}/{metric['metric']['exported_job']}#tabs-constituents",
                        current=metric["metric"].get("current", "0") == "1",
                    )
                )
            except KeyError:
                continue
        return jobs


class ChannelAnalyzer:
    @staticmethod
    def normalize_channel(channel: str) -> str:
        parts = channel.split("-")
        return (
            f"{parts[1]}-{parts[0]}-{'-'.join(parts[2:])}"
            if len(parts) > 1
            else channel
        )

    @staticmethod
    def get_relative_time(dt: datetime) -> str:
        now = datetime.now(timezone.utc)
        diff = now - dt
        if diff.days > 0:
            return f"{diff.days} days ago"
        secs = diff.seconds
        if secs >= 3600:
            return f"{secs//3600} hours ago"
        if secs >= 60:
            return f"{secs//60} minutes ago"
        return f"{secs} seconds ago"

    @staticmethod
    def combine_data(
        revisions: List[ChannelRevision],
        updates: List[ChannelUpdate],
        hydra_jobs: List[HydraJob],
    ) -> List[CombinedChannelData]:
        combined = []
        rev_map = {rev.channel: rev for rev in revisions}
        update_map = {upd.channel: upd for upd in updates}
        job_map = {job.channel: job for job in hydra_jobs}

        common_channels = (
            set(rev_map.keys()) & set(update_map.keys()) & set(job_map.keys())
        )

        for channel in common_channels:
            rev = rev_map[channel]
            upd = update_map[channel]
            job = job_map[channel]

            status_labels = []
            if rev.status:
                status_labels.append(rev.status.capitalize())

            if job.history and not job.history[-1] and rev.status != "unmaintained":
                status_labels.append("Build problem")

            combined.append(
                CombinedChannelData(
                    channel=channel,
                    revision=rev.revision,
                    short_revision=rev.revision[:12],
                    github_url=rev.github_url,
                    status=rev.status,
                    update_time=upd.timestamp,
                    update_age=ChannelAnalyzer._calculate_update_age(upd.timestamp),
                    hydra_job=job,
                    status_labels=status_labels,
                )
            )

        return sorted(
            combined,
            key=lambda x: ChannelAnalyzer.normalize_channel(x.channel),
            reverse=True,
        )

    @staticmethod
    def _calculate_update_age(timestamp: datetime) -> str:
        now = datetime.now(timezone.utc)
        age = now - timestamp
        if age < timedelta(days=3):
            return "success"
        if age < timedelta(days=10):
            return "warning"
        return "important"


class ReportGenerator:
    @staticmethod
    def print_report(combined_data: List[CombinedChannelData]):
        header = (
            f"{'Channel':<20} {'Updated':<20} {'Revision':<15} {'Hydra Job':<30} Status"
        )
        print(header)
        print("-" * len(header))
        for data in combined_data:
            job_str = (
                f"{data.hydra_job.project}/{data.hydra_job.jobset}/{data.hydra_job.job}"
            )
            print(
                f"{data.channel:<20} "
                f"{ChannelAnalyzer.get_relative_time(data.update_time):<20} "
                f"{data.short_revision:<15} "
                f"{job_str:<30} "
                f"{', '.join(data.status_labels)}"
            )


def main():

    parser = argparse.ArgumentParser(
        description="Tool to analyze Nix channels and GitHub issues, generating a detailed report."
    )
    subparsers = parser.add_subparsers(
        dest="command", required=True, help="Sub-commands"
    )

    # Subcommand: issues – fetch and display GitHub channel blockers
    issues_parser = subparsers.add_parser(
        "issues", help="Fetch and display GitHub channel blockers (issues)"
    )
    issues_parser.add_argument(
        "--github-url",
        default="https://api.github.com",
        help="Base URL for GitHub API (default: %(default)s)",
    )
    issues_parser.add_argument(
        "--repo",
        default="NixOS/nixpkgs",
        help="Repository to fetch issues from (default: %(default)s)",
    )
    issues_parser.add_argument(
        "--limit",
        type=int,
        default=10,
        help="Maximum number of issues to display (default: %(default)s)",
    )

    # Subcommand: channels – fetch and display channels report
    channels_parser = subparsers.add_parser(
        "channels", help="Fetch and display channels report from Prometheus"
    )
    channels_parser.add_argument(
        "--prometheus-url",
        default="https://prometheus.nixos.org/api/v1",
        help="Base URL for Prometheus API (default: %(default)s)",
    )
    channels_parser.add_argument(
        "--days",
        type=int,
        default=30,
        help="Number of days to look back for Hydra jobs (default: %(default)s)",
    )
    channels_parser.add_argument(
        "--filter-channel",
        type=str,
        help="Only include channels containing this substring",
    )

    # Subcommand: all – run both issues and channels reports
    all_parser = subparsers.add_parser(
        "all", help="Fetch and display both GitHub issues and channels report"
    )
    all_parser.add_argument(
        "--github-url",
        default="https://api.github.com",
        help="Base URL for GitHub API (default: %(default)s)",
    )
    all_parser.add_argument(
        "--repo",
        default="NixOS/nixpkgs",
        help="Repository to fetch issues from (default: %(default)s)",
    )
    all_parser.add_argument(
        "--prometheus-url",
        default="https://prometheus.nixos.org/api/v1",
        help="Base URL for Prometheus API (default: %(default)s)",
    )
    all_parser.add_argument(
        "--days",
        type=int,
        default=30,
        help="Number of days to look back for Hydra jobs (default: %(default)s)",
    )
    all_parser.add_argument(
        "--filter-channel",
        type=str,
        help="Only include channels containing this substring",
    )
    all_parser.add_argument(
        "--limit",
        type=int,
        default=10,
        help="Maximum number of issues to display (default: %(default)s)",
    )

    # Global options
    parser.add_argument(
        "--verbose", action="store_true", help="Enable verbose logging for debugging"
    )
    parser.add_argument(
        "--output",
        type=str,
        help="Write output to the specified file instead of stdout",
    )

    args = parser.parse_args()

    # Configure logging
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)
        logging.debug("Verbose mode enabled")
    else:
        logging.basicConfig(level=logging.INFO)

    # Prepare the output stream
    out_stream = open(args.output, "w") if args.output else sys.stdout

    if args.command == "issues":
        github_client = GitHubClient(args.github_url)
        try:
            issues = github_client.fetch_channel_blockers(repo=args.repo)
            issues = issues[: args.limit]
            with redirect_stdout(out_stream):
                print("GitHub Issues:")
                for issue in issues:
                    print(f"- {issue.title} ({issue.url})")
        except Exception as e:
            with redirect_stdout(out_stream):
                print(f"Error fetching GitHub issues: {e}")

    elif args.command == "channels":
        prometheus_client = PrometheusClient(args.prometheus_url)
        try:
            revisions = prometheus_client.get_channel_revisions()
            updates = prometheus_client.get_channel_updates()
            hydra_jobs = prometheus_client.get_hydra_jobs(args.days)
            combined = ChannelAnalyzer.combine_data(revisions, updates, hydra_jobs)
            if args.filter_channel:
                combined = [
                    data for data in combined if args.filter_channel in data.channel
                ]
            with redirect_stdout(out_stream):
                ReportGenerator.print_report(combined)
        except Exception as e:
            with redirect_stdout(out_stream):
                print(f"Error processing channel data: {e}")

    elif args.command == "all":
        github_client = GitHubClient(args.github_url)
        prometheus_client = PrometheusClient(args.prometheus_url)
        with redirect_stdout(out_stream):
            print("GitHub Issues:")
        try:
            issues = github_client.fetch_channel_blockers(repo=args.repo)
            issues = issues[: args.limit]
            with redirect_stdout(out_stream):
                for issue in issues:
                    print(f"- {issue.title} ({issue.url})")
        except Exception as e:
            with redirect_stdout(out_stream):
                print(f"Error fetching GitHub issues: {e}")

        with redirect_stdout(out_stream):
            print("\nChannels Report:")
        try:
            revisions = prometheus_client.get_channel_revisions()
            updates = prometheus_client.get_channel_updates()
            hydra_jobs = prometheus_client.get_hydra_jobs(args.days)
            combined = ChannelAnalyzer.combine_data(revisions, updates, hydra_jobs)
            if args.filter_channel:
                combined = [
                    data for data in combined if args.filter_channel in data.channel
                ]
            with redirect_stdout(out_stream):
                ReportGenerator.print_report(combined)
        except Exception as e:
            with redirect_stdout(out_stream):
                print(f"Error processing channel data: {e}")

    if args.output:
        out_stream.close()


if __name__ == "__main__":
    main()


def api_usage_example_1():
    from . import (
        GitHubClient,
        PrometheusClient,
        ChannelAnalyzer,
        ReportGenerator,
    )

    # Example usage in another script
    github = GitHubClient()
    prometheus = PrometheusClient()

    issues = github.fetch_channel_blockers()
    revisions = prometheus.get_channel_revisions()
    updates = prometheus.get_channel_updates()
    jobs = prometheus.get_hydra_jobs(60)

    combined = ChannelAnalyzer.combine_data(revisions, updates, jobs)
    ReportGenerator.print_report(combined)
