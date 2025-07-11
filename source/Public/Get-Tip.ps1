function Get-Tip {
    <#
    .SYNOPSIS
        Get tips and shortcuts for PowerShell and VSCode.

    .DESCRIPTION
        Random tips that I find useful for PowerShell and VSCode and always forget but need to refrence from time to time.

    .EXAMPLE
        Get-Tip
    #>
    [CmdletBinding()]
    param ()

    $Tips = @"

# The function returns a string containing various tips and shortcuts for PowerShell and VSCode.
Variables:
`$PROFILE = 'C:\Users\`$(`$env:USERNAME)\Documents\WindowsPowerShell\profile.ps1'

Functions:
- Get-Weather
- Show-ObjectTree
    - Allows you to pipe an object to a TUI tree view (requires Pwsh 7 and Microsoft.PowerShell.ConsoleGuiTools module)
- `${Function:<functionName>} #dumps out function source code

InteliSense (posh 7.0 only)
- F2 brings up a list view!
- F1 brings you to get-help!

Aliases:
- web = Default browser (chrome)
- rdp = Enter-PSSession
- rex = Start-RemoteExchangeSession
- code = VSCode

Commands:
- tree /f
- n+ .\<file.txt>  ##opens file in notepad++ in current directory

VSCode:
# Command Pallate
    - Ctrl+Shift+P

# Editing
    - Ctrl+Shift+[ = Fold
    - Ctrl+Shift+] = Unfold

# Zen Mode
    - Ctrl+K Z = Toggle Zen Mode (distraction free mode)

# Multi-Line and Cursor edits:
    - Ctrl+F2 = Multi line edits where its value is duplicated (highlighted)
    - Alt+Click = Multi cursor edits (specific to where you click)
    - Ctrl + Shift + Alt + Down(Up)Arrow = Cursor Column Select Down or Up for multi line edits
    - F12 when cursor is on a function to show definition window popup

# Terminal
    - Ctrl+J = Hide/Show Terminal
    - Ctrl+` = Open new Terminal
    - F1 = Pop into Help file

# Copilot
    - Ctrl+Alt+I = Opens copilot chat window

# Explorer
    - Ctrl+B = Hide/Show Explorer

# Folding sections
    - Ctrl+K Ctrl+0 = Fold All
    - Ctrl+K Ctrl+J = Unfold All

# Split window coding panes
    - Ctrl+Alt + Left/Right Arrows = Viewing multiple tabs at once

# Add comment based help template to new Function files
    - ##

Terminal:
# Quake mode
    - win+`

# New Windows Terminal
    - wt

# Toggle between listView and inLine for intelliSense prediction
    - F2

# Capture screen (terminal)
    - F12

# Which function: (shows function parameters)
    - which <functionName>
"@
    return $Tips
}