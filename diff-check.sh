#!/bin/bash

CONF_PATH=(
"service/mpd/run"
"starship.toml"
"ssh/ssh_config.d"
"ssh/sshd_config.d"
"micro/settings.json"
"mpd/mpd.conf"
"ncmpcpp/config"
"htop/htoprc"
)

for i in ${CONF_PATH[@]}; do
  name=$(basename "$i")
  [[ $i =~ ^service ]] && {
    diff $i $PREFIX/var/$i
    test $? -gt 0 && echo "[SERVICE-DETECT] $i has changed"
    continue
  }
  [[ $name =~ \.d$ ]] && {
    diff config/$i $PREFIX/etc/$i
    test $? -gt 0 && echo "[DIR-DETECT] $i has changed"
    continue
  }
  [[ $i == "starship.toml" ]] && {
    diff config/starship/starship.toml ~/.config/$i
    test $? -gt 0 && echo "[CONFIG-DETECT] $i has changed"
    continue
  }
  diff config/$i ~/.config/$i &> /dev/null;
  test $? -gt 0 && echo "[CONFIG-DETECT] $i has changed"
done

echo Different check completed
