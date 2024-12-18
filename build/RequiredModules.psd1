<#
.SYNOPSIS
    Required modules

.DESCRIPTION
    List of dependencies needed for the build process

.LINK
    https://github.com/RamblingCookieMonster/PSDepend
#>

# Build dependencies
@{
    PSScriptAnalyzer            = 'latest'
    Pester                      = 'latest'
    InvokeBuild                 = 'latest'
    ModuleBuilder               = 'latest'
    BuildHelpers                 = 'latest'
    'powershell-yaml'           = 'latest'
}
