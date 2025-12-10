Add-Type -TypeDefinition @"
public enum Project
{
    None,
    Automation,
    BeautyContest,
    CommonLibrary,
    LoanInterestCalculator,
    MessagingLibrary,
    MineGame,
    mine_game,
    ObservabilityLibrary,
    RuleOfThree,
    TestingLibrary,
    TicketBuddy_ModularMonolith,
    TypicalRestApi,
    WebApiLibrary
}
"@
Add-Type -TypeDefinition @"
public enum ProjectTypes
{
    None,
    Dotnet,
    JavaScript,
    Python
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
         [Project]::CommonLibrary = [PSCustomObject]@{
             Git        = "git@github.com:SeanMJennings/CommonLibrary.git";
             Directory  = "~\CommonLibrary";
             DotnetSolution = "~\CommonLibrary\Common.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };
         [Project]::LoanInterestCalculator      = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/LoanInterestCalculator.git"; 
             Directory    = "~\LoanInterestCalculator";
             DotnetSolution = "~\LoanInterestCalculator\LoanInterestCalculator.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };
         [Project]::MessagingLibrary = [PSCustomObject]@{
             Git        = "git@github.com:SeanMJennings/MessagingLibrary.git";
             Directory  = "~\MessagingLibrary";
             DotnetSolution = "~\MessagingLibrary\Messaging.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };
         [Project]::MineGame           = [PSCustomObject]@{
             Git        = "git@github.com:SeanMJennings/MineGame.git";
             Directory  = "~\MineGame";
             DotnetSolution = "~\MineGame\MineGame.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };
         [Project]::mine_game          = [PSCustomObject]@{
             Git        = "git@github.com:SeanMJennings/mine-game.git";
             Directory  = "~\mine-game";
             PythonSolution = "~\mine-game";
             ProjectTypes = @([ProjectTypes]::Python)
         };
         [Project]::ObservabilityLibrary = [PSCustomObject]@{
             Git        = "git@github.com:SeanMJennings/ObservabilityLibrary.git";
             Directory  = "~\ObservabilityLibrary";
             DotnetSolution = "~\ObservabilityLibrary\Observability.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };
         [Project]::RuleOfThree = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/rule-of-three.git"; 
             Directory    = "~\rule-of-three";
             PythonSolution = "~\rule-of-three\server";
             CodeSolution = "~\rule-of-three\client";
             ProjectTypes = @([ProjectTypes]::JavaScript,[ProjectTypes]::Python)
         };
         [Project]::TestingLibrary = [PSCustomObject]@{
             Git        = "git@github.com:SeanMJennings/TestingLibrary.git";
             Directory  = "~\TestingLibrary";
             DotnetSolution = "~\TestingLibrary\Testing.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };
         [Project]::TicketBuddy_ModularMonolith = [PSCustomObject]@{ 
             Git          = "git@github.com:SeanMJennings/TicketBuddy_ModularMonolith.git"; 
             Directory    = "~\TicketBuddy_ModularMonolith";
             DotnetSolution = "~\TicketBuddy_ModularMonolith\ModularMonolith\TicketBuddy.sln";
             CodeSolution = "~\TicketBuddy_ModularMonolith\UI";
             ProjectTypes = @([ProjectTypes]::JavaScript,[ProjectTypes]::Dotnet)
         };
         [Project]::TypicalRestApi = [PSCustomObject]@{
             Git          = "git@github.com:SeanMJennings/TypicalRestApi.git";
             Directory    = "~\TypicalRestApi";
             DotnetSolution = "~\TypicalRestApi\TypicalRestApi.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
         };
         [Project]::WebApiLibrary = [PSCustomObject]@{
             Git        = "git@github.com:SeanMJennings/WebApiLibrary.git";
             Directory  = "~\WebApiLibrary";
             DotnetSolution = "~\WebApiLibrary\WebApi.sln";
             ProjectTypes = @([ProjectTypes]::Dotnet)
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