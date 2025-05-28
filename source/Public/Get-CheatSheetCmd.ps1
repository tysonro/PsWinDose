function Get-CheatSheetCmd {
<#
.SYNOPSIS
Get CMD Cheat Sheet

.DESCRIPTION
CMD Cheat Sheet will return a list of common CMD commands and their descriptions

.EXAMPLE
Get-CheatSheetCmd

Returns all of the commands and descriptions

.EXAMPLE
Get-CheatSheetCmd -Search "repadmin"

Returns all of the commands and descriptions that match the search term
#>
    [CmdletBinding()]
    Param(
        [Alias('s')]
        [string]$Search = $null
    )

    # My curated list of helpful CMD commands
    $cmdHash = @{
        "repadmin /syncall /a /e" = "(run as admin) Forces DC Site replication across all partitions on all DCs"
        "set" = "Lists all of the windows variables you can use such as: %AppData%"
        "set l" = "Shows what DC server you connected to"
        "net use" = "Lists network drives and their locations"
        "netstat" = "Lists all active ports, Use option (-a) for full list"
        "nslookup" = "Resolves DNS names to IP address and vice versa"
        "ping" = "Test an IP connection, use option (-t) to avoid TTL expiration"
        "ipconfig" = "Configure IP, use /all to list all"
        "gpupdate" = "Update group policy (gpupdate /force)"
        "net view" = "Lists all shared network resources"
        "net accounts" = "List info about account"
        "perfmon" = "Performance monitor. TIP: start >> run >> perfmon /report (this will generate a perfmon report for the next 60 seconds to allow you to try and duplicate an issue and get detailed logs on the issue)."
        "regsvr32" = "Register or unregister a DLL file"
        "route print" = "List routing table"
        "arp -a" = "Lists IP table with MAC addresses"
        "net share" = "Lists all the shares currently on the computer"
        "netplwiz" = "Advanced User Accounts Window"
        "DISKPART" = "Enters into the diskpart utility, use ? for help. Can give you info on disk size, etc.
        TIP:  Great for fixing broken/corrupted usb drives. Try the following commands:
        list disk
        select disk 1
        clean
        create partition primary
        format fs=fat32 quick
        "
        "klist" = "Lists all kerberos tickets"
        "dfsutil diag viewdfspath \\domain.local\dfsroot\share" = "DFS Path Diagnostic Tool. Use this to reveal the source of a DFS path."
    }

    # Create a table of the commands and descriptions (an array of objects)
    $table = @()
    foreach ($key in $cmdHash.Keys) {
        $command = $key
        $description = $cmdHash[$key]
        $row = [pscustomobject]@{
            'Command' = $command
            'Description' = $description
        }
        $table += $row
    }

    # Return all or based on a matching search term
    if ($search) {
        $result = $table | Where-Object { $_.Command -like "*$search*" }
        if ($result) {
            return $result
        } else {
            Write-Output "No results found for '$search'"
        }
    } else {
        return $table
    }
}
New-Alias cheat-cmd Get-CheatSheetCmd
