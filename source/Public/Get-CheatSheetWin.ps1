function Get-CheatSheetWin {
    <#
    .SYNOPSIS
    Get Windows Cheat Sheet

    .DESCRIPTION
    Get Windows Cheat Sheet will return a list of helpful keyboard shortcuts and their descriptions

    .EXAMPLE
    Get-CheatSheetWin

    Returns all of the commands and descriptions

    .EXAMPLE
    Get-CheatSheetWin -Search "rename"

    Returns all of the commands and descriptions that match the search term
    #>
        [CmdletBinding()]
        Param(
            [Alias('s')]
            [string]$Search = $null
        )

        # My curated list of helpful CMD commands
        $winHash = @{
            "Right Click" = "Shift+F10"
            "Create new folder" = "Ctrl+Shift+N"
            "Rename" = "F2"
            "Copy raw text" = "Ctrl+Shift+C"
            "Paste raw text" = "Ctrl+Shift+V"
        }

        # Create a table of the commands and descriptions (an array of objects)
        $table = @()
        foreach ($key in $winHash.Keys) {
            $command = $key
            $description = $winHash[$key]
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
    New-Alias cheat-win Get-CheatSheetWin
