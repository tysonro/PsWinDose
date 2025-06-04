# v5.0.0

###########
# Modules #
###########

Import-Module posh-git, terminal-icons

# Check if we're running inside VS Code with the PowerShell extension
#if ($null -eq $psEditor) {
#    # We're not running inside VS Code, import PSReadLine
#    Import-Module PSReadLine
#}
##Import-Module PSReadline -MinimumVersion 2.2.2
#if ($PSVersionTable.PSVersion -lt [version]'7.2') {
#    # This module creates the $PSStyle variable for versions of PowerShell that don't have it built-in
#    Import-Module psstyle
#}

############
# PSDRIVES #
############

# Repos:
#New-Variable -Name Repos -Value "$($env:OneDrive)\Repos" -Scope Global -Force
#$null = New-PSDrive -Name Repos -PSProvider FileSystem -Root $Repos -ErrorAction SilentlyContinue
#
## BD:
#New-Variable -Name BD -Value 'C:\BD' -Scope Global -Force
#$null = New-PSDrive -Name BD -PSProvider FileSystem -Root $BD -ErrorAction SilentlyContinue
#
## TRO:
#New-Variable -Name TRO -Value 'C:\tro' -Scope Global -Force
#$null = New-PSDrive -Name TRO -PSProvider FileSystem -Root $tro -ErrorAction SilentlyContinue
#
###########
# ALIASES #
###########

# sudo alias
Set-Alias -Name sudo -Value gsudo

# rdp alias
#Set-Alias -Name rdp -Value Enter-PSSession

# notepadd++
Set-Alias -Name n+ -Value "C:\Program Files\Notepad++\notepad++.exe"

Set-Alias -Name cicommit -Value "git commit -a --amend --no-edit && git push --force-with-lease"

#######################
# CUSTOMIZE THE SHELL #
#######################

# Setting vi Mode # https://codeandkeep.com/PowerShell-And-Vim/
#Set-PSReadlineOption -EditMode vi -BellStyle None

# Set oh-my-posh theme
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/kushal.omp.json" | Invoke-Expression

<# Setup PSReadLine
if ($host.Name -eq 'ConsoleHost' -or $host.Name -eq 'Visual Studio Code Host' ) {
    # not sure if I'll need this but just keeping it here for now
}#>

<#
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionViewStyle InLine # ListView | Inline (default) (Note: F2 toggles in real time!)
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::Yellow
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::Yellow
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
    "InlinePrediction" = '#70A99F'
}

# Version specific settings
if ($PSVersionTable.PSVersion -ge [version]'7.0') {
    # PowerShell 7.x and later configurations
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin

    # Enable Az Predictor Plugin
    #Import-Module Az.Tools.Predictor
} else {
    # PowerShell 5.1 configurations
    Set-PSReadLineOption -PredictionSource History
}

################
# KEY BINDINGS #
################

#Add?
#- CTRL+H = History to OGV
#- CTRL+D = $env:USERPROFILE\Documents\WindowsPowerShell

# Test PowerShell Module
$test = @{
    Chord = 'ctrl+t'
    BriefDescription = 'TestPowerShellModule'
    Description = 'Test the current directory/powershell module with pester'
    ScriptBlock = {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(".\build.ps1 -taskList clean,test")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
Set-PSReadLineKeyHandler @test

# Build PowerShell Module
$build = @{
    Chord = 'ctrl+b'
    BriefDescription = 'BuildPowerShellModule'
    Description = 'Build the current directory/powershell module'
    ScriptBlock = {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(".\build.ps1 -taskList clean,test,build")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
Set-PSReadLineKeyHandler @build

# Sends command history to Out-GridVeiw
$history = @{
    Chord = 'ctrl+h'
    BriefDescription = 'HistoryToOGV'
    Description = 'Sends command history to Out-GridVeiw'
    ScriptBlock = {
        Get-History | Out-GridView -Title 'Select Command' -PassThru | Invoke-History
    }
}
Set-PSReadlineKeyHandler @history

# Captures terminal screen to clipboard
Set-PSReadLineKeyHandler -Chord 'F12' -Function 'CaptureScreen'

#############
# FUNCTIONS #
#############

function which($name) {
    # find and return the definition of the specified command
    Get-Command -Name $name | Select-Object -ExpandProperty Definition
}
#>
# Get an inspirational quote (PsWinDose)
"`n"
$quotes = Import-PowerShellDataFile "C:\ProgramData\PsWinDose\inspirationalQuotes.psd1"
"🍺 " + ($quotes.quotes | Get-Random) | Write-Host -ForegroundColor Cyan
"`n"
