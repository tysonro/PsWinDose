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
        'github.copilot-chat'
        'dendron.dendron'
        'dendron.dendron-markdown-shortcuts'
        'vscode-icons-team.vscode-icons'
        'tylerleonhardt.vscode-inline-values-powershell' # Inline debugging info!
        'ms-azuretools.vscode-azurefunctions'
        'redhat.vscode-yaml'
        'eamodio.gitlens'
        'ms-azuretools.vscode-bicep'
        'bierner.markdown-checkbox' # Adds checkboxesto markdown
        'bierner.markdown-emoji' # Adds emojis to markdown
        'yzane.markdown-pdf' # Markdown to PDF converter
        'yzhang.markdown-all-in-one' # Adds table of contents, keybaord shortcuts, etc. to markdown
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
