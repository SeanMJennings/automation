#!/bin/bash

set -e

sudo apt update
sudo apt upgrade
sudo apt install curl
sudo apt install -y python3
sudo apt install -y python3-pip
sudo apt install -y python3-dev python3-venv build-essential
sudo apt install xpad

sudo apt install -y ca-certificates
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo -e "Types: deb\nURIs: https://download.docker.com/linux/ubuntu\nSuites: $(. /etc/os-release && echo "$UBUNTU_CODENAME")\nComponents: stable\nSigned-By:
    /etc/apt/keyrings/docker.asc" | sudo tee /etc/apt/sources.list.d/docker.sources
sudo apt update
sudo sed -i '1a Architectures: amd64' /etc/apt/sources.list.d/docker.sources
curl -L -o docker-desktop-amd64.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"
sudo apt-get update
sudo apt install -y ./docker-desktop-amd64.deb
rm docker-desktop-amd64.deb

sudo apt install libfuse2
URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' \
| grep -oP '"linux":\{[^}]*"link":"\K[^"]+')
FILE=$(basename "$URL")
DIR="${FILE%.tar.gz}"
wget -c "$URL"
tar -xzf "$FILE"
sudo mv "$DIR" /opt/
rm -rf "$DIR" "$FILE"

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

sudo apt install -y copyq
sudo apt-get update
sudo apt-get install -y wget apt-transport-https
sudo apt-get install -y dotnet-sdk-10.0
sudo apt update
sudo apt install -y gh

gh auth login --scopes read:packages --git-protocol ssh --hostname github.com --skip-ssh-key --web
token=$(gh auth token)
dotnet nuget remove source github 2>/dev/null || true
dotnet nuget add source https://nuget.pkg.github.com/SeanMJennings/index.json --name github --username SeanMJennings --password "$token" --store-password-in-clear-text
dotnet tool install -g Aspire.Cli --prerelease

brew install nuget
brew install unixodbc
brew install freetds
brew install azure-cli
brew install sqlcmd

curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ noble main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli

sudo apt-get -y install nunit-console
sudo apt install -y nodejs
sudo apt install -y npm

npm install -g azurite
npm install -g npm-check-updates
npm install -g serve
npm install -g vite
npm install -g azure-functions-core-tools

curl -fsSL https://claude.ai/install.sh | bash

sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt install -y snap
sudo snap install postman
sudo snap install storage-explorer
sudo snap install dbeaver-ce --stable --classic
sudo snap install whatsapp-linux-app
sudo snap install proton-mail
sudo snap install proton-pass
sudo snap install zoom-client

read -p "Computer will now be restarted to finish installation. Press any key"
sudo systemctl reboot
