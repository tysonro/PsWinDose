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

    if ($AdminConsole -like "False*") {
        Write-Warning "You need to run PowerShell as an administrator to use this function!`n"
        Break
    }
}
