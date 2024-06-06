#! /usr/bin/env bash

notifier="Asuslinux switcher"

show_logout() {
  qdbus org.kde.LogoutPrompt /LogoutPrompt  org.kde.LogoutPrompt.promptLogout
}


if [ "$(supergfxctl -g)" = "Integrated" ]; then
  notify-send -a "$notifier" "You are already in Integrated mode"

elif  [ "$(supergfxctl -g)" = "Vfio" ]; then
  notify-send -a "$notifier" "Not implemented for now"

elif  [ "$(supergfxctl -g)" = "Hybrid" ]; then
  OUTPUT="$(supergfxctl -m Integrated)"

  if [ $?  = 0 ]; then
    notify-send --wait -a "$notifier" "Switching.."
    show_logout
  else
    notify-send -a "$notifier" "Switching failed. $OUTPUT"
  fi

else
  notify-send -a "$notifier" "This case is not covered"
fi
