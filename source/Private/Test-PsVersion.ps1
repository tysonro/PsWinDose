function Test-PSVersion {
    <#
    .SYNOPSIS
        Test PowerShell Version

    .DESCRIPTION
        Checks if you are running a minimum version of PowerShell. Returns true or false.

    .PARAMETER MinimumVersion
        The minimum version of PowerShell required. Must use SemVer (semantic versioning): major.minor.patch (0.0.0)

    .EXAMPLE
        Test-PSVersion -MinimumVersion '7.4.0'
        Returns true or false
    #>
    [CmdletBinding()]
    Param(
        [version]$MinimumVersion
    )
    # Get the current PowerShell version
    $CurrentVersion = $PSVersionTable.PSVersion

    # Check if the current version is greater than or equal to the required version
    if ($CurrentVersion -ge $MinimumVersion) {
        Write-Verbose "[Test-PSVersion] :: Current PowerShell version is greater than or equal to $MinimumVersion. Version: $CurrentVersion"
        Write-Output $true
    } else {
        Write-Verbose "[Test-PSVersion] :: Current PowerShell version is less than $MinimumVersion. Version: $CurrentVersion"
        Write-Output $false
    }
}
