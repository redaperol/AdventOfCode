enum color {
    red = 12
    green = 13
    blue = 14
}

function Get-ColorMinimum {
    param (
        [color]
        $color,

        [string]
        $Game
    )
    [System.Collections.ArrayList]$IntArray = @()
    $StringArray = ([regex]::Matches($Game,"\d*\s$color").Value) -replace '[a-z]',''
    foreach ($String in $StringArray) {
        $null = $IntArray.Add([int]$String)
    }
    $Result = $IntArray | Sort-Object -Descending | Select-Object -First 1
    return $Result
}

function Get-GamePower {
    param (
        [string]
        $Game
    )
    $RedMinimum = Get-ColorMinimum -color red -game $game
    $GreenMinimum = Get-ColorMinimum -color green -game $game
    $BlueMinimum = Get-ColorMinimum -color blue -game $game
    
    $Result = $RedMinimum * $GreenMinimum * $BlueMinimum
    return $Result
}

$GamesArray = Get-Content ./input.txt
$Result = 0
foreach ($Game in $GamesArray) {
    $Result += Get-GamePower -Game $Game
}
Return $Result