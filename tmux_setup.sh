#! /bin/bash

sudo apt install zsh tmux -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "set -g mouse on" >> ~/.tmux.conf

cat >> ~/.zshrc << EOL
if [[ \$- =~ i ]] && [[ -z "\$TMUX" ]] && [[ -n "\$SSH_TTY" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

EOL
tmux new-session -s ssh_tmux

