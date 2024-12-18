<#
.SYNOPSIS
    PSScriptAnalyzer Settings

.DESCRIPTION
    Defines the rules for PSScriptAnalyzer to process. The [PSSA.Tests.ps1] file runs the analyzer tests.

.NOTES
    PSScriptAnalyzer is a static code checker for PowerShell modules and scripts.
    PSScriptAnalyzer checks the quality of PowerShell code by running a set of rules.
    The rules are based on PowerShell best practices identified by the PowerShell Team and the community.
    It generates DiagnosticResults (errors and warnings) to inform users about potential code defects and
    suggests possible solutions for improvements.

.NOTES
    Analyzer rules can get pretty complex. To see what's possible ask AI:
        Prompt: Provide an example PSScriptAnalyzerSettings.psd1 file

.LINK
    https://github.com/PowerShell/PSScriptAnalyzer
#>
@{
    # List of rule names to include. If empty or omitted, all rules will be included.
    Rules = @{}

    # List of rule names to exclude. If omitted, no rules are excluded.
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'
    )

    Severity = @(
        #'Information'
        'Warning'
        'Error'
    )
}
