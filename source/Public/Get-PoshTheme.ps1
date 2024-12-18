function Get-PoshTheme {
<#
.SYNOPSIS
Get oh-my-posh themes

.DESCRIPTION
Gets the oh-my-posh theme(s) from the default location: $env:POSH_THEMES_PATH.

Default behavior is to list them all out. If you specify a theme name, it will return the theme object.

Favorites:
    - night-owl
    - jv_sitecorian
    - atomic
    - rudolfs-dark
    - marcduiker
    - powerlevel10k_rainbow
    - powerlevel10k_classic
    - tonybaloney
    - thecyberden
    - jandedobbeleer

.PARAMETER Theme
Theme name to return. If not specified, all themes will be returned.

.PARAMETER Visual
If specified, will print out all the themes in a visual format for preview

.EXAMPLE
Get-PoshTheme
Lists all the themes

.EXAMPLE
Get-PoshTheme -Theme atomic
Returns object containing name and path of the theme

.EXAMPLE
Get-PoshTheme -Visual
Prints out previews of all the themes

.NOTES
Get-PoshThemes is part of the oh-my-posh-core module which is installed via .exe (Module is deprecated). See documentation:

https://ohmyposh.dev/docs/installation/windows

#>
    [CmdletBinding()]
    param(
        [string]$Theme,
        [switch]$Visual
    )

    if ($Theme) {
        $Themes = Get-ChildItem -Path $env:POSH_THEMES_PATH -Filter "$Theme.omp.json" | ForEach-Object {
            $Name = ($_.BaseName).split('.')[0]
            [PSCustomObject]@{
                Theme = $Name
                Path  = $_.FullName
            }
        }

        return $Themes
    }
    elseif ($Visual) {
        # Print out the themes for a preview
        Get-PoshThemes
    }
    else {
        Get-PoshThemes -List
    }
}
