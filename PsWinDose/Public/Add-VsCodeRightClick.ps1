function Add-VsCodeRightClick {
<#
.SYNOPSIS
Adds right click context menu to open files and folders with VS Code
.DESCRIPTION
Adds right click context menu to open files and folders with VS Code
.EXAMPLE
Add-VsCodeRightClick

.NOTES
Win 11 context menu
https://www.youtube.com/watch?v=yzsb_il7aPw

#>
    [cmdletbinding()]
    param(
        $vsCodePath = "C:\Program Files\Microsoft VS Code\Code.exe"
    )
    # Need to run as admin
    if (!(Test-Elevation)) {
        Write-Error "Session is not elevated. Please run this script as an Administrator!" -ErrorAction Stop
    }

    if (Test-Path $vsCodePath -ErrorAction Stop) {
        Write-Output "Adding right click context menu for VS Code..."

        # Create a registry drive for HKEY_CLASSES_ROOT
        New-PSDrive -Name "HKCR" -PSProvider Registry -Root "HKEY_CLASSES_ROOT" -ErrorAction SilentlyContinue | Out-Null

        # Open files
        ## NOTE: The open files section will create the folders but has problems setting values in this location for some reason...
        ## If you want to add the open files context menu option you will need to manually set the values in the registry.
        $rootPath = "HKCR:\*\shell\vscode"
        New-Item -Path $rootPath -Force
        #Set-ItemProperty -Path $rootPath -Name "(default)" -Value "Open with VSCode" -Force
        #Set-ItemProperty -Path $rootPath -Name "Icon" -Value "`"$vsCodePath`",0" -Force
            # Value: "C:\Program Files\Microsoft VS Code\Code.exe",0

        New-Item -Path "$rootPath\command" -Force
        #Set-ItemProperty -Path "$rootPath\command" -Name "(Default)" -Value "`"$vsCodePath`" `"%1`"" -Force
            # Value: "C:\Program Files\Microsoft VS Code\Code.exe" "%1"

        # Open folders with VS Code
        $directoryPath = "HKCR:\Directory\shell\vscode"
        New-Item -Path $directoryPath -Force
        Set-ItemProperty -Path $directoryPath -Name "(default)" -Value "Open with VSCode" -Force
        Set-ItemProperty -Path $directoryPath -Name "Icon" -Value "`"$vsCodePath`",0" -Force

        New-Item -Path "$directoryPath\command" -Force
        Set-ItemProperty -Path "$directoryPath\command" -Name "(default)" -Value "`"$vsCodePath`" `"%1`"" -Force

        # Open current Directory
        $backgroundPath = "HKCR:\Directory\Background\shell\vscode"
        New-Item -Path $backgroundPath -Force
        Set-ItemProperty -Path $backgroundPath -Name "(default)" -Value "Open with VSCode"
        Set-ItemProperty -Path $backgroundPath -Name "Icon" -Value "`"$vsCodePath`",0"

        New-Item -Path "$backgroundPath\command" -Force
        Set-ItemProperty -Path "$backgroundPath\command" -Name "(default)" -Value "`"$vsCodePath`" `"%V`""
    }
    Write-Output "Open with VSCode context menu option added successfully."
}
