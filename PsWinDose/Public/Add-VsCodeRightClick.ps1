function Add-VsCodeRightClick {
<#
.SYNOPSIS
Adds right click context menu to open files and folders with VS Code
.DESCRIPTION
Adds right click context menu to open files and folders with VS Code
.EXAMPLE
Add-VsCodeRightClick
#>
    [cmdletbinding()]
    param(
        $vsCodePath = "C:\Program Files\Microsoft VS Code\Code.exe"
    )


<#
ORGINAL CMD File:



Windows Registry Editor Version 5.00

; Open files
[HKEY_CLASSES_ROOT\*\shell\Open with VS Code]
@="Edit with VSCode"
"Icon"="C:\\Program Files\\Microsoft VS Code\\Code.exe,0"

[HKEY_CLASSES_ROOT\*\shell\Open with VS Code\command]
@="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%1\""

; Open Folders
[HKEY_CLASSES_ROOT\Directory\shell\vscode]
@="Open with VSCode"
"Icon"="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\",0"

[HKEY_CLASSES_ROOT\Directory\shell\vscode\command]
@="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%1\""

; Open current Directory
[HKEY_CLASSES_ROOT\Directory\Background\shell\vscode]
@="Open with VSCode"
"Icon"="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\",0"

[HKEY_CLASSES_ROOT\Directory\Background\shell\vscode\command]
@="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%V\""


#>

# trying to convert it into powershell but getting stuck on the HKCR:\*



    if (Test-Path $vsCodePath -ErrorAction Stop) {
        Write-Host "Adding right click context menu for VS Code...  UNDER DEVELOPMENT" -fore red

        New-PSDrive -Name "HKCR" -PSProvider Registry -Root "HKEY_CLASSES_ROOT" -ErrorAction SilentlyContinue | Out-Null

        # Open files
        #$openWithVSCodeKey = "HKCR:\*\shell\Open with VS Code"
        #$openWithVSCodeCommandKey = "$openWithVSCodeKey\command"
        #if (!(Test-Path $openWithVSCodeKey) -or (Get-ItemPropertyValue $openWithVSCodeKey -Name "(default)") -ne "Edit with VSCode" -or (Get-ItemPropertyValue $openWithVSCodeKey -Name "Icon") -ne "$vsCodePath,0") {
        #    New-Item -Path $openWithVSCodeKey -Force | Out-Null
        #    Set-ItemProperty -Path $openWithVSCodeKey -Name "(default)" -Value "Edit with VSCode"
        #    Set-ItemProperty -Path $openWithVSCodeKey -Name "Icon" -Value "$vsCodePath,0"
        #}

        #if (!(Test-Path $openWithVSCodeCommandKey) -or (Get-ItemPropertyValue $openWithVSCodeCommandKey -Name "(default)") -ne "`"$vsCodePath`" `"%1`"") {
        #    New-Item -Path $openWithVSCodeCommandKey -Force | Out-Null
        #    Set-ItemProperty -Path $openWithVSCodeCommandKey -Name "(default)" -Value "`"$vsCodePath`" `"%1`""
        #}

        ## Open Folders
        #$openFolderKey = "HKCR:\Directory\shell\vscode"
        #$openFolderCommandKey = "$openFolderKey\command"
        #if (!(Test-Path $openFolderKey) -or (Get-ItemPropertyValue $openFolderKey -Name "(default)") -ne "Open with VSCode" -or (Get-ItemPropertyValue $openFolderKey -Name "Icon") -ne "`"$vsCodePath`",0") {
        #    New-Item -Path $openFolderKey -Force | Out-Null
        #    Set-ItemProperty -Path $openFolderKey -Name "(default)" -Value "Open with VSCode"
        #    Set-ItemProperty -Path $openFolderKey -Name "Icon" -Value "`"$vsCodePath`",0"
        #}
        #
        #if (!(Test-Path $openFolderCommandKey) -or (Get-ItemPropertyValue $openFolderCommandKey -Name "(default)") -ne "`"$vsCodePath`" `"%1`"") {
        #    New-Item -Path $openFolderCommandKey -Force | Out-Null
        #    Set-ItemProperty -Path $openFolderCommandKey -Name "(default)" -Value "`"$vsCodePath`" `"%1`""
        #}
        #
        ## Open current Directory
        #$openCurrentDirectoryKey = "HKCR:\Directory\Background\shell\vscode"
        #$openCurrentDirectoryCommandKey = "$openCurrentDirectoryKey\command"
        #if (!(Test-Path $openCurrentDirectoryKey) -or (Get-ItemPropertyValue $openCurrentDirectoryKey -Name "(default)") -ne "Open with VSCode" -or (Get-ItemPropertyValue $openCurrentDirectoryKey -Name "Icon") -ne "`"$vsCodePath`",0") {
        #    New-Item -Path $openCurrentDirectoryKey -Force | Out-Null
        #    Set-ItemProperty -Path $openCurrentDirectoryKey -Name "(default)" -Value "Open with VSCode"
        #    Set-ItemProperty -Path $openCurrentDirectoryKey -Name "Icon" -Value "`"$vsCodePath`",0"
        #}
        #
        #if (!(Test-Path $openCurrentDirectoryCommandKey) -or (Get-ItemPropertyValue $openCurrentDirectoryCommandKey -Name "(default)") -ne "`"$vsCodePath`" `"%V`"") {
        #    New-Item -Path $openCurrentDirectoryCommandKey -Force | Out-Null
        #    Set-ItemProperty -Path $openCurrentDirectoryCommandKey -Name "(default)" -Value "`"$vsCodePath`" `"%V`""
        #}
    }
}
