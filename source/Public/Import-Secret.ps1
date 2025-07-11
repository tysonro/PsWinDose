function Import-Secret {
<#
.SYNOPSIS
    Import secrets from a JSON file to a Secret Management vault.

.DESCRIPTION
    The Import-Secret function reads secrets from a specified JSON file and imports them to a Secret Management vault.
    It supports secrets of type PSCredential, String, and SecureString.

.PARAMETER Path
    The path to the JSON file containing the secrets to be imported.

.PARAMETER Vault
    The name of the Secret Management vault where the secrets will be imported.

.EXAMPLE
    Import-Secret -Path 'C:\Backups\SecretsBackup.json' -Vault 'myVault'
    This example imports secrets from the specified JSON file to the 'myVault' vault.

.LINK
    Adapted from: https://www.powershell.co.at/powershell-secrets-management-part-4-backup-export-migrate-secrets/
#>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'The secret is already in plain text in the JSON file')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Vault
    )
    # Check if the vault exists, create it if it doesn't
    if (-not (Get-SecretVault | Where-Object { $_.Name -eq $vault })) {
        Register-SecretVault -Name $vault -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
    }

    # Read the JSON file
    $secrets = Get-Content -Path $Path | ConvertFrom-Json

    # Restore each secret
    foreach ($secret in $secrets) {
        Write-PSFMessage -Level Important -Message "Restoring secret $($secret.Name)"
        switch ($secret.Type) {
            'PSCredential' {
                $username = $secret.Value.Username
                $password = $secret.Value.Password | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName PSCredential -ArgumentList $username, $password
                Set-Secret -Name $secret.Name -Secret $credential -Vault $vault
            }
            'String' {
                $secretValue = $secret.Value | ConvertTo-SecureString -AsPlainText -Force
                Set-Secret -Name $secret.Name -Secret $secretValue -Vault $vault
            }
            'SecureString' {
                $secretValue = $secret.Value | ConvertTo-SecureString -AsPlainText -Force
                Set-Secret -Name $secret.Name -Secret $secretValue -Vault $vault
            }
            default {
                Set-Secret -Name $secret.Name -Secret $secret.Value -Vault $vault
            }
        }
    }
}
