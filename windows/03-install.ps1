winget install -e --id Google.Drive
winget install -e --id Ditto.Ditto
winget install -e --id Google.Chrome
winget install -e --id Greenshot.Greenshot
winget install -e --id WhatsApp.WhatsApp
winget install -e --id Postman.Postman
winget install -e --id Microsoft.PowerShell
winget install -e --id Microsoft.VisualStudio.2022.Professional --override "--add Microsoft.VisualStudio.Component.CoreEditor --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.AzureBuildTools --includeRecommended --passive"
winget install -e --id Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000" # for arduino c++ development

choco install python -yr
winget install -e --id=astral-sh.uv

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
choco install yarn -yr
choco install nunit-console-runner -yr
choco install notepadplusplus -yr
choco install nordpass -yr
choco install nordvpn -yr
choco install zoom -yr
choco install docker-desktop -yr
choco install dbeaver -yr
choco install sql-server-management-studio -yr
choco install sqlcmd -yr

yarn global add azurite
yarn global add npm-check-updates
yarn global add serve
yarn global add vite
yarn global add @anthropic-ai/claude-code

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
wsl --install -d Debian

Read-Host "Computer will restart then please run .\automation\windows\04-configure.ps1"
Restart-Computer
