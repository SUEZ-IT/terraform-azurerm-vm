$rawdisk = Get-Disk | Where-Object PartitionStyle -eq 'raw'

if ($null -ne $rawdisk) {
    foreach ($disk in $rawdisk){
        $dl = Get-Disk $disk.Number | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize
        Format-Volume -DriveLetter $dl.DriveLetter -FileSystem NTFS -NewFileSystemLabel "Disk $dl.Driveletter" -Confirm:$false
    }
}
else {
    exit
}