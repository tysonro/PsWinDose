Function Get-Weather {
    <#
    .SYNOPSIS
    Retrieves weather information from wttr.in.

    .DESCRIPTION
    This function retrieves weather information from wttr.in for Portland by default. It can also provide detailed weather information, moon phase, or weather for the current location based on the parameters provided.

    .PARAMETER Detailed
    Switch to retrieve detailed weather information for Portland (3-day forecast).

    .PARAMETER Moon
    Switch to retrieve the current moon phase information.

    .PARAMETER CurrentLocation
    Switch to retrieve weather information for the current location.

    .EXAMPLE
    PS C:\> Get-Weather -Detailed
    Retrieves a 3-day weather forecast for Portland.

    .EXAMPLE
    PS C:\> Get-Weather -Moon
    Retrieves the current moon phase information.

    .EXAMPLE
    PS C:\> Get-Weather -CurrentLocation
    Retrieves weather information for the current location.

    .LINK
    https://github.com/chubin/wttr.in
    #>
    [CmdletBinding()]
    param (
        [switch]$Detailed,
        [switch]$Moon,
        [switch]$CurrentLocation
    )

    $switch = $false

    switch ($PSBoundParameters.Keys) {
        'Detailed' {
            # Portland (3-day)
            Invoke-RestMethod 'https://wttr.in/portland-maine?u'
            $switch = $true
        }
        'Moon' {
            # Moon Phase
            Invoke-RestMethod https://wttr.in/moon
            $switch = $true
        }
        'CurrentLocation' {
            # Current Location
            Invoke-RestMethod https://wttr.in?u
            $switch = $true
        }
    }
    # If switch wasn't used, default to Portland (current conditions)
    if (!$switch) {
        # Portland (current conditions)
        Invoke-RestMethod 'https://wttr.in/portland-maine?0u'
    }
}
