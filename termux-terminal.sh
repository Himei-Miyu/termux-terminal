#!/bin/bash

TERMUX_ROOT_DIR=$PREFIX/etc/termux
TERMUX_HOME_DIR=~/.termux
TERMUX_FONT_FILE=$TERMUX_HOME_DIR/font.ttf
MOTD_FILE=$PREFIX/etc/motd
PKGs=(rsync htop termux-api tmux jq tree nodejs zsh micro starship neofetch openssh openssl-tool gnupg git)
HOST="https://himei.city"
FONT_URL="$HOST/fonts/FiraCodeNerdFont-Regular.ttf"
TERMUX_CONF_URL="$HOST/api/general/termux"
STARSHIP_CONF_URL="$HOST/api/general/starship"
ZSH_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
#rm -rf ~/.config
rm -rf ~/.termux* ~/.screen* ~/.vim* ~/.zsh* ~/.oh-my* ~/.zcom* ~/.cache* ~/.local* ~/.npm*
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
addLine 'alias micro="micro -clipboard internal"'

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc



[ ! -f "$MOTD_FILE.bak" ] && {
    cp "$MOTD_FILE" "$MOTD_FILE.bak"
    echo -e "" > "$MOTD_FILE"
}
[ ! -f "~/.termux/termux.properties.bak" ] && {
	cp "~/.termux/termux.properties" "~/.termux/termux.properties.bak"
	curl -fsSLo ~/.termux/termux.properties $TERMUX_CONF_URL
}

echo "Staring... zsh"
sleep 2
clear
zsh
