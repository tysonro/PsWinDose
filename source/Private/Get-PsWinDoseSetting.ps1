function Get-PsWinDoseSetting {
<#
.SYNOPSIS
Get PsWindose Settings

.DESCRIPTION
Gets the PsWinDose settings from the pswindose.settings.json file. This is used to configure the PsWinDose module.

.EXAMPLE
Get-PsWinDoseSetting
#>
[CmdletBinding()]
Param(
    # Path to settings file
    $Path = "$PSScriptRoot\Config\pswindose.settings.json"
)
    Get-Content $Path -Raw | ConvertFrom-Json
}
