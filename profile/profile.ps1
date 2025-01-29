# v4.0.6

###########
# Modules #
###########

Import-Module posh-git
Import-Module Terminal-Icons
# Check if we're running inside VS Code with the PowerShell extension
if ($null -eq $psEditor) {
    # We're not running inside VS Code, import PSReadLine
    Import-Module PSReadLine
}
#Import-Module PSReadline -MinimumVersion 2.2.2
#Import-Module ugit
if ($PSVersionTable.PSVersion -lt [version]'7.2') {
    # This module creates the $PSStyle variable for versions of PowerShell that don't have it built-in
    Import-Module psstyle
}

############
# PSDRIVES #
############

# Repos:
New-Variable -Name Repos -Value "$($env:OneDrive)\Repos" -Scope Global -Force
$null = New-PSDrive -Name Repos -PSProvider FileSystem -Root $Repos -ErrorAction SilentlyContinue

# BD:
New-Variable -Name BD -Value 'C:\BD' -Scope Global -Force
$null = New-PSDrive -Name BD -PSProvider FileSystem -Root $BD -ErrorAction SilentlyContinue

# TRO:
New-Variable -Name TRO -Value 'C:\tro' -Scope Global -Force
$null = New-PSDrive -Name TRO -PSProvider FileSystem -Root $tro -ErrorAction SilentlyContinue

###########
# ALIASES #
###########

# sudo alias
Set-Alias -Name sudo -Value gsudo

# rdp alias
Set-Alias -Name rdp -Value Enter-PSSession

# notepadd++
Set-Alias -Name n+ -Value "C:\Program Files\Notepad++\notepad++.exe"

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
    Import-Module Az.Tools.Predictor
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
    Get-Command -Name $name | Select-Object -ExpandProperty Definition
}

Function Get-Weather {
    param (
        [switch]$Detailed,
        [switch]$Moon,
        [switch]$CurrentLocation
    )

    $switch = $false

    switch ($PSBoundParameters.Keys) {
        'Detailed' {
            # Cape Elizabeth (3-day)
            Invoke-RestMethod https://wttr.in/cape+elizabeth
            $switch = $true
        }
        'Moon' {
            # Moon Phase
            Invoke-RestMethod https://wttr.in/moon
            $switch = $true
        }
        'CurrentLocation' {
            # Current Location
            Invoke-RestMethod https://wttr.in
            $switch = $true
        }
    }
    # If switch wasn't used, default to Cape Elizabeth (today only)
    if (!$switch) {
        # Cape Elizabeth (today only)
        Invoke-RestMethod https://wttr.in/cape+elizabeth?0
    }
}

########
# TIPS #
########

$Tips = "
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
"

############
# LEARNING #
############

# Learn something today (show a random cmdlet help and "about" article
#If  ($IsWindows -eq $true) {
#Get-Command -Module Microsoft*, Cim*, PS*, ISE | Get-Random | Get-Help -ShowWindow
#Get-Random -input (Get-Help about*) | Get-Help -ShowWindow
#}

# Koans
#Write-Host "`nMeasure-Karma?" -ForegroundColor Yellow


##########
# QUOTES #
##########

$Quotes = @(
    # Drums / Music
    "I'm gonna push and pull like crazy... but don't follow me mother fucker! - Joe Sample"
    "Life is a paradiddle... put 1 stick in front of the other & find the zone! - Ross R. Mason"
    "An Average band with a great drummer sounds great. A great band with an average drummer sounds average. - Buddy Rich"
    "Practice should be focused and deliberate."
    "Every man must walk to the beat of his own drummer. - Henry David Thoreau"
    "Music is the silence between the notes - Claude Debussy"

    # General
    "wu wei: the principal of not forcing in anything we do. - go with the flow."
    "Same shit different shovel."
    "Don't practice until you get it right. Practice until you can't get it wrong."
    "There is nothing permanent except change. - Heraclitus"
    "If you cannot do great things, do small things in a great way. - Napoleon Hill"
    "Plans are worthless, but planning is everything. - Dwight Eisenhower"
    "There is no knowledge without experience. - Albert Einstein"
    "If you are going to eat shit, don't nibble."
    "Things change. Always. - Abraham Lincoln"
    "Strive to be a perpetual student."
    "You can't go back and change the beginning but you can start where you are and change the ending. - C.S. Lewis"
    "Many go fishing all of their lives, without knowing it is not fish they are after. - Henry David Thoreau"
    "Wherever you are, that's where you should be."
    "If you can change your mind, you can change your life. - William James"
    "The greatest weapon against stress is our ability to choose one thought over another. - William James"
    "The definition of genius is taking the complex and making it simple. - Albert Einstein"
    "The only way of discovering the limits of the possible is to venture a little way past them into the impossible. - Arthur C. Clarke"
    "It is not necessary to change. Survival is not mandatory. - W. Edwards Deming"
    "Meet tomorrow's deadline, complete all the necessary work before tonight's play."
    "The illiterate of the 21st centrury will not be those who cannot read and write, but those who cannot learn, unlearn, and relearn. - Alvin Toffler"
    "Live as if you were to die tomorrow. Learn as if you were to live forever. - Mahatma Gandhi"
    "Learn from the mistakes of others. You can't live long enough to make them all yourself. - Anonymous"
    "Nothing great was ever achieved without enthusiasm. - Ralph Waldo Emerson"
    "A lot of problems happen because of your internal state. When you're calm, happy, and fulfilled you don't pick fights, create drama, or keep score."
    "The problem with familiarity is not so much that it breeds contempt, but that it breeds loss of perspective."
    "Jack of all trades, master in none, but oftentimes better than a master of one."
    "Sometimes being pushed to the wall gives you the momentum necessary to get over it! - Peter de Jager"
    "It's not where you take things from; it's where you take them to. - Jean-Luc Godard"
    "To be prepared against surprise is to be trained. To be prepared for surprise is to be educated."
    "While you can't see it or touch it, the most valuable thing you have is your attention."
    "You don't need more time. You need more focus."
    "The days are long but the decades are short."
    "The first and greatest step to wisdom is silent observation."
    "A big problem is just a bunch of small problems combined. Learn to separate them out."
    "A man who dares to waste an hour of time has not discovered the value of his life. - Charles Darwin"
    "Writing that lacks simplicity reveals thinking that lacks understanding."
    "It is better to be roughly right than precisely wrong - John Maynard Keynes"
    "You're effecient when you do something with minimum waste. And you're effective when you're doing the right something."
    "If you want to learn a thing, read that; If you want to know a thing, write that; if you want to master a thing teach that."
    "Simple can be harder than complex: You have to work hard to get your thinking clean to make it simple. But it's worth it in the end because once you get there, you can move mountains. - Steve Jobs"
    "Do or do not. There is no try. - Yoda"
    "When you focus on the past, that's your ego. When I focus on the future, that's my pride. I try to focus on the present. That's humility."
    "Life is made up of days that mean nothing and moments that mean everything. - Milan Kundera"
    "Seek truth, not opinions that confirm your world view."
    "Spend the best hours of your day on the biggest opportunity, not the biggest problem."
    "amor fati (a love of fate) - Nietzsche"
    "To hell with all my worries, they are negligible at best. I leave for Maine tomorrow where my soul can take a rest. - George H. Lewis"
    "Control your perceptions. Direct your actions. Willingly accept what's outside your control."
    "You only need to know the direction, not the destination. The direction is enough to make the next choice. - James Clear"
    "Short-term results come from intensity but long-term results come from consistency"
    "Patience is not passive, on the contrary, it is concentrated strength (in other words, be active in the moment but patient with the results). - Bruce Lee"
    "Realize deeply that the present moment is all you ever have. Make the NOW the primary focus of your life. NOW is all there ever is; there is no past or future except as memory or anticipation in your mind. - Eckhart Tolle"
    "Today, Not tomorrow!"
    "Learn from the past but don't hang on to it. Yesterday is irrelevant."
    "The simplest way to achieve simplicity is through thoughtful reduction. When in doubt, just remove. But be careful of what you remove... When it is possible to reduce a system's functionality without significant penalty, true simplification is realized."
    "Trust is earned in drops and lost in buckets."
    "You're efficient when you do something with minimum waste. And you're effective when you're doing the right something."
    "The obstacle on the path becomes the way. - Marcus Aurelius"
    "Realize deeply that the present moment is all you ever have. Make the NOW the primary focus of your life. NOW is all there ever is; there is no past or future except as memory or anticipation in your mind. - Eckhart Tolle"
    "Hey dummy, future you wishes you'd sleep more, drink less, excercise and eat healthier!!!"
    "Where attention goes, energy flows - T. Harv Eker"
    "Most of what we say and do is not essential. If you can eliminate it, you'll have more time, and more tranquility. Ask yourself at every moment, 'Is this necessary?' - Marcus Aurelius"
    "Experience is the hardest kind of teacher. It gives you the test first and the lesson afterward! - Oscar Wilde"
    "Let come what may."
    "Clear writing gives poor thinking nowhere to hide, making a lack of understanding visible."
    "Nobody can go back and start a new beginning, but anyone can start today and make a new ending. - Maria Robinson"
    "Simple is not easy"
    "Short-term results come from intensity but long-term results come from consistency"
    "If you are depressed you are living in the past. If you are anxious, you are living in the future. If you are at peace you are living in the present. - Lao Tzu"
    "Cynicism masquerades as wisdom, but it is the furthest thing from it. - Stephen Colbert"
    "Kaizen [ki-zen]: A Japanese term meaning change for the better or continuous improvement"
    "Stick to the basics: Do your job. Sweat the details. Put the team first. Be attentive. Ignore the noise. Speak for yourself."
    "Secret to success: Know what to ignore."
    "The obstacle on the path becomes the way. - Marcus Aurelius"
    "The best way to predict the future is to create it. - Abraham Lincoln"
    "The courage to start. The Discipline to finish. The confidence to figure it out. The patience to know progress is not always visible. The persistence to keep going, even on the bad days. That's the formula to winning."
    "The truly free individual is free only to the extent of his own self-mastery. While those who will not govern themselves are condemned to find masters to govern over them. - Steven Pressfield, The War of Art"
    "Consistently boring days make for extraordinary decades."
    "Finding myself by process of elimination - Jonathan Stefiuk"
    "There is no such thing as a quantum leap. There is only dogged persistence - and in the end, you make it look like a quantum leap. - James Dyson"
    "If you can't explain it simply, you don't understand it well enough. - Albert Einstein"
    "When one person teaches, two people learn - Tiago Forte"
    "Time is our most irreplaceable asset - we cannot buy more of it. We can only strive to waste as little as possible. - The Daily Stoic"
    "The real test in life is not in keeping out of the rough, but in getting out after you are in. - Zig Ziglar"
    "Motion creates momentum, and momentum reveals opportunities that standing still never could."
    "Don't go fetch the egg from the chickens ass just yet!"
    "Live like you will die tomorrow, learn like you will live forever!"
    "The successful learn vicariously; the foolish insist on firsthand pain."
    "Build for flow."

    # IT: Coding/DevOps/etc.
    "Automation applied to an efficient operation will magnify the efficiency. Automation applied to an inefficient operation will magnify the inefficiency. - Bill Gates"
    "Happy Scripting!"
    "Experiment, fail fast, and learn fast!"
    "Create an environment where you can fail quickly, and fix just as quickly."
    "Fail Fast. Learn Fast. Improve Fast."
    "Plan for failure"
    "Fail Fast, Scale Fast."
    "Simplicity is about subtracting the obvious and adding the meaningful. - John Maeda"
    "Everything is designed. Few things are designed well."
    "Those who forget to automate are doomed to repeat their work."
    "We have to stop optimizing for programmers and start optimizing for users. - Jeff Atwood"
    "Any sufficiently advanced technology is indistinguishable from magic. - Arthur C. Clarke"
    "Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live. - John Woods"
    "Any fool can write code that a computer can understand. Good programmers write code that humans can understand. - Martin Fowler"
    "Wealthy people work to learn. Poor people work for money."
    "Seek first to understand, then to be understood. - Stephen Covey"
    "Insanity is doing the same thing over and over again and expecting different results. - Albert Einstein"
    "The measure of intelligence is the ability to change. - Albert Einstein"
    "Programmers Mantra: SSoT (single source of truth) and DRY (dont repeat yourself)"
    "Burnout is caused by a lack of progress"
    "Repetition is the mother of learning, the father of action, which makes it the architect of accomplishment."
    "The best software design is simple and easy to understand."
    "Understanding that no system is without errors is critical to building resilient systems. - Heidi Waterhouse"
    "AI will not replace you. A person using AI will!"
    "To ship is to choose! - Jeffrey Snover"
)
Get-Random $Quotes | Write-Host -ForegroundColor Cyan
Write-Output "`n"
