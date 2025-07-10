function Install-CustomFont {
    <#
    .SYNOPSIS
        Installs custom fonts

    .DESCRIPTION
        Installs custom fonts for Windows Terminal and Visual Studio Code.

    .EXAMPLE
        Install-CustomFonts -Path '<pathToSaveFontFiles>'
    #>
    [CmdletBinding()]
    param(
        [string]$Path
    )

    # Install Nerd Fonts: CascaydiaCove
    $nfVersion = '3.4.0'
    $fontsUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v$nfVersion/CascadiaCode.zip"
    $fontsZipPath = "$Path\Fonts.zip"

#
# !!! These checks aren't working... why? How do I detect if the nerd fonts are already installed?
## Need to do a better check, currently only checking if the zip file exists (i.e. downloaded)
#

    # Check if the font is already installed
    #$fontName = "CaskaydiaCove"
    #$fontsFolder = [System.Environment]::GetFolderPath("Fonts")
    ##Get-ChildItem -Path $fontsFolder -Filter "*$fontName*"
    #$fontEnvInstalled = Test-Path "$fontsFolder\*$fontName*.ttf"
    #$fontEnvInstalled = Test-Path "$fontsFolder\$fontName Nerd Font Complete.ttf"
#
    ## Check if the font is already installed using the registry
    #$fontName = "Cascadia"
    #$fontRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    #$fonts = Get-ItemProperty -Path $fontRegistryPath
    #$fontRegInstalled = $fonts.PSObject.Properties | Where-Object { $_.Name -like "*$fontName*" }

    #if ($fontEnvInstalled -and $fontRegInstalled) {
    if ("$Path\Fonts.zip") {
        Write-PSFMessage -Level Important -Message "Fonts have already been downloaded and installed. Skipping installation." # LIAR!
    } else {
        # Download the fonts zip file
        Write-PSFMessage -Level Important -Message "Downloading and installing font: $fontName"
        Invoke-WebRequest -Uri $fontsUrl -OutFile $fontsZipPath

        # Extract the fonts from the zip file
        $fontsExtractPath = "$Path\Fonts"
        Expand-Archive -Path $fontsZipPath -DestinationPath $fontsExtractPath -Force

        # Wait for the extraction to complete
        Start-Sleep -Seconds 2

        # Install the fonts by copying them to the Windows Fonts folder
        $shellApp = New-Object -ComObject Shell.Application
        $shellNamespace = $shellApp.Namespace(0x14) # Fonts folder
        $fontFiles = Get-ChildItem -Path $fontsExtractPath -Include '*.ttf','*.ttc','*.otf' -Recurse

        foreach ($fontFile in $fontFiles) {
            # Copy font to the Fonts folder
            $shellNamespace.CopyHere($fontFile.FullName, 0x10)
        }
    }
}
