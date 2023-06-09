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

*NOTE: This project is intented for my own personal use, however if you find it helpful, feel free to use or fork this repo.*

## Getting Started

Clone this repo locally and build the module. Once it is built you can either import it from the ```BuildOutput\Artifacts``` folder or copy it to a module location.

```powershell
# 1. Build module
.\build.ps1 -taskList clean, test, build, deploy

# 2. Import module
Import-Module PsWinDose

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
