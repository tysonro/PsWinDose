<#
.DESCRIPTION
    Master list of apps I've used and like to use on my Windows machines.
    The 'Install-Software' function uses this list to install the apps.

    'Id' is the winget package ID. You can find it by running:
        winget search <packageName>
#>
@{
    Apps = @(
        @{
            Name        = '7-Zip';
            Id          = '7zip.7zip';
            Description = '7-Zip file archiver';
            Default     = $false
        },
        @{
            Name        = 'Angry IP Scanner';
            Id          = 'AngryIPScanner.AngryIPScanner';
            Description = 'Network ip/port scanner';
            Default     = $false
        },
        @{
            Name        = 'AZCopy';
            Id          = 'Microsoft.Azure.AZCopy.10';
            Description = 'Azure copy tool';
            Default     = $false
        },
        @{
            Name        = 'Azure CLI';
            Id          = 'Microsoft.AzureCLI';
            Description = 'Azure CLI';
            Default     = $false
        },
        @{
            Name        = 'Azure Functions Core Tools';
            Id          = 'Microsoft.Azure.FunctionsCoreTools';
            Description = 'Azure Functions core tools';
            Default     = $false
        },
        @{
            Name        = 'Azure Storage Explorer';
            Id          = 'Microsoft.Azure.StorageExplorer';
            Description = 'Azure Storage Explorer';
            Default     = $false
        },
        @{
            Name        = 'BareTail';
            Id          = 'baremetalsoft.baretail';
            Description = 'BareTail: log file viewer';
            Default     = $false
        },
        @{
            Name        = 'Bicep';
            Id          = 'Microsoft.Bicep';
            Description = 'ARM Templates/Infrastructure-as-Code (IaC) for Azure';
            Default     = $false
        },
        @{
            Name        = 'Docker Desktop';
            Id          = 'Docker.DockerDesktop';
            Description = 'Docker Desktop for Windows';
            Default     = $false
        },
        @{
            Name        = 'Discord';
            Id          = 'Discord.Discord';
            Description = 'PowerShell community🌎';
            Default     = $false
        },
        @{
            Name        = 'Everything';
            Id          = 'voidtools.Everything';
            Description = 'Local search utility';
            Default     = $false
        },
        @{
            Name        = 'Fiddler';
            Id          = 'Telerik.FiddlerClassic';
            Description = 'Web traffic debugging';
            Default     = $false
        },
        @{
            Name        = 'Flux';
            Id          = 'flux.flux';
            Description = 'Flux: adjusts screen brightness based on time of day';
            Default     = $false
        },
        @{
            Name        = 'GIMP';
            Id          = 'GIMP.GIMP';
            Description = 'GNU Image Manipulation Program';
            Default     = $false
        },
        @{
            Name        = 'Git';
            Id          = 'Git.Git';
            Description = 'Git version control system';
            Default     = $false
        },
        @{
            Name        = 'Git Credential Manager';
            Id          = 'Git Credential Manager Core';
            Description = 'Git credential manager';
            Default     = $false
        },
        @{
            Name        = 'GitHub CLI';
            Id          = 'GitHub.cli';
            Description = 'GitHub command line interface';
            Default     = $false
        },
        @{
            Name        = 'GitHub Desktop';
            Id          = 'GitHub.GitHubDesktop';
            Description = 'GitHub Desktop App';
            Default     = $false
        },
        @{
            Name        = 'GitKraken';
            Id          = 'Axosoft.GitKraken';
            Description = 'Git GUI client';
            Default     = $false
        },
        @{
            Name        = 'gsudo';
            Id          = 'gerardog.gsudo';
            Description = 'SUDO: https://github.com/gerardog/gsudo';
            Default     = $false
        },
        @{
            Name        = 'Logitech G Hub';
            Id          = 'Logitech.GHUB';
            Description = 'Keyboard/mouse manager';
            Default     = $false
        },
        @{
            Name        = 'mRemoteNG';
            Id          = 'mRemoteNG.mRemoteNG';
            Description = 'Remote connections manager';
            Default     = $false
        },
        @{
            Name        = 'MySQL';
            Id          = 'Oracle.MySQL';
            Description = 'MySQL Database Server';
            Default     = $false
        },
        @{
            Name        = 'Notepad++';
            Id          = 'Notepad++.Notepad++';
            Description = 'Notepad++ editor';
            Default     = $false
        },
        @{
            Name        = 'Obsidian';
            Id          = 'Obsidian.Obsidian';
            Description = 'Personal Knowledge Managmenet (PKM)';
            Default     = $false
        },
        @{
            Name        = 'Oh My Posh';
            Id          = 'JanDeDobbeleer.OhMyPosh';
            Description = 'Prompt engine to customize the shell prompt';
            Default     = $false
        },
        @{
            Name        = 'PowerShell';
            Id          = 'Microsoft.PowerShell';
            Description = 'PowerShell Core';
            Default     = $false
        },
        @{
            Name        = 'PowerToys';
            Id          = 'Micorsoft.PowerToys';
            Description = 'Microsoft PowerToys suite';
            Default     = $false
        },
        @{
            Name        = 'PuTTY';
            Id          = 'PuTTY.PuTTY';
            Description = 'SSH and telnet client';
            Default     = $false
        },
        @{
            Name        = 'ScreenToGif';
            Id          = 'NickeManarin.ScreenToGif';
            Description = 'Creates gifs from screen recordings';
            Default     = $false
        },
        @{
            Name        = 'Spotify';
            Id          = 'Spotify.Spotify';
            Description = 'Music streaming';
            Default     = $false
        },
        @{
            Name        = 'SQL Server Management Studio';
            Id          = 'Microsoft.SQLServerManagementStudio';
            Description = 'SSMS';
            Default     = $false
        },
        @{
            Name        = 'SysInternals Suite';
            Id          = 'sysinternals';
            Description = 'Microsoft SysInternals Suite';
            Default     = $false
        },
        @{
            Name        = 'Visual Studio Code';
            Id          = 'Microsoft.VisualStudioCode';
            Description = 'VsCode IDE';
            Default     = $true
        },
        @{
            Name        = 'Visual Studio Code Insiders';
            Id          = 'Microsoft.VisualStudioCodeInsiders';
            Description = 'VsCode Insiders IDE';
            Default     = $false
        },
        @{
            Name        = 'VLC';
            Id          = 'VideoLAN.VLC';
            Description = 'Media player';
            Default     = $false
        },
        @{
            Name        = 'WinSCP';
            Id          = 'WinSCP.WinSCP';
            Description = 'SFTP and FTP client';
            Default     = $false
        },
        @{
            Name        = 'Wireshark';
            Id          = 'WiresharkFoundation.Wireshark';
            Description = 'Network protocol analyzer';
            Default     = $false
        },
        @{
            Name        = 'WizTree';
            Id          = 'AntibodySoftware.WizTree';
            Description = 'Disk space analyzer - https://www.diskanalyzer.com/';
            Default     = $false
        }
    )
}
