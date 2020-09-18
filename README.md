# My PowerShell Profile

My PowerShell profile is a collection of functions that add neat shortcuts and
functionality to all of my PowerShell consoles by default.

See this [blog post](https://tseknet.com/blog/psprofile) for a detailed breakdown.

## Installation

If you want to just get started with copying my homework run the following command in
PowerShell as administrator:

```powershell
iex ((New-Object Net.WebClient).DownloadString('https://github.com/tseknet/PowerShell-Profile/raw/master/install.ps1'))
```

⚠ As always, be sure you're aware of what you're downloading from the internet. You can view the source on GitHub and inspect the code prior to
downloading/executing anything described in this post. I've begun working on making my profile into a [PowerShell module](https://github.com/tseknet/tsekprofile) to make this easier to install.

## Usage

The following functions are included with this profile:

```powershell
Set-Path, Import-MyModules, Get-Elevation, Set-WindowTitle, Import-GitRepo, Install-Fonts, Copy-LastCommand, Edit-Profile, Open-HistoryFile, Get-FileHash256, Get-ExportedFunctions
```

## Screenshots

PowerShell running in an administrative window while working on a git repo

![PowerShell Admin](Admin_Git.png)

PowerShell running in a non-admin window while working in `C:\Tmp`

![PowerShell Non-Admin](Non-Admin.png)

## Included Modules

I can't take all the credit. The following (awesome) modules will be installed
by default:

1. [posh-git](https://github.com/dahlbyk/posh-git): Integrates Git and
   PowerShell by providing Git status summary information
1. [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh): Theme engine for
   PowerShell
1. [Get-ChildItemColor](https://github.com/joonro/Get-ChildItemColor): Provides
   colorization of outputs of `Get-ChildItem` Cmdlet of PowerShell
1. [PSWriteHTML](https://github.com/EvotecIT/PSWriteHTML): Output PowerShell
   commands to a formatted HTML page

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)