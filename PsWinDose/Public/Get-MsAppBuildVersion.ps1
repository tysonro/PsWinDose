function Get-MsAppBuildVersion {
<#
.SYNOPSIS
Get the latest version of a Microsoft app.

.DESCRIPTION
Get the latest version of a Microsoft app using datafornerds.io.

.EXAMPLE
Get-MsAppVersion

.LINK
https://datafornerds.io/
#>
    [CmdletBinding()]
    param ()
    $d4n = Invoke-RestMethod -Uri "https://raw.datafornerds.io/ms/msapps/buildnumbers.json"
    $d4n.data
}
