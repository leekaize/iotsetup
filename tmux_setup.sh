#! /bin/bash

sudo apt install zsh tmux -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "set -g mouse on" >> ~/.tmux.conf
