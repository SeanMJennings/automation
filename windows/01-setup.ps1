##### PRE REQUISITE #####
# allow download of chocolatey and setup azure artifacts cred provider
# Set-ExecutionPolicy -ExecutionPolicy Bypass
# then set to RemoteSigned at the end of this script
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
########################

$projectsRoot = "C:\Users\seanj\repos"
mkdir $projectsRoot -force
[System.Environment]::SetEnvironmentVariable('ProjectsRoot',$projectsRoot, 'User')

winget install -e --id Microsoft.PowerShell #Powershell 7+

write-host "`nInstalling chocolatey" -fore yellow
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install git -yr

write-host "`nSetting up ssh" -fore yellow
$env:path += ";$env:programFiles\Git\bin;$env:programFiles\Git\cmd;$env:programFiles\Git\usr\bin;"
$sshDirectory = "$env:userprofile\.ssh"
mkdir $sshdirectory -force
ssh-keygen -f "$sshdirectory\id_rsa"

write-host "`n$sshdirectory\id_rsa.pub has been generated" -fore green
write-host "`nAdd the key to your github account" -fore red 
read-host "`n`nThen press any key"

Set-Location $projectsRoot
& "$env:programFiles\Git\usr\bin\ssh-agent.exe" | % {
        if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
            [void][Environment]::SetEnvironmentVariable($Matches['key'], $Matches['value'])
        }
    }
& "$env:programFiles\Git\usr\bin\ssh-add" "$sshdirectory\id_rsa"

git config --global core.compression 0 repack
git clone git@github.com:SeanMJennings/automation.git
Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue

$name = read-host `nPlease enter your name for git
$email = read-host `nPlease enter your email address for git

git config --global user.name $name
git config --global user.email $email

Copy-Item "$projectsRoot\automation\windows\powershell\*" (split-path $PROFILE) -Recurse -Force

$content = {(Get-Content "$projectsRoot\automation\windows\powershell\Microsoft.PowerShell_profile.ps1")}.Invoke()
$content.Insert(0, "`$projectsRoot = `"$projectsRoot`"") 
$content | Set-Content $PROFILE

if($PROFILE -Match "WindowsPowerShell") {
    Write-Host `nSetting up PowerShell Core `(PowerShell 7`) profile
    $destination = "$(($PROFILE))\.." -replace "WindowsPowerShell", "PowerShell"
    Copy-Item "$($PROFILE)\.." $destination -Recurse -Force
}

write-host "`nSetup Complete. Please edit Projects.ps1 found at (Split-Path $PROFILE)" -fore green

& $PROFILE

Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-artifacts-credprovider.ps1) } -AddNetfx" # azure artifacts cred provider
write-host "`nPlease change the execution policy back to RemoteSigned" -fore yellow
write-host "`nPlease run .\automation\windows\02-clean.ps1"
