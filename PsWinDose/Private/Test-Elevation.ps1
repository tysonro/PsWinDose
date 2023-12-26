function Test-Elevation {
<#
.SYNOPSIS
Tests if the current user is an admin.

.DESCRIPTION
Tests if the current user is an admin, if they aren't it writes a warning breaks out of the function.

.EXAMPLE
Test-Elevation
#>
    [CmdletBinding()]
    param()
    $AdminConsole = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

    if ($AdminConsole -eq $false) {
        Write-Verbose "You are not running PowerShell as an administrator"
        return $false
    }
    if ($AdminConsole -like $true) {
        Write-Verbose "You are running PowerShell as an administrator"
        return $true
    }
}
