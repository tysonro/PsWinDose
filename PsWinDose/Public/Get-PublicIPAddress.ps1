function Get-PublicIpAddress {
<#
.SYNOPSIS
Retrieves the public IP address of the machine.

.DESCRIPTION
The `Get-PublicIpAddress` function retrieves the public IP address of the machine by making a request to either:

* https://ifconfig.me/ip
* https://www.ipify.org/

.EXAMPLE
PS C:\> Get-PublicIpAddress
203.0.113.1

This example retrieves the public IP address of the machine and returns it as a string.
#>
    [CmdletBinding()]
    param (
    )
    $uri1 = "https://ifconfig.me/ip"
    $uri2 = "https://api.ipify.org"

    # Try this first
    $restRequest1 = Invoke-RestMethod -Uri $uri1

    if ($restRequest1) {
        Write-Verbose "Using: $uri1"
        return $restRequest1
    }
    else {
        Write-Verbose "Using: $uri2"
        $restRequest2 = Invoke-RestMethod -Uri $uri2
        return $restRequest2
    }
}
# Create function alias (referenced in manifest file to export module alias)
New-Alias -Name 'gpip' -Value 'Get-PublicIpAddress'
