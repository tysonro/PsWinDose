function Reset-TeamsActivity {
<#
.SYNOPSIS
Keep Microsoft Teams from going Idle

.DESCRIPTION
The Teams presence, will go from 'Available' to 'Away' after 5 minutes of inactivity. This script will keep Teams from going idle, by toggling the Teams window to the top (making it the active window), every 4.5 minutes (270 seconds).

Details:
There are several Teams processes, but only one of them will have a non-zero 'MainWindowHandle' - That is the actual window.

This script toggles the Teams window to the top (making it the active window), every 4.5 minutes (270 seconds).
Thus when Teams is the active window, the Teams presence is set to 'Available', before it can show an 'Away' presence.

.EXAMPLE
Reset-TeamsActivity

Will keep Teams status from going idle. The script will run for 30 minutes by default or until you press CTRL+C.

.EXAMPLE
Reset-TeamsActivity -Timer 10

Will keep Teams status from going idle. The script will run until for 10 minutes or until you press CTRL+C.

.NOTES
NOTE: Teams status is logged here:

$TeamsStatus = Get-Content -Path $env:APPDATA"\Microsoft\Teams\logs.txt" -Tail 1000 | Select-String -Pattern `
'Setting the taskbar overlay icon -',`
'StatusIndicatorStateService: Added' | Select-Object -Last 1
#>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        $Timer = 30 #Minutes
    )

    $startTime = Get-Date
    $timeLimit = New-TimeSpan -Minutes $Timer
    $sleepTime = 270 # 4.5 minutes

    # Minimize/Restore the Teams window every 4.5 minutes (270 seconds) until the timer is reached
    Do {
        if ($PSCmdlet.ShouldProcess("Teams", "Minimize/Restore")) {
            Write-Verbose "Minimizing/Restoring Teams window"

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
        }

        # Sleep for a bit
        Start-Sleep $sleepTime
        Write-Verbose "Time elapsed: $((Get-Date) - $startTime)"
    } While ((Get-Date) - $startTime -lt $timeLimit)
}
