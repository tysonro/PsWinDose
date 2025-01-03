﻿function Start-WindowsSetup {
<#
.SYNOPSIS
Tyson's Win10/11 provisioning script

.DESCRIPTION
Customizes a windows 10/11 device: all the apps and settings I like.

Note: Must run as administrator

.EXAMPLE
PS> .\Start-WindowsSetup.ps1 -RepoName 'repo1' -RepoPath '\\server1\Repo1Path'
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        $RepoName,
        [Parameter(Mandatory)]
        $RepoPath
    )

    Import-Module PSFramework
    Write-PSFMessage -Level Verbose "Starting Windows Setup"

        # I think I need to find out where its necessary to run as admin and maybe just elevate for that portion (meaning, separate the logic out for admin functions).
    # I'd rather have it mostly run in the user context. Winget for example will prompt for admin creds when a software needs it. (by default)
    # Example, the package providers probably do need admin rights, but i should be installing those for ALL users. Modules should be current user only.
    if (-not (Test-Elevation)) {
        throw "Need to run as administrator"
    }

    if (-not $env:PsWinDose) {
        Initialize-PsWinDose
    }

    if ($pscmdlet.ShouldProcess($repoName)) {
        # Bootstrap and install package providers
        Install-PSPackageProvider -RepoName $RepoName -RepoPath $RepoPath -AddPrivateRepo

        <# Add to bootstrap phase:
            - Install winget
            - Install chocolatey
            - Install Posh 7.x
            - Install these modules: PSFramework, Microsoft.PowerShell.ConsoleGuiTools
        #>

        # Install PowerShell Modules
        Install-PSModule

        # Install software
        ## Needs winget installed first!!!!
        Install-Software


        # Install VSCode Extensions
        ## I'm using vscode profiles now so maybe i need to figure out how to export/import those over...?
        #Install-VSCodeExtension



        #NOTE: Wait until I have it in a module, it'll be easier to reference the profile.ps1 script with $PSScriptRoot
        # Set up PowerShell profile
        #Install-PSProfile

        # Set up custom terminal
        #Set-CustomTerminal

        # Remove unwanted apps
        #Remove-Software

        # dell monitor management


        # Add right click context menu to open files and folders with VS Code
        #Add-VSCodeRightClick
    }
}
