function Get-WindowsProductKey {
<#
.SYNOPSIS
Get the Windows Product Key from Registry.

.DESCRIPTION
Get the Windows Product Key from Registry.

.EXAMPLE
Get-WindowsProductKey
#>
    [CmdletBinding()]
    param (
    )
    Get-CimInstance -ClassName SoftwareLicensingService | Select-Object -ExpandProperty OA3xOriginalProductKey
}
