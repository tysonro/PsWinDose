function Invoke-TeamsActivity {
<#
.SYNOPSIS
Keep Microsoft Teams from going Idle

.DESCRIPTION
The Teams presence (status), will go from 'Available' to 'Away' after 5 minutes of inactivity. This script will keep Teams from going idle, by toggling the Teams window to the top (making it the active window), every 4.5 minutes (270 seconds) and sending a key stroke.

Details:
There are several Teams processes, but only one of them will have a non-zero 'MainWindowHandle' - That is the actual window.

This script toggles the Teams window to the top (making it the active window), every 4.5 minutes (270 seconds). It then sends a key stroke.
Thus when Teams is the active window and a key stroke is sent, the Teams presence persists as 'Available', before it can show an 'Away' presence.

.EXAMPLE
Invoke-TeamsActivity

Will keep Teams status from going idle. The script will run for 30 minutes by default or until you press CTRL+C.

.EXAMPLE
Invoke-TeamsActivity -Timer 10

Will keep Teams status from going idle. The script will run until for 10 minutes or until you press CTRL+C.

.NOTES
NOTE: Teams status is logged here:

$TeamsStatus = Get-Content -Path $env:APPDATA"\Microsoft\Teams\logs.txt" -Tail 1000 | Select-String -Pattern `
'Setting the taskbar overlay icon -',`
'StatusIndicatorStateService: Added' | Select-Object -Last 1
#>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Alias("t")]
        $Timer = 30 #Minutes
    )

    $startTime = Get-Date
    $timeLimit = New-TimeSpan -Minutes $Timer
    $sleepTime = 270 #Seconds (4.5 minutes)
    Write-Host "Start time: $($startTime.toString("hh:mm:ss tt"))"

    # Load the necessary type to simulate a key press
    Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;

        public class Keyboard {
            [DllImport("user32.dll", CharSet = CharSet.Auto, ExactSpelling = true)]
            public static extern IntPtr SetFocus(HandleRef hWnd);

            [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
            public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);
        }
"@
    # Minimize/Restore the Teams window every 4.5 minutes (270 seconds) until the timer is reached
    Do {
        if ($PSCmdlet.ShouldProcess("Teams", "Restore and simulate key press")) {
            Write-Verbose "Restoring Teams window and simulating key press"

            Get-Process | Where-Object {
                $_.Product -match "Teams" -and $_.MainWindowHandle -ne 0
            } | ForEach-Object {
                Set-WindowStyle -Style MINIMIZE -MainWindowHandle $_.MainWindowHandle
            }

            Start-Sleep 2

            Get-Process | Where-Object {
                $_.Product -match "Teams" -and $_.MainWindowHandle -ne 0
            } | ForEach-Object {
                Set-WindowStyle -Style RESTORE -MainWindowHandle $_.MainWindowHandle
            }

            Write-Verbose "Simulating key press"

            # Get the Teams process
            $teamsProcess = Get-Process | Where-Object {
                $_.Product -match "Teams" -and $_.MainWindowHandle -ne 0
            }

            # Set focus to the Teams window
            [Keyboard]::SetFocus((New-Object System.Runtime.InteropServices.HandleRef($null, $teamsProcess.MainWindowHandle))) | Out-Null

            # Simulate a key press (e.g., VK_F15)
            [Keyboard]::keybd_event(0x7F, 0, 0, 0) # Key down
            [Keyboard]::keybd_event(0x7F, 0, 2, 0) # Key up
        }

        # Sleep for a bit
        Start-Sleep $sleepTime
        Write-Host "Time elapsed: $((Get-Date) - $startTime)"
    } While ((Get-Date) - $startTime -lt $timeLimit)
}

# set alias
Set-Alias -Name ita -Value Invoke-TeamsActivity
