function Get-ElevationStatus {
<#
.SYNOPSIS
Check if the current user is an admin

.DESCRIPTION
Check if the current user is an admin and returns true or false.

.EXAMPLE
Get-ElevationStatus

.EXAMPLE
Get-ElevationStatus -Verbose
#>
    [CmdletBinding()]
    param ()
    $AdminConsole = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

    if ($AdminConsole) {
        Write-Verbose "You are running as administrator"
    }
    else {
        Write-Verbose "You are NOT running as administrator"
    }
    return $AdminConsole
}
