function AssociateFileExtensions ($Extensions, $OpenAppPath){
    $Extensions | % {
        $fileType = (cmd /c "assoc $_").Split("=")[-1]
        cmd /c "ftype $fileType=""$OpenAppPath"" ""%1"""
    }
}

AssociateFileExtensions .txt,.ps1,.psm1,.js "$env:programFiles\Microsoft VS Code\Code.exe"

$email = read-host `nPlease enter your email address

write-host "`nCreate a personal access token on github with read:packages permission" -fore yellow
$username = read-host `nPlease enter your GitHub username

git config --global user.name $email
git config --global user.email $email

& "~\automation\windows\configs\win10_configure.ps1"
& "~\automation\windows\configs\VSCode\extensions.ps1"

Copy-Item "~\automation\windows\configs\VSCode\*.json" "$env:userprofile\AppData\Roaming\Code\User"

Restart-Computer