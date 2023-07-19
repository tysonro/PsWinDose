Function Install-PSPackageProvider {
<#
.SYNOPSIS
Installs Package Providers

.DESCRIPTION
Checks if provider is present, otherwise installs the following Package Providers:
    - NuGet
    - ChocolateyGet
    - Chocolatey

.EXAMPLE
Install-PackageProviders -RepoName 'repo1' -RepoPath '\\server1\Repo1Path'
#>
    [CmdLetBinding()]
    Param(
        $RepoName,
        $RepoPath,
        [switch]$AddPrivateRepo
    )

    if ($AddPrivateRepo) {
        # Add private repository
        if (!(Get-PSRepository -Name $RepoName -ErrorAction SilentlyContinue)) {
            $Repo = @{
                Name = $RepoName
                SourceLocation = $RepoPath
                PublishLocation = $RepoPath
                InstallationPolicy = 'Trusted'
            }
            Write-Host "`nRegistering $RepoName repository..."
            Register-PSRepository @Repo
        }
        Write-Host "`n$RepoName is already registered"
    }

    # Get list of current package providers
    Write-Host "`nChecking available package providers..." -ForegroundColor Cyan
    $Providers = Get-PackageProvider -ListAvailable

    # Set PSGallery as trusted
    $Trusted = (Get-PackageSource -Name PSGallery).IsTrusted
    if (!($Trusted)) {
        Write-Output "`nConfiguring PSGallery as a trusted package source..."
        Set-PackageSource -Name PSGallery -Trusted -Verbose:$false | Out-Null
    }

    # NuGet
    $Nuget = $Providers | Where-Object {$_.Name -eq 'NuGet'}
    if (!$Nuget) {
        Write-Output "`nInstalling NuGet Package Provider..."
        Install-PackageProvider -Name NuGet -Force
        #Find-PackageProvider -Name NuGet -ForceBootstrap -IncludeDependencies # Also installs, wonder what the forcebootstrap and includedependencies does?
    }

    # ChocolateyGet
    #$ChocoGet = $Providers | Where-Object {$_.Name -eq 'ChocolateyGet'}
    #if ($ChocoGet) {
    #    Write-Verbose "`nChocolateyGet Package Provider is already installed."
    #}
    #else {
    #    Write-Output "`nInstalling ChocolateyGet Package Provider..."
    #    Install-PackageProvider -Name ChocolateyGet -Force
    #}

    # Chocolatey
    if (!(Test-Path -Path 'C:\ProgramData\Chocolatey')) {
        Write-Output "`nInstalling Chocolatey..."
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
}
