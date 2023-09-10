#! /bin/bash

sudo apt install zsh tmux -y
echo "set -g mouse on" >> ~/.tmux.conf
read -p "After installation, re-login to update config. Press Enter to continue..." </dev/tty
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cat >> ~/.zshrc << EOL
if [[ \$- =~ i ]] && [[ -z "\$TMUX" ]] && [[ -n "\$SSH_TTY" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

EOL

