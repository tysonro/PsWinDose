function Get-CheatSheetBash {
<#
.SYNOPSIS
Get Bash Cheat Sheet

.DESCRIPTION
Bash Cheat Sheet will return a list of common Bash/Azure CLI commands and their descriptions

.EXAMPLE
Get-CheatSheetBash

Returns all of the commands and descriptions

.EXAMPLE
Get-CheatSheetBash -Search ""

Returns all of the commands and descriptions that match the search term

.EXAMPLE
cheat-bash -Search "more"
#>
    [CmdletBinding()]
    Param(
        [Alias('s')]
        [string]$Search = $null
    )

    # My curated list of helpful posh commands
    $poshHash = @{
        "df -h" = "Provides filesystem and disk space usage"
    }

    # Create a table of the commands and descriptions (an array of objects)
    $table = @()
    foreach ($key in $poshHash.Keys) {
        $command = $key
        $description = $poshHash[$key]
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
New-Alias cheat-bash Get-CheatSheetBash
