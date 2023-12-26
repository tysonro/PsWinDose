<#
.SYNOPSIS
    Psake Build Script

.DESCRIPTION
    Build process for a PowerShell Module:
        - Initialize build environment
        - Clean build environment
        - Analyze code with PsScriptAnalyzer (linting)
        - Unit testing with Pester
        - Build module artifact:
            - Update module manifest
            - Combine functions into .psm1 file

.LINK
    https://github.com/psake/psake
#>
[CmdletBinding()]
Param()

# Prepare build environment
# PSake makes variables declared here available in other scriptblocks
Properties {
    # Build
    $env:ArtifactPath = "$env:BHBuildOutput\Artifacts\$env:BHProjectName"
    $env:ArtifactManifestPath = "$env:ArtifactPath\$env:BHProjectName.psd1"
    $env:ArtifactModulePath = "$env:ArtifactPath\$env:BHProjectName.psm1"
}

# Define default tasks to run if psake is invoked without any specified tasks
Task 'Default' -Depends Init, Clean, Test

# Initialize build environment
Task 'Init' {
    Set-Location $env:BHProjectPath

    "`nBuild System Details:"
    Get-Item env:BH*
    "`n"
}

# Clean build environment (BuildOutput directory)
Task 'Clean' -Depends 'Init' {
    Write-Output "Cleaning: $env:BHBuildOutput"
    Remove-Item -Path $env:BHBuildOutput -Recurse -Force -ErrorAction 'SilentlyContinue'
    New-Item -Path $env:BHBuildOutput -ItemType 'Directory' -Force | Out-String | Write-Verbose
}

# Unit testing with Pester
Task 'Test' -Depends 'Init' {
    Import-Module Pester -force
    $Config = [PesterConfiguration]@{
        TestResult = @{
            OutputFormat = 'NunitXml'
            OutputPath = "$env:BHBuildOutput\TestResults.Pester.xml"
            OutputEncoding = 'UTF8'
            Enabled = $true
        }
        Output = @{
            Verbosity = 'Detailed'
        }
    }
    Invoke-Pester -Configuration $Config
}

# Build module artifact
Task 'Build' -Depends 'Init' {
    # Create artifact folder (BuildOutput)
    New-Item -Path $env:ArtifactPath -ItemType 'Directory' -Force | Out-String | Write-Verbose

    # Get public and private function files
    $PublicFunctions = @(Get-ChildItem -Path "$env:BHModulePath\Public\*.ps1" -Recurse)
    $PrivateFunctions = @(Get-ChildItem -Path "$env:BHModulePath\Private\*.ps1" -Recurse -ErrorAction 'SilentlyContinue')

    # Update public functions to export in existing manifest
    $env:BHPSModuleManifest | Set-ModuleFunction -FunctionsToExport $PublicFunctions.BaseName

    # Copy existing manifest to artifact folder
    Copy-Item -Path $env:BHPSModuleManifest -Destination "$env:ArtifactPath" -Recurse

    # Copy profile.ps1 to artifact folder
    Copy-Item -Path "$env:BHProjectPath\Profile\profile.ps1" -Destination "$env:ArtifactPath\profile.ps1"

    # Copy Config folder to artifact folder
    Copy-Item -Path "$env:BHModulePath\Public\Config" -Destination $env:ArtifactPath -Recurse

    # Combine functions into a single .psm1 module
    @($PublicFunctions + $PrivateFunctions) | Get-Content | Add-Content -Path $env:ArtifactModulePath -Encoding UTF8

    # Get current manifest version
    try {
        $Manifest = Test-ModuleManifest -Path $env:ArtifactManifestPath -ErrorAction 'Stop'
        [Version]$ManifestVersion = $Manifest.Version
        Write-Output "Current version is: $ManifestVersion"
    }
    catch {
        throw "Could not get manifest version from [$env:ArtifactPath]"
    }
    Write-Output "`nFINISHED: Release artifact creation."
}

# Build module artifact
#Task 'Deploy' -Depends 'Init' {
#    # Deploy artifact
#    $userModulePath = $env:psmodulePath.split(';')[0]
#    Write-Output "Deploying build artifacts to: $userModulePath"
#    Copy-Item -Path $env:ArtifactPath -Destination $UserModulePath -Recurse -Force
#    Write-Output "`nFINISHED: Deploying build artifacts."
#}
