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
  [nginx]="Web server"
  [pnpm]=""
)

declare -A dirs

# Variable host directory path
dirs[host]="https://himei.city"
dirs[host_font]=${dirs[host]}/fonts

# Variable github directory path
dirs[gh]="https://github.com"
dirs[gh_raw]="https://raw.githubusercontent.com"
dirs[gh_main]=${dirs[gh_raw]}/Himei-Miyu/termux-terminal/refs/heads/main
dirs[gh_cnf]=${dirs[gh_main]}/config
dirs[gh_etc]=${dirs[gh_main]}/etc
dirs[gh_run]=${dirs[gh_main]}/service

# Variable user directory path
dirs[usr_cnf]=$HOME/.config
dirs[usr_mpd]=${dirs[usr_cnf]}/mpd
dirs[usr_tmx]=$HOME/.termux
dirs[usr_run]=${dirs[usr_tmx]}/service

# Variable system directory path
dirs[sys_etc]=$PREFIX/etc
dirs[sys_ssh]=${dirs[sys_etc]}/ssh
dirs[sys_sshcnf]=${dirs[sys_ssh]}/ssh_config.d
dirs[sys_sshdcnf]=${dirs[sys_ssh]}/sshd_config.d
dirs[sys_run]=$PREFIX/var/service
dirs[sys_tmx]=${dirs[sys_etc]}/termux

# Variable file path
sys_motd=${dirs[sys_etc]}/motd
sys_resolv=${dirs[sys_etc]}/resolv.conf
sys_tmx_mir_def=${dirs[sys_tmx]}/mirrors/default
sys_tmx_mir=${dirs[sys_tmx]}/chosen_mirrors
sys_zsh=$PREFIX/bin/zsh
usr_tmx_prop=${dirs[usr_tmx]}/termux.properties
gh_tmx_prop=${dirs[gh_cnf]}/termux/termux.properties
usr_starship_cnf=${dirs[usr_cnf]}/starship.toml
gh_starship_cnf=${dirs[gh_cnf]}/starship.toml
usr_micro_cnf=${dirs[usr_cnf]}/micro/settings.json
gh_micro_cnf=${dirs[gh_cnf]}/micro/settings.json
usr_htop_cnf=${dirs[usr_cnf]}/htop/htoprc
gh_htop_cnf=${dirs[gh_cnf]}/htop/htoprc
usr_mpd_cnf=${dirs[usr_cnf]}/mpd/mpd.conf
gh_mpd_cnf=${dirs[gh_cnf]}/mpd/mpd.conf
usr_nginx_cnf=${dirs[usr_cnf]}/nginx/nginx.conf
gh_nginx_cnf=${dirs[gh_cnf]}/nginx/nginx.conf
usr_ncmpcpp_cnf=${dirs[usr_cnf]}/ncmpcpp/config
gh_ncmpcpp_cnf=${dirs[gh_cnf]}/ncmpcpp/config
sys_ssh_00_cnf=${dirs[sys_sshcnf]}/00-env.conf
gh_ssh_00_cnf=${dirs[gh_etc]}/ssh/ssh_config.d/00-env.conf
sys_sshd_00_cnf=${dirs[sys_sshdcnf]}/00-hosting.conf
gh_sshd_00_cnf=${dirs[gh_etc]}/ssh/sshd_config.d/00-hosting.conf
sys_sshd_01_cnf=${dirs[sys_sshdcnf]}/01-env.conf
gh_sshd_01_cnf=${dirs[gh_etc]}/ssh/sshd_config.d/01-env.conf
sys_mpd_run=${dirs[sys_run]}/mpd/run
gh_mpd_run=${dirs[gh_run]}/mpd/run
sys_nginx_run=${dirs[sys_run]}/nginx/run
gh_nginx_run=${dirs[gh_run]}/nginx/run
sys_sshd_run=${dirs[sys_run]}/sshd/run
gh_sshd_run=${dirs[gh_run]}/sshd/run
sys_svlogger=$PREFIX/share/termux-services/svlogger
gh_log_run=${dirs[gh_run]}/log/run
usr_font=${dirs[usr_tmx]}/font.ttf
host_font=${dirs[host_font]}/FiraCodeNerdFont-Regular.ttf
gh_ohmyzsh=${dirs[gh_raw]}/ohmyzsh/ohmyzsh/master/tools/install.sh

log() { echo -e "\e[32;1m[INFO] $@\e[0m"; sleep 5; }

log "Backup motd file"

# Backup default motd and replace empty motd
cd $HOME
mv $sys_motd $sys_motd.bak && :> $sys_motd;

log "Delete user files"

rm -rf .ssh/known_hosts* .lyrics .gitconfig .tor .node* .config* .termux .screen* .vim* .zsh* .oh-my* .zcom* .cache* .local* .npm* .mpd;
ls -A

read -p "$(printf '\e[33;1m[DEBUG] Breakpoint 1/7\n[DEBUG] please any key to continue...\e[0m')"

log "Create user config files"

mkdir -p .termux .config

# Change working path to .config directory
cd ${dirs[usr_cnf]};
mkdir -p pulse micro mpd mpd/playlists ncmpcpp htop nginx;

# Change working path to .config/mpd directory
cd ${dirs[usr_mpd]}
touch log database pid state sticker.sql;

# Replace termux pkg mirror with default cloudflare server
cat $sys_tmx_mir_def > $sys_tmx_mir

log "Setting dns"

printf "192.168.2.20\n1.1.1.1" > $sys_resolv

log "Update & upgrade termux"

apt update;
apt -y -o Dpkg::Options::="--force-confdef" full-upgrade;

read -p "$(printf '\e[33;1m[DEBUG] Breakpoint 2/7\n[DEBUG] please any key to continue...\e[0m')"

log "Install packages"

pkg install -y "${!pkg_kv[@]}"

ls -A $HOME

log "Delete auto generate files"

rm -rf $HOME/.mpd*

read -p "$(printf '\e[33;1m[DEBUG] Breakpoint 3/7\n[DEBUG] please any key to continue...\e[0m')"

log "Create symbolic link"

# Termux use zsh shell default on startup
cd ${dirs[usr_tmx]}
ln -s $sys_zsh shell

# link service daemon to ~/.termux/service directory
ln -s ${dirs[sys_run]} ${dirs[usr_run]}

log "Download config files"

curl -fsSLo $usr_tmx_prop $gh_tmx_prop
curl -fsSLo $usr_starship_cnf $gh_starship_cnf
curl -fsSLo $usr_micro_cnf $gh_micro_cnf
curl -fsSLo $usr_htop_cnf $gh_htop_cnf
curl -fsSLo $usr_mpd_cnf $gh_mpd_cnf
curl -fsSLo $usr_nginx_cnf $gh_nginx_cnf
curl -fsSLo $usr_ncmpcpp_cnf $gh_ncmpcpp_cnf
curl -fsSLo $sys_ssh_00_cnf $gh_ssh_00_cnf
curl -fsSLo $sys_sshd_00_cnf $gh_sshd_00_cnf
curl -fsSLo $sys_sshd_01_cnf $gh_sshd_01_cnf

log "Download service daemon files"

curl -fsSLo $sys_mpd_run $gh_mpd_run
curl -fsSLo $sys_nginx_run $gh_nginx_run
curl -fsSLo $sys_sshd_run $gh_sshd_run

read -p "$(printf '\e[33;1m[DEBUG] Breakpoint 4/7\n[DEBUG] please any key to continue...\e[0m')"

log "Create symbolic link service daemon logs"

cd $TMPDIR
ln -s $sys_svlogger run
curl -fsSLo run $gh_log_run

for f in ${dirs[sys_run]}/*; do
  rm -rf $f/log/run;
  cp -P run $f/log/;
done

tree ${dirs[sys_run]}

read -p "$(printf '\e[33;1m[DEBUG] Breakpoint 5/7\n[DEBUG] please any key to continue...\e[0m')"

log "Install Font"

curl -fsSLo $usr_font $host_font

log "Install micro editor plugins"

micro -plugin install prettier quoter filemanager

log "Install ohmyzsh framework"

bash -c "$(curl -fsSL $gh_ohmyzsh)" "" --unattended

log "Install ohmyzsh plugins"

plugins=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
git clone ${dirs[gh]}/zsh-users/zsh-autosuggestions.git $plugins/zsh-autosuggestions
git clone ${dirs[gh]}/zdharma-continuum/fast-syntax-highlighting.git $plugins/fast-syntax-highlighting
sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions fast-syntax-highlighting)/' $HOME/.zshrc

read -p "$(printf '\e[33;1m[DEBUG] Breakpoint 6/7\n[DEBUG] please any key to continue...\e[0m')"

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

log "Termux reload settings"

termux-reload-settings

ps -aux | grep runsv

pkill runsv

log "Initial zsh"

zsh -lc 'sleep 2;echo "inside zsh svdir: $SVDIR"'
echo "outside zsh svdir : $SVDIR"

[ -z $SVDIR ] && export SVDIR=${dirs[sys_run]} && log "svdir path export fixed"

log "Enable service daemon"

echo final check $SVDIR

sv_list=(mpd sshd);

for v in "${sv_list[@]}"; do sv-enable $v; done

log "Install package additional"

pnpm i -g prettier prettier-plugin-tailwindcss;

read -p "$(printf '\e[33;1m[DEBUG] Breakpoint 7/7\n[DEBUG] please any key to continue...\e[0m')"

log "Start zsh"

cd $HOME

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

zsh -li && exit 0
