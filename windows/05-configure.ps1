function AssociateFileExtensions ($Extensions, $OpenAppPath) {
    foreach ($Extension in $Extensions) {
        Register-FTA $OpenAppPath $Extension
        Write-Host "Associate file extension $Extension with $OpenAppPath"
    }
}

cd $PSScriptRoot
. .\SetFileTypeAssociation.ps1

$riderExtensions = @(".ps1",".sln",".csproj",".cs",".yaml")
$pyCharmExtensions = @(".py",".toml")
$notePadPlusPlusExtensions = @(".txt",".json")

AssociateFileExtensions $riderExtensions "$env:LOCALAPPDATA\Programs\Rider\bin\rider64.exe"
AssociateFileExtensions $pyCharmExtensions "$env:LOCALAPPDATA\Programs\PyCharm\bin\pycharm64.exe"
AssociateFileExtensions $notePadPlusPlusExtensions "$env:programFiles\Notepad++\notepad++.exe"

choco install boxstarter

import-module "$env:ALLUSERSPROFILE\Boxstarter\Boxstarter.Chocolatey"
Disable-GameBarTips

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-BoxstarterTaskbarOptions -Unlock -Dock Bottom -Combine Always -Size Small
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key DontUsePowerShellOnWinX 0
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key ShowSuperHidden 0
Set-ItemProperty $key ShowTaskViewButton 0
Stop-Process -ProcessName explorer -Force

& "~\automation\windows\configs\VSCode\extensions.ps1"

Copy-Item "~\automation\windows\configs\VSCode\*.json" "$env:userprofile\AppData\Roaming\Code\User"
Read-Host "Please run .\automation\windows\06-disable-startups.ps1"
Remove-Item .\SetFileTypeAssociation.ps1 -Force
