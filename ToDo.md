# To Do List

Draw inspiration from: https://github.com/SamErde/PSPreworkout


SPECTRE CONSOLE (TUI)
pwshspectreconsole module to add a TUI
Specifically, using it to add TUI functionality on the cheat codes! 
I bet I can create somethign that will scale easily, and make it easier to get to and digest the cheats.



AUTOMATE VSCODE SETTINGS... profiles, settings.json, etc.
VSCODE SETTINGS (customize title bar when hovering over taskbar icon)
Settings: ctrl ,
type: 'window.title'
Custom value: ${separator}${activeRepositoryName}${separator}${activeEditorShort}${separator}${activeRepositoryBranchName}
OR
Add this to settings.json:
"window.title": "${separator}${activeRepositoryName}${separator}${activeEditorShort}${separator}${activeRepositoryBranchName}"


- Add a build/version badge to the readme


PSReadLine Sample Profile.ps1: ..\Documents\WindowsPowerShell\Modules\PSReadLine\2.2.2\SamplePsReadlineProfile.ps1
    - Note: Expand Alias inline (# This example will replace any aliases on the command line with the resolved commands.)




Installing module idea... can I set it up like this:

`iex (irm https://raw.githubusercontent.com/rmbolger/Posh-ACME/main/instdev.ps1)`

Simply run that and it will run a bootstrap script, download the module, run install-pswindose.ps1, etc.


  -- Improve the Invoke-TeamsActivity module.
    - Better host output with time elapse.



- Take a look at this project and draw inspiration!!:: https://github.com/SamErde/PSPreworkout


Look at what Sam Erde has done: <https://github.com/SamErde/PowerShell-Pre-Workout>
    - He leveraged this concept from a blog about using different profiles for core, posh, terminal and vscode: <https://powershellisfun.com/2023/11/23/using-a-specific-powershell-profile-for-a-console-session-windows-terminal-powershell-ise-or-visual-studio-code/>
    - The idea is to dot source the specific profile you want based on logic in your main profile. Say based on environment... Makes for a more tailored shell experience
    - Also has his own install oh-my-posh




1. Improve CI/CD with psframework something other than psake  
   
2. There should be an artifact created for each build that can be downloaded as a .zip. This makes it easier on a baremetal machine to install the module - no need to clone the repo and build it which in itself requires several dependencies. Just download the .zip, extract and run Install-PsWinDose.ps1.

The artifact should be published to a location that can be downloaded from a script. This will allow for a 3 liner to install the module.

Plan: Use this 3 liner to download and execute the gist script (Install-PsWinDose.ps1). This will then download the published artifact (successfully built module) and then copy it to the 5.1 and 7.x locations.

- Need to get a CI/CD working to produce the artifact for the gist!

```powershell
# Raw Gist Url
$scriptUrl = "https://gist.github.com/tysonro/8e68cbc46917739c85ffa9c54dacd240/raw/Install-PsWinDose.ps1"

# Download the script from the Gist
$scriptContent = Invoke-WebRequest -Uri $scriptUrl | Select-Object -ExpandProperty Content

# Run Install-PsWinDose.ps1 to install the latest version of this module
Invoke-Expression -Command $scriptContent
```

Have this code on the ReadMe.md so it is as easy is going to the github repo and copy/pasting to get going.

3. Configure the time zone automatically in case it's in pst like it happened on win11

## Ideas

- A script that creates a scheduled task and is triggered by a log on event. Checks if the specified wifi network is available (provided by parameer) and if it is, it will attempt to connect.
This way, whenever I come into the office it automatically connects. (Our GPO does not allow auto connect to wifi networks). (alternatively - a batch file created on the fly and dropped in the startup folder that does the same thing - Not sure which would be better)

## Install module from github

Maybe this is a way to do it?

``` powershell
# Download the module
Invoke-WebRequest -Uri "https://github.com/thetolkienblackguy/Microsoft.Graph.Extensions/archive/main.zip" -OutFile "Microsoft.Graph.Extensions.zip"

# Extract the module
Expand-Archive -Path "Microsoft.Graph.Extensions.zip" -DestinationPath "C:\Temp"

# Move the module to the PowerShell modules folder
Move-Item -Path "C:\Temp\Microsoft.Graph.Extensions-main" -Destination "$($env:PSModulePath.Split(';')[0])\Microsoft.Graph.Extensions"

# Import the module
Import-Module Microsoft.Graph.Extensions
```
