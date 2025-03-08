function Install-Software {
<#
    .SYNOPSIS
        Install software I like to use

    .DESCRIPTION
        Installs software using winget. If the software is already installed, winget will attempt to update it when
        you run the install commands on a machine that already has it installed.

        winget commands:
            Find: winget search <package-name>
            Install: winget install <package-name>
            List: winget list <package-name>
            Download: winget download <package-name> -d '<downloadDirectory>'

    .EXAMPLE
        Install-Software

    .EXAMPLE
        Install-Software -All

    .EXAMPLE
        Install-Software -RSAT
        Install RSAT components (needs to run as Admin)

    .EXAMPLE
        Install-Software -AIShell
        Installs AI Shell

    .EXAMPLE
        Install-Software -Default
        Installs apps marked as default in the config file (winget.apps.psd1)

    .LINK
        Winget Docs: https://learn.microsoft.com/en-us/windows/package-manager/winget/

        Good examples: https://github.com/brwilkinson/AzureDeploymentFramework/blob/main/ADF/1-prereqs/00-InstallTools.ps1
#>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Does not recognize $global is used elsewhere')]
    [CmdletBinding()]
    param (
        [switch]$All,
        [switch]$RSAT,
        [switch]$AIShell,
        [switch]$Default
    )
    Import-Module PSFramework, Microsoft.PowerShell.ConsoleGuiTools

    # Check if winget is already installed
    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-PSFMessage -Level Error -Message "Winget is not installed. Bootstrap with: Initialize-PsWinDose" -ErrorAction Stop
    } else {
        Write-PSFMessage -Level Verbose -Message "Winget is already installed."
    }

    # Import the winget app list data file
    $wingetAppList = Import-PowerShellDataFile -Path "$PSScriptRoot\config\winget.apps.psd1"

    # Create calculated properties with custom names
    $wgAppList = $wingetAppList.Apps | Select-Object @{n='Name';e={$_.Name}}, @{n='Id';e={$_.Id}}, @{n='Description';e={$_.Description}}, @{n='Default';e={$_.Default}}

    # Check if no parameters were passed
    if ($PSBoundParameters.Count -eq 0) {
        # Run the default action (select apps interactively)
        $appList = $wgAppList | Out-ConsoleGridView -Title "Select apps to install" -OutputMode Multiple
    } else {
        switch ($PSBoundParameters.Keys) {
            'All' {
                $appList = $wgAppList
            }
            'RSAT' {
                # Install RSAT (needs to run as Admin)
                if (Test-Elevation) {
                    $rsatComponents = Get-WindowsCapability -Name RSAT* -Online | Select-Object @{n='Name';e={$_.Name}}, @{n='State';e={$_.State}}

                    # Filter out already installed components
                    $rsatComponentsToInstall = $rsatComponents | Where-Object { $_.State -ne 'Installed' }

                    if ($rsatComponentsToInstall.Count -eq 0) {
                        Write-PSFMessage -Level Important -Message "All RSAT components are already installed."
                    } else {
                        # Allow user to select RSAT components to install
                        $selectedComponents = $rsatComponentsToInstall | Out-ConsoleGridView -Title "Select RSAT components to install" -OutputMode Multiple

                        if ($selectedComponents) {
                            foreach ($component in $selectedComponents) {
                                Write-PSFMessage -Level Important -Message "Installing $($component.Name)..."
                                Add-WindowsCapability -Online -Name $component.Name
                            }
                        } else {
                            Write-PSFMessage -Level Important -Message "No RSAT components selected for installation."
                        }
                    }
                } else {
                    Write-PSFMessage -Level Warning -Message "RSAT can only be installed from an elevated PowerShell prompt."
                }
            }
            'AIShell' {
                # https://github.com/PowerShell/AIShell
                Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-aishell.ps1') }"
            }
            'Default' {
                $appList = $wgAppList | Where-Object {$_.Default -eq $true}
            }
        }
    }

    # If app list is populated, install apps via winget
    if ($appList) {
        foreach ($app in $appList) {
            if ((winget list $app.id --accept-source-agreements) -like "*no installed package*") {
                Write-PSFMessage -Level Important -Message "Installing $($app.id)..."
                Write-PSFMessage -Level Important -Message "Command: winget install $($app.id) -e --accept-source-agreements --force"
                winget install $app.id -e --accept-source-agreements --force
            } else {
                Write-PSFMessage -Level Important -Message "$($app.id) is already installed."
            }
        }
    }
}
