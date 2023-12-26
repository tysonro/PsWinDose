<#
Installs latest version/local build of PsWinDose for both 5.1 and 7.x versions of PowerShell.

It will require you to have built the module first, which creates the artifact and populates the BuildHelpers environment variables.

Note: You will need to run this in the context of either or both of the PowerShell
version(s) you want to use it with.

https://github.com/tysonro/PsWinDose
#>

[CmdletBinding()]
param(
    [switch]$Both
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Verbose "Script root: $scriptRoot"

$buildArtifactPath = Join-Path -Path "$scriptRoot\BuildOutput\Artifacts" -ChildPath (Get-Item -Path $scriptRoot).baseName
Write-Verbose "Build artifact path: $buildArtifactPath"

# Get the default module path from the first array index of environment variable PsModulePath (typically the user's ..\Documents\WindowsPowerShell\Modules folder)
$modulePath = $env:psModulePath.split(';')[0]
$moduleRoot = Get-Item -Path "$modulePath\..\.."

$Ps5ModulePath = Join-Path -Path $moduleRoot.fullName -ChildPath 'WindowsPowerShell\Modules'
Write-Verbose "PowerShell 5.1 Path: $Ps5ModulePath"

$Ps7ModulePath = Join-Path -Path $moduleRoot.fullName -ChildPath 'PowerShell\Modules'
Write-Verbose "PowerShell 7.x Path: $Ps7ModulePath"

if ($Both) {
    # Copy the module folder to the both 5.1 and 7.x paths
    Write-Output "Copying module to (5.1): $Ps5ModulePath"
    Copy-Item -Path $buildArtifactPath -Destination $Ps5ModulePath -Recurse -Force

    Write-Output "Copying module to (7.x): $Ps7ModulePath"
    Copy-Item -Path $buildArtifactPath -Destination $Ps7ModulePath -Recurse -Force
} else {
    # Copy the module folder to the default module path (session specific)
    Write-Output "Copying module to $modulePath"
    Copy-Item -Path $buildArtifactPath -Destination $modulePath -Recurse -Force
}
