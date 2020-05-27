###############################################################################
# Install the TsekNet PowerShell profile from GitHub for the desired scope.
#
# By default, this will overwrite $PROFILE.CurrentUserCurrentHost.
# See https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
# for more information. around scopes
###############################################################################

$scope = 'CurrentUserCurrentHost'

# Profile.ps1 URL.
$url = 'https://git.io/tsekprofile'

$profile_dir = Split-Path $PROFILE.$scope
$profile_file = $profile.$scope
$request = Invoke-WebRequest $url -UseBasicParsing  -ContentType "text/plain; charset=utf-8"

if (-not (Test-Path $profile_dir)) {
    New-Item -Path $profile_dir -ItemType Directory | Out-Null
    Write-Verbose "Created new profile directory: $profile_dir"
}

# Leverage IO.File for PowerShell 5 comppatability.
[System.IO.File]::WriteAllLines($profile_file, $request.Content)
Write-Verbose "Wrote profile file: $profile_file with content from: $url"
& $profile_file -Verbose