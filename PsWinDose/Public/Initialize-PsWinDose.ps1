function Initialize-PsWinDose {
<#
.SYNOPSIS
Initialize PsWinDose

.DESCRIPTION
Initializes the PsWinDose module. This is used to configure the PsWinDose module.

.EXAMPLE
Initialize-PsWinDose
#>
[CmdletBinding()]
Param()
    Write-Verbose "[Initilize-PsWinDose] Initializing PsWinDose module...]"

    # Get the PsWinDose settings (settings.json)
    $Settings = Get-PsWinDoseSetting

    # Create root path if it doesn't exist
    if (-not (Test-Path -Path $Settings.rootPath)) {
        try {
            New-Item -Path $Settings.rootPath -ItemType Directory
        } catch {
            throw "Unable to create root path: $Settings.rootPath"
        }
    }

    # Create the software destination path if it doesn't exist
    if (-not (Test-Path -Path $Settings.softwareDestinationPath)) {
        try {
            New-Item -Path $Settings.softwareDestinationPath -ItemType Directory
        } catch {
            throw "Unable to create software destination path: $Settings.softwareDestinationPath"
        }
    }


### hmm, i need admin rights to set env: vars... use something else? or just run this as admin?


    # Set the PsWinDose environment variable
    if (-not $env:PsWinDose) {
        Write-Verbose "[Initialize-PsWinDose] Setting PsWinDose environment variable to $($Settings.rootPath)"
        [System.Environment]::SetEnvironmentVariable('PsWinDose', $Settings.rootPath, 'User')
    }
}
