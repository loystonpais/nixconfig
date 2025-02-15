#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages(p: [p.requests])"

"""
A Python script that fetches channel information from GitHub and Prometheus,
combines the data, and displays a summary table on the terminal.

The script performs the following tasks:
  - Fetches GitHub issues for channels with a "channel blocker" severity.
  - Fetches channel revision data and update times from Prometheus.
  - Fetches a history of Hydra job failure statuses over time.
  - Combines the data (only for channels present in all datasets).
  - Determines if the latest Hydra job status is a failure (a build problem)
    unless the channel is marked as "unmaintained".
  - Prints a summary table showing channel, update time (relative), short revision,
    Hydra job identifier, and status labels.
  
Usage:
  python script.py [--prometheus-url URL] [--github-issues-url URL] [--days N]
  
For example, to look back 30 days (the default) and use the default endpoints:
  python script.py
"""

import argparse
import requests
import datetime
from datetime import timezone, timedelta
from urllib.parse import quote_plus
import sys


def get_relative_time(dt):
    """Return a simple relative time string (e.g. '3 days ago')."""
    now = datetime.datetime.now(timezone.utc)
    diff = now - dt
    seconds = diff.total_seconds()
    if seconds < 60:
        return f"{int(seconds)} seconds ago"
    elif seconds < 3600:
        minutes = int(seconds // 60)
        return f"{minutes} minutes ago"
    elif seconds < 86400:
        hours = int(seconds // 3600)
        return f"{hours} hours ago"
    else:
        days = int(seconds // 86400)
        return f"{days} days ago"


def normalize_channel(channel):
    """
    Normalize a channel string by splitting on '-' and rearranging parts.
    Expected channel format: "collection-time[-qualifier]".
    Returns a string in the form "time-collection-qualifier".
    """
    parts = channel.split("-")
    collection = parts[0] if len(parts) > 0 else ""
    time_part = parts[1] if len(parts) > 1 else ""
    qualifier = parts[2] if len(parts) > 2 else ""
    return f"{time_part}-{collection}-{qualifier}"


def aggregate_by_channel(records):
    """Aggregate a list of dict records into a dict keyed by channel."""
    out = {}
    for rec in records:
        channel = rec.get("channel")
        out[channel] = rec["value"]
    return out


def fetch_issues(issues_url):
    """Fetch GitHub issues from the provided URL."""
    r = requests.get(issues_url)
    r.raise_for_status()
    return r.json()


def fetch_metrics(query_type, params, base_url):
    """
    Fetch metrics from Prometheus.
    
    query_type should be "query" or "query_range".
    params is a dict of query parameters.
    """
    # Build the query string
    qs = "&".join(f"{k}={v}" for k, v in params.items())
    url = f"{base_url}/{query_type}?{qs}"
    r = requests.get(url)
    r.raise_for_status()
    data = r.json()
    return data["data"]["result"]


def main():
    parser = argparse.ArgumentParser(
        description="Fetch channel info from Prometheus and GitHub and display a summary."
    )
    parser.add_argument(
        "--prometheus-url",
        default="https://prometheus.nixos.org/api/v1",
        help="Base URL for the Prometheus API",
    )
    parser.add_argument(
        "--github-issues-url",
        default="https://api.github.com/repos/NixOS/nixpkgs/issues?labels=1.severity%3A%20channel%20blocker",
        help="URL for the GitHub issues API",
    )
    parser.add_argument(
        "--days",
        type=int,
        default=30,
        help="How many days to look back for Hydra job failures (default: 30)",
    )
    args = parser.parse_args()

    # --- Fetch GitHub Issues ---
    try:
        issues = fetch_issues(args.github_issues_url)
        print("GitHub Issues (channel blockers):")
        for issue in issues:
            title = issue.get("title")
            url = issue.get("html_url")
            created_at = issue.get("created_at")
            print(f"  - {title} ({url}) [Created: {created_at}]")
    except Exception as e:
        print("Error fetching GitHub issues:", e, file=sys.stderr)

    # --- Prepare time range for Prometheus query_range ---
    now = datetime.datetime.now(timezone.utc)
    ideal_start = now - timedelta(days=args.days)
    earliest_start = datetime.datetime(2019, 12, 30, 1, 0, 0, tzinfo=timezone.utc)
    start = ideal_start if ideal_start > earliest_start else earliest_start
    end = now
    # Prometheus accepts RFC3339 or ISO8601 strings
    start_str = quote_plus(start.isoformat())
    end_str = quote_plus(end.isoformat())

    # --- Fetch revision data (channel_revision) ---
    try:
        revision_params = {"query": "channel_revision"}
        revision_records = fetch_metrics("query", revision_params, args.prometheus_url)
        revision_data = []
        for rec in revision_records:
            metric = rec.get("metric", {})
            channel = metric.get("channel")
            revision = metric.get("revision")
            if not channel or not revision:
                continue
            revision_data.append({
                "channel": channel,
                "revision": revision,
                "short_revision": revision[:12],
                "github_url": f"https://github.com/NixOS/nixpkgs/commit/{revision}",
                "status": metric.get("status"),
            })
        revision_by_channel = {d["channel"]: d for d in revision_data}
    except Exception as e:
        print("Error fetching revision data:", e, file=sys.stderr)
        revision_by_channel = {}

    # --- Fetch update time data (channel_update_time) ---
    try:
        update_params = {"query": "channel_update_time"}
        update_records = fetch_metrics("query", update_params, args.prometheus_url)
        update_data = []
        for rec in update_records:
            metric = rec.get("metric", {})
            channel = metric.get("channel")
            val = rec.get("value", [])
            if not channel or len(val) < 2:
                continue
            try:
                update_time = float(val[1])
            except ValueError:
                continue
            update_data.append({
                "channel": channel,
                "update_time": update_time,
            })
        update_by_channel = {d["channel"]: d for d in update_data}
    except Exception as e:
        print("Error fetching update time data:", e, file=sys.stderr)
        update_by_channel = {}

    # --- Fetch job failure history (hydra_job_failed) ---
    try:
        jobset_params = {
            "query": "hydra_job_failed",
            "start": start_str,
            "end": end_str,
            "step": "1h"
        }
        jobset_records = fetch_metrics("query_range", jobset_params, args.prometheus_url)
        jobset_data = []
        for rec in jobset_records:
            metric = rec.get("metric", {})
            channel = metric.get("channel")
            project = metric.get("project")
            jobset = metric.get("jobset")
            job = metric.get("exported_job")
            # "current" may be provided by Prometheus; interpret as a Boolean.
            current = metric.get("current") in [1, "1"]
            values = rec.get("values", [])
            # Create a history: True if the value equals 0 (i.e. build succeeded), False if not.
            job_history = [float(state[1]) == 0 for state in values]
            oldest_status = float(values[0][0]) if values else None
            jobset_data.append({
                "channel": channel,
                "current": current,
                "project": project,
                "jobset": jobset,
                "job": job,
                "job_history": job_history,
                "oldest_status": oldest_status,
                "hydra_url": f"https://hydra.nixos.org/job/{project}/{jobset}/{job}#tabs-constituents",
            })
        jobset_by_channel = {d["channel"]: d for d in jobset_data}
    except Exception as e:
        print("Error fetching jobset data:", e, file=sys.stderr)
        jobset_by_channel = {}

    # --- Combine the datasets ---
    combined = []
    for channel, jobset in jobset_by_channel.items():
        if channel not in revision_by_channel or channel not in update_by_channel:
            continue  # ensure complete data across all three sources
        combined_record = jobset.copy()
        # Add revision info
        rev = revision_by_channel[channel]
        combined_record.update({
            "revision": rev["revision"],
            "short_revision": rev["short_revision"],
            "github_url": rev["github_url"],
            "status": rev["status"],
        })
        # Add update time info (convert from UNIX timestamp)
        upd = update_by_channel[channel]
        upd_dt = datetime.datetime.fromtimestamp(upd["update_time"], tz=timezone.utc)
        combined_record.update({
            "update_time": upd_dt,
            "update_time_relative": get_relative_time(upd_dt),
            "update_time_local": upd_dt.isoformat(),
        })
        # Determine update_age based on recency (only for current channels)
        if combined_record.get("current"):
            if upd_dt > now - timedelta(days=3):
                combined_record["update_age"] = "success"
            elif upd_dt > now - timedelta(days=10):
                combined_record["update_age"] = "warning"
            else:
                combined_record["update_age"] = "important"
        else:
            combined_record["update_age"] = "unknown"
        # Compute oldest status relative time (if available)
        if combined_record.get("oldest_status"):
            oldest_dt = datetime.datetime.fromtimestamp(combined_record["oldest_status"], tz=timezone.utc)
            combined_record["oldest_status_relative"] = get_relative_time(oldest_dt)
        else:
            combined_record["oldest_status_relative"] = "unknown"
        combined.append(combined_record)

    # --- Sort the channels (using normalized channel string in descending order) ---
    combined.sort(key=lambda rec: normalize_channel(rec["channel"]), reverse=True)

    # --- Display the combined data as a table ---
    header = f"{'Channel':<20} {'Updated':<20} {'Revision':<15} {'Hydra Job':<30} Status"
    print("\nChannel Status:")
    print(header)
    print("-" * len(header))
    for record in combined:
        channel = record.get("channel", "")
        update_rel = record.get("update_time_relative", "")
        short_rev = record.get("short_revision", "")
        hydra_job = "/".join([record.get("project", ""), record.get("jobset", ""), record.get("job", "")])
        # Determine status labels:
        #  - Based on channel revision "status": beta, deprecated, unmaintained, stable, rolling.
        #  - And if the last job status is a failure (i.e. False) and channel is not unmaintained.
        status = record.get("status", "")
        status_labels = []
        if status == "beta":
            status_labels.append("Beta")
        elif status == "deprecated":
            status_labels.append("Deprecated")
        elif status == "unmaintained":
            status_labels.append("End of life")
        elif status in ["stable", "rolling"]:
            status_labels.append(status.capitalize())

        job_history = record.get("job_history", [])
        if job_history and (not job_history[-1]) and status != "unmaintained":
            status_labels.append("Build problem")

        status_str = " ".join(status_labels)
        print(f"{channel:<20} {update_rel:<20} {short_rev:<15} {hydra_job:<30} {status_str}")

if __name__ == "__main__":
    main()
