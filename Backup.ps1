param($path, $dest, [switch]$whatif)

#check that the paths are valid
if(($null -ne $path) -and ($null -ne $dest) -and (Test-Path $path) -and (Test-Path $dest)){
    $ErrorActionPreference = "Stop"
    try{
        #create log file if not already done
        $logFile = $dest + "\..\logFile.log"
        if(!(Test-Path $logFile)){
            New-Item $logFile
        }
        #grab content from log file
        $logCont = @(Get-Content $logFile)
        
        $date = ""
        #check if log file is empty (first time)
        if($null -eq $logCont[0]){
            #transform var in array
            $logCont = @("temporary")

            #assign current date and time
            $date = (Get-Date).toString("dd/MM/yyyy HH:mm:ss")
            $logCont[0] = $date
        }else{
            #grab previous backup date
            $date = $logCont[0].Substring(0,19)
        }

        #create temp dir to make sure $destFiles isn't empty
        if(!$whatif){
            New-Item -Path $dest -Name "temp" -ItemType Directory | out-null
        }

        #save all paths in an array
        $pathFiles = @(Get-ChildItem -Path $path -Recurse)
        $destFiles = @(Get-ChildItem -Path $dest -Recurse)
        
        #save fullName of parameter paths
        $pathPath = ($pathFiles[0].Parent).FullName
        $destPath = ($destFiles[0].Parent).FullName

        #add a member that returns the (fullName - fullName of parameter)
        $pathFiles | Add-Member -type ScriptProperty -name FullNameCut -value {($this.FullName).replace($pathPath, "")}
        $destFiles | Add-Member -type ScriptProperty -name FullNameCut -value {($this.FullName).replace($destPath, "")}

        #items that were deleted and remained in destination
        $del = Compare-Object $destFiles $pathFiles -Property FullNameCut | Where-Object { $_.SideIndicator -eq '<=' } | Foreach-Object { $_ }

        #delete extra files/folders
        foreach($item in $del){
            $header = (get-date).toString("dd/MM/yyyy HH:mm:ss") + " | "
            $temp = $destPath + $item.FullNameCut
            $wi = ""
            if($whatif){
                $wi = "WhatIf: "
            }else{
                Remove-Item $temp
            }
            if($item.FullNameCut -ne "\temp"){
                $logCont += $header + $wi + $temp + " has been deleted"
            }
        }

        #items that aren't in destination
        $yet = Compare-Object $destFiles $pathFiles -Property FullNameCut | Where-Object { $_.SideIndicator -eq '=>' } | Foreach-Object { $_ }

        #copy missing files/folders
        foreach($item in $yet){
            $header = (get-date).toString("dd/MM/yyyy HH:mm:ss") + " | "
            $tempPath = $pathPath + $item.FullNameCut
            $tempDest = $destPath + $item.FullNameCut
            $wi = ""
            if($whatif){
                $wi = "WhatIf: "
            }else{
                Copy-Item $tempPath $tempDest
            }
            $logCont += $header + $wi + $tempPath + " Copied to " + $tempDest
        }

        #only backup files that have been modified since the last backup
        $executionDate = [datetime]::parseexact($date, 'dd/MM/yyyy HH:mm:ss', $null)
        $wi = ""
        if($whatif){
            $wi = "WhatIf: "
        }
        Get-ChildItem -Path $path | Where-Object{$_.LastWriteTime -gt $executionDate} | ForEach-Object{$header = (get-date).toString("dd/MM/yyyy HH:mm:ss") + " | "; $logCont += $header + $wi + $_.FullName + " has been updated"}
        if(!$whatif){
            Get-ChildItem -Path $path | Where-Object{$_.LastWriteTime -gt $executionDate} | Copy-Item -Destination $dest -Recurse -Force
        }
        
        #update log file
        $currentDate = (Get-Date).toString("dd/MM/yyyy HH:mm:ss")
        $logCont[0] = $currentDate + " | Backup Executed"
        Set-Content logFile.log $logCont

    #if you don't have permission catch exception
    }catch [System.UnauthorizedAccessException]{
        Write-Host "Error: You don't have Permissions" -ForegroundColor Red
    }
}else{
    Write-Host "Error: Please insert Valid Paths" -ForegroundColor Red
}