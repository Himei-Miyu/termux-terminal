#!/bin/bash

TERMUX_FOLDER=$PREFIX/etc/termux
MOTD_FILE=$PREFIX/etc/motd
PACKAGES=(htop termux-api tmux jq tree nodejs zsh micro starship neofetch openssh openssl-tool gnupg git)
FONT_URL="https://himei.city/fonts/FiraCodeNerdFont-Regular.ttf"
TERMUX_URL="https://himei.city/api/general/termux"
ZSH_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
#rm -rf ~/.config
rm -rf ~/.screen* ~/.vim* ~/.zsh* ~/.oh-my* ~/.zcom* ~/.cache ~/.local ~/.npm*
cat $TERMUX_FOLDER/mirrors/default > $TERMUX_FOLDER/chosen_mirrors
apt update;
apt -y -o Dpkg::Options::="--force-confdef" upgrade;
apt install -y ${PACKAGES[@]}
npm install -g pnpm
curl -fsSL $ZSH_URL | bash -
curl -fsSL $FONT_URL -o ~/.termux/font.ttf

echo 'neofetch' >> ~/.zshrc
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
echo 'export GPG_TTY=$(tty)' >> ~/.zshrc
echo 'alias l="ls -A"' >> ~/.zshrc
echo 'alias micro="micro -clipboard internal"' >> ~/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc

[ ! -f "${MOTD_FILE}.bak" ] && {
    cp "$MOTD_FILE" "${MOTD_FILE}.bak"
    echo -e "" > "$MOTD_FILE"
}
echo "Staring... zsh"
sleep 2
clear
zsh
