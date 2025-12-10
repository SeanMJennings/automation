#!/bin/bash

set -e

projectsRoot="$HOME/repos"
mkdir -p "$projectsRoot"
echo "export ProjectsRoot=$projectsRoot" >> "$HOME/.bashrc"
export ProjectsRoot="$projectsRoot"

sudo apt update
sudo apt install -y git curl

sshDirectory="$HOME/.ssh"
mkdir -p "$sshDirectory"
chmod 700 "$sshDirectory"

if [ ! -f "$sshDirectory/id_rsa" ]; then
    ssh-keygen -t rsa -b 4096 -f "$sshDirectory/id_rsa" -N ""
fi

cat "$sshDirectory/id_rsa.pub"
echo ""
read -p "Press any key after adding the key to GitHub..."

eval "$(ssh-agent -s)"
ssh-add "$sshDirectory/id_rsa"

if [ ! -f "$sshDirectory/config" ]; then
    cat > "$sshDirectory/config" << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa
    AddKeysToAgent yes
EOF
    chmod 600 "$sshDirectory/config"
fi

ssh -T git@github.com || true

git config --global core.compression 0
git config --global init.defaultBranch main

read -p "Please enter your name for git: " name
read -p "Please enter your email address for git: " email
git config --global user.name "$name"
git config --global user.email "$email"

type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

gh auth login --scopes read:packages

token=$(gh auth token)
dotnet nuget remove source github 2>/dev/null || true
dotnet nuget add source https://nuget.pkg.github.com/SeanMJennings/index.json --name github --username SeanMJennings --password "$token" --store-password-in-clear-text

if ! grep -q "ssh-agent" "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" << 'EOF'

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_rsa 2>/dev/null
fi
EOF
fi

cd "$projectsRoot"


