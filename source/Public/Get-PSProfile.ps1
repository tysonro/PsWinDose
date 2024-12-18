function Get-PSProfile {
<#
.SYNOPSIS
Gets my PowerShell profile.ps1 contents

.DESCRIPTION
Returns the contents of the profile.ps1 file contained within this module. This profile is what will be applied when using the Set-PSProfile function.

.EXAMPLE
Get-PSProfile
#>
    [cmdletbinding()]
    param()
    # Get profile.ps1 content
    Get-Content -Path "$PSScriptRoot\profile.ps1" -Raw
}
