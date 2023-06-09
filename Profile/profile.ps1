###########
# Modules #
###########

Import-Module posh-git
Import-Module Terminal-Icons
Import-Module PSReadline -MinimumVersion 2.2.2
Import-Module ugit
if ($PSVersionTable.PSVersion -lt [version]'7.2') {
    # This module creates the $PSStyle variable for versions of PowerShell that don't have it built-in
    Import-Module psstyle
}

############
# PSDRIVES #
############

# Repos:
New-Variable -Name Repos -Value 'C:\Users\1668\OneDrive - BerryDunn\Scripts' -Scope Global -Force
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

# rdp alias
Set-Alias -Name rdp -Value Enter-PSSession


#######################
# CUSTOMIZE THE SHELL #
#######################

# Setting vi Mode # https://codeandkeep.com/PowerShell-And-Vim/
#Set-PSReadlineOption -EditMode vi -BellStyle None

# Set oh-my-posh theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression

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
} else {
    # PowerShell 5.1 configurations
    Set-PSReadLineOption -PredictionSource History
}

################
# KEY BINDINGS #
################

# Build PowerShell Module
$build = @{
    Chord = 'ctrl+b'
    BriefDescription = 'BuildPowerShellModule'
    LongDescription = 'Build the current directory/powershell module'
    ScriptBlock = {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(".\build.ps1 -taskList clean,test,build,deploy")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
Set-PSReadLineKeyHandler @build

# Test PowerShell Module
$test = @{
    Chord = 'ctrl+t'
    BriefDescription = 'TestPowerShellModule'
    LongDescription = 'Test the current directory/powershell module with pester'
    ScriptBlock = {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(".\build.ps1 -taskList clean,test")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
Set-PSReadLineKeyHandler @test

# Sends command history to Out-GridVeiw
$history = @{
    Chord = 'ctrl+h'
    BriefDescription = 'HistoryToOGV'
    LongDescription = 'Sends command history to Out-GridVeiw'
    ScriptBlock = {
        Get-History | Out-GridView -Title 'Select Command' -PassThru | Invoke-History
    }
}
Set-PSReadlineKeyHandler @history


#############
# FUNCTIONS #
#############
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
`$PROFILE = 'C:\Users\1668\Documents\WindowsPowerShell\profile.ps1'

Functions:
- Get-Weather
- `${Function:<functionName>} #dumps out function source code

HotKeys:
- CTRL+H = History to OGV
- CTRL+D = $env:USERPROFILE\Documents\WindowsPowerShell
- CTRL+S = \\bdmp.com\scripts
- CTRL+T = 'anakin@berrydunn.com'

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
- start notepadd++ .\<file.txt>

VSCode:
# Command Pallate
	- Ctrl+Shift+P

# Multi-Line and Cursor edits:
	- Ctrl+F2 = Multi line edits where its value is duplicated (highlighted)
	- Alt+Click = Multi cursor edits (specific to where you click)
	- Ctrl + Shift + Alt + Down(Up)Arrow = Cursor Column Select Down or Up for multi line edits
    - F12 when cursor is on a function to show definition window popup

# Terminal
    - Ctrl+J = Hide/Show Terminal
    - Ctrl+` = Open new Terminal

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

# Toggle between listView and inLine for intelliSense prediction
    - F2
"


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
)
Get-Random $Quotes | Write-Host -ForegroundColor Cyan
Write-Output "`n"

# Koans
#Write-Host "`nMeasure-Karma?" -ForegroundColor Yellow
