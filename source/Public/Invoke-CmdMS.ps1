function Invoke-CmdMS {
    <#
    .SYNOPSIS
        Invokes commands from Merill's GitHub page based on specified parameters.

    .DESCRIPTION
        This script retrieves commands from a CSV file hosted on Merill's GitHub page and allows filtering based on alias, browser, command, or a custom filter.

    .PARAMETER Alias
        Specifies one or more aliases to filter the commands.

    .PARAMETER Browser
        Specifies the browser to use. Valid values are 'Brave', 'Chrome', 'FireFox', and 'MSEdge'.

    .PARAMETER Command
        Specifies one or more commands to filter the commands.

    .PARAMETER Filter
        Specifies a custom filter to apply when retrieving commands. Default is an empty string which retrieves all commands.

    .EXAMPLE
        Invoke-CmdMS -Alias "exampleAlias"
        Retrieves and displays commands with the specified alias.

    .EXAMPLE
        Invoke-CmdMS -Browser "Chrome"
        Retrieves and displays commands for the Chrome browser.

    .EXAMPLE
        Invoke-CmdMS -Command "exampleCommand"
        Retrieves and displays commands with the specified command.

    .EXAMPLE
        Invoke-CmdMS -Filter "exampleFilter"
        Retrieves and displays commands that match the specified filter.

    .NOTES
        Author: Harm Veenstra
        GitHub: https://github.com/HarmVeenstra/Powershellisfun/blob/main/Open%20links%20from%20the%20cmd.ms%20website/Invoke-CmdMS.ps1
        Blog: https://powershellisfun.com/2024/12/12/powershell-function-for-the-cmd-ms-website/

    .LINK
        Merrill's utility: https://cmd.ms/
        https://github.com/merill/cmd
    #>
    [CmdletBinding(DefaultParameterSetName = 'Filter')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = ('Alias'))][string[]]$Alias,
        [Parameter(Mandatory = $false)][ValidateSet('Brave', 'Chrome', 'FireFox', 'MSEdge')][string]$Browser,
        [Parameter(Mandatory = $false, ParameterSetName = ('Command'))][string[]]$Command,
        [Parameter(Mandatory = $false, ParameterSetName = ('Filter'))][string]$Filter = ''
    )

    #Retrieve commands.csv from Merill's GitHub page, use $filter if specified or '' when not specified to retrieve all URLs
    try {
        $cmds = (Invoke-RestMethod -Uri https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv -ErrorAction Stop | ConvertFrom-Csv -ErrorAction Stop) -match $filter
        Write-Host ("Retrieved URLs from https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv...") -ForegroundColor Green
    }
    catch {
        Write-Warning ("Error retrieving commands from https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv, check internet access! Exiting..." -f $shortname)
        return
    }

    #If $alias(es) or $Command(s) were specified, check if they are valid
    if ($Alias) {
        $aliases = foreach ($shortname in $Alias) {
            try {
                $aliascmds = Invoke-RestMethod -Uri https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv -ErrorAction Stop | ConvertFrom-Csv -ErrorAction Stop | Where-Object Alias -EQ $shortname
                if ($aliascmds) {
                    Write-Host ("Specified {0} alias was found..." -f $shortname) -ForegroundColor Green
                    [PSCustomObject]@{
                        Alias = $shortname
                        URL   = $aliascmds.Url
                    }
                }
                else {
                    Write-Warning ("Specified Alias {0} was not found, check https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv for the correct name(s)..." -f $shortname)
                }
            }
            catch {
                Write-Warning ("Error displaying/selecting Alias {0} from https://cmd.ms, check https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv for the correct name(s)..." -f $shortname)
            }
        }
    }

    if ($Command) {
        $Commands = foreach ($portal in $Command) {
            try {
                $commandcmds = Invoke-RestMethod -Uri https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv -ErrorAction Stop | ConvertFrom-Csv -ErrorAction Stop | Where-Object Command -EQ $portal
                if ($commandcmds) {
                    Write-Host ("Specified {0} Command was found..." -f $portal) -ForegroundColor Green
                    [PSCustomObject]@{
                        Command = $portal
                        URL     = $commandcmds.Url
                    }
                }
                else {
                    Write-Warning ("Specified Command {0} was not found, check https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv for the correct name(s)..." -f $portal)
                }
            }
            catch {
                Write-Warning ("Error displaying/selecting Command {0} from https://cmd.ms, check https://raw.githubusercontent.com/merill/cmd/refs/heads/main/website/config/commands.csv for the correct name(s)..." -f $portal)
            }
        }
    }

    #If $Alias or $Command was not specified, display all items in a GridView
    if (-not ($Alias) -and -not ($Command)) {
        #Output $cmds to Out-ConsoleGridView. If the PowerShell version is 7 or higher, install Microsoft.PowerShell.ConsoleGuiTools if needed
        if ($host.Version.Major -ge 7) {
            if (-not (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable )) {
                try {
                    Install-Module Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -ErrorAction Stop
                    Write-Host ("Installed required Module Microsoft.PowerShell.ConsoleGuiTools") -ForegroundColor Green
                }
                catch {
                    Write-Warning ("Error installing required Module Microsoft.PowerShell.ConsoleGuiTools, exiting...")
                    return
                }
            }
            $cmds = $cmds | Sort-Object Category | Out-ConsoleGridView -Title 'Select the site(s) by selecting them with the spacebar and hit Enter to continue...' -ErrorAction Stop
            if (-not ($cmds)) {
                Write-Warning ("No site(s) selected / Pressed Escape, exiting...")
                return
            }
        }
        #Output $cmds to Out-GridView if the PowerShell version is 5 or lower
        if ($host.Version.Major -le 5) {
            $cmds = $cmds | Sort-Object Category | Out-GridView -PassThru -Title 'Select the site(s) by selecting them with the spacebar while holding CTRL, hit Enter to continue...' -ErrorAction Stop
            if (-not ($cmds)) {
                Write-Warning ("No site(s) selected / Pressed Escape...")
                return
            }
        }
    }

    #Try to open the selected URLs from either $alias, $Command or $cmds
    if ($Alias) {
        foreach ($url in $aliases) {
            if ($Browser) {
                #Open in specified Browser using -Browser
                try {
                    Start-Process "$($Browser).exe" -ArgumentList $url.URL -ErrorAction Stop
                    Write-Host ("Opening selected URL {0} in {1} browser for Alias {2}..." -f $url.url, $Browser, $url.Alias) -ForegroundColor Green
                }
                catch {
                    Write-Warning ("Error opening selected URL {0} in {1} browser for Alias {2}" -f $url.url, $Browser, $url.Alias)
                }
            }
            else {
                try {
                    Start-Process $url.URL -ErrorAction Stop
                    Write-Host ("Opening selected URL {0} for Alias {1} in the default browser..." -f $url.url, $url.Alias) -ForegroundColor Green
                }
                catch {
                    Write-Warning ("Error opening selected URL {0} for Alias {1} in the default browser" -f $url.url, $url.Alias)
                }
            }
        }
    }

    if ($Command) {
        foreach ($url in $commands) {
            if ($Browser) {
                #Open in specified Browser using -Browser
                try {
                    Start-Process "$($Browser).exe" -ArgumentList $url.URL -ErrorAction Stop
                    Write-Host ("Opening selected URL {0} in {1} browser for Command {2}..." -f $url.url, $Browser, $url.command) -ForegroundColor Green
                }
                catch {
                    Write-Warning ("Error opening selected URL {0} in {1} browser for Command {2}" -f $url.url, $Browser, $url.command)
                }
            }
            else {
                try {
                    Start-Process $url.URL -ErrorAction Stop
                    Write-Host ("Opening selected URL {0} for Command {1} in the default browser..." -f $url.url, $url.command) -ForegroundColor Green
                }
                catch {
                    Write-Warning ("Error opening selected URL {0} for Command {1} in the default browser" -f $url.url, $url.command)
                }
            }
        }
    }

    if (-not ($Alias) -and -not ($Command)) {
        foreach ($cmd in $cmds) {
            #Open in Default Browser (Without using -Browser)
            if ($Browser) {
                #Open in specified Browser using -Browser
                try {
                    Start-Process "$($Browser).exe" -ArgumentList $cmd.URL -ErrorAction Stop
                    Write-Host ("Opening selected URL {0} in {1} browser..." -f $cmd.url, $Browser) -ForegroundColor Green
                }
                catch {
                    Write-Warning ("Error opening selected URL {0} in {1} browser" -f $cmd.url, $Browser)
                }
            }
            else {
                try {
                    Start-Process $cmd.URL -ErrorAction Stop
                    Write-Host ("Opening selected URL {0} in the default browser..." -f $cmd.url) -ForegroundColor Green
                }
                catch {
                    Write-Warning ("Error opening selected URL {0} in the default browser" -f $cmd.url)
                }
            }
        }
    }
}
