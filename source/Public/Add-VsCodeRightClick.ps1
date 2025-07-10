function Add-VsCodeRightClick {
    <#
    .SYNOPSIS
        Adds VS Code context menu

    .DESCRIPTION
        Adds right click context menu to open files and folders with VS Code

    .EXAMPLE
        Add-VsCodeRightClick
        Adds the context menu to open files and folders with VS Code.

    .EXAMPLE
        Add-VsCodeRightClick -Force
        Forcefully adds the context menu even if it already exists.
    #>
    [cmdletbinding()]
    param(
        $vsCodePath = "C:\Program Files\Microsoft VS Code\Code.exe",
        [switch]$Force
    )
    # Need to run as admin
    if (!(Test-Elevation)) {
        Write-Error "Session is not elevated. Please run this script as an Administrator!" -ErrorAction Stop
    }

    if (Test-Path $vsCodePath -ErrorAction Stop) {
        $rootPath = "HKCR:\*\shell\vscode"

        # Because of the way PowerShell handles wildcards (*), we need to do this to test the existence of the key (test-path doesn't work)
        $baseKey = [Microsoft.Win32.Registry]::ClassesRoot
        $key = $baseKey.OpenSubKey($rootPath -replace "HKCR:\\", "")

        if ($key -and -not $Force) {
            # Key already exists
            Write-PSFMessage -Level Important -Message "VS Code right click context menu already exists. Use -Force to overwrite."
            return
        }
        Write-PSFMessage -Level Important -Message "Adding right click context menu for VS Code..."

        try {
            # Create a registry drive for HKEY_CLASSES_ROOT
            New-PSDrive -Name "HKCR" -PSProvider Registry -Root "HKEY_CLASSES_ROOT" -ErrorAction SilentlyContinue | Out-Null

            # Open files
            Write-Verbose "Creating registry key: $rootPath"
            New-Item -Path $rootPath -Force -ErrorAction Stop | Out-Null

            Write-Verbose "Creating registry key: $rootPath\command"
            New-Item -Path "$rootPath\command" -Force -ErrorAction Stop | Out-Null

            # Open folders with VS Code
            $directoryPath = "HKCR:\Directory\shell\vscode"
            Write-Verbose "Creating registry key: $directoryPath"
            New-Item -Path $directoryPath -Force -ErrorAction Stop | Out-Null
            Set-ItemProperty -Path $directoryPath -Name "(default)" -Value "Open with VSCode" -Force
            Set-ItemProperty -Path $directoryPath -Name "Icon" -Value "`"$vsCodePath`",0" -Force

            Write-Verbose "Creating registry key: $directoryPath\command"
            New-Item -Path "$directoryPath\command" -Force -ErrorAction Stop | Out-Null
            Set-ItemProperty -Path "$directoryPath\command" -Name "(default)" -Value "`"$vsCodePath`" `"%1`"" -Force

            # Open current Directory
            $backgroundPath = "HKCR:\Directory\Background\shell\vscode"
            Write-Verbose "Creating registry key: $backgroundPath"
            New-Item -Path $backgroundPath -Force -ErrorAction Stop | Out-Null
            Set-ItemProperty -Path $backgroundPath -Name "(default)" -Value "Open with VSCode"
            Set-ItemProperty -Path $backgroundPath -Name "Icon" -Value "`"$vsCodePath`",0"

            Write-Verbose "Creating registry key: $backgroundPath\command"
            New-Item -Path "$backgroundPath\command" -Force -ErrorAction Stop | Out-Null
            Set-ItemProperty -Path "$backgroundPath\command" -Name "(default)" -Value "`"$vsCodePath`" `"%V`""
        } catch {
            Write-Error "Failed to add VS Code context menu registry keys: $($_.Exception.Message)"
        }
        Write-PSFMessage -Level Important -Message "Open with VSCode context menu option added successfully."
    }
}
