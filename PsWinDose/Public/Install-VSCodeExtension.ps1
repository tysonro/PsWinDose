function Install-VSCodeExtension {
<#
.SYNOPSIS
Installs VSCode extensions.

.DESCRIPTION
Installs my favorite VSCode extensions.

.EXAMPLE
Install-VSCodeExtension
#>
    [CmdletBinding()]
    param()
    $extensions = @(
        'ms-vscode.powershell'
        'github.copilot'
        'dendron.dendron'
        'dendron.dendron-markdown-shortcuts'
        'vscode-icons-team.vscode-icons'
        'tylerleonhardt.vscode-inline-values-powershell' # Inline debugging info!
        'ms-azuretools.vscode-azurefunctions'
        'redhat.vscode-yaml'
        'eamodio.gitlens'
        'ms-azuretools.vscode-bicep'
    )

    foreach ($extension in $extensions) {
        if (Test-Path "$env:USERPROFILE\.vscode\extensions\$extension*") {
            Write-Host "$extension is already installed." -ForegroundColor Green
        } else {
            Write-Host "Installing $extension" -ForegroundColor Cyan
            code --install-extension $extension
        }
    }
}
