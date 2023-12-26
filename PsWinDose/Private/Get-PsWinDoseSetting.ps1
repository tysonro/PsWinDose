function Get-PsWinDoseSetting {
<#
.SYNOPSIS
Get PsWindose Settings

.DESCRIPTION
Gets the PsWinDose settings from the settings.json file. This is used to configure the PsWinDose module.

.EXAMPLE
Get-PsWinDoseSetting
#>
[CmdletBinding()]
Param(
    # Path to settings.json file
    $Path = "$PSScriptRoot\Config\Settings.json"
)
    Get-Content $Path -Raw | ConvertFrom-Json
}
