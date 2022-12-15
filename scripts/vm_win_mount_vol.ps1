slmgr /skms sefrinf02080.fr.green.local:1688
slmgr /ato
Invoke-WebRequest -Uri "https://stocsa.blob.core.windows.net/vmaas/wsus.ps1" -OutFile "c:\wsus.ps1" 
invoke-expression -Command "c:\wsus.ps1"
Start-Sleep -Seconds 3
Remove-Item -Path "c:\wsus.ps1"

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