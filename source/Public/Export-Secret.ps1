function Export-Secret {
<#
    .SYNOPSIS
        Export secrets from a Secret Management vault to a JSON file.

    .DESCRIPTION
        The Export-Secret function retrieves secrets from a specified Secret Management vault and exports them to a JSON file.
        The secrets can be of type PSCredential, String, or SecureString.

        Once exported, the JSON file can be used to restore the secrets using the Restore-Secrets function.

    .PARAMETER Vault
        The name of the Secret Management vault from which to retrieve secrets.

    .PARAMETER Path
        The path to the JSON file where the secrets will be exported.

    .EXAMPLE
        Export-Secret -vault 'myVault' -path 'C:\Backups'
        This example exports secrets from the vault 'myVault' to the designated file location.

    .LINK
        Adapted from: https://www.powershell.co.at/powershell-secrets-management-part-4-backup-export-migrate-secrets/
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Vault,

        [Parameter(Mandatory)]
        [string]$Path
    )
    $vaultSecrets = Get-SecretInfo -Vault $vault

    $secrets = foreach ($secret in $vaultSecrets) {
        Write-PSFMessage -Level Important -Message "Exporting secret: $($secret.name)"

        switch ($secret.Type) {
            'PSCredential' {
                $cred = Get-Secret -Name $secret.Name
                $secretValue = @{
                    Username = $cred.Username
                    Password = $cred.Password | ConvertFrom-SecureString -AsPlainText
                }
            }
            'String' {
                $secretValue = Get-Secret -Name $secret.Name | ConvertFrom-SecureString -AsPlainText
            }
            'SecureString' {
                $secretValue = Get-Secret -Name $secret.Name | ConvertFrom-SecureString -AsPlainText
            }
            default {
                $secretValue = Get-Secret -Name $secret.Name
            }
        }
        [PSCustomObject]@{
            Name  = $secret.Name
            Type  = [string]$secret.Type
            Value = $secretValue
        }
    }
    $destination = Join-Path -Path $Path -ChildPath 'SecretsBackup.json'
    $secrets | ConvertTo-Json | Set-Content -Path $destination
    Get-Item -Path $destination
}
