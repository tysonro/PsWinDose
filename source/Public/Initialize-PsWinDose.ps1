function Initialize-PsWinDose {
    <#
    .SYNOPSIS
        Initialize PsWinDose

    .DESCRIPTION
        Initializes (bootstraps) the PsWinDose module by installing hard dependencies and setting up the environment.

        - Creates the root folder for PsWinDose
        - Creates the software destination folder
        - Installs package providers

    .EXAMPLE
        Initialize-PsWinDose

    .EXAMPLE
        Initialize-PsWinDose -Force
    #>
    [CmdletBinding()]
    Param(
        [switch]$Force
    )
    # Get the PsWinDose settings (pswindose.settings.json)
    $Settings = Get-PsWinDoseSetting

    if (-not (Test-Elevation)) {
        throw "Need to run as administrator"
    }

    if ($Force) {
        # Remove root folder and force main code block to run
        Remove-Item -Path $Settings.rootPath -Recurse -Force
    }

    # If root path doesn't exist, initialize/bootstrap pswindose environment
    if (-not (Test-Path -Path $Settings.rootPath)) {
        Write-Verbose "Initializing PsWinDose module..."

        Write-Verbose "Installing latest version of PSResourceGet module..."
        Install-Module -Name Microsoft.PowerShell.PSResourceGet -Force

        Write-Verbose "Setting PSGallery to 'trusted' in PSRepository and PSResourceRepository..."
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        Set-PSResourceRepository -Name PSGallery -Trusted

        # Ensure PSFramework is installed for logging and consoleGuiTools for advanced TUI's
        Write-Verbose "Checking module dependencies..."
        Test-ModuleDependency -Name 'PSFramework', 'Microsoft.PowerShell.ConsoleGuiTools' -ErrorAction Stop
        Import-Module PSFramework -Force

        # Create root PsWinDose directory
        Write-PSFMessage -Level Important "Creating root directories..."
        try {
            New-Item -Path $Settings.rootPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
            Write-PSFMessage -Level Important "Root directory created: $($Settings.rootPath)"
        } catch {
            throw "Unable to create root path: $Settings.rootPath"
        }

        # Create the software destination path
        if (-not (Test-Path -Path $Settings.softwareDestinationPath)) {
            try {
                New-Item -Path $Settings.softwareDestinationPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
                Write-PSFMessage -Level Important "Software destination directory created: $($Settings.softwareDestinationPath)"
            } catch {
                throw "Unable to create software destination path: $Settings.softwareDestinationPath"
            }
        }

        # Ensure winget is installed
        if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
            # Download and install winget via msix app from GitHub
            $latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest ).assets.browser_download_url | Where-Object {
                $_.EndsWith( ".msixbundle" )
            }
            $latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]

            Write-PSFMessage -Level Important -Message "Downloading winget to artifacts directory..."
            Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"

            Write-PSFMessage -Level Important -Message "Installing winget..."
            Add-AppxPackage $latestWingetMsixBundle
            Remove-Item -Path "./$latestWingetMsixBundle"
        } else {
            Write-PSFMessage -Level Important -Message "Winget is already installed"
        }

        # Bootstrap and install package providers
        Install-PSPackageProvider

        <# Add to bootstrap phase:
            - Install winget
            - Install chocolatey
            - Install Posh 7.x
            - Install these modules: PSFramework, Microsoft.PowerShell.ConsoleGuiTools
        #>


        # Set the PsWinDose environment variable
        #if (-not $env:PsWinDose) {
        #    # This won't show up immediately, it'll need a new shell loaded...
        #    Write-Verbose "[Initialize-PsWinDose] Setting PsWinDose environment variable to $($Settings.rootPath)"
        #    [System.Environment]::SetEnvironmentVariable('PsWinDose', $Settings.rootPath, [System.EnvironmentVariableTarget]::User)
        #}
    } else {
        Write-PSFMessage -Level Important -Message 'PsWinDose is already initialized/bootstrapped'
    }
}
