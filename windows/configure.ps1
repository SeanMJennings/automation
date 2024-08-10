function AssociateFileExtensions ($Extensions, $OpenAppPath) {
    foreach ($Extension in $Extensions) {
        Register-FTA $OpenAppPath $Extension
        Write-Host "Associate file extension $Extension with $OpenAppPath"
    }
}

cd $PSScriptRoot

$jetBrainsExtensions = @(".ps1",".sln",".csproj",".cs",".yaml")
$pyCharmExtensions = @(".py",".toml")
$notePadPlusPlusExtensions = @(".txt",".json")

AssociateFileExtensions $jetBrainsExtensions "${Env:ProgramFiles(x86)}\JetBrains\JetBrains Rider 2023.3.4\bin\rider64.exe"
AssociateFileExtensions $pyCharmExtensions "$env:programFiles\JetBrains\PyCharm Community Edition 2024.1.4\bin\pycharm64.exe"
AssociateFileExtensions $notePadPlusPlusExtensions "$env:programFiles\Notepad++\notepad++.exe"

$name = read-host `nPlease enter your name
$email = read-host `nPlease enter your email address

git config --global user.name $name
git config --global user.email $email

& "~\automation\windows\configs\win10_configure.ps1"
& "~\automation\windows\configs\VSCode\extensions.ps1"

Copy-Item "~\automation\windows\configs\VSCode\*.json" "$env:userprofile\AppData\Roaming\Code\User"
Read-Host "Computer will restart then please run .\automation\windows\disable_startups.ps1"
Remove-Item .\SetFileTypeAssociation.ps1 -Force
Restart-Computer