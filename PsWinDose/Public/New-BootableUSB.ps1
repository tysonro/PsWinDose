Function New-BootableUSB {
    <#
        .Synopsis
        Creates a bootable USB drive for Windows operating systems.

        .Description
        Formats a usb drive and then creates a bootable partition with a windows image.

        .Parameter Number
        Number/id of the disk you want to format. This can be identified with: Get-Disk

        .Parameter FileSystem
        NTFS or Fat32

        .Parameter IsoPath
        Full path to .iso file

        .Example
        Get-Disk 2 | New-BootableUSB -FileSystem NTFS -IsoPath $IsoPath

        .Notes
        For a linux image, you will need to use Rufus:
        Install-Package rufus -ProviderName ChocolateyGet
    #>
        [CmdletBinding()]
        Param(
            [Parameter(ValueFromPipelineByPropertyName)]
            $Number,
            $FileSystem = 'ntfs',
            $IsoPath
        )

        # Must be running as administrator
        Test-Elevation

        # Format drive
        $Results = Clear-Disk -Number $Number -RemoveData -RemoveOEM -Confirm:$false -PassThru |
        New-Partition -UseMaximumSize -IsActive -AssignDriveLetter |
        Format-Volume -FileSystem $FileSystem

        # Get existing drive letters
        $Volumes = (Get-Volume).Where({$_.DriveLetter}).DriveLetter

        # Mount the ISO
        Mount-DiskImage -ImagePath $IsoPath

        # Compare drive letters to get the new one assigned to the ISO
        $ISO = (Compare-Object -ReferenceObject $Volumes -DifferenceObject (Get-Volume).Where({$_.DriveLetter}).DriveLetter).InputObject

        # Update BOOTMGR bootcode (make it a bootable usb drive)
        Set-Location -Path "$($ISO):\boot"
        bootsect.exe /nt60 "$($Results.DriveLetter):"

        # Copy ISO contents to USB drive
        Copy-Item -Path "$($ISO):\*" -Destination "$($Results.DriveLetter):" -Recurse -Verbose
    }
