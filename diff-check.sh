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

SNAP="snapshot.txt"

[ ! -f "$SNAP" ] && sha256sum "${tracking[@]}" > "$SNAP" || echo "Nothing change"

diff -u "$SNAP" <(sha256sum "${tracking[@]}")
