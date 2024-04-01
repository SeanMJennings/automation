function AssociateFileExtensions ($Extensions, $OpenAppPath) {
    foreach ($Extension in $Extensions) {
        $Extension | % {
            try
            {
                $var = $_.FileExtension
                $fileType = (cmd /c "assoc .ps").Split("=")[-1]
            }
            catch
            {
                $var = $_.FileExtension
                $var2 = $_.Associate
                $fileType = (cmd /c "assoc .ps1=PS1 File").Split("=")[-1]
                Write-Host $fileType
            }
            finally
            {
                cmd /c "ftype $fileType=""$OpenAppPath"" ""%1"""
            }
        }
    }
}

$jetBrainsExtensions = @( 
    @{ FileExtension=".ps1"; Associate="PS1 File"; }
)
AssociateFileExtensions $jetBrainsExtensions "$env:programFiles(x86)\JetBrains\JetBrains Rider 2023.3.4\bin\rider64.exe"
##AssociateFileExtensions .py "$env:programFiles\Microsoft VS Code\Code.exe"
##AssociateFileExtensions .txt, .json "$env:programFiles\Notepad++\notepad++.exe"

#$name = read-host `nPlease enter your name
#$email = read-host `nPlease enter your email address
#
#git config --global user.name $name
#git config --global user.email $email
#
#& "~\automation\windows\configs\win10_configure.ps1"
#& "~\automation\windows\configs\VSCode\extensions.ps1"
#
#Copy-Item "~\automation\windows\configs\VSCode\*.json" "$env:userprofile\AppData\Roaming\Code\User"
#Read-Host "Computer will restart then please run .\automation\windows\disable_startups.ps1"
#Restart-Computer