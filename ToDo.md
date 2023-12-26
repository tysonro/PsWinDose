# To Do List




Look at what Sam Erde has done: <https://github.com/SamErde/PowerShell-Pre-Workout>
    - He leveraged this concept from a blog about using different profiles for core, posh, terminal and vscode: <https://powershellisfun.com/2023/11/23/using-a-specific-powershell-profile-for-a-console-session-windows-terminal-powershell-ise-or-visual-studio-code/>
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
This way, whenever I come into the office it automatically connects. (Our GPO does not allow auto connect to wifi networks). (alternatively - a batch file created on the fly and dropped in 
the startup folder that does the same thing - Not sure which would be better)
