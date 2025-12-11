choco install boxstarter

import-module "$env:ALLUSERSPROFILE\Boxstarter\Boxstarter.Chocolatey"
Disable-GameBarTips

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-BoxstarterTaskbarOptions -Unlock -Dock Bottom -Combine Always -Size Small
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key DontUsePowerShellOnWinX 0
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key ShowSuperHidden 1
Set-ItemProperty $key ShowTaskViewButton 0
Stop-Process -ProcessName explorer -Force
