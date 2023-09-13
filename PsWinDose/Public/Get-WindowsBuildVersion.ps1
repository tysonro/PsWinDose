function Get-WindowsBuildVersion {
<#
.SYNOPSIS
Get Windows Build Version

.DESCRIPTION
Get Windows Build Version using CIM and datafornerds.io

.EXAMPLE
Get-Win10BuildVersion

.LINK
https://datafornerds.io/
#>
    [CmdletBinding()]
    param()

    # Get OS Info
    $os = Get-CimInstance -ClassName Win32_OperatingSystem

    # Get Windows 10 Build Release info from datafornerds.io
    $d4n = Invoke-RestMethod -Uri "https://raw.datafornerds.io/ms/mswin/releases.json"

    # Match my build number with the datafornerds.io data
    $myBuild = $d4n.data | Where-Object { $_.Version -eq $os.buildNumber }

    # Return the object
    $obj = [PSCustomObject]@{
        Edition = $os.caption
        Version = $myBuild.Build
        BuildNumber = $os.version
        Architecture = $os.OSArchitecture
    }
    return $obj
}
