function Get-SystemInfo {
<#
.SYNOPSIS
Get System Information

.DESCRIPTION
Get System Information using CIM and datafornerds.io

.EXAMPLE
Get-SystemInfo
#>
    [CmdletBinding()]
    Param()

    # Get the operating system information
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $osName = $os.Caption
    $osVersion = $os.Version
    $osArchitecture = $os.OSArchitecture

    # Get the computer system information
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    $manufacturer = $computerSystem.Manufacturer
    $model = $computerSystem.Model

    # Get the processor information
    $processor = Get-CimInstance -ClassName Win32_Processor
    $processorName = $processor.Name
    $processorCores = $processor.NumberOfCores
    $processorThreads = $processor.NumberOfLogicalProcessors

    # Get the memory information
    $memory = Get-CimInstance -ClassName Win32_PhysicalMemory
    $totalMemory = ($memory | Measure-Object -Property Capacity -Sum).Sum / 1GB

    # Get the network adapter information
    $networkAdapters = Get-CimInstance -ClassName Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true }
    $networkAdapterNames = $networkAdapters.Name

    # Get the system uptime
    $uptime = (Get-Date) - $os.LastBootUpTime

    # Return the gathered system information
    $obj = [PSCustomObject]@{
        OperatingSystem = $osName
        Version = $osVersion
        Architecture = $osArchitecture
        Manufacturer = $manufacturer
        Model = $model
        Processor = $processorName
        Cores = $processorCores
        Threads = $processorThreads
        TotalMemory = $totalMemory
        NetworkAdapters = $networkAdapterNames
        Uptime = $uptime
    }
    return $obj
}
New-Alias gsi Get-SystemInfo
