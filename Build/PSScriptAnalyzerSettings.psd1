<#
.SYNOPSIS
    PSScriptAnalyzer Settings

.DESCRIPTION
    Defines the rules for PSScriptAnalyzer to process. The [PSSA.Tests.ps1] file runs the analyzer tests.

.NOTES
    PSScriptAnalyzer is a static code checker for Windows PowerShell modules and scripts.
    PSScriptAnalyzer checks the quality of Windows PowerShell code by running a set of rules.
    The rules are based on PowerShell best practices identified by PowerShell Team and the community.
    It generates DiagnosticResults (errors and warnings) to inform users about potential code defects and
    suggests possible solutions for improvements.

.LINK
    https://github.com/PowerShell/PSScriptAnalyzer
#>
@{
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'
        'PSAvoidUsingInvokeExpression'
    )

    Severity = @(
        #'Information'
        'Warning'
        'Error'
    )

    Rules = @{}
}
