#!/bin/bash

set -e

projectsRoot="/home/seanjennings/repos"
mkdir -p "$projectsRoot"
echo "export ProjectsRoot=$projectsRoot" >> "$HOME/.bashrc"
export ProjectsRoot="$projectsRoot"

sudo apt update
sudo apt install -y git curl

sshDirectory="$HOME/.ssh"
mkdir -p "$sshDirectory"
chmod 700 "$sshDirectory"

read -p "Please enter your email address for git: " email
ssh-keygen -t ed25519 -C $email
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub

git config --global core.compression 0
git config --global init.defaultBranch main

read -p "Please enter your name for git: " name
git config --global user.name "$name"
git config --global user.email "$email"

type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

if ! grep -q "ssh-agent" "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" << 'EOF'

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_rsa 2>/dev/null
fi
EOF
fi

cd "$projectsRoot"
