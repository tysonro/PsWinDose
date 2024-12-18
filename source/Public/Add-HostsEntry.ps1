function Add-HostsEntry {
<#
.SYNOPSIS
Add a new entry to the hosts file.

.DESCRIPTION
Adds a new entry to the hosts file with the specified IP address and hostname.

.PARAMETER IPAddress
The IP address to be added to the hosts file.

.PARAMETER Hostname
The hostname to be added to the hosts file.

.PARAMETER HostsPath
The path to the hosts file. Default is C:\Windows\System32\drivers\etc\hosts.

.EXAMPLE
Add-HostsEntry -IPAddress "192.168.1.100" -Hostname "mycustomdomain.com"
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$IPAddress,

        [Parameter(Mandatory)]
        [string]$Hostname,

        $HostsPath = "C:\Windows\System32\drivers\etc\hosts"
    )
    # Need to run as admin
    if (!(Test-Elevation)) {
        Write-Error "Session is not elevated. Please run this script as an Administrator!" -ErrorAction Stop
    }

    # Check if the entry already exists
    $existingEntry = Select-String -Path $HostsPath -Pattern $Hostname
    if ($existingEntry) {
        Write-Warning "Entry for $Hostname already exists. Please remove it first if you want to add a new one."
    } else {
        # Update hosts file with the new entry
        $entry = "$IPAddress`t$Hostname"
        Add-Content -Path $HostsPath -Value $entry
        Write-Verbose "Added entry: $entry"

        # Output the updated hosts file
        Get-HostsFile -HostsFilePath $HostsPath
    }
}
