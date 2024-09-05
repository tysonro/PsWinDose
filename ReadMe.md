# PsWinDose

A heavy dose of:

- Windows tasks
- Windows Configurations
- Windows Administrative functions
- Windows Setup
- Software Management
- Module Management
- PowerShell Profile Management
- Configure Shell Prompt Themes

Pretty much a collection of common tools I can use to automate my Windows experience.

*NOTE: This project is intended for my own personal use, however if you find it helpful, feel free to use at your own risk! ...It mostly works ;)*

*DISCLAIMER: I've accumulated a lot of code over the years, many of which is certainly not original. Unfortunately, I haven't done a good job of keeping track of all the original source of any code I may have copied. I'll start trying to do better, but if anyone finds their code on here and would like me to reference their blog or project, let me know and I'd be happy to do so!*

### Current Commands:

Add-HostsEntry
Add-VsCodeRightClick  
Get-CheatSheetCmd  
Get-CheatSheetIpv4  
Get-CheatSheetIpv6  
Get-CheatSheetPosh
Get-CheatSheetRegEx  
Get-CmdletAlias  
Get-ElevationStatus  
Get-FileOwner  
Get-FolderSize  
Get-HostsFile
Get-MsAppBuildVersion  
Get-PoshTheme  
Get-PSProfile  
Get-SystemInfo  
Get-SystemUptime  
Get-WinBuildVersion  
Get-WindowsProductKey  
Install-PSModule  
Install-PSPackageProvider  
Install-PSProfile  
Install-Software  
Install-VSCodeExtension  
New-BootableUSB  
Remove-HostsEntry
Remove-Software  
Set-CustomTerminal  
Set-PoshTheme  
Start-WindowsSetup  

## Getting Started

Clone this repo locally and build the module. Once it is built, there is a `Install-PsWinDose.ps1` script that will copy the module to the appropriate locations for PowerShell 5.1 and/or 7.x.

```powershell
# 1. Build module
.\build.ps1 -taskList clean, test, build

# 2. Copy module to PowerShell 5.1 and/or 7.x locations
.\Install-PsWinDose.ps1

# 3. Get a list of commands
Get-Command -Module PsWinDose

# 4. Get help on a command
Get-Help <commandName>
```

## Windows Setup

One of the primary purposes of this module is to automate app installations, configurations and customizations in a Windows environment after it has been imaged, provisioned, deployed, etc.

```Start-WindowsSetup``` is a controller script that will:

- Install latest version of PowerShell
- Default Terminal to latest version of PowerShell
- Customize Windows Terminal
- Install PowerShell Modules
- Install Software
- Install custom PowerShell profile.ps1

## PowerShell Profile Management

A few functions to help manage my profile:

```powershell
Install-PSProfile
```

## PowerShell Themes

To help manage oh-my-posh themes, here are some helpful functions:

```powershell
Get-PoshTheme

# Great way to experiment and try new ones out. To permanently set it though, you need to update the theme in the profile.ps1 file.
Set-PoshTheme
```
