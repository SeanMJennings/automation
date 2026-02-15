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

read -p "Please add ssh key to GitHub and then press enter"
ssh -T git@github.com

git config --global core.compression 0
git config --global init.defaultBranch main

read -p "Please enter your name for git: " name
git config --global user.name "$name"
git config --global user.email "$email"

cd "$projectsRoot"
