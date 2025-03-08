function Add-PSPrivateRepository {
<#
    .SYNOPSIS
        Registers a private repository

    .DESCRIPTION
        Registers a private package(nuget) repository.

    .EXAMPLE
        Add-PrivateRepository -RepoName 'repo1' -RepoPath '\\server1\Repo1Path'
#>
    [CmdletBinding()]
    param(
        $RepoName,
        $RepoPath
    )
    # Get repo name if it wasn't provided
    if (!$RepoName) {
        $repoName = Read-Host -Prompt 'Enter private repo name'
    }

    # Add private repository
    if (!(Get-PSRepository -Name $RepoName -ErrorAction SilentlyContinue)) {
        if (!$RepoPath) {
            $repoPath = Read-Host -Prompt 'Enter private repo path'
        }

        Write-PSFMesage -Level Important -Message 'Adding private repository...'
        $Repo = @{
            Name = $RepoName
            SourceLocation = $RepoPath
            PublishLocation = $RepoPath
            InstallationPolicy = 'Trusted'
        }
        Write-PSFMessage -Level Important -Message 'Registering $RepoName repository...'
        Register-PSRepository @Repo
    }
    Write-PSFMessage -Level Important -Message "$RepoName is already registered"
}
