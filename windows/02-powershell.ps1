$projectsRoot = [System.Environment]::GetEnvironmentVariable('ProjectsRoot', 'User')
Set-Location $projectsRoot

winget install -e --id Microsoft.PowerShell #Powershell 7+
git clone git@github.com:SeanMJennings/automation.git

Copy-Item "$projectsRoot\automation\windows\powershell\*" (split-path $PROFILE) -Recurse -Force

$content = {(Get-Content "$projectsRoot\automation\windows\powershell\Microsoft.PowerShell_profile.ps1")}.Invoke()
$content.Insert(0, "`$projectsRoot = `"$projectsRoot`"") 
$content | Set-Content $PROFILE

if($PROFILE -Match "WindowsPowerShell") {
    Write-Host `nSetting up PowerShell Core `(PowerShell 7`) profile
    $destination = "$(($PROFILE))\.." -replace "WindowsPowerShell", "PowerShell"
    Copy-Item "$($PROFILE)\.." $destination -Recurse -Force
}

$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

foreach ($profile in $settings.profiles.list) {
    if ($profile.name -match "PowerShell") {
        $profile | Add-Member -NotePropertyName "elevate" -NotePropertyValue $true -Force
    }
}

$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath

& $PROFILE

write-host "`nPlease run .\automation\windows\03-clean.ps1"
