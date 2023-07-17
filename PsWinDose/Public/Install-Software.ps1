function Install-Software {
<#
.SYNOPSIS
Install software I like to use

.DESCRIPTION
Installs software using Chocolatey and Winget.

WinGet will attempt to update it when you run the install commands on a machine that already has it installed.

Good examples: https://github.com/brwilkinson/AzureDeploymentFramework/blob/main/ADF/1-prereqs/00-InstallTools.ps1

.EXAMPLE
choco search <package-name>
Finds a package on chocolatey

.EXAMPLE
choco list --local-only <package-name>
Lists installed packages

.EXAMPLE
$env:ChocolateyInstall
Returns the path to the chocolatey install directory

.EXAMPLE
choco upgrade chocolatey
Upgrades chocolatey

.EXAMPLE
winget search <package-name>
Finds a package on winget

.EXAMPLE
winget list --local-only <package-name>
Lists installed packages

.NOTES
## FOIL
Crescendo wrapper for Chocolatey
https://github.com/ethanbergstrom/Foil


## COBALT
Crescendo wrapper for WinGet
https://github.com/ethanbergstrom/Cobalt


## CHOCOLATEYGET
Package Management (OneGet) provider that facilitates installing Chocolatey packages from any NuGet repository.
https://github.com/Jianyunt/ChocolateyGet

.LINK
Winget Docs: https://learn.microsoft.com/en-us/windows/package-manager/winget/
#>
    [CmdletBinding()]
    param ()

    ##############
    # CHOCOLATEY #
    ##############
    #$chocoAppList = @(
    #    #'AzureDataStudio-PowerShell', #currently getting from Intune
	#    #'grammarly-for-windows' # desktop and web based AI for grammar!
    #)
    #
    #foreach ($app in $chocoAppList) {
    #    choco list $app --local-only
    #    if ($appPath) {
    #        Write-Host "$app is already installed."
    #    } else {
    #        Write-Host "Installing $app..."
    #        choco install $app -y
    #        Write-Host "Installed $app."
    #    }
    #}


    ##########
    # WINGET #
    ##########
    $wgAppList = @(
        'Git.Git'
        'Microsoft.PowerShell' #PowerShell 7.x
        'mRemoteNG.mRemoteNG'
        'sysinternals' #SysInternals Suite
        'Micorosft.PowerToys' #Profile backup: C:\Users\1668\OneDrive - BerryDunn\Documents\PowerToys\Backup
        '7zip.7zip'
        'VideoLAN.VLC'
        'voidtools.Everything' #Powerful local search utility
        'NickeManarin.ScreenToGif' #Creates gifs from screen recordings
        'Spotify.Spotify'
        'Logitech.GHUB' #Logitech G Hub: keyboard/mouse
        'gerardog.gsudo' #SUDO: https://github.com/gerardog/gsudo
        #'Git Credential Manager Core'
        #'GitHub.cli'
        'Microsoft.SQLServerManagementStudio'
        'Microsoft.AzureDataStudio'
        'Microsoft.AzureStorageExplorer'
        'Microsoft.Azure.FunctionsCoreTools'
        'JanDeDobbeleer.OhMyPosh' #Prompt engine to customize the shell prompt
        'Grammarly.Grammarly' #Grammarly for Windows
        'flux.flux' #Flux: adjusts screen brightness based on time of day
    )

    foreach ($app in $wgAppList) {
        if (winget list $app) {
            Write-Host "$app is already installed." -ForegroundColor Green
        } else {
            Write-Host "Installing $app..." -ForegroundColor Cyan
            winget install $app
        }
    }

    ##########
    # OTHER #
    ##########

    # RSAT
    Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online #Needs to run as Admin

    # Download and Install Azure Portal Desktop Client
    #Invoke-WebRequest -Uri "https://portal.azure.com/App/Download?acceptLicense=true" -OutFile "$env:USERPROFILE\Downloads\AzurePortalInstaller.exe"
    #$AzPortalArgs = '/Q'
    #Start-Process -FilePath "$env:USERPROFILE\Downloads\AzurePortalInstaller.exe" -ArgumentList $AzPortalArgs

    # Install LogiTech G Series Hub software for keyboard and mouse
    #$LogiGSeries = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe'
    #$Destination = 'C:\BD\Software\LogiTech'
    #mkdir $Destination
    #Invoke-WebRequest -Uri $LogiGSeries -OutFile (Join-Path $Destination 'LogiTechGSeries.exe')
}
