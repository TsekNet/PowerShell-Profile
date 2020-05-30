################################################################################
# Install the TsekNet PowerShell profile from GitHub for the desired scope.    #
################################################################################

# One of AllUsersAllHosts, AllUsersCurrentHost, CurrentUserAllHost, CurrentUserCurrentHost
$Scope = "CurrentUserCurrentHost"
$URL = 'https://github.com/TsekNet/PowerShell-Profile/raw/master/profile.ps1'


$profile_dir = Split-Path $PROFILE.$Scope
$profile_file = $profile.$Scope
$request = Invoke-WebRequest $URL -UseBasicParsing  -ContentType "text/plain; charset=utf-8"

if (-not (Test-Path $profile_dir)) {
  New-Item -Path $profile_dir -ItemType Directory | Out-Null
  Write-Verbose "Created new profile directory: $profile_dir"
}

# Leverage IO.File for PowerShell 5 comppatability.
[IO.File]::WriteAllLines($profile_file, $request.Content)
Write-Verbose "Wrote profile file: $profile_file with content from: $URL"
& $profile_file -Verbose