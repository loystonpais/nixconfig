#! /usr/bin/env bash

notifier="Asuslinux switcher"

show_logout() {
  qdbus org.kde.LogoutPrompt /LogoutPrompt  org.kde.LogoutPrompt.promptLogout
}

if [ "$(supergfxctl -g)" = "Hybrid" ]; then
  case `notify-send -a "$notifier" 'You need to switch to Integrated first' -A switch=Switch -A cancel=Cancel` in

    switch)
      OUTPUT="$(supergfxctl -m Integrated)"

      if [ $?  = 0 ]; then
        notify-send --wait -a "$notifier" "Switching.."
        show_logout
      else
        notify-send -a "$notifier" "Switching failed. $OUTPUT"
      fi
      ;;

    cancel)
      notify-send -a "$notifier" "Canceled"
      ;;
  esac

elif  [ "$(supergfxctl -g)" = "Vfio" ]; then
  notify-send -a "$notifier" "You are already on Vfio"

elif  [ "$(supergfxctl -g)" = "Integrated" ]; then
  supergfxctl -m Vfio
  if [ $? = 0 ]; then
    notify-send -a "$notifier" "Switched to Vfio"
  else
    notify-send -a "$notifier" "Failed to switch for some reason"
  fi

else
  notify-send -a "$notifier" "This case is not covered"
fi

