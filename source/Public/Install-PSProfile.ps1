function Install-PSProfile {
<#
.SYNOPSIS
Sets up my PowerShell profile

.DESCRIPTION
Installs my PowerShell profile.ps1 file to the current user's profile directory. This profile is what will be applied when starting a new PowerShell session. This currently works for both 5.1 and 7.x versions of PowerShell.

.EXAMPLE
Install-PSProfile

.NOTES
Steve Lee's Profile.ps1:
	- https://gist.github.com/SteveL-MSFT/a208d2bd924691bae7ec7904cab0bd8e

    - Another good blog on using a GIST: https://xkln.net/blog/securely-synchronizing-powershell-profiles-across-multiple-computers/

.LINK
Customize your Shell: https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/creating-profiles?view=powershell-7.3

about_Profiles: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3
#>
    [cmdletbinding()]
    param()

    # Get profile.ps1 content from module/repo
    $profileContent = Get-PSProfile

    # PowerShell 7.x and 5.1 profile paths
    $Paths = @(
        $env:OneDrive + "\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" #7.x
        $env:OneDrive + "\Documents\PowerShell\Microsoft.VSCode_profile.ps1" #7.x vscode
        $env:OneDrive + "\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" #5.1
        $env:OneDrive + "\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1" #5.1 vscode
        $env:UserProfile + "\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" #7.x
        $env:UserProfile + "\Documents\PowerShell\Microsoft.VSCode_profile.ps1" #7.x vscode
        $env:UserProfile + "\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" #5.1
        $env:UserProfile + "\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1" #5.1 vscode
    )

    foreach ($profilePath in $paths) {
        # Overwrite profile directory and file
        Write-Warning "Overwriting PowerShell Profile: $profilePath"
        New-Item -Path $profilePath -ItemType File -Force | Out-Null

        # Get and set profile content
        Set-Content -Path $profilePath -Value $profileContent -Force
    }
}
