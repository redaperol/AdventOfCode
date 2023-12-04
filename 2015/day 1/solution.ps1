$Content = Get-Content ./input.txt
$ResultPart1 = 0
$HasEnteredFloor =$false
foreach ($line in $Content) {
    for ($i = 0; $i -lt $Line.Length; $i++) {
        if ($line[$i] -eq "(") {
            $ResultPart1++
        }
        elseif ($line[$i] -eq ")") {
            $ResultPart1--
        }
        Write-Host "position : $i, floor : $ResultPart1"
        if (!($HasEnteredFloor) -and ($ResultPart1 -eq -1)) {
            $ResultPart2 = $i +1
            $HasEnteredFloor = $true
        }
    }
}
Write-Host $ResultPart1
Write-Host $ResultPart2