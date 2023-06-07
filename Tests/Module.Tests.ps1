<#
.SYNOPSIS
    Pester tests for module unit testing

.DESCRIPTION
    Unit tests for a PowerShell module:
        - Valid folder structure
        - Valid code
        - Aheres to BerryDunn standards
        - Valid module
#>

BeforeDiscovery {
    # If Pester is directly invoked the build environment variables need to be set
    if (!(Get-ChildItem -Path env:BH*)) {
        # Normalize build system into envioronment variables with BuildHelpers module
        Set-BuildEnvironment -Force
    }

    # Ensure scope is clean and one or more multiple versions of the module are not loaded
    Get-Module -Name $env:BHProjectName | Remove-Module

    # Get scripts and functions from within the module directory
    $Scripts = Get-ChildItem "$env:BHProjectPath\$env:BHProjectName" -Include *.ps1, *.psm1, *.psd1 -Recurse
    $Functions = Get-ChildItem "$env:BHProjectPath\$env:BHProjectName" -Include *.ps1 -Recurse
}

Describe "$env:BHProjectName Unit Tests" {
    Context 'Validate Folder Structure' {
        It "'Tests' folder should exist in project root" {
            $TestFolder = Get-ChildItem -Path $env:BHProjectPath -Name 'Tests' | Should -Not -BeNullOrEmpty
        }
        It "'ReadMe.md' file should exist in project root" {
            Get-ChildItem -Path $env:BHProjectPath -Name ReadMe.md | Should -Not -BeNullOrEmpty
        }
        It "'Public' folder should exist in module root" {
            Get-ChildItem -Path $env:BHProjectPath\$env:BHProjectName -Name 'Public' | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Validate PowerShell Code' -ForEach $Scripts {
        It "$($_.name) should be valid PowerShell" {
            $_.FullName | Should -Exist
            $Contents = Get-Content -Path $_.FullName -ErrorAction Stop
            $Errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($Contents, [ref]$Errors)
            $Errors.Count | Should -Be 0
        }
    }

    Context "Validate Advanced Functions" -ForEach $Functions {
        BeforeAll {
            # Dot source function
            . $_.FullName
        }
        It "$($_.Name) should be an advanced function" {
            $FunctionContent = Get-Content Function:$($_.BaseName)

            # Comment based help is inside the function
            $FunctionContent -Match '<#' | Should -Be $true
            $FunctionContent -Match '#>' | Should -Be $true

            # Properly formed help block
            $FunctionContent -Match '.SYNOPSIS' | Should -Be $true
            $FunctionContent -Match '.DESCRIPTION' | Should -Be $true
            $FunctionContent -Match '.EXAMPLE' | Should -Be $true

            # Should be an advanced function
            $FunctionContent = Get-Content Function:$($_.BaseName)
            $_.FullName | Should -FileContentMatch 'Function'
            $FunctionContent -Match 'CmdLetBinding' | Should -Be $true
            $FunctionContent -Match 'Param' | Should -Be $true
        }
    }

    Context 'Validate Module' {
        BeforeAll {
            # $ModulePath specifies the root module path which excludes the supporting build files
            $ModulePath = "$env:BHProjectPath\$env:BHProjectName"
        }
        It 'Should have a valid manifest file' {
            {Test-ModuleManifest (Join-Path $ModulePath "$env:BHProjectName.psd1")} | Should -Not -Throw
        }
        It 'Module should import cleanly' {
            {Import-Module (Join-Path $ModulePath "$env:BHProjectName.psm1") -Force} | Should -Not -Throw
        }
    }
}
