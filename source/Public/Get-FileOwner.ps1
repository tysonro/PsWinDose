function Get-FileOwner {
<#
.SYNOPSIS
Get file owners within a given path

.Description
This function gets a listing of file owners and other info within a given path

.Parameter Path
Path where files are to be Audited

.Example
Get-FileOwner -Path c:\users

Specify the parent folder from which all subfolders are queried

.Link
https://github.com/TheTaylorLee/AdminToolbox
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    # Test for Admin Privleges, exit if not
    Test-Elevation

    $LastWrite = @{
        Name       = 'Last Write Time'
        Expression = { $_.LastWriteTime.ToString('u') }
    }
    $Owner = @{
        Name       = 'File Owner'
        Expression = { (Get-Acl $_.FullName).Owner }
    }
    $HostName = @{
        Name       = 'Host Name'
        Expression = { $env:COMPUTERNAME }
    }

    Get-ChildItem -Recurse -Path $Path |
    Select-Object $HostName, $Owner, Name, Directory, $LastWrite, Length
}
