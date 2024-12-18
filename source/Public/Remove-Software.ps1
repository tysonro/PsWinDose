function Remove-Software {
<#
.SYNOPSIS
Uninstalls software
.DESCRIPTION
Uninstalls software
.EXAMPLE
Remove-Software
#>
    [cmdletbinding(SupportsShouldProcess)]
    param()

    # Apps to uninstall
    #$UninstallApps = @(
    #    'Google Chrome',
    #    'Adobe Acrobat 2017',
    #    'EasyImport',
    #    'Moffsoft FreeCalc'
    #)


    <#
    Remove old Pester module
    Windows 10 (LTSB/C) and Server 2016 ships with version 3.4.0
    Due to script signing, we need to remove that version first in order for PSKoans to install the latest (depends on a newer version of Pester)
    Docs: https://pester.dev/docs/v4/introduction/installation
    #>
    if ($Pester = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -eq '3.4.0'}) {
        Write-Output 'Removing version 3.4.0 of Pester...'
        takeown /F $Pester.ModuleBase /A /R | Out-Null
        icacls $Pester.ModuleBase /reset | Out-Null
        icacls $Pester.ModuleBase /grant Administrators:'F' /inheritance:d /T | Out-Null
        Remove-Item -Path $Pester.ModuleBase -Recurse -Force
    }

    # Uninstall apps
    #Foreach ($App in $UninstallApps) {
    #    Uninstall-App -Name $App -AllUsers
    #}



    # Uninstall unwanted apps
    #Foreach ($App in $UninstallApps) {
    #    $RemoveApp = Get-WmiObject -Class Win32_Product | Where-Object {
    #        $_.Name -eq $App
    #    }
    #    Write-Host "Removing Application: $App" -Fore Yellow
    #    $RemoveApp.Uninstall()
    #}
    # OR:
    #Get-Package -Provider Programs -IncludeWindowsInstaller -Name $App | Uninstall-Package -Force

}
