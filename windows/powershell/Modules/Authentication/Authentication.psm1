function Update-GitHubPackageFeedNpmAuth($packageFeedToken = $null) {
    $path = "$env:USERPROFILE\.npmrc"
    if (!$packageFeedToken) { $packageFeedToken = Get-GitHubPackageFeedAuthToken }
    if (!(Test-Path $path))
    {
        New-Item -path "$env:USERPROFILE" -name ".npmrc" -type "file"
    }
    Set-Content -path "$env:USERPROFILE\.npmrc" -value "//npm.pkg.github.com/:_authToken=$packageFeedToken"
    Write-Host "`nUpdated npmrc with GitHub package feed token" -fore green
}

function Update-GitHubPackageFeedNugetAuth($packageFeedToken = $null) {
    if (!$packageFeedToken) { $packageFeedToken = Get-GitHubPackageFeedAuthToken }
    $ghUserDetails = gh api user | ConvertFrom-Json
    $nugetUsername = $ghUserDetails.login

    if (-not $(Get-PackageSource -Name ThePackageSource -ProviderName NuGet -ErrorAction Ignore))
    {
        dotnet nuget add source https://nuget.pkg.github.com/the_package_source/index.json --name ThePackageSource --username "$nugetUsername" --password "$packageFeedToken"
    } else {
        dotnet nuget update source ThePackageSource --username "$nugetUsername" --password "$packageFeedToken"
    }
    Write-Host "`nUpdated nuget source with GitHub package feed token" -fore green
}

function Update-GitHubPackageFeedAuth($packageFeedToken = $null) {
    Update-GitHubPackageFeedNpmAuth $packageFeedToken
    Update-GitHubPackageFeedNugetAuth $packageFeedToken
}

function Get-GitHubPackageFeedAuthToken() {
    write-host "`nGenerate a github personal access token for access to the GitHub package feeds:" -fore yellow
    Write-Host "    1. Go to www.github.com/settings/tokens" -fore yellow
    Write-Host "    2. Select Generate new token --> Generate new token (classic)." -fore yellow
    Write-Host "    3. Give it a note and select your expiration" -fore yellow
    Write-Host "    4. Check read:packages and nothing else (9th checkbox down)" -fore yellow
    Write-Host "    5. Click Generate Token" -fore yellow
    Write-Host "`nAlternatively provide an existing valid personal access token found in .npmrc or nuget.config if you already have one" -fore yellow
    $packageFeedToken = Read-Host "`nCopy your token and paste it here"
    return $packageFeedToken
}

Export-ModuleMember -function Get-GitHubPackageFeedAuthToken
Export-ModuleMember -function Update-GitHubPackageFeedNpmAuth
Export-ModuleMember -function Update-GitHubPackageFeedNugetAuth
Export-ModuleMember -function Update-GitHubPackageFeedAuth