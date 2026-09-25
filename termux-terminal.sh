#!/bin/bash

# Variable key-value package list
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
  [nginx]="Web server"                   # Hosting web server
  [pnpm]="Package manager"               # Package manager
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
dirs[usr_log]=${dirs[usr_tmx]}/log

# Variable system directory path
dirs[sys_etc]=$PREFIX/etc
dirs[sys_var]=$PREFIX/var
dirs[sys_ssh]=${dirs[sys_etc]}/ssh
dirs[sys_sshcnf]=${dirs[sys_ssh]}/ssh_config.d
dirs[sys_sshdcnf]=${dirs[sys_ssh]}/sshd_config.d
dirs[sys_run]=${dirs[sys_var]}/service
dirs[sys_tmx]=${dirs[sys_etc]}/termux
dirs[sys_log]=${dirs[sys_var]}/log/sv

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

debugLog() { [ -n "$debug" ] && read -p "$(printf "\e[33;1m[DEBUG] Breakpoint $@\n[DEBUG] please any key to continue...\e[0m")"; }
debugScript() { [ -n "$debug" ] && $@; }
debugMode() { [[ "$1" == "-d" ]] && debug='on'; }

getHash() { awk -v target="$1" '{ if(target==$2) {print $1;} }' snapshot-server.txt; }

log "Next: Backup MOTD and create empty file..."

mv $sys_motd $sys_motd.bak && :> $sys_motd;

debugScript ls -A $PREFIX/etc
debugScript echo "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 $sys_motd" | sha256sum -c
debugLog "1/18 - Was the default MOTD file successfully backed up and a new empty MOTD file created?"

log "Next: Deleting config files in home directory..."

cd $HOME
rm -rf .ssh/known_hosts* .lyrics .gitconfig .tor .node* .config* .termux .screen* .vim* .zsh* .oh-my* .zcom* .cache* .local* .npm* .mpd;

debugScript ls -A $HOME
debugLog "2/18 - Have the config files in home directory been successfully deleted?"

log "Next: Creating config files in home directory..."

mkdir -p .termux .config

# Change working path to .config directory
cd ${dirs[usr_cnf]};
mkdir -p pulse micro mpd mpd/playlists ncmpcpp htop nginx;

# Change working path to .config/mpd directory
cd ${dirs[usr_mpd]}
touch log database pid state sticker.sql;

# Replace termux pkg mirror with default cloudflare server
cat $sys_tmx_mir_def > $sys_tmx_mir

debugScript ls -A $HOME && ls -A $HOME/.config/*
debugLog "3/18 - Have the config files in home directory been successfully created?"

log "Next: Configuring DNS system in resolv.conf..."

printf "192.168.2.20\n1.1.1.1" > $sys_resolv

debugScript echo "c4b3c7d7023d1b8ee968a02aeaad0d007f603e53ef181bc868237628f39ad87e $sys_resolv" | sha256sum -c
debugLog "4/18 - Has the system DNS configuration in resolv.conf been successfully updated?"

log "Next: Updating and upgrading Termux..."

apt update;
apt -y -o Dpkg::Options::="--force-confdef" full-upgrade;

debugLog "5/18 - Has Termux been successfully updated and upgraded?"

log "Next: Installing packages..."

pkg install -y "${!pkg_kv[@]}"

debugLog "6/18 - Were all packages installed successfully?"

log "Next: Deleting auto-generated config files..."

rm -rf $HOME/.mpd*

debugScript ls -A $HOME
debugLog "7/18 - Have the auto-generated config files been successfully deleted?"

log "Next: Creating symbolic links..."

# Termux use zsh shell default on startup
cd ${dirs[usr_tmx]}
ln -s $sys_zsh shell

# link service daemon to ~/.termux/* directory
ln -s ${dirs[sys_run]} ${dirs[usr_run]}
ln -s ${dirs[sys_log]} ${dirs[usr_log]}

debugScript tree $HOME/.termux
debugLog "8/18 Have the symbolic links been successfully created?"

log "Next: Downloading config files..."

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

debugScript tree $HOME/.termux $HOME/.config
debugScript echo "$(getHash config/termux/termux.properties) $usr_tmx_prop" | sha256sum -c
debugScript echo "$(getHash config/starship.toml) $usr_starship_cnf" | sha256sum -c
debugScript echo "$(getHash config/micro/settings.json) $usr_micro_cnf" | sha256sum -c
debugScript echo "$(getHash config/htop/htoprc) $usr_htop_cnf" | sha256sum -c
debugScript echo "$(getHash config/mpd/mpd.conf) $usr_mpd_cnf" | sha256sum -c
debugScript echo "$(getHash config/nginx/nginx.conf) $usr_nginx_cnf" | sha256sum -c
debugScript echo "$(getHash config/ncmpcpp/config) $usr_ncmpcpp_cnf" | sha256sum -c
debugScript echo "$(getHash etc/ssh/ssh_config.d/00-env.conf) $sys_ssh_00_cnf" | sha256sum -c
debugScript echo "$(getHash etc/ssh/sshd_config.d/00-hosting.conf) $sys_sshd_00_cnf" | sha256sum -c
debugScript echo "$(getHash etc/ssh/sshd_config.d/01-env.conf) $sys_sshd_01_cnf" | sha256sum -c
debugLog "9/18 Have the config files been successfully downloaded?"

log "Next: Downloading service daemon files..."

curl -fsSLo $sys_mpd_run $gh_mpd_run
curl -fsSLo $sys_nginx_run $gh_nginx_run
curl -fsSLo $sys_sshd_run $gh_sshd_run

debugScript tree $PREFIX/var/service
debugScript echo "$(getHash service/mpd/run) $sys_mpd_run" | sha256sum -c
debugScript echo "$(getHash service/nginx/run) $sys_nginx_run" | sha256sum -c
debugScript echo "$(getHash service/sshd/run) $sys_sshd_run" | sha256sum -c
debugLog "10/18 Have the service daemon files been successfully downloaded?"

log "Next: Creating symbolic links for service daemon logs..."

cd $TMPDIR
ln -s $sys_svlogger run
curl -fsSLo run $gh_log_run

for f in ${dirs[sys_run]}/*; do
  rm -rf $f/log/run;
  cp -P run $f/log/;
done

debugScript tree $PREFIX/var/service
debugLog "11/18 Have the symbolic links for the service daemon logs been successfully created?"

log "Next: Downloading fonts..."

curl -fsSLo $usr_font $host_font

debugScript tree $HOME/.termux
debugScript echo "22d18aa0eac12ee0416e12dda68168d3610ce71521e6faf272b8615a6c5f0f30 $usr_font" | sha256sum -c
debugLog "12/18 Have the fonts been successfully downloaded?"

log "Next: Installing Micro editor plugins..."

micro -plugin install prettier quoter filemanager

debugLog "13/18 Have the Micro editor plugins been successfully installed?"

log "Next: Installing Oh My Zsh..."

bash -c "$(curl -fsSL $gh_ohmyzsh)" "" --unattended

debugLog "14/18 Has Oh My Zsh been successfully installed?"

log "Next: Installing Oh My Zsh plugins..."

plugins=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
git clone ${dirs[gh]}/zsh-users/zsh-autosuggestions.git $plugins/zsh-autosuggestions
git clone ${dirs[gh]}/zdharma-continuum/fast-syntax-highlighting.git $plugins/fast-syntax-highlighting
sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions fast-syntax-highlighting)/' $HOME/.zshrc

debugLog "15/18 Have the Oh My Zsh plugins been successfully installed?"

log "Next: Adding custom scripts to .zshrc..."

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

debugScript micro .zshrc
debugLog "16/18 Have the custom scripts been successfully added to .zshrc?"

log "Next: Reloading Termux settings..."

termux-reload-settings

log "Next: Initializing Zsh..."

zsh -lc 'sleep 1;'

[ -z $SVDIR ] && export SVDIR=${dirs[sys_run]} && log "Fixed: Export SVDIR daemon..."

log "Next: Enabling service daemons..."

sv_list=(mpd sshd);

for v in "${sv_list[@]}"; do sv-enable $v; done

debugScript tree $PREFIX/var/service
debugLog "17/18 Have the service daemons been successfully enabled?"

log "Next: Installing additional packages with pnpm..."

pnpm i -g prettier prettier-plugin-tailwindcss;

debugLog "18/18 Have the additional packages been successfully installed with pnpm?"

log "Next: Starting Zsh..."

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
