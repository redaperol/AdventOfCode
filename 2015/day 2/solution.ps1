using namespace System.Collections
$Content = Get-Content "C:\Users\antoine.perol\Documents\Repos\AdventOfCode\2015\day 2/input.txt"
$ResultPart1 = 0
$ResultPart2 = 0
for ($i = 0; $i -lt $Content.Count; $i++) {
    $line = $Content[$i]
    [int]$Length = ($Line | select-string -pattern "^(\d+)x").Matches.groups[1].value
    [int]$Width = ($Line | select-string -pattern "x(\d+)x").Matches.groups[1].value
    [int]$Height = ($Line | select-string -pattern "x(\d+)$").Matches.groups[1].value
    
    $AllSide = @(
        $Length
        $Width
        $Height
    )

    $LongestSide = ($AllSide | Measure-Object -Maximum).Maximum
    $SmallestSide = $AllSide | Where-Object {$_ -NE $LongestSide}

    if ($SmallestSide.count -eq 1) {
        $FirstPartRibbon = 4*$($SmallestSide[0])
    }
    elseif ($SmallestSide.count -eq 2) {
        $FirstPartRibbon = 2*$($SmallestSide[0]) + 2*$($SmallestSide[1])
    }
    else {
        $FirstPartRibbon = 4*$Length
    }

    $SecondPartRibbon = $Length*$Width*$Height
    $Ribbon = $FirstPartRibbon + $SecondPartRibbon
    $ResultPart2+=$Ribbon

    $AllShape = @(
        ($Side1 = $Length*$Width)
        ($Side2 = $Width*$Height)
        ($Side3 = $Height*$Length)
    )

    $SmallestShape = ($AllShape | Measure-Object -Minimum).Minimum
    $ShapeMultiply = foreach ($Shape in $AllShape) {
        $Shape*2
    }
    $RequiredPaper = $SmallestShape + ($ShapeMultiply | Measure-Object -Sum).Sum
    $ResultPart1+=$RequiredPaper
}

Write-host "Solutions part 1 : " -NoNewline; Write-Host $ResultPart1 -ForegroundColor Green
Write-host "Solutions part 2 : " -NoNewline; Write-Host $ResultPart2 -ForegroundColor Green