#!/bin/bash

TERMUX_ROOT_DIR=$PREFIX/etc/termux
TERMUX_HOME_DIR=$HOME/.termux
TERMUX_FONT_FILE=$TERMUX_HOME_DIR/font.ttf
MOTD_FILE=$PREFIX/etc/motd
#python-yt-dlp      : download video
#dnsutils           : dig,nslookup command
#mpd                : music player server
#mpc                : music player client
#ncmpcpp            : UI music player client
#termux-services    : sv command manage deamon
#ncurses-utils      : tput command check terminal screen
#rsync              : send/receive file better scp
#htop               : check status device
#termux-api         : utility tool termux with android
#tmux               : multi screen in terminal
#jq                 : convert json format
#tree               : list dir with tree format
#nodejs             : runtime node server
#zsh                : terminal
#micro              : editor like vscode
#starship           : beautiful terminal
#neofetch           : show type system
#openssh            : ssh server/remote
#openssl-tool       : openssl command make certificate
#gnupg              : gpg command make signature
#git                : version control or store code
PKGs=(python-yt-dlp dnsutils mpd mpc ncmpcpp termux-services ncurses-utils rsync htop termux-api tmux jq tree nodejs zsh micro starship neofetch openssh openssl-tool gnupg git)
HOST="https://himei.city"
FONT_URL="$HOST/fonts/FiraCodeNerdFont-Regular.ttf"
TERMUX_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/config/termux/termux.properties"
STARSHIP_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/config/starship/starship.toml"
MICRO_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/config/micro/settings.json"
HTOP_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/config/htop/htoprc"
MPD_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/config/mpd/mpd.conf"
NCMPCPP_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/config/ncmpcpp/config"

ZSH_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

mv $MOTD_FILE $MOTD_FILE.bak
echo -e "" > "$MOTD_FILE"
[ -f $HOME/.termux/termux.properties.bak ] && mv $HOME/.termux/termux.properties.bak $PREFIX/etc

rm -rf $HOME/.PUBLIC_IP $HOME/.config* $HOME/.termux $HOME/.screen* $HOME/.vim* $HOME/.zsh* $HOME/.oh-my* $HOME/.zcom* $HOME/.cache* $HOME/.local* $HOME/.npm*
mkdir -p $HOME/.config/micro $HOME/.config/mpd $HOME/.config/ncmpcpp $HOME/.config/htop $HOME/.termux
[ -f $PREFIX/etc/termux.properties.bak ] && mv $PREFIX/etc/termux.properties.bak $HOME/.termux/
curl -fsSLo $HOME/.termux/termux.properties $TERMUX_CONF_URL
curl -fsSLo $HOME/.config/starship.toml $STARSHIP_CONF_URL
curl -fsSLo $HOME/.config/micro/settings.json $MICRO_CONF_URL
curl -fsSLo $HOME/.config/htop/htoprc $HTOP_CONF_URL
curl -fsSLo $HOME/.config/mpd/mpd.conf $MPD_CONF_URL
curl -fsSLo $HOME/.config/ncmpcpp/config $NCMPCPP_CONF_URL
cat $TERMUX_ROOT_DIR/mirrors/default > $TERMUX_ROOT_DIR/chosen_mirrors
apt update;
apt -y -o Dpkg::Options::="--force-confdef" full-upgrade;
apt install -y ${PKGs[@]}
corepack enable
corepack prepare pnpm@latest --activate
curl -fsSL $ZSH_URL | bash -
curl -fsSLo $TERMUX_FONT_FILE $FONT_URL

addLine() { echo "$1" >> $HOME/.zshrc; }
addLine 'neofetch'
addLine 'eval "$(starship init zsh)"'
addLine 'export GPG_TTY=$(tty)'
addLine 'export XDG_CONFIG_HOME="$HOME/.config"'
addLine 'export XDG_DATA_HOME="$HOME/.local/share"'
addLine 'export XDG_CACHE_HOME="$HOME/.cache"'
addLine 'alias l="ls -A"'
addLine \
'flock -n $PREFIX/tmp/fetch_public_ip.lock -c \'
  while true; do
    [ -f $HOME/.PUBLIC_IP ] || printf "OFFLINE" > $HOME/.PUBLIC_IP;
    ping -c 1 -s 1 1.1.1.1 &> /dev/null;
    [ $? -eq 0 ] && PUBLIC_IP="$(nslookup myip.opendns.com resolver1.opendns.com 2> /dev/null | grep Address | tail -1 | cut -d" " -f2 | tr -d " ")" || PUBLIC_IP="OFFLINE";
    [ -z "$PUBLIC_IP" ] && printf "FETCHING" > $HOME/.PUBLIC_IP || printf "$PUBLIC_IP" > $HOME/.PUBLIC_IP;
    sleep 3;
  done &
\''
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' $HOME/.zshrc

ln -s $PREFIX/bin/zsh $HOME/.termux/shell

termux-reload-settings

c=$(tput cols)
b='-------------------------------------------------'
w=${#b}; iw=$((w-2))
rainbow=$'\e[1;31mW\e[1;33mE\e[1;32mL\e[1;36mC\e[1;34mO\e[1;35mM\e[1;31mE\e[0m'
l2_raw=" HIMEI.CITY TERMINAL "
icon=""
white_icon=$'\e[37m'"$icon"$'\e[0m'
green_text=$'\e[1;32m'" HIMEI.CITY TERMINAL "$'\e[0m'
m=$(printf '%*s' $(((c-w)/2)) "")
p1=$(((iw-7)/2)); q1=$((iw-7-p1))
p2=$(((iw-${#l2_raw})/2)); q2=$((iw-${#l2_raw}-p2))
clear
echo "${m}${b}"
echo "${m}|$(printf '%*s' $iw "")|"
echo "${m}|$(printf '%*s' $p1 "")${rainbow}$(printf '%*s' $q1 "")|"
echo "${m}|$(printf '%*s' $p2 "")${white_icon}${green_text}${white_icon}$(printf '%*s' $q2 "")|"
echo "${m}|$(printf '%*s' $iw "")|"
echo "${m}${b}"

sleep 2
zsh -i -c "echo -e \UF0206 restart termux"
sleep 2

exit 0
