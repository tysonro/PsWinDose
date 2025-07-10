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
        Allows you to pick and choose which ones to install

    .EXAMPLE
        Install-PSModule -Default
        Only installs the modules marked as default in the install.modules.psd1 file

    .EXAMPLE
        Install-PSModule -All
        Installs all modules listed in the install.modules.psd1 file
#>
    [cmdletbinding()]
    param(
        [switch]$Default,
        [switch]$All
    )
    Import-Module PSFramework, Microsoft.PowerShell.ConsoleGuiTools

    # Import the module list data file
    $moduleList = Import-PowerShellDataFile -Path "$psscriptroot\config\install.modules.psd1"

    # Create calculated properties with custom names
    $modules = $moduleList.Modules | Select-Object @{n='Name';e={$_.Name}}, @{n='Description';e={$_.Description}}, @{n='Author';e={$_.Author}}, @{n='ProjectUrl';e={$_.ProjectUrl}}, @{n='Default';e={$_.Default}}

    if ($All) {
        $selectedModules = $modules
    } elseif ($Default) {
        $selectedModules = $modules | Where-Object { $_.Default -eq $true }
    } else {
        # Allow user to select modules to install
        $selectedModules = $modules | Out-ConsoleGridView -Title 'Select modules to install' -OutputMode Multiple
    }

    # Install PowerShell Modules
    foreach ($module in $selectedModules) {
        if (Get-InstalledModule -Name $module.Name -ErrorAction SilentlyContinue) {
            Write-PSFMessage -Level Important -Message "$($module.Name) is already installed"
        } else {
            Write-PSFMessage -Level Important -Message "Installing module: $($module.Name)"
            Find-Module -Name $module.Name | Install-Module -Scope CurrentUser -Force
        }
    }

    # PSStyle - For backwards compatibility regarding prompt styles and colors
    if ($PSVersionTable.PSVersion -lt [version]'7.2') {
        if (Get-InstalledModule -Name psstyle -ErrorAction SilentlyContinue) {
            Write-PSFMessage -Level Important -Message 'PSStyle is already installed'
        } else {
            # This module creates the $PSStyle variable for versions of PowerShell that don't have it built-in
            Write-PSFMessage -Level Important -Message 'Installing module: PSStyle'
            Find-Module -Name psstyle | Install-Module -Scope CurrentUser -Force
        }
    }
}
