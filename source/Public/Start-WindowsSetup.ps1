function Start-WindowsSetup {
    <#
    .SYNOPSIS
        Tyson's Win 11 provisioning script

    .DESCRIPTION
        Customizes a windows 11 device: all the apps and settings I like.

        Note: Must run as administrator to bootstrap

    .EXAMPLE
        PS> .\Start-WindowsSetup.ps1
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')] # PSScriptAnalyzer: Suppress ShouldProcess
    param (
        [switch]$AddPrivateRepo
    )
    # I think I need to find out where its necessary to run as admin and maybe just elevate for that portion (meaning, separate the logic out for admin functions).
    # I'd rather have it mostly run in the user context. Winget for example will prompt for admin creds when a software needs it. (by default)
    # Example, the package providers probably do need admin rights, but i should be installing those for ALL users. Modules should be current user only.
    # So, I think I need elevation to install winget? Can i just have gsudo be a pre-req, install that and then use that to elevate for just the winget install?
    # that way the rest will be installed to user scope. Why isn't winget just part of win11 now?
    if (-not (Test-Elevation)) {
        throw "Need to run as administrator"
    }

    # Initialize PsWinDose (bootstrap)
    Initialize-PsWinDose

    # Add private repository
    if ($AddPrivateRepo) {
        Add-PSPrivateRepository
    }

    # Install default PowerShell Modules
    Install-PSModule -Default

    # Install default software
    Install-Software -Default

    # Set up PowerShell profile
    Install-PSProfile

    # Set up custom terminal
    #Set-CustomTerminal

    # Remove unwanted apps
    #Remove-Software

    # Add right click context menu to open files and folders with VS Code
    Add-VSCodeRightClick
}
