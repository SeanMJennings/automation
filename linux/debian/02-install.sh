#!/bin/bash

set -e

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

if ! command -v asdf &> /dev/null; then
    curl -sL https://raw.githubusercontent.com/wslutilities/wslu/master/extras/scripts/wslu-install | bash
    brew install asdf
    echo ". $(brew --prefix asdf)/libexec/asdf.sh" >> "$HOME/.bashrc"
    . "$(brew --prefix asdf)/libexec/asdf.sh"
fi

sudo apt-get update
sudo apt-get install -y wget apt-transport-https
wget https://packages.microsoft.com/config/debian/$(cat /etc/debian_version | cut -d'.' -f1)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-9.0
sudo apt update
sudo apt install -y libpci3 libegl1 libgl1 dbus-x11
sudo apt install firefox-esr
sudo apt install gh -y

sudo service dbus start
gh auth login --scopes read:packages --git-protocol ssh --hostname github.com --skip-ssh-key --web
sudo service dbus stop

token=$(gh auth token)
dotnet nuget remove source github 2>/dev/null || true
dotnet nuget add source https://nuget.pkg.github.com/SeanMJennings/index.json --name github --username SeanMJennings --password "$token" --store-password-in-clear-text

brew install nuget

sudo apt-get install -y powershell

if ! asdf plugin list | grep -q python; then
    asdf plugin-add python
fi
asdf install python latest
asdf global python latest

curl -sSL https://install.python-poetry.org | python3 -
if ! grep -q "poetry" "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

brew install unixodbc
brew install freetds

if ! asdf plugin list | grep -q nodejs; then
    asdf plugin-add nodejs
fi
asdf install nodejs latest
asdf global nodejs latest

brew install azure-cli
brew install sqlcmd

npm install -g azurite
npm install -g npm-check-updates
npm install -g serve
npm install -g vite
npm install -g @anthropic-ai/claude-code

if ! command -v snap &> /dev/null; then
    sudo apt update
    sudo apt install -y snapd
    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap 2>/dev/null || true
fi

sudo snap install code --classic
sudo snap install postman
sudo snap install storage-explorer
sudo snap install dbeaver-ce