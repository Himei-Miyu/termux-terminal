#!/bin/bash

TERMUX_ROOT_DIR=$PREFIX/etc/termux
TERMUX_HOME_DIR=~/.termux
TERMUX_FONT_FILE=$TERMUX_HOME_DIR/font.ttf
MOTD_FILE=$PREFIX/etc/motd
PKGs=(rsync htop termux-api tmux jq tree nodejs zsh micro starship neofetch openssh openssl-tool gnupg git)
HOST="https://himei.city"
FONT_URL="$HOST/fonts/FiraCodeNerdFont-Regular.ttf"
TERMUX_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/configs/termux/termux.properties"
STARSHIP_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/configs/starship/starship.toml"
MICRO_CONF_URL="https://raw.githubusercontent.com/Himei-Miyu/termux-terminal/refs/heads/main/configs/micro/settings.json"
ZSH_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

mv $MOTD_FILE $MOTD_FILE.bak
echo -e "" > "$MOTD_FILE"
mv ~/.termux/termux.properties $PREFIX/etc/termux.properties.bak

rm -rf ~/.config* ~/.termux* ~/.screen* ~/.vim* ~/.zsh* ~/.oh-my* ~/.zcom* ~/.cache* ~/.local* ~/.npm*
mkdir -p ~/.config/micro ~/.termux
mv $PREFIX/etc/termux.properties.bak ~/.termux/
curl -fsSLo ~/.termux/termux.properties $TERMUX_CONF_URL
curl -fsSLo ~/.config/starship.toml $STARSHIP_CONF_URL
curl -fsSLo ~/.config/micro/settings.json $MICRO_CONF_URL
cat $TERMUX_ROOT_DIR/mirrors/default > $TERMUX_ROOT_DIR/chosen_mirrors
apt update;
apt -y -o Dpkg::Options::="--force-confdef" upgrade;
apt install -y ${PKGs[@]}
npm install -g pnpm
curl -fsSL $ZSH_URL | bash -
curl -fsSLo $TERMUX_FONT_FILE $FONT_URL

addLine() { echo "$1" >> ~/.zshrc; }
addLine 'neofetch'
addLine 'eval "$(starship init zsh)"'
addLine 'export GPG_TTY=$(tty)'
addLine 'alias l="ls -A"'

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc

echo "Staring... zsh"
sleep 2
clear
zsh
