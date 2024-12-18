function Get-ConnectedDC {
<#
.SYNOPSIS
    Returns the name of the domain controller that the machine is currently connected to.
.DESCRIPTION
    Returns the name of the domain controller that the machine is currently connected to.
.EXAMPLE
    PS C:\> Get-ConnectedDC
    DC01
#>
    [CmdletBinding()]
    param()

    # Get the current domain information
    $domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

    # Get the domain controller that the machine is currently connected to
    $connectedDC = $domain.PdcRoleOwner

    return $connectedDC.Name
}
