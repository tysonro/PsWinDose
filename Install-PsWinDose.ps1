<#
Installs latest version/local build of PsWinDose.

Default behavior is to install it for all users (c:\program files) for both 5.1 and 7.x versions of PowerShell.

It will require you to have built the module first, which creates the artifact and populates the BuildHelpers environment variables.

https://github.com/tysonro/PsWinDose
#>

[CmdletBinding()]
param()

. "$PSScriptRoot\source\Private\Test-Elevation.ps1"
if (-not (Test-Elevation)) {
    Write-Error -Message "Need to run as administrator" -ErrorAction Stop
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Verbose "Script root: $scriptRoot"

$buildArtifactPath = Join-Path -Path "$scriptRoot\BuildOutput" -ChildPath (Get-Item -Path $scriptRoot).baseName
Write-Verbose "Build artifact path: $buildArtifactPath"

$Ps5ModulePath = 'C:\Program Files\WindowsPowerShell\Modules'
Write-Verbose "PowerShell 5.1 Path: $Ps5ModulePath"

$Ps7ModulePath = 'C:\Program Files\PowerShell\7\Modules'
Write-Verbose "PowerShell 7.x Path: $Ps7ModulePath"

# Copy the module folder to the both 5.1 and 7.x paths
Write-Output "Copying module to (5.1): $Ps5ModulePath"
Copy-Item -Path $buildArtifactPath -Destination $Ps5ModulePath -Recurse -Force

Write-Output "Copying module to (7.x): $Ps7ModulePath"
Copy-Item -Path $buildArtifactPath -Destination $Ps7ModulePath -Recurse -Force
