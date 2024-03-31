function AssociateFileExtensions ($Extensions, $OpenAppPath){
    $Extensions | % {
        try {$fileType = (cmd /c "assoc $_").Split("=")[-1]}
        catch {}
        finally {cmd /c "ftype $fileType=""$OpenAppPath"" ""%1"""}
    }
}

AssociateFileExtensions .cs,.csproj,.sln,.ps1,.psm1,.js,.ts,.json "{$env:programFiles(x86)}\JetBrains\JetBrains Rider 2023.3.4\bin\rider64.exe"
AssociateFileExtensions .py "$env:programFiles\Microsoft VS Code\Code.exe"
AssociateFileExtensions .txt "$env:programFiles\Notepad++\notepad++.exe"

$email = read-host `nPlease enter your email address

git config --global user.name $email
git config --global user.email $email

& "~\automation\windows\configs\win10_configure.ps1"
& "~\automation\windows\configs\VSCode\extensions.ps1"

Copy-Item "~\automation\windows\configs\VSCode\*.json" "$env:userprofile\AppData\Roaming\Code\User"
Read-Host "Computer will restart then please run .\automation\windows\disable_startups.ps1"
Restart-Computer