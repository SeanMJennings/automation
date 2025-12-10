sudo apt install git
apt install curl
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

theUser=$(whoami)
echo >> /home/"$theUser"/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/"$theUser"/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

sudo apt-get install build-essential
brew install gcc
brew install asdf

sudo apt-get update
sudo apt-get install -y wget
source /etc/os-release
version_id=$(cat /etc/debian_version)
wget -q https://packages.microsoft.com/config/debian/$version_id/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

sudo apt install snapd
sudo snap install postman
sudo snap install code --classic
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --version latest
brew install nuget

asdf plugin-add python
asdf install python
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
brew install unixodbc
brew install freetds --with-unixodbc

brew install azure-cli
sudo snap install azuredatastudio
sudo snap install storage-explorer
brew install node
brew install postgresql
sudo snap install dbeaver-ce
brew install sqlcmd

npm install -g azurite
npm install -g npm-check-updates
npm install -g serve
npm install -g vite
npm install -g @anthropic-ai/claude-code