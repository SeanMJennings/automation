#!/bin/bash

set -e

sudo apt update
sudo apt install curl

if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo "" >> "$HOME/.bashrc"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    sudo apt-get install -y build-essential
    brew install gcc
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

sudo apt-get update
sudo apt-get install -y wget apt-transport-https
sudo apt-get install -y dotnet-sdk-10.0
sudo apt update
sudo apt install gh -y

gh auth login --scopes read:packages --git-protocol ssh --hostname github.com --skip-ssh-key --web

token=$(gh auth token)
dotnet nuget remove source github 2>/dev/null || true
dotnet nuget add source https://nuget.pkg.github.com/SeanMJennings/index.json --name github --username SeanMJennings --password "$token" --store-password-in-clear-text

brew install nuget
brew install unixodbc
brew install freetds
brew install azure-cli
brew install sqlcmd

sudo apt install -y nodejs
sudo apt install -y npm

npm install -g azurite
npm install -g npm-check-updates
npm install -g serve
npm install -g vite

curl -fsSL https://claude.ai/install.sh | bash

sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt install -y snap
sudo snap install postman
sudo snap install storage-explorer
sudo snap install dbeaver-ce --stable --classic

read -p "Computer will now be restarted to finish installation. Press any key"
sudo systemctl reboot
