using namespace System.Collections.Generic
function New-DiffList {
    param (
        [List[List[int]]]
        $MainList
    )
    [List[int]]$Diff =@()
    for ($i = 0; $i -lt $MainList[-1].Count -1; $i++) {
        $Diff.Add($MainList[-1][$i+1] - $MainList[-1][$i])
    }
    $MainList.Add($Diff)
}

function Get-NewNumber {
    param (
        [List[List[int]]]
        $MainList
    )
    
    for ($z = $MainList.Count-1; $z -ge 0; $z--) {
        $MainList[$z-1].Add($MainList[$z-1][-1] + $MainList[$z][-1])
    }
}

function Get-NewNumberPrevious {
    param (
        [List[List[int]]]
        $MainList
    )
    
    for ($z = $MainList.Count-1; $z -ge 0; $z--) {
        $MainList[$z-1].Insert(0,($MainList[$z-1][0] - $MainList[$z][0]))
    }
}

$Content = Get-Content ../input/day9.txt
$ResultPart1 = 0
$ResultPart2 = 0

for ($j = 0; $j -lt $Content.Length; $j++) {
    $PercentComplete = $j*100/$Content.Length
    Write-Progress -Id 1 -Activity Processing -PercentComplete $PercentComplete -Status "Line $j"
    [List[List[int]]]$MainList =@()
    [List[int]]$Numbers = ($Content[$j] | Select-String -Pattern "-?\d+" -AllMatches).Matches.Value
    $MainList.Add($Numbers)
    $NoZero = $true
    while ($NoZero) {
        New-DiffList -MainList $MainList
        if ((($MainList[-1] | Select-Object -Unique).Count -eq 1) -and (($MainList[-1] | Select-Object -Unique) -eq 0)) {
            $NoZero = $false   
        }
    }
    Get-NewNumber -MainList $MainList
    Get-NewNumberPrevious -MainList $MainList
    $ResultPart1+=$MainList[0][-1]
    $ResultPart2+=$MainList[0][0]
}
write-host "Result part1 :" -NoNewline; Write-Host $ResultPart1 -ForegroundColor Green
write-host "Result part2 :" -NoNewline; Write-Host $ResultPart2 -ForegroundColor Green