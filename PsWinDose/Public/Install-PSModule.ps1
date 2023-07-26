function Install-PSModule {
<#
.SYNOPSIS
Installs PowerShell modules

.DESCRIPTION
Installs all my favorite PowerShell modules:

- posh-git
- terminal-icons
- az.accounts
- exchangeOnlineManagement
- etc.

.EXAMPLE
Install-PSModule
#>
    [cmdletbinding()]
    param()

    # Modules to install
    $Modules = @(
        'Az.Accounts'
        'Az.Resources'
        'Az.Storage'
        'Az.KeyVault'
        'ExchangeOnlineManagement'
        'posh-git'
        'terminal-icons'
        'PSKoans' # Will Install Pester as a dependency!
        'PSEverything' # Requires 'Everything' app installed which is handled in the Install-Software script
        'PSDevOps' # James Brundage's module to automate git, Az Dev Ops and Github for DevOps tasks
        'PSFramework' # Fred Weinmann's module that provides tools for other modules and scripts (logging, etc.)
        'Az.Tools.Predictor' # Provides predictive intellisense for Az modules (requires PS 7.2+)
    )

    # Install PowerShell Modules
    Foreach ($Module in $Modules) {
        if (Get-InstalledModule -Name $Module -ErrorAction SilentlyContinue) {
            Write-Host "$Module is already installed." -ForegroundColor Green
        } else {
            Write-Host "Installing $Module..." -ForegroundColor Cyan
            Find-Module -Name $Module | Install-Module -Scope CurrentUser -Force
        }
    }

    # PSStyle - For backwards compatibility regarding prompt styles and colors
    if ($PSVersionTable.PSVersion -lt [version]'7.2') {
        if (Get-InstalledModule -Name psstyle -ErrorAction SilentlyContinue) {
            Write-Host "PSStyle is already installed." -ForegroundColor Green
        } else {
            # This module creates the $PSStyle variable for versions of PowerShell that don't have it built-in
            Write-Host "Installing PSStyle..." -ForegroundColor Cyan
            Find-Module -Name psstyle | Install-Module -Scope CurrentUser -Force
        }

    }
}
