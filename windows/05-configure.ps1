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

& "~\automation\windows\configs\windows_configure.ps1"
& "~\automation\windows\configs\VSCode\extensions.ps1"

Copy-Item "~\automation\windows\configs\VSCode\*.json" "$env:userprofile\AppData\Roaming\Code\User"
Read-Host "Please run .\automation\windows\06-disable-startups.ps1"
Remove-Item .\SetFileTypeAssociation.ps1 -Force
