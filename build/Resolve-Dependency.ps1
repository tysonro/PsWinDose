<#
.SYNOPSIS
    Resolve build dependencies using ModuleFast.

.PARAMETER DependencyFile
    Specifies the dependency configuration file for the this script. The default value is
    'RequiredModules.psd1' relative to this script's path.

.PARAMETER TargetPath
    Path where module dependencies will be saved by ModuleFast. Defaults to $env:LOCALAPPDATA/PowerShell/RequiredModules.

.EXAMPLE
    Resolve-Dependency.ps1 -DependencyFile 'RequiredModules.psd1' -TargetPath 'BuildOutput/RequiredModules'
    Resolve dependencies using the 'RequiredModules.psd1' file and save them to 'BuildOutput/RequiredModules'.
#>
[CmdletBinding()]
param
(
    [string]$DependencyFile = (Join-Path -Path $PSScriptRoot -ChildPath 'RequiredModules.psd1'),

    [string]$TargetPath = (Join-Path -Path $env:LOCALAPPDATA -ChildPath '/PowerShell/RequiredModules')
)

Write-Host -Object "[pre-build] Resolving dependencies with ModuleFast." -ForegroundColor Green

# Ensure ModuleFast is bootstrapped
try {
    Write-Verbose "Bootstrapping ModuleFast..."

    $moduleFastBootstrapUri = 'bit.ly/modulefast'

    $invokeWebRequestParameters = @{
        Uri         = $moduleFastBootstrapUri
        ErrorAction = 'Stop'
    }
    $moduleFastBootstrapScript = Invoke-WebRequest @invokeWebRequestParameters
    $moduleFastBootstrapScriptBlock = [ScriptBlock]::Create($moduleFastBootstrapScript)
    & $moduleFastBootstrapScriptBlock
}
catch {
    Write-Error "Failed to bootstrap ModuleFast. Error: $_"
    throw
}

# Ensure the dependency file exists
if (-not (Test-Path -Path $DependencyFile)) {
    Write-Error "Dependency file not found: $DependencyFile"
    throw
}

# Import dependencies from the file
try {
    $dependencies = Import-PowerShellDataFile -Path $DependencyFile
}
catch {
    Write-Error "Failed to import dependency file: $_"
    throw
}

# Ensure TargetPath exists
if (-not (Test-Path -Path $TargetPath)) {
    Write-Verbose "Creating target path: $TargetPath"
    New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
}

# Build the specification (dependency list) for ModuleFast
$mfSpec = @()

# Convert $dependencies to the required ModuleFast syntax
foreach ($key in $dependencies.Keys) {
    $version = $dependencies[$key]

    if ($version -eq 'latest') {
        # Use the shorthand syntax for latest versions
        $mfSpec += $key
    } else {
        # Use the shorthand syntax for specific versions
        $mfSpec += "$key=$version"
    }
    Write-Verbose "Adding dependency to ModuleFast specification: $($mfSpec[-1])"
}

# Install dependencies with ModuleFast
try {
    Write-Verbose "Installing dependencies with ModuleFast..."

    $installModuleFastParameters = @{
        Destination          = $TargetPath
        DestinationOnly      = $true
        NoPSModulePathUpdate = $true
        NoProfileUpdate      = $true
        Update               = $true
        Confirm              = $false
    }
    # Get the plan for the dependencies
    $moduleFastPlan = Install-ModuleFast -Specification $mfSpec -Plan @installModuleFastParameters

    if ($moduleFastPlan) {
        # Clear all modules in plan from the current session so they can be fetched again.
        $moduleFastPlan.Name | Get-Module | Remove-Module -Force

        # Install dependencies
        $moduleFastPlan | Install-ModuleFast @installModuleFastParameters
    }
    Write-Host -Object "[pre-build] Dependencies successfully resolved and saved to: $TargetPath" -ForegroundColor Green
} catch {
    Write-Error "Failed to install dependencies with ModuleFast. Error: $_"
    throw
}
