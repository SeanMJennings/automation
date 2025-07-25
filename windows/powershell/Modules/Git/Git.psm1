function Ssh-SignIn{
    Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue
        
    & "$env:programFiles\Git\usr\bin\ssh-agent.exe" | % {
        if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
            [void][Environment]::SetEnvironmentVariable($Matches['key'], $Matches['value'])
        }
    }

    & "$env:programFiles\Git\usr\bin\ssh-add.exe" $env:USERPROFILE\.ssh\id_rsa
}

function Status([Project] $project){
    function Show-Status($targetProject){
        Write-Host `nStatus for $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git status .
    } 

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Show-Status $_ }
    Set-Location $dir
}

function Pull ([Project] $project){
    function Git-Pull($targetProject){
        Write-Host `nPulling $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git pull
    }

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Git-Pull $_ }
    Set-Location $dir
}

function Push ([Project] $project = [Project]::None, $message, [Switch] $noBuild, [Switch] $clientOnly, [Switch] $serverOnly){
    function Git-Push($targetProject){
        Write-Host `nCommitting $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory        
        git add .
        git commit . -m $message --no-status
        git push 
    }  

    if ($null -eq $message) {
        $message = "_"
    } 

    Clear-Host
    $dir = Get-Location 
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { 
        if (!$noBuild) { Build $_.Key -clientOnly:$clientOnly -serverOnly:$serverOnly } else { Pull $_.Key }
        Git-Push $_ 
    }
    Set-Location $dir
}

function Revert ([Project] $project = [Project]::None){
    function Git-Revert($targetProject){
        Write-Host `nReverting $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
 
        git reset --hard origin/main 
        git reset --hard origin/master
        git clean -qf
    }

    Clear-Host
    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Git-Revert $_ }
    Pull $project
    Set-Location $dir
}

function Clone([Project] $project = [Project]::None) {
    function Git-Clone($targetProject) {
        Write-Host `nCloning $targetProject.Key -Fore Green
        Set-Location ~
        git clone $targetProject.Value.Git 
    }

    Clear-Host
    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project -eq $_.name } | % { Git-Clone $_ }
    Set-Location $dir
}