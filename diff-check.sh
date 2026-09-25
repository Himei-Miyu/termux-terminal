#!/bin/bash

tracking=(
"$HOME/.config/starship.toml"
"$HOME/.config/micro/settings.json"
"$HOME/.config/mpd/mpd.conf"
#"$HOME/.config/ncmpcpp/bindings"
"$HOME/.config/ncmpcpp/config"
"$HOME/.config/htop/htoprc"
"$HOME/.config/nginx/nginx.conf"
"$HOME/.termux/termux.properties"
"$PREFIX/etc/resolv.conf"
"$PREFIX/etc/ssh/ssh_config.d/00-env.conf"
"$PREFIX/etc/ssh/sshd_config.d/00-hosting.conf"
"$PREFIX/etc/ssh/sshd_config.d/01-env.conf"
"$PREFIX/var/service/mpd/run"
"$PREFIX/var/service/sshd/run"
"$PREFIX/var/service/nginx/run"
"$PREFIX/var/service/mpd/log/run"
"$PREFIX/var/service/sshd/log/run"
"$PREFIX/var/service/nginx/log/run"
)

server=(
"config/starship.toml"
"config/micro/settings.json"
"config/mpd/mpd.conf"
#"config/ncmpcpp/bindings"
"config/ncmpcpp/config"
"config/htop/htoprc"
"config/nginx/nginx.conf"
"config/termux/termux.properties"
"etc/resolv.conf"
"etc/ssh/ssh_config.d/00-env.conf"
"etc/ssh/sshd_config.d/00-hosting.conf"
"etc/ssh/sshd_config.d/01-env.conf"
"service/mpd/run"
"service/sshd/run"
"service/nginx/run"
"service/log/run"
"service/log/run"
"service/log/run"
)

SNAP1="snapshot-server.txt"
SNAP2="snapshot-tracking.txt"
rm -rf snapshot-server.txt snapshot-tracking.txt
[ ! -f "$SNAP1" ] && sha256sum "${server[@]}" > "$SNAP1"
[ ! -f "$SNAP2" ] && sha256sum "${tracking[@]}" > "$SNAP2"

join -v 1 <(sort -k1,1 snapshot-tracking.txt) <(sort -k1,1 snapshot-server.txt)

diff_result=$(diff <(awk '{print $1}' snapshot-tracking.txt | sort) <(awk '{print $1}' snapshot-server.txt | sort))

[ -z "$diff_result" ] && echo "Nothing Change"

