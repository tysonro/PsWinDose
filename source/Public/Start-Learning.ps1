
function Start-Learning {
    <#
    .SYNOPSIS
        Start Learning

    .DESCRIPTION
        Start Learning

    .EXAMPLE
        Start-Learning

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', Justification = 'Not changing state with this funciton')]
    [CmdletBinding()]
    param ()

    ############
    # LEARNING #
    ############

    # Learn something today (show a random cmdlet help and "about" article
    Get-Command -Module Microsoft*, Cim*, PS*, ISE | Get-Random | Get-Help -ShowWindow

    # this one takes a while...
    #Get-Random -input (Get-Help about*) | Get-Help -ShowWindow

    # Koans
    Write-Host "`nMeasure-Karma?" -ForegroundColor Yellow

    # Get-Help -Online | Out-Default
}
