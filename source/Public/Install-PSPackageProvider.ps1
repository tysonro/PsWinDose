# PSScriptAnalyzer -SuppressRule PSAvoidUsingInvokeExpression
Function Install-PSPackageProvider {
<#
    .SYNOPSIS
        Installs Package Providers

    .DESCRIPTION
        Checks if provider is present, otherwise installs the following Package Providers:
            - NuGet
            - ChocolateyGet
            - Chocolatey

        Will also mark the PsGallery as trusted.

    .EXAMPLE
        Install-PackageProviders
#>
    [CmdLetBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '')]
    Param()

    # Set PSGallery as trusted
    $Trusted = (Get-PackageSource -Name PSGallery).IsTrusted
    if (!($Trusted)) {
        Write-PSFMessage -Level Important -Message 'Configuring PSGallery as a trusted package source...'
        Set-PackageSource -Name PSGallery -Trusted -Verbose:$false | Out-Null
    }

    # Get list of current package providers
    Write-PSFMessage -Level Important -Message 'Checking available package providers...'
    $Providers = Get-PackageProvider -ListAvailable

    # NuGet
    $Nuget = $Providers | Where-Object {$_.Name -eq 'NuGet'}
    if (!$Nuget) {
        Write-PSFMessage -Level Important -Message 'Installing NuGet Package Provider...'
        Install-PackageProvider -Name NuGet -Force
        #Find-PackageProvider -Name NuGet -ForceBootstrap -IncludeDependencies # Also installs, wonder what the forcebootstrap and includedependencies does?
    } else {
        Write-PSFMessage -Level Important -Message 'NuGet is already installed.'
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
        Write-PSFMessage -Level Important -Message 'nstalling Chocolatey...'
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    } else {
        Write-PSFMessage -Level Important -Message 'Chocolatey is already installed.'
    }
}
