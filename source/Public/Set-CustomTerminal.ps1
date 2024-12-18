function Set-CustomTerminal {
<#
.SYNOPSIS
Sets up my custom terminal settings

.DESCRIPTION
Central source for my powershell profile. Update here and then use the function to update the profile.ps1 file on the current device.

# I recommend to put this in your own Powershell profile, so it's loaded by default
New-Variable -Name Repos -Value 'D:/Repos' -Scope Global -Force
$null = New-PSDrive -Name AZ -PSProvider FileSystem -Root $Repos -EA 0
Set-Location -Path AZ:
Import-Module oh-my-posh
Set-PoshPrompt -Theme $PoshPromptPath
Import-Module posh-git
Import-Module Terminal-Icons
Import-Module Az.Accounts
Import-Module -Name $Repos/ADF/ADF/release-az/azSet.psm1 -Scope Global -Force

   - Customizing my terminal prompt: https://www.jondjones.com/tactics/productivity/customise-your-powershell-prompt-like-a-boss/
        - oh-my-posh, nerdfont, posh-git

.NOTES
TROUBLESHOOTING:
# Get version of oh-my-posh
oh-my-posh version

# Get install location
Get-Command oh-my-posh

https://ohmyposh.dev/docs/command
		- CustomTerminal: https://www.youtube.com/watch?v=5-aK2_WwrmM
		- vscode tutorial: https://www.youtube.com/watch?v=ZqEsWxzv8yg
		- custom terminal with scott hanselman: https://www.youtube.com/watch?v=oHhiMf_6exY
		- https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal

- Terminal themes: https://windowsterminalthemes.dev/
	- When you click "get theme", it copies the json config to your clipboard (more info here: https://towardsdatascience.com/new-windows-terminal-the-best-you-can-have-9945294707e7)


- Community prompts with oh my posh:
	- https://gist.github.com/DeadlyBrad42/ab69aedcd9741df3151b

Terminal Opacaity:
    - Open settings > open json file
    - find the defaults section under profiles and add this code:

    "defaults":
{
    // Put settings here that you want to apply to all profiles.
    "useAcrylic": true,
    "acrylicOpacity": 0.65
},

OR

    "defaults":
{
    // Put settings here that you want to apply to all profiles.
    "useAcrylic": false,
    "Opacity": 0.65
},


Items left to do:

- Set terminal as the default terminal application (this is done via the terminal settings.json)


.EXAMPLE
Set-CustomTerminal


.LINK
https://ohmyposh.dev/
https://www.nerdfonts.com/
https://github.com/devblackops/Terminal-Icons

Troubleshooting Terminal-Icons: https://gist.github.com/markwragg/6301bfcd56ce86c3de2bd7e2f09a8839

How to make the ultimate Terminal Prompt on Windows 11 [Scott Hanselman]:
 - https://www.youtube.com/watch?v=VT2L1SXFq9U
 - https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal

Windows Terminal Tips and Tricks: https://learn.microsoft.com/en-us/windows/terminal/tips-and-tricks
#>
    [cmdletbinding(SupportsShouldProcess)]
    param()


    # Install Nerd Fonts: CascaydiaCove
    $fontsUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/CascadiaCode.zip"
    $fontsZipPath = "$PWD\Fonts.zip"

    # Download the fonts zip file
    $download = Invoke-WebRequest -Uri $fontsUrl -OutFile $fontsZipPath
    $download

    # Extract the fonts from the zip file
    $fontsExtractPath = "$PWD\Fonts"
    Expand-Archive -Path $fontsZipPath -DestinationPath $fontsExtractPath -Force

    # Wait for the extraction to complete
    Start-Sleep -Seconds 2

    # Install the fonts by copying them to the Windows Fonts folder
    $shellApp = New-Object -ComObject Shell.Application
    $shellNamespace = $shellApp.Namespace(0x14) # Fonts folder
    $fontFiles = Get-ChildItem -Path $fontsExtractPath -Include '*.ttf','*.ttc','*.otf' -Recurse

    foreach ($fontFile in $fontFiles) {
        #$fontFullName = $fontFile.FullName
        $shellNamespace.CopyHere($fontFile.FullName, 0x10) # Copy font to the Fonts folder
    }
}



# NOTE (tyson):: This needs to be set in the settings.json file of the windows terminal:
# You need to set the "Caskaydia..." fonts as the default font in the settings.json file of the windows terminal
# Copy custom settings.json file to the windows terminal settings.json file
# Define the paths to your custom settings.json file and the default settings.json file
#$customSettingsPath = "path\to\your\custom\settings.json"
#$defaultSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    # terminal settings file path
#                       "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Make a backup of the original settings.json file
#Copy-Item -Path $defaultSettingsPath -Destination "${defaultSettingsPath}.backup"

# Replace the default settings.json file with your custom one
#Copy-Item -Path $customSettingsPath -Destination $defaultSettingsPath -Force
<#
    "defaultProfile": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "profiles":
    {
        "defaults":
        {
            "font":
            {
                "face": "CaskaydiaCove Nerd Font Mono"
            }
        },

#>








# VSCODE Settings (settings.json)
# https://ohmyposh.dev/docs/installation/fonts
#NOTE: (tyson):: For VSCODE font, do this:
#path: $env:AppData\Code\User\settings.json
# update font (in settings.json) - settings > Font > open json:
$settings = @"
    "editor.fontFamily": "CaskaydiaCove Nerd Font Mono, Consolas, 'Courier New', monospace",
    "editor.fontLigatures": true
    "editor.fontFamily": "CaskaydiaCove Nerd Font Mono",
    "editor.fontLigatures": true,
    "terminal.integrated.fontFamily": "CaskaydiaCove Nerd Font Mono",
"@
# Replace the default settings.json file with your custom one
Set-Content -Path "$env:AppData\Code\User\settings.json" -Value $settings



#integrated font family (search in settings)
#CaskaydiaCove Nerd Font Mono, Consolas, 'Courier New', monospace










<#
    # Create a custom profile for PowerShell Core
    $pwshProfile = @{
        Name = 'PowerShell Core'
        Guid = '{c6eaf9f4-32a7-5fdc-b5cf-066e8a4b1e40}'
        Icon = 'C:\Program Files\PowerShell\7\pwsh.exe'
        Hidden = $false
        AcrylicOpacity = 0.5
        UseAcrylic = $true
        BackgroundImage = 'C:\Users\Tyson\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
        BackgroundImageStretchMode = 'UniformToFill'
        BackgroundImageAlignment = 'bottomRight'
        ColorScheme = 'Solarized Dark'
        FontFace = 'Cascadia Code PL'
        FontSize = 10
        HistorySize = 9001
        Padding = '0, 0, 0, 0'
        SnapOnInput = $true
        StartingDirectory = 'C:\Users\Tyson\Documents\WindowsPowerShell'
        TabTitle = 'PowerShell Core'
    }

    # Create a custom profile for PowerShell
    $psProfile = @{
        Name = 'PowerShell'
        Guid = '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}'
        Hidden = $false
        AcrylicOpacity = 0.5
        UseAcrylic = $true
        ColorScheme = 'Solarized Dark'
        FontFace = 'Cascadia Code PL'
        FontSize = 10
        HistorySize = 9001
        Padding = '0, 0, 0, 0'
        SnapOnInput = $true
        StartingDirectory = 'C:\Users\Tyson\Documents\WindowsPowerShell'
        TabTitle = 'PowerShell'
    }

    # Create a custom profile for cmd
    $cmdProfile = @{
        Name = 'cmd'
        Guid = '{0caa0dad-35be-5f56-a8ff-afceeeaa6101}'
        Hidden = $false
        AcrylicOpacity = 0.5
    }
    #>





<#CHATGPT:

# Define the path to the settings.json file
$settingsJsonPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Read the current contents of the settings.json file
$settings = Get-Content -Raw -Path $settingsJsonPath | ConvertFrom-Json

# Update the default profile settings for each terminal
$settings.profiles.default | ForEach-Object {
    $terminalType = $_.guid

    # Customize the settings based on the terminal type
    switch ($terminalType) {
        'powershell' {
            # Customize the PowerShell prompt
            $_.fontFace = 'Nerd Font Name' # Replace with your desired Nerd Font name
            $_.colorScheme = 'OneHalfDark' # Replace with your desired color scheme
            # Add any additional customizations specific to PowerShell
        }
        'pwsh' {
            # Customize the PowerShell 7.x prompt
            $_.fontFace = 'Nerd Font Name' # Replace with your desired Nerd Font name
            $_.colorScheme = 'OneHalfDark' # Replace with your desired color scheme
            # Add any additional customizations specific to PowerShell 7.x
        }
        'cmd' {
            # Customize the Command Prompt prompt
            $_.fontFace = 'Nerd Font Name' # Replace with your desired Nerd Font name
            $_.colorScheme = 'OneHalfDark' # Replace with your desired color scheme
            # Add any additional customizations specific to Command Prompt
        }
        'Azure Cloud Shell' {
            # Customize the Azure Cloud Shell prompt
            $_.fontFace = 'Nerd Font Name' # Replace with your desired Nerd Font name
            $_.colorScheme = 'OneHalfDark' # Replace with your desired color scheme
            # Add any additional customizations specific to Azure Cloud Shell
        }
        'Visual Studio Code Integrated Terminal' {
            # Customize the VS Code Integrated Terminal prompt
            $_.fontFace = 'Nerd Font Name' # Replace with your desired Nerd Font name
            $_.colorScheme = 'OneHalfDark' # Replace with your desired color scheme
            # Add any additional customizations specific to VS Code Integrated Terminal
        }
        # Add more cases for other terminal types as needed
    }
}

# Save the updated settings.json file
$settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsJsonPath -Encoding UTF8


#>