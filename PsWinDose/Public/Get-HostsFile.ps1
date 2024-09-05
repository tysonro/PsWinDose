function Get-HostsFile {
<#
.SYNOPSIS
Get hosts file

.DESCRIPTION
Reads the contents of the hosts file located at default location.

.PARAMETER HostsFilePath
The path to the hosts file.

.EXAMPLE
Get-HostsFile
#>
    [CmdletBinding()]
    param(
        [string]$HostsFilePath = "C:\Windows\System32\drivers\etc\hosts"
    )

    try {
        # Read the contents of the hosts file
        $hostsContent = Get-Content -Path $HostsFilePath

        if ($hostsContent) {
            Write-Verbose "Contents of the hosts file [$($HostsFilePath)]:"
            $hostsContent | ForEach-Object { Write-Host $_ }
        } else {
            Write-Verbose "The Hosts file is empty."
        }
    } catch {
        Write-Error "Error: Unable to read the Hosts file. Please make sure you have the correct path and necessary permissions."
    }
}
