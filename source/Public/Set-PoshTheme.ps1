# PSScriptAnalyzer -ExcludeRule PSAvoidUsingInvokeExpression
function Set-PoshTheme {
<#
.SYNOPSIS
Sets the oh-my-posh theme.

.DESCRIPTION
Sets the oh-my-posh theme.

.PARAMETER Theme
The name of the theme to set. Must be a valid oh-my-posh theme located in the default oh-my-posh theme path [$env:POSH_THEMES_PATH].

.EXAMPLE
Set-PoshTheme -Theme Agnoster

.EXAMPLE
Get-PoshTheme -Theme Atomic | Set-PoshTheme
#>
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '')]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Theme
    )
    process {
        if ($pscmdlet.ShouldProcess("$Theme","Setting oh-my-posh theme")) {
            Write-Host "Setting oh-my-posh theme to: $Theme" -ForegroundColor green
            oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/$Theme.omp.json" | Invoke-Expression
        }
    }
}
