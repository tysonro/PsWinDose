function Test-ModuleDependency {
    <#
    .SYNOPSIS
    Ensures required PowerShell modules are installed and imported.

    .DESCRIPTION
    Checks if a module is imported; if not, it attempts to import it. If the module is not installed,
    it will attempt to install it from the specified repository before importing.

    .PARAMETER Name
    The name(s) of the PowerShell module(s) to check.

    .PARAMETER Repository
    The repository to search for missing modules (default: PSGallery).

    .EXAMPLE
    Test-ModuleDependency -Name 'Az.Accounts', 'Az.Automation'

    .EXAMPLE
    Test-ModuleDependency -Name 'BD-Credentials', 'BD-AdminTools' -Repository 'MyInternalRepo'
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string[]]$Name,

        [string]$Repository = 'PSGallery'
    )

    foreach ($ModuleName in $Name) {
        # Check if module is already imported
        if (Get-Module -Name $ModuleName) {
            Write-Verbose "[Test-ModuleDependency] :: Module [$ModuleName] is already imported."
            continue
        }

        # Special case for ActiveDirectory module
        if ($ModuleName -eq 'ActiveDirectory') {
            try {
                Import-Module ActiveDirectory -ErrorAction Stop
                Write-Verbose "[Test-ModuleDependency] :: Module [$ModuleName] imported successfully."
                continue
            } catch {
                Write-Warning "[Test-ModuleDependency] :: Module [$ModuleName] requires RSAT installation. Install it manually via 'Get-WindowsCapability -Name RSAT.ActiveDirectory* -Online | Add-WindowsCapability -Online'."
                continue
            }
        }

        # Check if module is installed
        if (!(Get-InstalledModule -Name $ModuleName -ErrorAction SilentlyContinue)) {
            Write-Verbose "[Test-ModuleDependency] :: Module [$ModuleName] is not installed. Searching in repository [$Repository]..."

            # Attempt to find the module
            try {
                $ModuleExists = Find-Module -Name $ModuleName -Repository $Repository -ErrorAction Stop
            } catch {
                Write-Error "[Test-ModuleDependency] :: Failed to find module [$ModuleName] in repository [$Repository]. Skipping..."
                continue
            }

            # Install the module if found
            if ($ModuleExists) {
                try {
                    Install-Module -Name $ModuleName -Repository $Repository -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
                    Write-Verbose "[Test-ModuleDependency] :: Module [$ModuleName] installed successfully."
                } catch {
                    Write-Error "[Test-ModuleDependency] :: Failed to install module [$ModuleName]. Check permissions or repository availability."
                    continue
                }
            } else {
                Write-Error "[Test-ModuleDependency] :: Module [$ModuleName] not found in repository [$Repository]."
                continue
            }
        }

        # Attempt to import the module
        try {
            Import-Module -Name $ModuleName -ErrorAction Stop
            Write-Verbose "[Test-ModuleDependency] :: Module [$ModuleName] imported successfully."
        } catch {
            Write-Error "[Test-ModuleDependency] :: Module [$ModuleName] is installed but failed to import. Check for missing dependencies or corrupted installations."
        }
    }
}
