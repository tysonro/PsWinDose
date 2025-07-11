function Add-PSPrivateRepository {
<#
    .SYNOPSIS
        Registers a private repository

    .DESCRIPTION
        Registers a private package(nuget) repository to both PSRepository (legacy) and PSResourceRepository.

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

    if (!$RepoPath) {
        $repoPath = Read-Host -Prompt 'Enter private repo path'
    }

    # Legacy: PowerShellGet
    if (!(Get-PSRepository -Name $RepoName -ErrorAction SilentlyContinue)) {
        Write-PSFMessage -Level Important -Message "Adding private repository [$RepoName] to PowerShellGet (legacy)..."
        $Repo = @{
            Name = $RepoName
            SourceLocation = $RepoPath
            PublishLocation = $RepoPath
            InstallationPolicy = 'Trusted'
        }
        Register-PSRepository @Repo
    } else {
        Write-PSFMessage -Level Important -Message "$RepoName is already registered in PowerShellGet"
    }

    # PSResourceGet
    if (!(Get-PSResourceRepository -Name $RepoName -ErrorAction SilentlyContinue)) {
        Write-PSFMessage -Level Important -Message "Adding private repository [$RepoName] to PSResourceGet..."
        Register-PSResourceRepository -Name $RepoName -Uri $RepoPath -Trusted
    } else {
        Write-PSFMessage -Level Important -Message "$RepoName is already registered in PSResourceGet"
    }
}
