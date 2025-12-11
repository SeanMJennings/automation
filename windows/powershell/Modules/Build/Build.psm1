function GoTo ([Project] $project) {
    if ($project -eq [Project]::None) {
        Write-Host "`nNo project provided`n" -Fore Red
        return
    }
    Set-Location (Get-Projects).Get_Item($project).Directory
}

function SetupProject ([Project] $project) {
    function Setup-Project($targetProject) {
        if (-not(Test-Path "$($_.Value.Directory)")) { Clone $targetProject.key }
        else { pull $targetProject.Key }
            
        if (Test-Path "$($_.Value.Directory)\setupMyProject.ps1") {
            Write-Host "`nRunning $($targetProject.Key) Project setup`n" -ForegroundColor Green
            Set-Location $_.Value.Directory
            & "$($_.Value.Directory)\setupMyProject.ps1"
            Write-Host "`n$($targetProject.Key) project set up and ready to go`n" -ForegroundColor Green
        }
        else { Write-Host "`n$($targetProject.Key) does not have a project setup`n" -ForegroundColor Red }

        Build $targetProject.Key
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Setup-Project $_ }
}

function Open ([Project] $project = [Project]::None, [Switch] $clientOnly, [Switch] $serverOnly) {
    function Open-Project($targetProject) {
        $dir = Get-Location
        Set-Location $_.Value.Directory     
        
        git pull
        BreakOnFailure $dir '**************** Pull Failed ****************'

        if ($null -ne $_.Value.DotnetSolution -and -not $clientOnly) { 
            & $_.Value.DotnetSolution 
        } 

        if ($null -ne $_.Value.CodeSolution -and -not $serverOnly) { 
            $dir = Get-Location
            Set-Location ($_.Value.CodeSolution -replace '[^\\]+$')
            & rider64.exe ($_.Value.CodeSolution -replace '.*\\')
        }        
        
        if ($null -ne $_.Value.PythonSolution -and -not $clientOnly -and $_.Value.ProjectTypes.contains([ProjectTypes]::Python)) {
            $dir = Get-Location
            Set-Location ($_.Value.PythonSolution -replace '[^\\]+$')
            & pycharm64.exe ($_.Value.PythonSolution -replace '.*\\')
        }
        
        Set-Location $dir
    }

    Clear-Host
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Open-Project $_ }
}

function OpenInGitHub ([Project] $project = [Project]::None) {
    function Open-Project($targetProject) {
        $url = $_.Value.Git -replace "git@github.com:" -replace ".git"
        Start-Process "https://github.com/${url}"
    }
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Open-Project $_ }
}

function Build ([Project] $project, [Switch] $clientOnly, [Switch] $serverOnly) {
    function Build-Project($targetProject) {
        $dir = Get-Location
        Set-Location $_.Value.Directory         

        git pull
        BreakOnFailure $dir '**************** Pull Failed ****************'

        if ($null -ne $_.Value.DotnetSolution -and -not $clientOnly) { 
            Write-Host `nBuilding $targetProject.Key -Fore Green
            $solutionPath = Resolve-Path ($_.Value.DotnetSolution)            
            dotnet build $solutionPath --configuration Release -nologo --verbosity q --no-incremental 
            BreakOnFailure $dir '**************** Build Failed ****************'
            Migrate $targetProject.Key
            Write-Host `nRunning Tests`n -Fore Green
            dotnet test $solutionPath -m:1 --filter FullyQualifiedName!~Smokes --no-build --no-restore --nologo --verbosity m
            BreakOnFailure $dir '**************** Tests Failed ****************'
        }         

        if ($null -ne $_.Value.CodeSolution -and -not $serverOnly -and $_.Value.ProjectTypes.contains([ProjectTypes]::JavaScript)) {
            Write-Host `nBuilding JavaScript $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.CodeSolution         
            yarn
            yarn test
            BreakOnFailure $dir '**************** Javascript Build Failed ****************'
        }         
        
        if ($null -ne $_.Value.PythonSolution -and -not $clientOnly -and $_.Value.ProjectTypes.contains([ProjectTypes]::Python)) {
            Write-Host `nBuilding Python $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.PythonSolution
            & "$($_.Value.PythonSolution)\.venv\Scripts\activate.ps1"
            poetry run pytest
            deactivate
            BreakOnFailure $dir '**************** Python Build Failed ****************'
        } 

        Set-Location $dir
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Build-Project $_ }
    Write-Host `n**************** Build was successful ****************`n -Fore Green
}

function Migrate ([Project] $project) {
    function Migrate-Project($targetProject) {
        if ($null -ne $_.Value.DotnetSolution) { 
            $dir = Get-Location
            Set-Location $_.Value.Directory
            Get-ChildItem .\ -Recurse | where { $_.Fullname -Like "*bin\Run.exe" } | % {      
                Write-Host `nRunning Migrations - $_.FullName`n -Fore Green
                & (Resolve-Path $_.FullName)
                BreakOnFailure $dir 'Migrations Failed'
            }
            Set-Location $dir
        } 
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Migrate-Project $_ }
}
    
function Run-Client([Project] $project) {
    function Run($targetProject) {
        if ($null -ne $_.Value.CodeSolution) {
            Write-Host `nRunning $targetProject.Key client `n -Fore Green     
            Set-Location $_.Value.CodeSolution    
            yarn start            
        }
    }

    Clear-Host
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Run $_ }
}

function Run-Server([Project] $project) {
    function Run($targetProject) {
        if ($null -ne $_.Value.ServerHost) {
            if (!(Get-Process CosmosDB.Emulator -ErrorAction SilentlyContinue)) { CosmosDB.Emulator.exe /NoUi /PartitionCount=50 /NoExplorer /DefaultPartitionCount=50 }
            Write-Host `nRunning $targetProject.Key server `n -Fore Green
            Set-Location $_.Value.ServerHost
            dotnet watch run --urls https://localhost:5001
        }
    }

    Clear-Host
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Run $_ }
}

function Watch([Project] $project) {
    function Watch-Project($targetProject) {
        if ($null -ne $_.Value.CodeSolution) {
            Write-Host `nWatching JavaScript $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.CodeSolution    
            yarn watch
            Set-Location $dir
        }
    }

    Clear-Host
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Watch-Project $_ }
}

function BreakOnFailure([string] $directory, [string] $message = 'It failed!') {
    if ($lastexitcode -ne 0) {
        Write-Host `n $message`n -Fore Red
        Set-Location $directory
        break
    }
}

function ClearDotnetBuild([Project] $project = [Project]::None) {
    function Clear-Dotnet-Project($targetProject) {
        if ($null -ne $_.Value.DotnetSolution) {
            $dir = Get-Location
            Set-Location ($_.Value.Directory)
            gci -include bin,obj -recurse | remove-item -force -recurse
            Set-Location $dir
        }
    }

    Clear-Host
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Clear-Dotnet-Project $_ }
}