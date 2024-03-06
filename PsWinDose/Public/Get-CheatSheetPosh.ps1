function Get-CheatSheetPosh {
    <#
    .SYNOPSIS
    Get PowerShell Cheat Sheet

    .DESCRIPTION
    Get PowerShell Cheat Sheet will return a list of common PowerShell commands and their descriptions

    .EXAMPLE
    Get-CheatSheetPosh

    Returns all of the commands and descriptions

    .EXAMPLE
    Get-CheatSheetposh -Search "repadmin"

    Returns all of the commands and descriptions that match the search term

    .EXAMPLE
    cheat-posh -Search "more"
    #>
        [CmdletBinding()]
        Param(
            [Alias('s')]
            [string]$Search = $null
        )

        # My curated list of helpful posh commands
        $poshHash = @{
            "| Out-Host -Paging" = "Equivelant of piping to more in linux (| more). Returns information one page at a time."
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
    New-Alias cheat-posh Get-CheatSheetPosh
