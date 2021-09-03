set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
set-location ~

remove-item alias:curl

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
& $PSScriptRoot\AddEnvironmentPaths.ps1
& $PSScriptRoot\Projects.ps1

(get-projects).GetEnumerator() | Where-Object { [bool]$_.Value.Script } |  % { import-module $_.Value.Script -DisableNameChecking }

write-host "Does update work locally"

function Edit-Profile { code (Split-Path $PROFILE) }

function Edit-Hosts{ code c:\windows\system32\drivers\etc\hosts }

function Update-Automation { 
  $automationDir =((get-projects).GetEnumerator() | Where-Object { $_.Name -eq "Automation" }).Value.Directory 
  
  if(!(Test-Path $automationDir)){ clone Automation }

  pull Automation

  Remove-Item "$(Split-Path $PROFILE)\Modules\*" -r -for
  Copy-Item "$automationDir\windows\powershell\modules" (Split-Path $PROFILE) -r -fo

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