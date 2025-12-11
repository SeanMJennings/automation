##### PRE REQUISITE #####
# allow download of chocolatey and setup azure artifacts cred provider
# Set-ExecutionPolicy -ExecutionPolicy Bypass
# then set to RemoteSigned at the end of this script
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
########################

$projectsRoot = "C:\Users\seanj\repos"
mkdir $projectsRoot -force
[System.Environment]::SetEnvironmentVariable('ProjectsRoot',$projectsRoot, 'User')

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
Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue

$name = read-host `nPlease enter your name for git
$email = read-host `nPlease enter your email address for git
git config --global user.name $name
git config --global user.email $email

Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-artifacts-credprovider.ps1) } -AddNetfx" # azure artifacts cred provider whilst remote signed off
write-host "`nPlease change the execution policy back to RemoteSigned" -fore yellow
write-host "`nPlease run .\automation\windows\02-powershell.ps1"
