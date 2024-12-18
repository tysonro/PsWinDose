
function Remove-HostsEntry {
<#
.SYNOPSIS
Remove an entry from the hosts file.

.DESCRIPTION
Removes the entry for the specified hostname from the hosts file.

.PARAMETER Hostname
The hostname to be removed from the hosts file.

.PARAMETER HostsPath
The path to the hosts file. Default is C:\Windows\System32\drivers\etc\hosts.

.EXAMPLE
Remove-HostsEntry -Hostname "mycustomdomain.com"
#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Hostname,

        $HostsPath = "C:\Windows\System32\drivers\etc\hosts"
    )
    # Need to run as admin
    if (!(Test-Elevation)) {
        Write-Error "Session is not elevated. Please run this script as an Administrator!" -ErrorAction Stop
    }

    # Read the file content
    $hostsContent = Get-Content $hostsPath

    # Filter out the lines that match the hostname
    $newHostsContent = $hostsContent | Where-Object {$_ -notmatch $Hostname}

    # Check if the entry was found and removed
    if ($hostsContent.Count -ne $newHostsContent.Count) {
        # Save the modified content back to the file
        $newHostsContent | Set-Content -Path $hostsPath
        Write-Verbose "Removed entry: $Hostname"

        # Output the updated hosts file
        Get-HostsFile -HostsFilePath $HostsPath
    } else {
        Write-Warning "No entry found for $Hostname."
    }
}
