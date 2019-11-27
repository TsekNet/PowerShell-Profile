<#
  .SYNOPSIS
    @TsekNet PowerShell Profile.

  .DESCRIPTION
    Personal heavily customized PowerShell profile. Feel free to use and distrubute as
    you see fit. Expect frequent updates. Please file PRs for any errors/improvements.

    To use this profile, simply place this file in any of your $profile
    directories and restart your PowerShell console
    (Ex: $profile)

    Execution of functions can be found a the bottom of this profile script.

  .LINK
    TsekNet.com
    GitHub.com/TsekNet
    Twitter.com/TsekNet
#>
[CmdletBinding()]
param ()

#region function declarations

# Helper function to change directory to my development workspace
function Set-Path {
  [CmdletBinding()]
  Param (
    [ValidateScript( {
        if (-Not ($_ | Test-Path) ) {
          Write-Verbose "Creating default location $_"
          New-Item -ItemType Directory -Force -Path $_
        }
        return $true
      })]
    [System.IO.FileInfo]$Path
  )
  Write-Verbose "Setting path to $Path."
  Set-Location $Path
}

# Helper function to ensure all modules are loaded, with error handling
function Import-MyModules {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string[]]$Modules
  )

  foreach ($Module in $Modules) {
    if (Get-Module -ListAvailable -Name $Module -Verbose:$false) {
      Write-Verbose "Module '$Module' found, skipping install."
      Continue
    }
    try {
      Write-Verbose "Attemping to install module '$Module"
      Import-Module -Name $Module -ErrorAction Stop -Verbose:$false
    }
    catch {
      $lookup = Find-Module -Name $Module
      if (-not $lookup) {
        Write-Error "Module `"$Module`" not found."
        continue
      }
      Install-Module -Name $Module -Scope AllUsers -Force -AllowClobber
      Import-Module -Name $Module -Scope Global -Verbose:$false
    }
  }
}

# Helper function to test prompt elevation
function Get-Elevation {
  [CmdletBinding()]
  param ()
  if (Test-Administrator) {
    $script:elevation = "Admin"
    Write-Verbose "Powershell is running as: $script:elevation"
  }
  else {
    $script:elevation = "Non-Admin"
    Write-Verbose "Powershell is running as: $script:elevation"
  }
}

# Helper function to set the window title
function Set-WindowTitle {
  [CmdletBinding()]
  param ()
  $host_title = [ordered]@{
    'Elevation' = $elevation
    'Version'   = "v$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
    'Session'   = "$env:COMPUTERNAME".ToLower()
  }

  $formatted_title = "PS [$($host_title.Values -join ' | ')]"

  Write-Verbose "Setting Window Title to '$formatted_title'"

  $Host.UI.RawUI.WindowTitle = $formatted_title
}

# Download Files from Github
function Import-GitRepo {
  <#
  .Synopsis
    This function will download a Github Repository without using Git
  .DESCRIPTION
    This function will download files from Github without using Git.  You will need to know the Owner, Repository name, branch (default master),
    and FilePath.  The Filepath will include any folders and files that you want to download.
  .EXAMPLE
    Import-GitRepo -Owner MSAdministrator -Repository WriteLogEntry -Verbose -FilePath `
        'WriteLogEntry.psm1',
        'WriteLogEntry.psd1',
        'Public',
        'en-US',
        'en-US\about_WriteLogEntry.help.txt',
        'Public\Write-LogEntry.ps1'
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType([int])]
  param (
    # Repository owner
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
    [string]$Owner,

    # Name of the repository
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 1)]
    [string]$Repository,

    # Branch to download from
    [Parameter(ValueFromPipelineByPropertyName, Position = 2)]
    [string]$Branch = 'master',

    # List of files/paths to download
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 3)]
    [string[]]$FilePath,

    # List of posh-git themes to download
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 4)]
    [string[]]$ThemeName
  )

  $modulespath = ($env:psmodulepath -split ";")[0]
  $PowerShellModule = "$modulespath\$Repository"
  $wc = New-Object System.Net.WebClient
  $wc.Encoding = [System.Text.Encoding]::UTF8
  if (-not(Test-Path $PowerShellModule)) {
    Write-Verbose "Creating module directory"
    New-Item -Type Container -Path $PowerShellModule -Force | Out-Null
  }

  if (-not(Test-Path $profile)) {
    Write-Verbose "Creating profile"
    New-Item -Path $profile -Force | Out-Null
  }

  foreach ($item in $FilePath) {
    if ($item -like '*.*') {
      $url = "https://raw.githubusercontent.com/$Owner/$Repository/$Branch/$item"
      Write-Verbose "Attempting to download from '$url'"
      if ($item -like "*$ThemeName.psm1") {
        Write-Verbose "'$item' detected, overwriting..."
        $fullpath = "$(Join-Path -Path (Get-ChildItem $profile).Directory.FullName -ChildPath 'PoshThemes')\$ThemeName.psm1"
        if (-not(Test-Path $fullpath)) {
          Write-Verbose "Creating file '$fullpath'"
          New-Item -ItemType File -Force -Path $fullpath | Out-Null
        }
        ($wc.DownloadString("$url")) | Out-File $fullpath
      }
      elseif ($item -like '*profile.ps1') {
        Write-Verbose "'$item' detected, overwriting..."
        New-Item -ItemType File -Force -Path $profile | Out-Null
        Write-Verbose "Created file '$profile'"
        ($wc.DownloadString("$url")) | Out-File "$profile"
      }
      else {
        Write-Verbose "'$item' detected, overwriting..."
        New-Item -ItemType File -Force -Path "$PowerShellModule\$item" | Out-Null
        Write-Verbose "Created file '$PowerShellModule\$item'"
        ($wc.DownloadString("$url")) | Out-File "$PowerShellModule\$item"
      }
    }
    else {
      New-Item -ItemType Container -Force -Path "$PowerShellModule\$item" | Out-Null
      Write-Verbose "Created file '$PowerShellModule\$item'"
      $url = "https://raw.githubusercontent.com/$Owner/$Repository/$Branch/$item"
      Write-Verbose "Attempting to download from $url"
    }
  }
}

function Install-Fonts {
  [CmdletBinding()]
  param (
    [System.IO.FileInfo]$TestFont = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\DejaVu Sans Mono for Powerline.ttf"
  )
  if (-not(Test-Path $TestFont)) {
    Write-Verbose "Installing Fonts to $($TestFont.DirectoryName)"
    git clone https://github.com/PowerLine/fonts
    Set-Location fonts
    .\install.ps1 'Deja*' -Confirm:$false
  }
}

#endregion

#region helper functions

Write-Verbose "==Setting command aliases=="

# Copy the last command entered
function Copy-LastCommand {
  Get-History -id $(((Get-History) | Select-Object -Last 1 |
      Select-Object ID -ExpandProperty ID)) |
  Select-Object -ExpandProperty CommandLine |
  clip
}

# Make it easy to edit this profile once it's installed
function Edit-Profile {
  if ($host.Name -match "ise") {
    $psISE.CurrentPowerShellTab.Files.Add($profile)
  }
  else {
    code-insiders $profile
  }
}

# Open PowerShell command history file
function Open-HistoryFile { code-insiders (Get-PSReadLineOption | Select-Object -ExpandProperty HistorySavePath) }

# Compute file hashes - useful for checking successful downloads
function Get-FileHash256 {
  $sha_256_hash = (Get-FileHash -Algorithm SHA256 $args).hash
  Write-Output "Hash for $args is '$sha_256_hash' (copied to clipboard)."
  $sha_256_hash | clip
}

function Get-ExportedFunctions {
  try {
    $helper_functions = (Get-Module $profile -ListAvailable | Select-Object -ExpandProperty ExportedCommands).Values.Name -join ', '
    Write-Host 'Profile helper functions: ' -NoNewline; Write-Host $helper_functions -ForegroundColor Green
  }
  catch {
    Write-Error "Error obtaining helper function list: $_"
  }
}

#endregion

#region statements

# Hold shift to turn on verbosity if running Windows PowerShell
if ("Desktop" -eq $PSVersionTable.PSEdition) {
  Add-Type -Assembly PresentationCore, WindowsBase
  try {
    if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::LeftShift) -OR
      [System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::RightShift)) {
      $VerbosePreference = "Continue"
    }
  }
  catch {
    Write-Warning "Error displaying verbosity via SHIFT key."
  }
}

#endregion

#region execution

try {
  Write-Verbose '==Removing default start up message=='
  Clear-Host

  Write-Verbose '==Getting latest profile files from GitHub=='
  Import-GitRepo -Owner tseknet -Repository PowerShell -FilePath `
    'Profile/Microsoft.PowerShell_profile.ps1',
  'Profile/Themes/TsekNet.psm1' -ThemeName 'TsekNet'

  Write-Verbose '==Importing modules required for profile=='
  $my_modules = @('posh-git', 'oh-my-posh', 'Get-ChildItemColor', 'PSWriteHTML')
  Import-MyModules -Modules $my_modules

  Write-Verbose '==Setting custom oh-my-posh theme=='
  Set-Theme 'TsekNet' -Verbose:$false

  Write-Verbose '==Checking console elevation=='
  Get-Elevation

  Write-Verbose '==Setting the console title=='
  Set-WindowTitle

  Write-Verbose '==Setting the default directory for new PowerShell consoles=='
  Set-Path 'C:\Tmp'

  Write-Verbose '==Installing fonts if necessary=='
  Install-Fonts

  Write-Verbose '==Changing to bash-like tab completion=='
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
  Set-PSReadlineOption -ShowToolTips -BellStyle Visual

  Write-Verbose '==Setting aliases=='
  Set-Alias ll Get-ChildItemColor -Option AllScope
  Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
  Set-Alias History Open-HistoryFile -Option AllScope

  Write-Verbose '==Getting and displaying list of helper functions=='
  Get-ExportedFunctions
}
catch {
  throw "Error configuring `$profile on line $($_.InvocationInfo.ScriptLineNumber): $_"
}

#endregion
