function Start-WindowsSetup {
<#
.SYNOPSIS
Tyson's Win10/11 provisioning script

.DESCRIPTION
Customizes a windows 10/11 device: all the apps and settings I like.

Note: Must run as administrator

.EXAMPLE
PS> .\Start-WindowsSetup.ps1

.NOTES
Turn this into a module: PCSetup
Put it into its own repo, a private one on github!
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (

    )


    # I think I need to find out where its necessary to run as admin and maybe just elevate for that portion? I'd
    # rather have it mostly run in the user context. Winget for example with prompt for admin creds when a software needs it. (by default)
    # Example, the package providers probably do need admin rights, but i should be installing those for ALL users. Modules should be current user only.
    if (!Test-Elevation) {
        throw "Need to run as administrator"
    }

    if ($pscmdlet.ShouldProcess()) {
        # Bootstrap and install package providers
        Install-PSPackageProviders

        # Install software
        Install-Software

        # Install PowerShell Modules
        Install-PSModule

        # Install VSCode Extensions
        Install-VSCodeExtension

        #NOTE: Wait until I have it in a module, it'll be easier to reference the profile.ps1 script with $PSScriptRoot
        # Set up PowerShell profile
        #Install-PSProfile

        # Set up custom terminal
        #Set-CustomTerminal

        # Remove unwanted apps
        #Remove-Software

        # Add right click context menu to open files and folders with VS Code
        #Add-VSCodeRightClick
    }
}
