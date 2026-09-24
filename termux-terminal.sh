#!/bin/bash

declare -A pkg_kv=(
  [gh]="GitHub CLI"                      # Manage GitHub repositories from terminal
  [zip]="ZIP compression"                # Compress and extract zip files
  [python-yt-dlp]="YouTube downloader"   # Download videos from YouTube
  [dnsutils]="DNS utilities"             # Check DNS tools like dig and nslookup
  [mpd]="Music Player Daemon"            # Background music player server
  [mpc]="MPD client"                     # Command-line music player controller
  [ncmpcpp]="Ncurses MPD client"         # Terminal-based music player interface
  [termux-services]="Termux services"    # Manage background services in Termux
  [ncurses-utils]="Ncurses utils"        # Terminal screen management utilities
  [rsync]="File sync utility"            # Synchronize and backup files
  [htop]="Process viewer"                # Real-time system resource monitor
  [termux-api]="Android API access"      # Access Android hardware features
  [tmux]="Terminal multiplexer"          # Split and manage terminal sessions
  [jq]="JSON processor"                  # Parse and manipulate JSON data
  [tree]="Directory tree viewer"         # Display folder structure as a tree
  [nodejs]="JavaScript runtime"          # Run JavaScript applications
  [zsh]="Z shell"                        # Feature-rich alternative shell
  [micro]="Text editor"                  # Modern and easy-to-use text editor
  [starship]="Prompt customizer"         # Cross-shell prompt customizer
  [neofetch]="System info"               # Display system information and logo
  [openssh]="SSH client/server"          # Secure remote connection tools
  [openssl-tool]="OpenSSL CLI"           # Cryptography and SSL certificate tools
  [gnupg]="GnuPG encryption"             # Encryption and digital signature tools
  [git]="Version control"                # Track code changes and version control
)

domain1="https://himei.city"
domain2="https://raw.githubusercontent.com"
domain3="https://github.com"
gitmain="$domain2/Himei-Miyu/termux-terminal/refs/heads/main"

declare -A url_kv=(
  ["$domain1/fonts/FiraCodeNerdFont-Regular.ttf"]="0"                # 0 Font file
  ["$gitmain/config/htop/htoprc"]="1"                                # 1 Custom view process file
  ["$gitmain/config/micro/settings.json"]="2"                        # 2 Config micro editor file
  ["$gitmain/config/mpd/mpd.conf"]="3"                               # 3 Config music player daemon file
  ["$gitmain/config/ncmpcpp/config"]="4"                             # 4 Config ui music player file
  ["$gitmain/config/starship.toml"]="5"                              # 5 Custom prompt shell file
  ["$gitmain/config/termux/termux.properties"]="6"                   # 6 Termux config file
  ["$gitmain/etc/ssh/ssh_config.d/00-env.conf"]="7"                  # 7 SSH config file
  ["$gitmain/etc/ssh/sshd_config.d/00-hosting.conf"]="8"             # 8 SSH server config file
  ["$gitmain/etc/ssh/sshd_config.d/01-env.conf"]="9"                 # 9 SSH server config file
  ["$gitmain/service/mpd/run"]="10"                                  # 10 Script music player service daemon file
  ["$domain2/ohmyzsh/ohmyzsh/master/tools/install.sh"]="11"          # 11 Framework zsh
)
declare -A cnf_kv=(
  ["$HOME/.config"]="0"                                              # 0 Config directory
  ["$HOME/.config/mpd"]="1"                                          # 1 Config mpd directory
  ["$HOME/.termux/font.ttf"]="2"                                     # 2 Termux font file
  ["$HOME/.termux/service"]="3"                                      # 3 Service daemon directory
  ["$HOME/.termux/termux.properties"]="4"                            # 4 Termux config file
  ["$PREFIX/etc/motd"]="5"                                           # 5 Motd file
  ["$PREFIX/etc/ssh/ssh_config.d"]="6"                               # 6 SSH config directory
  ["$PREFIX/etc/ssh/sshd_config.d"]="7"                              # 7 SSH server config directory
  ["$PREFIX/etc/termux"]="8"                                         # 8 Termux pkg mirror directory
  ["$PREFIX/var/service"]="9"                                        # 9 Service daemon directory
)

kvToIdx() {
  declare -n ref="$1_kv"
  mapfile -t $1_idx < <(printf "%s\n" "${!ref[@]}" | sort)
}

log() {
  echo -e "[INFO] $@"
  sleep 5
}

for name in pkg url cnf; do kvToIdx $name; done

echo "${!pkg_kv[@]}"
exit 1

log "Backup motd file"

# Backup default motd and replace empty motd
cd $HOME
mv ${cnf_idx[5]} ${cnf_idx[5]}.bak && :> ${cnf_idx[5]};

log "Delete local files"

rm -rf .ssh/known_hosts* .lyrics .gitconfig .tor .node* .config* .termux .screen* .vim* .zsh* .oh-my* .zcom* .cache* .local* .npm* .mpd;
ls -A

log "Create local config files"

mkdir -p .termux .config

# Change working path to .config directory
cd ${cnf_idx[0]};
mkdir -p pulse micro mpd mpd/playlists ncmpcpp htop;

# Change working path to .config/mpd directory
cd ${cnf_idx[1]}
touch log database pid state sticker.sql;

log "Download config files before pkg update"

# Change working path to .config directory
cd ${cnf_idx[0]};

# Download termux config
curl -fsSLo ${cnf_idx[4]} ${url_idx[6]}

# Download prompt shell config
curl -fsSLo starship.toml ${url_idx[5]}

# Download micro editor config
curl -fsSLo micro/settings.json ${url_idx[2]}

# Download view process config
curl -fsSLo htop/htoprc ${url_idx[1]}

# Download music player daemon config
curl -fsSLo mpd/mpd.conf ${url_idx[3]}

# Downlaod music player ui config
curl -fsSLo ncmpcpp/config ${url_idx[4]}

# Replace termux pkg mirror with default cloudflare server
cat ${cnf_idx[8]}/mirrors/default > ${cnf_idx[8]}/chosen_mirrors

log "Update & upgrade termux"

apt update;
apt -y -o Dpkg::Options::="--force-confdef" full-upgrade;

log "Install packages"

pkg install -y "${!pkg_kv[@]}"

log "Install pnpm by corepack"

npm i -g corepack
corepack enable
corepack prepare pnpm@latest --activate

log "Install ohmyzsh framework"

# Download ohmyzsh framework
curl -fsSL ${url_idx[11]} | bash -

log "Install Font"

# Download font
curl -fsSLo ${cnf_idx[2]} ${url_idx[0]}

log "Install script to .zshrc"

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
[[ -n "$SSH_FORWARD_PORT" ]] && {
  ID_TTY="${SSH_TTY##*/}"
  for i in "${PA_SINK_AVAILABLE[@]}"; do
    grep -q "^$i:" $PA_SINK_USING || {
      echo "$i:$ID_TTY" >> $PA_SINK_USING;
      pactl load-module \
        module-tunnel-sink \
        sink_name=$i \
        server=tcp:localhost:$SSH_FORWARD_PORT \
      &> /dev/null
      break;
    }
  done
  function CleanUpSSH() {
    grep -v ":$ID_TTY$" $PA_SINK_USING > $PA_SINK_USING.tmp || touch $PA_SINK_USING.tmp
    mv $PA_SINK_USING.tmp $PA_SINK_USING
    pactl unload-module "$(pactl list short modules | grep "$SSH_FORWARD_PORT" | awk '{print $1}')"
  }
  trap "CleanUpSSH" EXIT
}
alias l="ls -A"
alias {cln,clr,cls}="clear"
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

log "Install zsh plugins"

plugins=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins

git clone $domain3/zsh-users/zsh-autosuggestions.git $plugins/zsh-autosuggestions
git clone $domain3/zsh-users/zsh-syntax-highlighting.git $plugins/zsh-syntax-highlighting
git clone $domain3/zdharma-continuum/fast-syntax-highlighting.git $plugins/fast-syntax-highlighting
git clone --depth 1 -- $domain3/marlonrichert/zsh-autocomplete.git $plugins/zsh-autocomplete
sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' $HOME/.zshrc

log "Install micro editor plugins"

micro -plugin install prettier quoter filemanager

log "Create symbolic link"

cd $HOME/.termux
ln -s $PREFIX/bin/zsh shell

# link service daemon to ~/.termux/service directory
ln -s ${cnf_idx[9]} ${cnf_idx[3]}

log "Download config files after pkg update"

curl -fsSLo ${cnf_idx[3]}/mpd/run ${url_idx[10]}
curl -fsSLo ${cnf_idx[6]}/00-env.conf ${url_idx[7]}
curl -fsSLo ${cnf_idx[7]}/00-hosting.conf ${url_idx[8]}
curl -fsSLo ${cnf_idx[7]}/01-env.conf ${url_idx[9]}

log "Termux reload settings"

termux-reload-settings

log "Initial zsh shell"

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
sleep 5

log"Install package additional"

cd $HOME
zsh -i -c 'sv_list=(mpd sshd); for v in "${sv_list[@]}"; do sv-enable $v; done; pnpm i -g prettier prettier-plugin-tailwindcss; echo -e "[INFO] \UF0206 Service daemon need to restart termux!"'
sleep 5

log "Restarting"

zsh -i && exit 0
