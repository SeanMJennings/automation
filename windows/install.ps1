winget install -e --id Google.Drive
winget install -e --id Ditto.Ditto
winget install -e --id Google.Chrome
winget install -e --id Greenshot.Greenshot
winget install -e --id WhatsApp.WhatsApp
winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000" # for arduino c++ development

choco install 7zip -yr
choco install teamviewer -yr
choco install dotnet-sdk -yr
choco install malwarebytes -yr
choco install jetbrains-rider -yr
choco install pycharm-community -yr
choco install visualstudiocode -yr
choco install visualstudio2022professional -yr
choco install sql-server-2022 -yr
choco install sqllocaldb -yr
choco install sql-server-management-studio -yr
choco install sqlserver-cmdlineutils -yr
choco install azure-cosmosdb-emulator
choco install azure-data-studio -yr
choco install azure-cli -yr
choco install servicebusexplorer -yr
choco install nodejs -yr
choco install yarn -yr
choco install notepadplusplus -yr
choco install brave -yr
choco install nordpass -yr
choco install nordvpn -yr
choco install python -yr

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SqlWmiManagement')
$wmi = [Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer]::new('localhost')
$tcp = $wmi.ServerInstances['MSSQLSERVER'].ServerProtocols['Tcp']
$tcp.IsEnabled = $true
$tcp.Alter()
$server = [Microsoft.SqlServer.Management.Smo.Server]::new('localhost')
$server.LoginMode = 'Mixed'
$server.Alter()
Restart-Service -Name MSSQLSERVER -Force

yarn global add npm-check-updates
yarn global add serve

Read-Host "Computer will restart then please run .\automation\windows\configure.ps1"
Restart-Computer
