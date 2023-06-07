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
        'redhat.vscode-yaml'
        'dendron.dendron-markdown-shortcuts'
        'vscode-icons-team.vscode-icons'
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
