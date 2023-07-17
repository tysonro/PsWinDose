<#
Installs latest version/local build of PsWinDose for both 5.1 and 7.x versions of PowerShell.

Note: You will need to run this in the context of either or both of the PowerShell
version(s) you want to use it with.

https://github.com/tysonro/PsWinDose
#>

[CmdletBinding()]
param()

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Verbose "Script root: $scriptRoot"

$buildArtifactPath = Join-Path -Path "$scriptRoot\BuildOutput\Artifacts" -ChildPath $env:BHProjectName
Write-Verbose "Build artifact path: $buildArtifactPath"

# Get the module path from the first array index (typically the user's Documents\WindowsPowerShell\Modules folder)
$modulePath = $env:psModulePath.split(';')[0]
Write-Verbose "$modulePath"

# Copy the module folder to the default module path
Copy-Item -Path $buildArtifactPath -Destination $modulePath -Recurse -Force
