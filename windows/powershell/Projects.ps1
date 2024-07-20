Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None=0,
    Automation=1,
    BeautyContest = 2,
    CrudApi = 4,
    LoanInterestCalculator = 8,
    MineGame = 16,
    mine_game = 32,
    RuleOfThree = 64,
    All=Automation + BeautyContest + MineGame + mine_game + RuleOfThree
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
         [Project]::BeautyContest      = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/BeautyContest.git"; 
             Directory    = "~\BeautyContest";
             DotnetSolution = "~\BeautyContest\BeautyContest.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };              
         [Project]::CrudApi      = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/CrudApi.git"; 
             Directory    = "~\CrudApi";
             DotnetSolution = "~\CrudApi\CrudApi.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };         
         [Project]::LoanInterestCalculator      = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/LoanInterestCalculator.git"; 
             Directory    = "~\LoanInterestCalculator";
             DotnetSolution = "~\LoanInterestCalculator\LoanInterestCalculator.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
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
             PythonSolution = "~\mine_game";
             ProjectTypes = @([ProjectTypes]::Python)
         };
         [Project]::RuleOfThree = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/RuleOfThree.git"; 
             Directory    = "~\RuleOfThree";
             PythonSolution = "~\RuleOfThree\server";
             CodeSolution = "~\RuleOfThree\client";
             ProjectTypes = @([ProjectTypes]::JavaScript,[ProjectTypes]::Python)
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