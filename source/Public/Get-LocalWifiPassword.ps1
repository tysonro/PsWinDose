function Get-LocalWifiPassword {
<#
.SYNOPSIS
    Retrieves all saved WiFi SSIDs and their passwords on the local machine.

.DESCRIPTION
    This function enumerates all WiFi profiles saved on the local Windows machine and attempts to retrieve the cleartext password for each SSID.

.EXAMPLE
    Get-LocalWifiPassword
    Returns a list of all saved WiFi SSIDs and their passwords.

.EXAMPLE
    Get-LocalWifiPassword | Where-Object { $_.SSID -like '*Home*' }
    Filters the results to show only SSIDs containing 'Home'.

.OUTPUTS
    PSCustomObject with SSID and Password properties.
#>
    [CmdletBinding()]
    param ()

    (netsh wlan show profiles) | Select-String "All User Profile" | ForEach-Object {
        $name = ($_ -split ":")[1].Trim()
        $key = (netsh wlan show profile name="$name" key=clear | Select-String "Key Content" | ForEach-Object { ($_ -split ":")[1].Trim() })
        [PSCustomObject]@{
            SSID     = $name
            Password = ($key -join ", ")
        }
    }
}