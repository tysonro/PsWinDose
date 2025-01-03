<#
.SYNOPSIS
    Build script invoked by Invoke-Build.

.DESCRIPTION
    Bootstraps environment preparing it for building the module. Dependencies are resolved using ModuleFast.
    Invoke-Build is used as the task runner.

    The following tasks are available:
        - init: Initializes the build environment
        - clean: Removes the BuildOutput directory
        - test: Runs unit tests with Pester
            - Will overwrite existing test results with each run
        - build: Builds the module artifact
            - Cleans the build output before each build
        - publish: Publishes the module artifact

    Build process for a PowerShell Module:
        - Bootstrap: Handle dependencies with ModuleFast
            - Installs the required dependencies specified in 'RequiredModules.psd1'
            - Saves to default location: $env:LOCALAPPDATA/PowerShell/RequiredModules
        - Initialize build environment: Normalize build environment variables
        - Clean build environment
        - Analyze code with PsScriptAnalyzer (linting)
        - Unit testing with Pester
        - Build module artifact:
            - Update module manifest
            - Pack functions into .psm1 file
        - Publish module as a pipeline artifact

.PARAMETER Tasks
    Specifies the tasks to run. Defaults to '.' which will run init, clean, test, and build tasks.

.PARAMETER DependencyFile
    Specifies the configuration file for the dependencies. Defaults to 'RequiredModules.psd1' relative to this script's path.

.PARAMETER RequiredModulesDirectory
    Path where module dependencies will be saved by ModuleFast. Defaults to $env:LOCALAPPDATA/PowerShell/RequiredModules.

.PARAMETER ResolveDependency
    Resolve dependencies using ModuleFast.

.PARAMETER Refresh
    Refreshes module dependencies. This will remove the $RequiredModulesDirectory before resolving dependencies.

.EXAMPLE
    .\.build.ps1 -ResolveDependency
    This will run the default task [init, clean, test, build] and resolve dependencies using ModuleFast.

.EXAMPLE
    .\.build.ps1 noop -bootstrap
    This will run the noop task (no operation) and resolve dependencies using ModuleFast. (bootstrap is an alias for -ResolveDependency).

.EXAMPLE
    .\.build.ps1 noop -ResolveDependency -Refresh
    This will run the noop task (no operation), resolve dependencies using ModuleFast by refreshing the RequiredModules directory.

.EXAMPLE
    Invoke-Build Test
    This will run the Test task.

.EXAMPLE
    Invoke-Build Clean, Test, Build
    This will clean the build output folder, run unit tests, and build the module artifact.

.NOTES
    You can start using the "Invoke-Build" command after you run the .\.build.ps1 script first or install Invoke-Build module to your user scope.

    Inspiration was taken from the Sampler module: https://github.com/gaelcolas/Sampler

.LINK
    InvokeBuild: https://github.com/nightroman/Invoke-Build
    ModuleFast: https://github.com/JustinGrote/ModuleFast
#>
[CmdletBinding()]
Param(
    [Parameter(Position = 0)]
    [string[]]$Tasks = '.',

    [string]$DependencyFile = (Join-Path -Path $PSScriptRoot -ChildPath '.\build\RequiredModules.psd1'),

    [string]$RequiredModulesDirectory = (Join-Path -Path $env:LOCALAPPDATA -ChildPath '/PowerShell/RequiredModules'),

    [Parameter(ParameterSetName = 'ResolveDependencySet')]
    [Alias('bootstrap')]
    [switch]$ResolveDependency,

    [Parameter(ParameterSetName = 'ResolveDependencySet')]
    [switch]$Refresh
)
#
#region: Bootstrap InvokeBuild
#
#if (!$MyInvocation.ScriptName.EndsWith('Invoke-Build.ps1')) {
if ($MyInvocation.ScriptName -notlike '*Invoke-Build.ps1') {
	$ErrorActionPreference = 1

    Write-Host -Object "[pre-build] Starting bootstrap process" -ForegroundColor Green

    if ($ResolveDependency) {
        # Clean the RequiredModules directory
        if ($Refresh) {
            if (Test-Path -Path $RequiredModulesDirectory) {
                Write-Host -Object "[pre-build] Cleaning RequiredModules directory" -ForegroundColor Yellow
                Remove-Item -Path $RequiredModulesDirectory -Recurse -Force
            }
        }
        # Resolve dependencies
        .\build\Resolve-Dependency.ps1 -DependencyFile $DependencyFile -TargetPath $RequiredModulesDirectory
    } else {
        Write-Host -Object "[pre-build] Skipping dependency resolution. Use -ResolveDependency or -Bootstrap." -ForegroundColor Yellow
    }

    # Pre-pending $requiredModulesPath folder to PSModulePath to resolve modules from this folder FIRST.
    $powerShellModulePaths = $env:PSModulePath -split [System.IO.Path]::PathSeparator
    if ($powerShellModulePaths -notcontains $RequiredModulesDirectory) {
        Write-Host -Object "[pre-build] Pre-pending '$RequiredModulesDirectory' folder to PSModulePath" -ForegroundColor Green
        $env:PSModulePath = $RequiredModulesDirectory + [System.IO.Path]::PathSeparator + $env:PSModulePath
    }

    Write-Host -Object "[pre-build] Bootstrap completed" -ForegroundColor Green
    Write-Host -Object "[build] Starting build with InvokeBuild. Executing Tasks: $($Tasks -join ', ')" -ForegroundColor Green
	return Invoke-Build $Tasks $MyInvocation.MyCommand.Path @PSBoundParameters
}

# Runs on exit
Exit-Build {
	Write-Host -Object "Exiting build script" -ForegroundColor Yellow
}

#
# SYNOPSIS: Default task [init, clean, test, build]
#
task . init, clean, test, build

#
# SYNOPSIS: Empty task, useful to test the bootstrap process
#
task noop {}

#
# SYNOPSIS: Initializes the build environment
#
task init {
    Write-Host -Object '[Task: Init]' -ForegroundColor Magenta

    # Sets build environment variables ($env:BH*)
    Import-Module BuildHelpers -Force
    Set-BuildEnvironment -Force
    Get-BuildEnvironment
    $script:configurationFile = (Join-Path -Path $PSScriptRoot -ChildPath '.\build\configuration.psd1')
}
#endregion

#
# SYNOPSIS: Removes BuildOutput directory
#
task Clean init, {
    Write-Host -Object '[Task: Clean]' -ForegroundColor Magenta

    # Clean the build output directory
    if (Test-Path -Path "$env:BHBuildOutput") {
        Write-Host -Object "Cleaning Artifact Path: $env:BHBuildOutput"
        Remove-Item -Path "$env:BHBuildOutput" -Recurse -Force
    }

    # Clean Test Results
    if (Test-Path -Path "$env:BHProjectPath\tests\TestResults.Pester.xml") {
        Write-Host -Object "Cleaning Test Results: $env:BHProjectPath\tests\TestResults.Pester.xml"
        Remove-Item -Path "$env:BHProjectPath\tests\TestResults.Pester.xml" -Force
    }
}

#
# SYNOPSIS: Unit tests
#
task Test init, {
    Write-Host -Object '[Task: Test]' -ForegroundColor Magenta

    # Run unit tests
    Import-Module Pester -Force
    $Config = [PesterConfiguration]@{
        Run = @{
            Path = 'tests'
        }
        TestResult = @{
            OutputFormat = 'NunitXml'
            OutputPath = 'tests\TestResults.Pester.xml'
            OutputEncoding = 'UTF8'
            Enabled = $true
            Strict = $true
        }
        Output = @{
            Verbosity = 'Detailed'
        }
    }
    Invoke-Pester -Configuration $Config
}

#
# SYNOPSIS: Build the module artifacts
#
task Build init, clean, {
    Write-Host -Object '[Task: Build]' -ForegroundColor Magenta

    Import-Module ModuleBuilder -Force
    Import-Module powershell-yaml -Force

    # Get build configuration
    $buildConfig = Import-PowerShellDataFile -Path $configurationFile

    # Get current version from module manifest (source)
    $currentVersion = (Import-PowerShellDataFile -Path $env:BHPSModuleManifest).ModuleVersion

    # Determine the pipeline YAML file based on the build system
    switch ($env:BHBuildSystem) {
        'GitHub Actions' {
            $yamlFile = "$env:BHProjectPath\.github\workflows\github-pipelines.yml"
            Write-Host -Object "Building from version [$currentVersion] on branch [$env:BHBranchName]"
        }
        'AzureDevOps' {
            $yamlFile = "$env:BHProjectPath\azure-pipelines.yml"
            Write-Host -Object "Building from version [$currentVersion] on branch [$env:BHBranchName]"
        }
        default {
            Write-Host -Object "Building from version [$currentVersion] locally"
            switch ($buildConfig.pipelineType) {
                'GitHub Actions' {
                    $yamlFile = "$env:BHProjectPath\.github\workflows\github-pipelines.yml"
                }
                'AzureDevOps' {
                    $yamlFile = "$env:BHProjectPath\azure-pipelines.yml"
                }
                default {
                    throw "Unknown pipeline type: $($buildConfig.pipelineType)"
                }
            }
        }
    }

    # Get 'StepVersionBy' value from pipelines.yml
    $Yaml = Get-Content -Path $yamlFile | ConvertFrom-Yaml
    $StepVersionBy = switch ($buildConfig.pipelineType) {
        'GitHub Actions' { $Yaml.env.STEP_VERSION_BY }
        'AzureDevOps' { $Yaml.variables.stepVersionBy }
        default { throw "Unknown pipeline type: $($buildConfig.pipelineType)" }
    }

    # Use build configuration file to bump the version
    Write-Host -Object "Stepping version by: $StepVersionBy"
    Update-Metadata -Path $configurationFile -PropertyName moduleVersion -Value $currentVersion
    Step-ModuleVersion -Path $configurationFile -By $stepVersionBy
    $newVersion = (Import-PowerShellDataFile -Path $configurationFile).moduleVersion

    # Build the module artifact
    $buildConfig = @{
        ModuleManifest = $env:BHPSModuleManifest
        Version = $newVersion
        OutputDirectory = "$env:BHBuildOutput"
        Target = 'CleanBuild'
        CopyPaths = @('..\profile','Public\Config')
    }
    $build = Build-Module @buildConfig -Passthru
    Write-Host -Object "$env:BHProjectName [$newVersion] built at: $($build.ModuleBase)" -ForegroundColor DarkGreen
}

#
# SYNOPSIS: Publish the module artifact
#
task Publish build, {
    Write-Host -Object '[Task: Publish]' -ForegroundColor Magenta

    Write-Host "Under development"
    pause
}
