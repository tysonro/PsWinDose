<#
.SYNOPSIS
    Pester tests for PSScriptAnalyzer

.DESCRIPTION
    Runs pester tests against PSScriptAnalyzer findings

.LINK
    https://github.com/pester/Pester
    https://github.com/PowerShell/PSScriptAnalyzer
#>

BeforeDiscovery {
    # If Pester is directly invoked the build environment variables need to be set
    if (!(Get-ChildItem -Path env:BH*)) {
        # Normalize build system into envioronment variables with BuildHelpers module
        Set-BuildEnvironment -Force
    }

    # Get PSSA rules
    $Rules = Get-ScriptAnalyzerRule
}

BeforeAll {
    $AnalyzerParams = @{
        Path = "$env:BHModulePath"
        Settings = "$env:BHProjectPath\Build\PSScriptAnalyzerSettings.psd1"
        Recurse = $true
    }
    $Analysis = Invoke-ScriptAnalyzer @AnalyzerParams
}

Describe "$env:BHProjectName PSScriptAnalyzer" -ForEach $Rules {
    Context 'Standard PSSA Rules' {
        BeforeAll {
            $Rule = $_
        }
        It "Should pass $_" {
            if ($Analysis.RuleName -contains $Rule) {
                $Analysis | Where-Object RuleName -eq $Rule -OutVariable Failures | Out-Default
                $Failures.Count | Should -Be 0
            }
        }
    }
}
