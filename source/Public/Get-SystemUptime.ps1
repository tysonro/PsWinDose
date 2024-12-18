Function Get-SystemUptime {
<#
.SYNOPSIS
Get the system uptime

.DESCRIPTION
Get the system uptime using CIM

.EXAMPLE
Get-SystemUptime

.EXAMPLE
gsup
#>
    [CmdletBinding()]
    Param()

    # Get last boot time using CIM and calculate the difference from now to get uptime
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $uptime = (Get-Date) - $os.LastBootUpTime

    # Output object
    $obj = [PSCustomObject]@{
        Uptime = $uptime
        Days = $uptime.Days
        Hours = $uptime.Hours
        Minutes = $uptime.Minutes
    }
    return $obj
}
New-Alias gsup Get-SystemUptime
