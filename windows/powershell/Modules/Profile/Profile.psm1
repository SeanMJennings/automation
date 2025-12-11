function Update-Profile() {
    $projectsRoot = [Environment]::GetEnvironmentVariable('ProjectsRoot')
    Copy-Item "$projectsRoot\automation\windows\powershell\*" (split-path $PROFILE) -Recurse -Force

    $content = {(Get-Content "$projectsRoot\automation\windows\powershell\Microsoft.PowerShell_profile.ps1")}.Invoke()
    $content.Insert(0, "`$projectsRoot = `"$projectsRoot`"")
    $content | Set-Content $PROFILE
}