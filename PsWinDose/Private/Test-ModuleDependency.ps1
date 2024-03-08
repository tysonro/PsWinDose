function Test-ModuleDependency {
<#
.SYNOPSIS
Test module dependency

.DESCRIPTION
Test if a module is installed and imported, attempt to install and import if it isn't

.EXAMPLE
Test-ModuleDependency -Name 'az.accounts', 'az.automation'

.EXAMPLE
Test-ModuleDependency -Name 'az.accounts', 'az.automation', 'ActiveDirectory', 'BD-Credentials', 'BD-AdminTools' -ErrorAction Stop
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string[]]$Name
    )
    foreach ($ModuleName in $Name) {
        if (!(Get-Module -Name $ModuleName)) {
            # Check if the module is imported
            if (!(Get-Module -Name $ModuleName)) {
                Write-Verbose "[Test-ModuleDependency] :: Module [$ModuleName] is not imported. Attempting to import..."

                # Try to import the module
                try {
                    Import-Module $ModuleName -ErrorAction Stop
                    Write-Verbose "[Test-ModuleDependency] :: Module [$ModuleName] imported successfully"
                } catch {
                    Write-Warning "Failed to import [$ModuleName]"
                    Write-Output "Checking if module is installed..."

                    # Check if the module is installed
                    if (!(Get-InstalledModule $ModuleName -ErrorAction SilentlyContinue)) {
                        Write-Output "Module [$ModuleName] is not installed. Attempting to install..."

                        # Try to find the module on the PSGallery
                        try {
                            $ModuleExists = Find-Module -Name $ModuleName -ErrorAction Stop
                        } catch {
                            Write-Error "Failed to find module [$ModuleName] in the PSGallery/internal BerryDunn Repository" -ErrorAction Stop
                        }
                        # Try to install the module
                        if ($ModuleExists) {
                            try {
                                Install-Module $ModuleName -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop

                                # Try to import the module
                                try {
                                    Import-Module $ModuleName -ErrorAction Stop
                                    Write-Output "Module [$ModuleName] imported successfully"
                                } catch {
                                    Write-Output "Failed to import module: $ModuleName"
                                }
                            } catch {
                                Write-Error "Failed to install module: $ModuleName"
                            }
                        }
                    } else {
                        Write-Error "Module [$ModuleName] is installed but appeared to have an issue importing." -ErrorAction Stop
                    }
                }
            }
        } else {
            Write-Verbose "[Test-ModuleDependency] :: Module [$ModuleName] is already imported"
        }
    }
}
