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

ISSUE: Still trying to work this all out on a fresh machine.
I struggled to get winget working properly on my last Win11 refresh.

I need to get my order of operations down.

 - Does it come with win11?
 - I think I can just run it as a normal user and it will elevate if needed
 - Getting to Pwrsh 7.x first is probably a good idea
 - Then use cobalt of the winget module to test for apps and install. Normal winget produces string text not objects.
 - This makes it harder to test if an app is already installed. I want to be able to run this script multiple times.


## FOIL
Crescendo wrapper for Chocolatey
https://github.com/ethanbergstrom/Foil


## COBALT
Crescendo wrapper for WinGet
https://github.com/ethanbergstrom/Cobalt


## Microsoft.WinGet.Client
Winget module for PowerShell
https://www.powershellgallery.com/packages/Microsoft.WinGet.Client/0.2.2


## CHOCOLATEYGET
Package Management (OneGet) provider that facilitates installing Chocolatey packages from any NuGet repository.
https://github.com/Jianyunt/ChocolateyGet

.LINK
Winget Docs: https://learn.microsoft.com/en-us/windows/package-manager/winget/
#>
    [CmdletBinding()]
    param ()

    Import-Module PSFramework

# # 1. Install powershell 7.x

# # 2 ensure winget is installed, setup and working


    # Download and Install LogiTech G Series Hub software for keyboard and mouse (Allows me to setup hotkeys)

# "logitech gaming software" --- I think this is the one i want... !!!
# https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.04.49_x64_Logitech.exe

#    $LogiGamingSoftware = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.04.49_x64_Logitech.exe'
#    $LogiDestination = (Get-PsWinDoseSetting).SoftwareDestinationPath
#    if (-not (Test-Path -Path $LogiDestination)) {
#        try {
#            New-Item -Path $LogiDestination -ItemType Directory
#        } catch {
#            throw "Unable to create download path: $LogiDestination"
#        }
#    }
#    Invoke-WebRequest -Uri $LogiGamingSoftware -OutFile (Join-Path $LogiDestination 'LogitechGamingSoftware.exe')

#    Start-Process -Path (Join-Path $LogiDestination 'LogitechGamingSoftware.exe') -verbose


    # Install LogiTech G Series Hub software for keyboard and mouse
    #$LogiGSeries = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe'
    #$Destination = 'C:\BD\Software\LogiTech'
    #mkdir $Destination
    #Invoke-WebRequest -Uri $LogiGSeries -OutFile (Join-Path $Destination 'LogiTechGSeries.exe')

# "Logitech G Hub" --- I don't think this is what I want...
#    $LogiGSeries = ' /lghub_installer.exe'
#    $LogiDestination = (Get-PsWinDoseSettings).SoftwareDestinationPath
#    if (-not (Test-Path -Path $LogiDestination)) {
#        try {
#            New-Item -Path $LogiDestination -ItemType Directory
#        } catch {
#            throw "Unable to create download path: $LogiDestination"
#        }
#    }
#    Invoke-WebRequest -Uri $LogiGSeries -OutFile (Join-Path $Destination 'LogiTechGSeries.exe')
#
    ## Need to figure out how to import my keyboard profile

    # Check if winget is already installed
    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
        # Download and install winget via msix app from GitHub
        $latestWingetMsixBundleUri = $( Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest ).assets.browser_download_url | Where-Object {
            $_.EndsWith( ".msixbundle" )
        }
        $latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
        Write-Information "Downloading winget to artifacts directory..."
        Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
        Add-AppxPackage $latestWingetMsixBundle
        Remove-Item -Path "./$latestWingetMsixBundle"
    } else {
        Write-Output "Winget is already installed."
    }

    Write-PSFramework -Level Important "Upgrading winget and accepting source agreements"
    winget upgrade --accept-source-agreements --accept-source-agreements --force

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
        #'Git.Git'
        #'Microsoft.PowerShell' #PowerShell 7.x
        'mRemoteNG.mRemoteNG'
        'sysinternals' #SysInternals Suite
        'Micorosft.PowerToys' #Profile backup: $env:OneDrive\Documents\PowerToys\Backup
        '7zip.7zip'
        'VideoLAN.VLC'
        'voidtools.Everything' #Powerful local search utility
        'NickeManarin.ScreenToGif' #Creates gifs from screen recordings
        'Spotify.Spotify'
        'Logitech.GHUB' #Logitech G Hub: keyboard/mouse
        'gerardog.gsudo' #SUDO: https://github.com/gerardog/gsudo
        #'Git Credential Manager Core'
        #'GitHub.cli'
        #'Microsoft.SQLServerManagementStudio'
        #'Microsoft.AzureDataStudio'
        'Microsoft.AzureStorageExplorer'
        'Microsoft.Azure.FunctionsCoreTools'
        'JanDeDobbeleer.OhMyPosh' #Prompt engine to customize the shell prompt
        #'Grammarly.Grammarly' #Grammarly for Windows
        'flux.flux' #Flux: adjusts screen brightness based on time of day
        #'Notepad++.Notepad++'
        'baremetalsoft.baretail' #BareTail: log file viewer
        'Microsoft.AzureCLI' #Azure CLI
    )

    foreach ($app in $wgAppList) {
        if ((winget list $app) -like "*no installed package*") {
            Write-Host "Installing $app..." -ForegroundColor Cyan
            winget install $app --accept-source-agreements --accept-source-agreements --force
        } else {
            Write-Host "$app is already installed." -ForegroundColor Green
        }
    }

    ##########
    # OTHER #
    ##########

    # RSAT
    if ((Get-WindowsCapability -Name RSAT.ActiveDirectory* -Online).State -eq 'Installed') {
        Write-Host "RSAT is already installed." -ForegroundColor Green
    } else {
        Write-Host "Installing RSAT..." -ForegroundColor Cyan
        Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online #Needs to run as Admin
    }

    # Download and Install Azure Portal Desktop Client
    #Invoke-WebRequest -Uri "https://portal.azure.com/App/Download?acceptLicense=true" -OutFile "$env:USERPROFILE\Downloads\AzurePortalInstaller.exe"
    #$AzPortalArgs = '/Q'
    #Start-Process -FilePath "$env:USERPROFILE\Downloads\AzurePortalInstaller.exe" -ArgumentList $AzPortalArgs
}
