#!/bin/bash

TRACKING_LIST=(
"service/mpd/run"
"config/starship.toml"
"config/micro/settings.json"
"config/mpd/mpd.conf"
"config/ncmpcpp/config"
"config/htop/htoprc"
"etc/ssh/ssh_config.d"
"etc/ssh/sshd_config.d"
)
fnLog() { [ $1 -gt 0 ] && echo -e "\e[31m[CHANGED]\e[0m $item" || echo -e "\e[32m[PASSED]\e[0m $item"; }
for item in ${TRACKING_LIST[@]}; do
  case "$item" in
    service*)
      diff $item $PREFIX/var/$item &> /dev/null
      fnLog $?
      ;;
    etc*)
      diff $item $PREFIX/$item &> /dev/null
      fnLog $?
      ;;
    config*)
      diff $item $HOME/.$item &> /dev/null
      fnLog $?
      ;;
    *)
      echo -e "\e[31m[ERROR]\e[0m Tracking unknown : $item" && exit 1
      ;;
  esac
done
