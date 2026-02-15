winget install -e --id Google.GoogleDrive
winget install -e --id Ditto.Ditto
winget install -e --id Google.Chrome
winget install -e --id Greenshot.Greenshot
winget install -e --id 9NKSQGP7F2NH #WhatsApp
winget install -e --id Postman.Postman
winget install -e --id Microsoft.VisualStudio.2022.Professional --override "--add Microsoft.VisualStudio.Component.CoreEditor --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.AzureBuildTools --includeRecommended --passive"
winget install -e --id Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000" # for arduino c++ development
winget install -e --id NordSecurity.NordPass
winget install -e --id NordSecurity.NordVPN
winget install -e --id=astral-sh.uv

choco install gh -yr
choco install python -yr
choco install jetbrainstoolbox -yr
choco install 7zip -yr
choco install teamviewer -yr
choco install malwarebytes -yr
choco install vscode -yr
choco install nuget.commandline -yr
choco install azure-cli -yr
choco install azure-functions-core-tools -yr
choco install servicebusexplorer -yr
choco install nodejs -yr
choco install nunit-console-runner -yr
choco install notepadplusplus -yr
choco install zoom -yr
choco install docker-desktop -yr
choco install dbeaver -yr
choco install sql-server-management-studio -yr
choco install sqlcmd -yr

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
gh auth login --scopes read:packages --git-protocol ssh --hostname github.com --skip-ssh-key
$token = gh auth token
dotnet nuget remove source github
dotnet nuget add source https://nuget.pkg.github.com/SeanMJennings/index.json --name github --username SeanMJennings --password $token --store-password-in-clear-text
dotnet tool install -g Aspire.Cli --prerelease
dotnet dev-certs https --clean
dotnet dev-certs https --trust

npm install -g azurite
npm install -g npm-check-updates
npm install -g serve
npm install -g vite
npm install -g @anthropic-ai/claude-code

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
wsl --install -d Debian
wsl --set-default Debian

Read-Host "Computer will restart then please run .\automation\windows\05-configure.ps1"
Restart-Computer
