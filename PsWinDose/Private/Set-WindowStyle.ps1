Function Set-WindowStyle {
<#
.SYNOPSIS
Set the window style of a process

.DESCRIPTION
Set the window style of a process (i.e. Minimize, Maximize, Restore, ext.). It requires getting the process handle and then using the Win32 ShowWindowAsync function to set the window style.

.EXAMPLE
Set-WindowStyle -Style MINIMIZE -MainWindowHandle $MainWindowHandle
#>
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
        $Style = 'SHOW',

        $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
    )

    # $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
    # Get-Process | ? { $_.Product -match "Teams" -and $_.MainWindowHandle -ne 0 }
    $WindowStates = @{
        FORCEMINIMIZE = 11
        HIDE = 0
        MAXIMIZE = 3
        MINIMIZE = 6
        RESTORE = 9
        SHOW = 5
        SHOWDEFAULT = 10
        SHOWMAXIMIZED = 3
        SHOWMINIMIZED = 2
        SHOWMINNOACTIVE = 7
        SHOWNA = 8
        SHOWNOACTIVATE = 4
        SHOWNORMAL = 1
    }

    if ($PSCmdlet.ShouldProcess("Window Style", "Set")) {
        Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $($WindowStates[$style]))

        $Win32ShowWindowAsync = Add-Type -memberDefinition @”
            [DllImport("user32.dll")]
            public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions -passThru

        $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
    }
}
