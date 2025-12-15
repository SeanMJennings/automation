$projectsRoot = [System.Environment]::GetEnvironmentVariable('ProjectsRoot', 'User')
Set-Location $projectsRoot
$powershellCoreProfileLocation = "$env:UserProfile\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$windowsPowershellProfileLocation = "$env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

winget install -e --id Microsoft.PowerShell #Powershell 7+

Copy-Item "$projectsRoot\automation\windows\powershell\*" (split-path $powershellCoreProfileLocation) -Recurse -Force
Copy-Item "$projectsRoot\automation\windows\powershell\*" (split-path $windowsPowershellProfileLocation) -Recurse -Force

$content = {(Get-Content "$projectsRoot\automation\windows\powershell\Microsoft.PowerShell_profile.ps1")}.Invoke()
$content.Insert(0, "`$projectsRoot = `"$projectsRoot`"") 
mkdir $env:UserProfile\Documents\PowerShell\ -force
mkdir $env:UserProfile\Documents\WindowsPowerShell\ -force
$content | Set-Content $env:UserProfile\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
$content | Set-Content $env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Personal" -Value "$env:UserProfile\Documents"

$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

foreach ($profile in $settings.profiles.list) {
    if ($profile.name -match "PowerShell") {
        $profile | Add-Member -NotePropertyName "elevate" -NotePropertyValue $true -Force
    }
}

$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
write-host "`nPlease run .\automation\windows\03-clean.ps1"