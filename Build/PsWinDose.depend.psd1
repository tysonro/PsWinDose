<#
.SYNOPSIS
    Requirements

.DESCRIPTION
    List of dependencies needed for the build process

.LINK
    https://github.com/RamblingCookieMonster/PSDepend
#>

@{
    # Defaults for all dependencies
    PSDependOptions  = @{
        Target     = 'CurrentUser'
    }

    # Build dependencies
    PSScriptAnalyzer  = '1.20.0'
    Pester            = '5.3.3'
    BuildHelpers      = '2.0.16'
    PSake             = '4.9.0'
    PowerShellGet     = '2.2.5'
    'PowerShell-yaml' = '0.4.2'
}
