<#
.DESCRIPTION
    Master list of PowerShell modules I like to use.
    The 'Install-PSModule' function uses this list to install the modules.
#>
@{
    Modules = @(
        @{
            Name        = 'Az.Accounts';
            Description = 'Azure Accounts module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/Azure/azure-powershell';
            Default     = $false
        },
        @{
            Name        = 'Az.KeyVault';
            Description = 'Azure KeyVault module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/Azure/azure-powershell';
            Default     = $false
        },
        @{
            Name        = 'Az.Resources';
            Description = 'Azure Resources module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/Azure/azure-powershell';
            Default     = $false
        },
        @{
            Name        = 'Az.Storage';
            Description = 'Azure Storage module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/Azure/azure-powershell';
            Default     = $false
        },
        @{
            Name        = 'Az.Tools.Predictor';
            Description = 'Azure Tools Predictor module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/Azure/azure-powershell';
            Default     = $false
        },
        @{
            Name        = 'ExchangeOnlineManagement';
            Description = 'Exchange Online Management module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/microsoft/Office365DSC';
            Default     = $false
        },
        @{
            Name        = 'Microsoft.PowerShell.SecretManagement';
            Description = 'Secret Management module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/PowerShell/SecretManagement';
            Default     = $true
        },
        @{
            Name        = 'Microsoft.PowerShell.SecretStore';
            Description = 'Secret Store module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/PowerShell/SecretStore';
            Default     = $true
        },
        @{
            Name        = 'Microsoft.WinGet.Client';
            Description = 'WinGet client module';
            Author      = 'Microsoft';
            ProjectUrl  = 'https://github.com/microsoft/winget-cli';
            Default     = $true
        },
        @{
            Name        = 'PSDevOps';
            Description = 'DevOps automation module by James Brundage';
            Author      = 'James Brundage';
            ProjectUrl  = 'https://github.com/StartAutomating/PSDevOps';
            Default     = $false
        },
        @{
            Name        = 'PSEverything';
            Description = 'PowerShell Everything module';
            Author      = 'Jaykul';
            ProjectUrl  = 'https://github.com/Jaykul/PSEverything';
            Default     = $false
        },
        @{
            Name        = 'PSFramework';
            Description = 'PowerShell Framework module by Fred Weinmann';
            Author      = 'Fred Weinmann';
            ProjectUrl  = 'https://github.com/PowershellFrameworkCollective/psframework';
            Default     = $true
        },
        @{
            Name        = 'posh-git';
            Description = 'Git prompt support';
            Author      = 'Keith Dahlby';
            ProjectUrl  = 'https://github.com/dahlbyk/posh-git';
            Default     = $true
        },
        @{
            Name        = 'terminal-icons';
            Description = 'Terminal icons';
            Author      = 'Devon Brenner';
            ProjectUrl  = 'https://github.com/devblackops/Terminal-Icons';
            Default     = $false
        }
    )
}
