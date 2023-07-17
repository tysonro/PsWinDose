<#
.SYNOPSIS
    Build controller and Bootstrap script for build process

.DESCRIPTION
    This script handles dependencies and requirements when the bootstrap switch is used.
    It also controls the task workflow for the 'build.psake.ps1' build script.

    At a minimum, we need to ensure NuGet and PSDepend are installed. PSDepend is then invoked
    to handle the rest of the requirements (see *.depend.psd1 configure dependencies).

.EXAMPLE
    You can run this script locally to test the entire build:
    .\build.ps1 -TaskList default, build, deploy

.EXAMPLE
    You can also run components of the build to test them individually:
    .\build.ps1 -TaskList build
#>
[CmdLetBinding()]
Param(
    $TaskList = 'Default',
    [switch]$Bootstrap
)

Write-Output "`nSTARTED TASKS: $($TaskList -join ',')`n"

# Bootstrap environment and load dependencies
if ($PSBoundParameters.Keys -contains 'Bootstrap') {
    Write-Output "Installing dependencies...`n"

    # Bootstrap NuGet package provider
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

    # Ensure PSDepend2 module is installed
    if (!(Get-Module PSDepend2 -ListAvailable)) {
        Write-Output 'Installing module PSDepend2...'
        Install-Module PSDepend2 -Scope CurrentUser -Force
    }

    <#
    Remove old Pester module
    Windows 10 and Server 2016 ships with version 3.4.0
    Due to script signing, we need to remove that version first in order for PSDepend to install the latest
    #>
    if ($Pester = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -eq '3.4.0'}) {
        Write-Output 'Removing version 3.4.0 of Pester...'
        takeown /F $Pester.ModuleBase /A /R | Out-Null
        icacls $Pester.ModuleBase /reset | Out-Null
        icacls $Pester.ModuleBase /grant Administrators:'F' /inheritance:d /T | Out-Null
        Remove-Item -Path $Pester.ModuleBase -Recurse -Force
    }

    # Install build dependencies
    $PSDependParms  = @{
        Import      = $true
        Confirm     = $false
        Install     = $true
        Force       = $true
    }

    # Check for dependencies defined in requirements.psd1
    Invoke-PSDepend @PSDependParms

    # Remove Bootstrap PSBoundParameter for passthru to PSake
    $PSBoundParameters.Remove('Bootstrap') | Out-Null
}
else {
    Write-Warning "Skipping dependency check...`n"
}

# Init BuildHelpers (Normalizes build system into envioronment variables with 'BuildHelpers' module)
Set-BuildEnvironment -GitPath git -Force

# Invoke Psake build tasks
$PsakeParms = @{
    BuildFile = (Join-Path -Path $env:BHProjectPath -ChildPath 'Build\build.psake.ps1')
    TaskList = $TaskList
    NoLogo = $true
}
Invoke-Psake @PsakeParms

Write-Output "`nFINISHED TASKS: $($TaskList -join ',')"

# If psake fails, exit
exit ([int](!$psake.build_success))
