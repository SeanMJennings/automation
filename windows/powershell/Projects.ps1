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
Add-Type -TypeDefinition @"
[System.Flags]
public enum ProjectTypes
{
    None=0,
    Dotnet=1,
    JavaScript = 2,
    Python = 4,
    All=Dotnet + JavaScript + Python
}
"@

function global:Get-Projects {
    return @{ 
         [Project]::Automation         = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/automation.git"; 
             Directory    = "~\automation"; 
             CodeSolution = "~\automation";
             ProjectTypes = @([ProjectTypes]::None)
         };
         [Project]::MineGame           = [PSCustomObject]@{ 
             Git        = "git@github.com:SeanMJennings/MineGame.git"; 
             Directory  = "~\MineGame";
             DotnetSolution = "~\MineGame\MineGame.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };
         [Project]::mine_game          = [PSCustomObject]@{ 
             Git        = "git@github.com:SeanMJennings/mine_game.git"; 
             Directory  = "~\mine_game"; 
             CodeSolution = "~\mine_game";
             ProjectTypes = @([ProjectTypes]::Python)
         };
         [Project]::BeautyContest      = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/BeautyContest.git"; 
             Directory    = "~\BeautyContest";
             DotnetSolution = "~\BeautyContest\BeautyContest.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };         
         [Project]::TechnicalDebtWheel = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/TechnicalDebtWheel.git"; 
             Directory    = "~\TechnicalDebtWheel";
             CodeSolution = "~\TechnicalDebtWheel";
             ProjectTypes = @([ProjectTypes]::JavaScript)
         };
    }
}

function global:Update-Projects { 
    $automationDir = ((get-projects).GetEnumerator() | Where-Object { $_.Name -eq "Automation" }).Value.Directory 
    $profileDir = Split-Path $PROFILE
   
    if (!(Test-Path $automationDir)) { clone Automation }

    pull Automation
 
    Copy-Item "$automationDir\windows\powershell\Projects.ps1" -Destination "$profileDir\Projects.ps1" -fo
    Write-Host "`nUpdated projects. Reloading shell`n" -Fore Green
    powershell.exe -nologo
}