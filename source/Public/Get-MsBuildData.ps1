function Get-MsBuildData {
<#
.SYNOPSIS
Get Microsoft build data

.DESCRIPTION
Get the latest Microsoft version and build data.

Information is sourced from: datafornerds.io

.EXAMPLE
Get-MsBuildData -WindowsReleases

.LINK
https://datafornerds.io/
#>
    [CmdletBinding()]
    param (
        [switch]$WindowsReleases,
        [switch]$WindowsBuilds,
        [switch]$M365AppBuilds
    )

    if ($windowsReleases) {
        $uri = "https://raw.datafornerds.io/ms/mswin/releases.json"
    }
    if ($windowsBuilds) {
        $uri = "https://raw.datafornerds.io/ms/mswin/buildnumbers.json"
    }
    if ($m365AppBuilds) {
        $uri = "https://raw.datafornerds.io/ms/msapps/buildnumbers.json"
    }

    $d4n = Invoke-RestMethod -Uri $uri
    $d4n.data
}
