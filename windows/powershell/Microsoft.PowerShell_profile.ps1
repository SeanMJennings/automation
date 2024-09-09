set-variable -name HOME -value $projectsRoot -force
(get-psprovider FileSystem).Home = $projectsRoot
set-location ~

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
& $PSScriptRoot\AddEnvironmentPaths.ps1
& $PSScriptRoot\Projects.ps1

Get-ChildItem -LiteralPath "$($PROFILE)\..\Modules" -Filter '*.psm1' -Recurse -File | ForEach-Object {
  Import-Module $PSItem.FullName -DisableNameChecking
}

function Edit-Profile { code (Split-Path $PROFILE) }

function Edit-Hosts { code c:\windows\system32\drivers\etc\hosts }

function Update-Automation { 
  $automationDir = ((get-projects).GetEnumerator() | Where-Object { $_.Name -eq "Automation" }).Value.Directory 
  
  if (!(Test-Path $automationDir)) { clone Automation }

  pull Automation

  $profileDir = Split-Path $PROFILE
  Remove-Item "$profileDir\Modules\*" -Recurse -Force
  Copy-Item "$automationDir\windows\powershell\modules" $profileDir -Recurse -Force
  Copy-Item "$automationDir\windows\powershell\AddEnvironmentPaths.ps1" -Destination "$profileDir\AddEnvironmentPaths.ps1" -Force
  
  Write-Host "`nUpdated automation scripts. Reloading shell`n" -Fore Green
  powershell.exe -nologo
}

function prompt {
  $origLastExitCode = $LASTEXITCODE

  $maxPathLength = 40
  $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
  if ($curPath.Length -gt $maxPathLength) {
    $curPath = '...' + $curPath.SubString($curPath.Length - $maxPathLength + 3)
  }

  Write-Host $curPath -ForegroundColor Green
  $LASTEXITCODE = $origLastExitCode
  "$('>' * ($nestedPromptLevel + 1)) "
}