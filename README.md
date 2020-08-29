# TsekNet's Profile

My personal, heavily customized PowerShell profile.

## Screenshots

PowerShell running in an administrative window while working on a git repo

![PowerShell Admin](Admin_Git.png)

PowerShell running in a non-admin window while working in `C:\Tmp`

![PowerShell Non-Admin](Non-Admin.png)

## Getting Started

### Installation

Run the following from an administrative PowerShell prompt:

```powershell
iex ((New-Object Net.WebClient).DownloadString('https://github.com/tseknet/Powershell-Profile/raw/master/install.ps1'))
```

**_NOTE:_** When running this for the first time, the startup may take a minute to install all the required modules & fonts.

### Imported Modules

I can't take all the credit. The following (awesome) modules will be installed
by default:

1. [posh-git](https://github.com/dahlbyk/posh-git)
1. [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)
1. [Get-ChildItemColor](https://github.com/joonro/Get-ChildItemColor)

## Custom Functions
Here's a high-level summary of some functions that my profile script provides:

1. Set the PowerShell Window Title with useful information such as elevation and version
1. Install/Import modules listed above
1. Overwrite `ll` / `ls` / `history` commands for better results
1. Download and set my personal `oh-my-posh` theme module, [TsekNet.psm1](https://github.com/TsekNet/PowerShell-Profile/blob/master/Themes/TsekNet.psm1)
1. Install [Powerline]((https://github.com/PowerLine/fonts) fonts using `posh-git`
1. Set the default location
1. Output functions made by the profile to the console

    ...and much more!

## Troubleshooting

Errors will be displayed to console, `$Error[0]` will have the latest error message if necessary for troubleshooting.

## Contributing

Please open a pull request with any issues you run into.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

* Hat tip to anyone whose code was used
* etc
