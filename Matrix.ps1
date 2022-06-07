#turn screen black with green font
$console = $host.UI.RawUI
$console.backgroundcolor = "black"
$console.foregroundcolor = "green"
$width = $console.MaxWindowSize.Width
$height = $console.MaxWindowSize.Height
for($i = 0; $i -lt $height; $i++){
    Write-Host
}
Clear-Host

function MatrixEffect {
    #assign random columns
    $chosen = $false
    $columnN = Get-Random -Minimum ($width/4) -Maximum ($width/2)
    $columnP = @()
    for($i = 0; $i -lt $columnN; $i++){
        $chosen = $true
        $ran = Get-Random -Minimum 0 -Maximum ($width-1)
        foreach ($item in $columnP){
            if($item -eq $ran -or $item -eq $rowRan){
                $chosen = $false
            }
        }
        if($chosen){
            $columnP += $ran
        }
    }

    #print effect
    for($i = 0; $i -lt $height; $i++){
            for($j = 0; $j -lt $width; $j++){
                $chosen = $true
                $rowN = 0
                foreach ($item in $columnP){
                    if($j -eq $item){
                        $uni = [char](Get-Random -Minimum 192 -Maximum 355)
                        Write-Host $uni -NoNewline
                        $chosen = $false
                    }
                }
                if($chosen){
                    Write-Host " " -NoNewline
                    $rowN++
                }
            }     
        Write-Host
    }
    Clear-Host
}

#do the effect till the user closes the application
while($true){
    MatrixEffect
}