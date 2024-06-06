#! /usr/bin/env bash

notifier="Asuslinux switcher"

notify-send -a "$notifier" "Current mode is "`supergfxctl -g`
