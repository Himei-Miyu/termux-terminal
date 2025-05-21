#!/bin/bash

TERMUX_RDIR=$PREFIX/etc/termux
TERMUX_DIR=$HOME/.termux
TERMUX_FONT=$TERMUX_DIR/font.ttf
MOTD=$PREFIX/etc/motd
#gh                 : gh command before use must gh auth login "github.com > ssh > skip > web login > specify 8 char"
#zip                : zip files
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
PKGs=(gh zip python-yt-dlp dnsutils mpd mpc ncmpcpp termux-services ncurses-utils rsync htop termux-api tmux jq tree nodejs zsh micro starship neofetch openssh openssl-tool gnupg git)
#External URL
HOST="https://himei.city"
HOST_GITHUB="https://raw.githubusercontent.com"
HOST_DEV="$HOST_GITHUB/Himei-Miyu/termux-terminal/refs/heads/main"
FONT_URL="$HOST/fonts/FiraCodeNerdFont-Regular.ttf"
TERMUX_CNF_URL="$HOST_DEV/config/termux/termux.properties"
STARSHIP_CNF_URL="$HOST_DEV/config/starship/starship.toml"
MICRO_CNF_URL="$HOST_DEV/config/micro/settings.json"
HTOP_CNF_URL="$HOST_DEV/config/htop/htoprc"
MPD_CNF_URL="$HOST_DEV/config/mpd/mpd.conf"
MPD_SV_URL="$HOST_DEV/service/mpd/run"
NCMPCPP_CNF_URL="$HOST_DEV/config/ncmpcpp/config"
PULSE_CNF_URL="$HOST_DEV/config/pulse/default.pa"
ZSH_SHELL_URL="$HOST_GITHUB/ohmyzsh/ohmyzsh/master/tools/install.sh"
#Local dir
TERMUX_RCNF="$PREFIX/etc/termux.properties"
MPD_CNF_DIR="$HOME/.config/mpd"
#Local file
TERMUX_CNF="$TERMUX_DIR/termux.properties"

echo "[INFO] Make backup file"
sleep 2

mv $MOTD $MOTD.bak && printf "" > $MOTD;
[ -f $TERMUX_CNF.bak ] && mv $TERMUX_CNF.bak $PREFIX/etc;
cd $HOME;

sleep 2
echo "[INFO] Delete directory and file"
sleep 2

rm -rf .ssh/known_hosts* .lyrics sockets .gitconfig .tor .PUBLIC_IP .node* .config* .termux .screen* .vim* .zsh* .oh-my* .zcom* .cache* .local* .npm*;

ls -A
sleep 2
echo "[INFO] Create directory and file"
sleep 3

mkdir .config && cd .config;
mkdir -p pulse micro mpd mpd/playlists ncmpcpp htop $HOME/.termux $HOME/sockets;
cd mpd && touch log database pid state sticker.sql;
[ -f $TERMUX_RCNF.bak ] && mv $TERMUX_RCNF.bak $TERMUX_CNF.bak;
cd ..;
curl -fsSLo $TERMUX_CNF $TERMUX_CNF_URL
curl -fsSLo starship.toml $STARSHIP_CNF_URL
curl -fsSLo micro/settings.json $MICRO_CNF_URL
curl -fsSLo htop/htoprc $HTOP_CNF_URL
curl -fsSLo mpd/mpd.conf $MPD_CNF_URL
curl -fsSLo ncmpcpp/config $NCMPCPP_CNF_URL
curl -fsSLo pulse/default.pa $PULSE_CNF_URL
cat $TERMUX_RDIR/mirrors/default > $TERMUX_RDIR/chosen_mirrors

sleep 2
echo "[INFO] Upgrade termux"
sleep 3

apt update;
apt -y -o Dpkg::Options::="--force-confdef" full-upgrade;

sleep 2
echo "[INFO] Install package"
sleep 2

apt install -y ${PKGs[@]}

sleep 2
echo "[INFO] Install PNPM"
sleep 2

corepack enable
corepack prepare pnpm@latest --activate

sleep 2
echo "[INFO] Install zsh shell"
sleep 2

curl -fsSL $ZSH_SHELL_URL | bash -
curl -fsSLo $TERMUX_FONT $FONT_URL

sleep 2
echo "[INFO] Add command to .zshrc"
sleep 2

addLine() { echo "$1" >> $HOME/.zshrc; }
addLine 'neofetch'
addLine 'eval "$(starship init zsh)"'
addLine 'export GPG_TTY=$(tty)'
addLine 'export MPD_HOST="$HOME/sockets/music-server.sock"'
addLine 'export XDG_CONFIG_HOME="$HOME/.config"'
addLine 'export XDG_DATA_HOME="$HOME/.local/share"'
addLine 'export XDG_CACHE_HOME="$HOME/.cache"'
addLine 'export XDG_RUNTIME_DIR="$HOME/runtime"'
#addLine '[ -z "$SSH_CONNECTION" ] && pulseaudio --load="module-native-protocol-tcp auth-anonymous=1" --exit-idle-time=-1 --daemon'
addLine 'alias l="ls -A"'
addLine 'flock -n $PREFIX/tmp/fetch_public_ip.lock -c '"'"
addLine '  while true; do'
addLine '    [ -f $HOME/.PUBLIC_IP ] || printf "OFFLINE" > $HOME/.PUBLIC_IP;'
addLine '    ping -c 1 -s 1 1.1.1.1 &> /dev/null;'
addLine '    [ $? -eq 0 ] && PUBLIC_IP="$(nslookup myip.opendns.com resolver1.opendns.com 2> /dev/null | grep Address | tail -1 | cut -d" " -f2 | tr -d " ")" || PUBLIC_IP="OFFLINE";'
addLine '    [ -z "$PUBLIC_IP" ] || printf "$PUBLIC_IP" > $HOME/.PUBLIC_IP;'
addLine '    sleep 3;'
addLine '  done &'
addLine "'"
addLine 'export PNPM_HOME="/data/data/com.termux/files/home/.local/share/pnpm"'
addLine 'case ":$PATH:" in'
addLine '  *":$PNPM_HOME:"*) ;;'
addLine '  *) export PATH="$PNPM_HOME:$PATH" ;;'
addLine 'esac'

sleep 2
echo "[INFO] Install plugin zsh and micro"
sleep 2

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' $HOME/.zshrc

micro -plugin install prettier quoter filemanager

sleep 2
echo "[INFO] Make folder link"
sleep 2

ln -s $PREFIX/bin/zsh $TERMUX_DIR/shell
ln -s $PREFIX/var/service $TERMUX_DIR/service
curl -fsSLo $TERMUX_DIR/service/mpd/run $MPD_SV_URL
rm -rf $HOME/.mpd

termux-reload-settings

sleep 2
echo "[INFO] Reload setting termux"
sleep 2

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
echo "${m}|$(printf '%*s' $iw '')|"
echo "${m}|$(printf '%*s' $p1 '')${rainbow}$(printf '%*s' $q1 '')|"
echo "${m}|$(printf '%*s' $p2 '')${white_icon}${green_text}${white_icon}$(printf '%*s' $q2 '')|"
echo "${m}|$(printf '%*s' $iw '')|"
echo "${m}${b}"

sleep 2
zsh -i -c "sv start mpd; sv start sshd; pnpm i -g prettier; echo -e '[INFO] \UF0206 Restart termux'"
sleep 2

exit 0
