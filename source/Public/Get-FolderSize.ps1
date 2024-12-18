function Get-FolderSize {
<#
.SYNOPSIS
Quickly Finds the size of a path

.DESCRIPTION
Quickly Finds the size of a folder

.Parameter Folder
Folder that is being audited for size

.Parameter ByteSize
Measurement used for displaying the folder size

.EXAMPLE
Get-Foldersize -Folder c:\users\ -ByteSize MB

Finds the size of the C:\users folder in MegaBytes

.EXAMPLE
Get-Foldersize -Folder c:\users\ -ByteSize GB

Finds the size of the C:\users folder in GigaBytes

.EXAMPLE
Get-Foldersize -Folder c:\users\ -ByteSize TB

Finds the size of the C:\users folder in MegaBytes

.Link
https://github.com/TheTaylorLee/AdminToolbox
#>
    [CmdletBinding()]
    [Alias('FolderSize')]
    Param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]$Folder, # Folder parameter specifies the folder to calculate the size for

        [Parameter(Position = 1)]
        [ValidateSet('MB', 'GB', 'TB')]
        [string]$ByteSize = 'MB', # ByteSize parameter specifies the unit to display the folder size

        [switch]$PassThru # PassThru switch parameter to output the calculated folder size as an object
    )

    $size = (Get-ChildItem $Folder -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum

    switch ($ByteSize) {
        'MB' {
            $result = $size / 1MB   # Calculate folder size in megabytes
            $unit = 'MB'
        }
        'GB' {
            $result = $size / 1GB   # Calculate folder size in gigabytes
            $unit = 'GB'
        }
        'TB' {
            $result = $size / 1TB   # Calculate folder size in terabytes
            $unit = 'TB'
        }
    }

    $output = "{0:N2} {1}" -f $result, $unit    # Format the result with the appropriate unit

    if ($PassThru) {
        $object = [PSCustomObject]@{
            Folder = $Folder
            Size = $output
        }
        Write-Output $object    # Output the custom object if -PassThru is used
    } else {
        Write-Output $output    # Output the formatted result if -PassThru is not used
    }
}
