param($path, $dest, [switch]$whatif)
#check that the paths are valid
if(($null -ne $path) -and ($null -ne $dest) -and (Test-Path $path) -and (Test-Path $dest)){

    #open a new powershell window across the whole screen
    Start-Process powershell {.\Matrix.ps1} -WindowStyle maximized

    #in the meantime execute the backup
    if($whatif){
        .\Backup.ps1 $path $dest -whatif
    }else{
        .\Backup.ps1 $path $dest
    }
    
}else{
    Write-Host "Error: Please insert Valid Paths" -ForegroundColor Red
}