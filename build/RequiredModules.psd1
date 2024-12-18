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
    # Defaults for all dependencies
    #BuildOptions  = @{
    #    Target     = 'CurrentUser'
    #    Gallery         = 'PSGallery'
    #    AllowPrerelease = $false
    #    WithYAML        = $true
    #}

    PSScriptAnalyzer            = 'latest'
    Pester                      = 'latest'
    InvokeBuild                 = 'latest'
    ModuleBuilder               = 'latest'
    BuildHelpers                 = 'latest'
    'powershell-yaml'           = 'latest'
    #dbatools                    = '2.1.28'
}
