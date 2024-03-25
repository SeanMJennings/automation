Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None=0,
    Automation=1,
    MineGame = 2,
    mine_game = 4,
    BeautyContest = 8,
    TechnicalDebtWheel = 16,
    All=Automation + MineGame + mine_game + BeautyContest + TechnicalDebtWheel
}
"@

function global:Get-Projects {
    return @{ 
         [Project]::Automation         = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/automation.git"; 
             Directory    = "~\automation"; 
             CodeSolution = "~\automation"; 
         };
         [Project]::MineGame           = [PSCustomObject]@{ 
             Git        = "git@github.com:SeanMJennings/MineGame.git"; 
             Directory  = "~\MineGame";
             CodeSolution = "~\MineGame\MineGame.sln"; 
         };
         [Project]::mine_game          = [PSCustomObject]@{ 
             Git        = "git@github.com:SeanMJennings/mine_game.git"; 
             Directory  = "~\mine_game"; 
             VsSolution = "~\mine_game"; 
         };
         [Project]::BeautyContest      = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/BeautyContest.git"; 
             Directory    = "~\BeautyContest";
             CodeSolution = "~\BeautyContest\BeautyContest.sln"; 
         };         
         [Project]::TechnicalDebtWheel = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/TechnicalDebtWheel.git"; 
             Directory    = "~\TechnicalDebtWheel";
             VsSolution = "~\TechnicalDebtWheel"; 
         };
    }
}

function global:Update-Projects { 
    $automationDir = ((get-projects).GetEnumerator() | where { $_.Name -eq "Automation" }).Value.Directory 
    $profileDir = Split-Path $PROFILE
   
    if (!(Test-Path $automationDir)) { clone Automation }

    pull Automation
 
    Copy-Item "$automationDir\windows\powershell\Projects.ps1" -Destination "$profileDir\Projects.ps1" -fo
    Write-Host "`nUpdated projects. Reloading shell`n" -Fore Green
    powershell.exe -nologo
}