enum color {
        red = 12
        green = 13
        blue = 14
}

function Assert-ColorValidity {
    param (
        [color]
        $color,

        [string]
        $Game
    )
    $ColorOccurrence = [regex]::Matches($Game,"\d*\s$color").Value
    foreach ($Occurrence in $ColorOccurrence) {
        [int]$Number = $Occurrence -replace '[a-z]',''
        if ($Number -gt $color.value__) {
            return $false
        }
    }
    return $true
}

function Assert-GameValidity {
    param (
        [string]
        $Game
    )

    foreach ($color in [color].GetEnumNames()) {
        $ColorValidity = Assert-ColorValidity -color $color -Game $Game
        if (!$ColorValidity) {
            return $false
        }
    }
    return $true
}

$GamesArray = Get-Content ./input.txt
$Result = 0
foreach ($Game in $GamesArray) {
    [int]$GameId=[regex]::Match($Game,'(\d*):').Value -replace ":",''
    $GameValidity = Assert-GameValidity -Game $Game
    if ($GameValidity) {
        $Result+=$GameId
    }
}
Return $Result