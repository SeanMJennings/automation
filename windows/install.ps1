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
choco install pycharm-community -yr
winget install -e --id=astral-sh.uv

choco install 7zip -yr
choco install teamviewer -yr
choco install malwarebytes -yr
choco install jetbrains-rider -yr
choco install vscode -yr
choco install nuget.commandline -yr
choco install azure-cosmosdb-emulator -yr
choco install azure-data-studio -yr
choco install azure-cli -yr
choco install azure-functions-core-tools -yr
choco install servicebusexplorer -yr
choco install nodejs -yr
choco install yarn -yr
choco install nunit-console-runner -yr
choco install notepadplusplus -yr
choco install brave -yr
choco install nordpass -yr
choco install nordvpn -yr
choco install zoom -yr
choco install docker-desktop -yr

choco install qgis -yr
choco install dbeaver -yr
$password = read-host "Enter password for postgresql"
choco install postgresql17 --params `/Password:${password}` --ia '--enable-components server,commandlinetools' -yr

choco install sql-server-2022 -yr
choco install sql-server-management-studio -yr
choco install sqlcmd -yr
refreshenv
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SqlWmiManagement')
$wmi = [Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer]::new('localhost')
$tcp = $wmi.ServerInstances['MSSQLSERVER'].ServerProtocols['Tcp']
$tcp.IsEnabled = $true
$tcp.Alter()
$server = [Microsoft.SqlServer.Management.Smo.Server]::new('localhost')
$server.LoginMode = 'Mixed'
$server.Alter()
sqlcmd -S . -Q "ALTER LOGIN sa DISABLE;"
Restart-Service -Name MSSQLSERVER -Force

yarn global add azurite
yarn global add npm-check-updates
yarn global add serve
yarn global add vite

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
wsl --install
wsl --install -d Debian

Read-Host "Computer will restart then please run .\automation\windows\configure.ps1"
Restart-Computer