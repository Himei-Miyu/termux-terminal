#!/bin/bash

declare -A PACKAGE
PACKAGE[NAMES]+="gh "                 # gh command before use must gh auth login "github.com > ssh > skip > web login > specify 8 char"
PACKAGE[NAMES]+="zip "                # zip files
PACKAGE[NAMES]+="python-yt-dlp "      # download video
PACKAGE[NAMES]+="dnsutils "           # dig,nslookup command
PACKAGE[NAMES]+="mpd "                # music player server
PACKAGE[NAMES]+="mpc "                # music player client
PACKAGE[NAMES]+="ncmpcpp "            # UI music player client
PACKAGE[NAMES]+="termux-services "  # sv command manage deamon
PACKAGE[NAMES]+="ncurses-utils "      # tput command check terminal screen
PACKAGE[NAMES]+="rsync "              # send/receive file better scp
PACKAGE[NAMES]+="htop "               # check status device
PACKAGE[NAMES]+="termux-api "         # utility tool termux with android
PACKAGE[NAMES]+="tmux "               # multi screen in terminal
PACKAGE[NAMES]+="jq "                 # convert json format
PACKAGE[NAMES]+="tree "               # list dir with tree format
PACKAGE[NAMES]+="nodejs "             # runtime node server
PACKAGE[NAMES]+="zsh "                # terminal
PACKAGE[NAMES]+="micro "              # editor like vscode
PACKAGE[NAMES]+="starship "           # beautiful terminal
PACKAGE[NAMES]+="neofetch "           # show type system
PACKAGE[NAMES]+="openssh "            # ssh server/remote
PACKAGE[NAMES]+="openssl-tool "       # openssl command make certificate
PACKAGE[NAMES]+="gnupg "              # gpg command make signature
PACKAGE[NAMES]+="git "                # version control or store code

declare -A URL
URL[HOST]="https://himei.city"
URL[GITHUB]="https://raw.githubusercontent.com"
URL[MAIN]="${URL[GITHUB]}/Himei-Miyu/termux-terminal/refs/heads/main"
URL[FONT]="${URL[HOST]}/fonts/FiraCodeNerdFont-Regular.ttf"
URL[ZSH]="${URL[GITHUB]}/ohmyzsh/ohmyzsh/master/tools/install.sh"

declare -A URLCNF
URLCNF[TERMUX]="${URL[MAIN]}/config/termux/termux.properties"
URLCNF[STARSHIP]="${URL[MAIN]}/config/starship/starship.toml"
URLCNF[MICRO]="${URL[MAIN]}/config/micro/settings.json"
URLCNF[HTOP]="${URL[MAIN]}/config/htop/htoprc"
URLCNF[MPD]="${URL[MAIN]}/config/mpd/mpd.conf"
URLCNF[MPDSV]="${URL[MAIN]}/service/mpd/run"
URLCNF[NCMPCPP]="${URL[MAIN]}/config/ncmpcpp/config"
URLCNF[SSH0]="${URL[MAIN]}/config/ssh/ssh_config.d/00-env.conf"
URLCNF[SSHD0]="${URL[MAIN]}/config/ssh/sshd_config.d/00-hosting.conf"
URLCNF[SSHD1]="${URL[MAIN]}/config/ssh/sshd_config.d/01-env.conf"

declare -A RCNF
RCNF[TERMUX]="$PREFIX/etc/termux.properties"
RCNF[DIR_SV]="$PREFIX/var/service"
RCNF[DIR_TERMUX]="$PREFIX/etc/termux"
RCNF[DIR_SSH]="$PREFIX/etc/ssh/ssh_config.d"
RCNF[DIR_SSHD]="$PREFIX/etc/ssh/sshd_config.d"
RCNF[MOTD]="$PREFIX/etc/motd"

declare -A LCNF
LCNF[DIRCNF]="$HOME/.config"
LCNF[DIR_MPD]="$HOME/.config/mpd"
LCNF[DIR_SV]="$HOME/.termux/service"
LCNF[TERMUX]="$HOME/.termux/termux.properties"
LCNF[FONT]="$HOME/.termux/font.ttf"

echo "[INFO] Backup motd & termux.properties files"
sleep 4

mv ${RCNF[MOTD]} ${RCNF[MOTD]}.bak && printf "" > ${RCNF[MOTD]};
[ -f ${LCNF[TERMUX]}.bak ] && mv ${LCNF[TERMUX]}.bak ${RCNF[TERMUX]}.bak;

echo "[INFO] Delete directory and file"
sleep 4

cd $HOME
rm -rf .ssh/known_hosts* .lyrics .gitconfig .tor .node* .config* .termux .screen* .vim* .zsh* .oh-my* .zcom* .cache* .local* .npm*;
ls -A

echo "[INFO] Create directory and file"
sleep 4

mkdir -p .termux .config && cd ${LCNF[DIRCNF]};
mkdir -p pulse micro mpd mpd/playlists ncmpcpp htop;
cd ${LCNF[DIR_MPD]} && touch log database pid state sticker.sql;
[ -f ${RCNF[TERMUX]}.bak ] && mv ${RCNF[TERMUX]}.bak ${LCNF[TERMUX]}.bak;
ls -A

echo "[INFO] Fetch config file"
sleep 4

cd ${LCNF[DIRCNF]};
curl -fsSLo ${LCNF[TERMUX]} ${URLCNF[TERMUX]}
curl -fsSLo starship.toml ${URLCNF[STARSHIP]}
curl -fsSLo micro/settings.json ${URLCNF[MICRO]}
curl -fsSLo htop/htoprc ${URLCNF[HTOP]}
curl -fsSLo mpd/mpd.conf ${URLCNF[MPD]}
curl -fsSLo ncmpcpp/config ${URLCNF[NCMPCPP]}
cat ${RCNF[DIR_TERMUX]}/mirrors/default > ${RCNF[DIR_TERMUX]}/chosen_mirrors

echo "[INFO] Upgrade termux"
sleep 4

apt update;
apt -y -o Dpkg::Options::="--force-confdef" full-upgrade;

echo "[INFO] Install package"
sleep 4

apt install -y ${PACKAGE[NAMES]}

echo "[INFO] Install PNPM"
sleep 4

corepack enable
corepack prepare pnpm@latest --activate

echo "[INFO] Install ZSH"
sleep 4

curl -fsSL ${URL[ZSH]} | bash -

echo "[INFO] Install Font"
sleep 4

curl -fsSLo ${LCNF[FONT]} ${URL[FONT]}

echo "[INFO] Add command to .zshrc"
sleep 4

cat << 'EOF' >> $HOME/.zshrc;
neofetch
eval "$(starship init zsh)"
export GPG_TTY=$(tty)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="$TMPDIR/runtime"
export MPD_HOST="$TMPDIR/runtime/mpd/mpd-server.sock"
export PA_SINK_AVAILABLE=(remote-1 remote-2 remote-3 remote-4 remote-5)
export PA_SINK_USING="$TMPDIR/runtime/pulse/sink-using.txt"
mkdir -p $TMPDIR/runtime/mpd $TMPDIR/runtime/lock
sv-enable mpd;
sv-enable sshd;
pulseaudio --check || {
  pulseaudio --load="module-native-protocol-tcp auth-anonymous=1" --exit-idle-time=-1 --daemon
  touch $PA_SINK_USING
  for i in ${PA_SINK_AVAILABLE[@]}; do
    pactl load-module \
      module-null-sink \
      sink_name=$i \
    &> /dev/null;
  done
  PA_SLAVES=$(printf "%s," "${PA_SINK_AVAILABLE[@]}")
  PA_SLAVES="${PA_SLAVES%,}"
  pactl load-module \
    module-combine-sink \
    sink_name=remote-sink \
    slaves=$PA_SLAVES \
    channels=2 \
    channel_map=front-left,front-right \
  &>/dev/null
  pactl unload-module module-null-sink
}
[[ -n "$SSH_TTY" ]] && {
  ID_TTY="${SSH_TTY##*/}"
  for i in "${PA_SINK_AVAILABLE[@]}"; do
    grep -q "^$i:" $PA_SINK_USING || {
      echo "$i:$ID_TTY" >> $PA_SINK_USING;
      pactl load-module \
        module-tunnel-sink \
        sink_name=$i \
        server=tcp:localhost:$SSH_FORWARD_PORT \
      &>/dev/null
      break;
    }
  done
  function cleanUp() {
    grep -v ":$ID_TTY$" $PA_SINK_USING > $PA_SINK_USING.tmp || touch $PA_SINK_USING.tmp
    mv $PA_SINK_USING.tmp $PA_SINK_USING
    pactl unload-module "$(pactl list short modules | grep "$SSH_FORWARD_PORT" | awk '{print $1}')"
  }
  trap "cleanUp" EXIT
}
alias l="ls -A"
flock -n $TMPDIR/runtime/lock/get-public-ip.lock -c '
  while true; do
    [ -e "$TMPDIR/runtime/lock/get-public-ip.lock" ] && {
      [ -f $TMPDIR/PUBLIC-IP ] || printf "OFFLINE" > $TMPDIR/PUBLIC-IP;
      ping -c 1 -s 1 1.1.1.1 &> /dev/null;
      [ $? -eq 0 ] && PUBLIC_IP="$(nslookup myip.opendns.com resolver1.opendns.com 2> /dev/null | grep Address | tail -1 | cut -d" " -f2 | tr -d " ")" || PUBLIC_IP="OFFLINE";
      [ -z "$PUBLIC_IP" ] || printf "$PUBLIC_IP" > $TMPDIR/PUBLIC-IP;
    } || break;
  sleep 3;
done &
'
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
EOF

echo "[INFO] Install plugin ZSH"
sleep 4

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' $HOME/.zshrc

echo "[INFO] Install plugin Micro"
sleep 4

micro -plugin install prettier quoter filemanager

echo "[INFO] Create symbolic link"
sleep 4

cd $HOME/.termux
ln -s $PREFIX/bin/zsh shell
ln -s ${RCNF[DIR_SV]} ${LCNF[DIR_SV]}

echo "[INFO] Fetch config file"
sleep 4

curl -fsSLo ${LCNF[DIR_SV]}/mpd/run ${URLCNF[MPDSV]}
curl -fsSLo ${RCNF[DIR_SSH]}/00-env.conf ${URLCNF[SSH0]}
curl -fsSLo ${RCNF[DIR_SSHD]}/00-hosting.conf ${URLCNF[SSHD0]}
curl -fsSLo ${RCNF[DIR_SSHD]}/01-env.conf ${URLCNF[SSHD1]}
rm -rf $HOME/.mpd

echo "[INFO] Reload termux settings"
sleep 4

termux-reload-settings

echo "[INFO] Start ZSH"
sleep 4

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
sleep 4

echo "[INFO] Install package"
sleep 4

zsh -i -c "pnpm i -g prettier; echo -e '[INFO] \UF0206 Service daemon need to restart termux!'"
sleep 4

echo "[INFO] Starting Preview ZSH"
sleep 4

zsh -i && exit 0
