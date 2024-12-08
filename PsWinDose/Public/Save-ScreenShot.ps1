<#
.SYNOPSIS
    Capture and save one or more screens to a file as a .JPG.

.DESCRIPTION
    Capture and save one or more screens to a file as a .JPG. You can also set there retention days for the files. Default is 30.

.EXAMPLE
    Save-ScreenCapture.ps1 -SavePath "C:\ScreenShots" -RetentionDays 30
    Save the primary screen to C:\ScreenShots

.NOTES
    Scheduled Task:
    - Run whether user is logged on or not
    - Run with highest privileges
    - Action: Start a program
    - Program/script: powershell.exe
    - Add arguments: -ExecutionPolicy Bypass -File "C:\path\to\Save-Screenshot.ps1" -SavePath "C:\screenshots" -RetentionDays 30

Author: Tyson O'Keefe
Date: 2024-10-21    
#>
[CmdletBinding()]
param(
    # Specify the directory to save the files to
    [string]$SavePath = 'c:\ScreenShots',

    # Specify the number of days to keep files for
    [Parameter()]
    [int]$RetentionDays = 30,

    [switch]$AllScreens
)

# Check Windows PowerShell 5.1 version
if ($PSVersionTable.PSVersion.Major -ne 5 -and $PSVersionTable.PSVersion.Minor -ne 1) {
    Write-Warning "This script requires Windows PowerShell 5.1"
    Exit
}

# Required modules - Install if it is not already installed
$modules = @(
    'pshot'
    'psframework'
)
$modules | foreach-object {
    if (-not (Get-Module -ListAvailable -Name $_)) {
	    Write-Verbose "Installing module $_"
        Install-Module -Name pshot -Force
    } else {Write-Verbose "Module $_ is already installed"}
}

# Create the directory if it does not exist
if (-not (Test-Path -Path $SavePath)) {
    Write-PSFMessage -Level Important -Message "Creating directory $SavePath"
    New-Item -Path $SavePath -ItemType Directory
}

# Capture the screen
$params = @{
    Directory = $SavePath
    Prefix = (Get-Date -Format 'yyyyMMdd-HHmmss')
    Primary = $true
    Verbose = $false
}
if ($AllScreens) {
    Write-PSFMessage -Level Important -Message "Capturing all screens"
    $params['Primary'] = $false
}
Get-PShot @params

# Clean up old files
$RetentionDate = (Get-Date).AddDays(-$RetentionDays)
Get-ChildItem -Path $Directory -Filter "*.jpg" | Where-Object { $_.LastWriteTime -lt $RetentionDate } | Remove-Item -Force
