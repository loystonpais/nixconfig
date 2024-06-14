#! /usr/bin/env bash

notifier="Asuslinux switcher"

show_logout() {
  qdbus org.kde.LogoutPrompt /LogoutPrompt  org.kde.LogoutPrompt.promptLogout
}

CURRENT_MODE=`supergfxctl -g`

if [ "$CURRENT_MODE" = "Hybrid" ]; then
  notify-send -a "$notifier" "You are already in hybrid mode"

elif  [ "$CURRENT_MODE" = "Vfio" ]; then
  notify-send -a "$notifier" "You need to switch to Integrated first. Trying nonetheless"
  supergfxctl -m Hybrid

elif  [ "$CURRENT_MODE" = "Integrated" ]; then
  OUTPUT="$(supergfxctl -m Hybrid)"

  if [ $?  = 0 ]; then
    notify-send --wait -a "$notifier" "Switching.."
    show_logout
  else
    notify-send -a "$notifier" "Switching failed. $OUTPUT"
  fi

else
  notify-send -a "$notifier" "This case is not covered"
fi
