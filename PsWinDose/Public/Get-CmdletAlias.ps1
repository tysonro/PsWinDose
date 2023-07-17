function Get-CmdletAlias {
<#
.SYNOPSIS
Get the alias for a cmdlet.

.DESCRIPTION
Get the alias for a cmdlet. As opposed to Get-Alias, this function will only return aliases for the specified cmdlet.

.EXAMPLE
Get-CmdletAlias -Name Get-ADUser
#>
[CmdletBinding()]
param (
    [string]$Name
)
    Write-Verbose $Name
    $Alias = Get-Alias | Where-Object { $_.Definition -like "$Name" }
    $Alias | Select-Object -Property @{Name='Cmdlet'; Expression={$_.Definition}}, @{Name='Alias'; Expression={$_.Name}}
}
