using namespace System.Collections
class card {
    [int]$Id
    [ArrayList]$WinningNumber
    [ArrayList]$PlayerNumber
    [ArrayList]$PlayerNumberWinner
    [int]$NumberOfMatch
    [int]$Point

    card([string]$Line,[hashtable]$NumberOfEachCard) {
        $this.NumberOfMatch      = 0
        $this.WinningNumber      = @()
        $this.PlayerNumber       = @()
        $this.PlayerNumberWinner = @()
        $this.Id                 = ($Line | Select-String -Pattern "Card\s+(\d+):").Matches.Groups[1].Value

        $Key = "Card$($this.Id)"
        $NumberOfEachCard.Add($Key,1)
        $Line = $Line -replace "Card\s+(\d+):",''
        
        $StringWinningNumber,$StringPlayerNumber = $Line.Split("|")
        $MatchesWinningNumber = ($StringWinningNumber | Select-String -Pattern "\s(\d+)" -AllMatches).Matches
        foreach ($item in $MatchesWinningNumber) {
            $Null = $this.WinningNumber.Add($item.Groups[1].Value)
        }

        $MatchesPlayerNumber = ($StringPlayerNumber | Select-String -Pattern "\s(\d+)" -AllMatches).Matches
        foreach ($item in $MatchesPlayerNumber) {
            $Null = $this.PlayerNumber.Add($item.Groups[1].Value)
        }

        foreach ($Number in $this.PlayerNumber) {
            if ($Number -in $this.WinningNumber) {
                $null = $this.PlayerNumberWinner.Add($Number)
                $this.NumberOfMatch++
            }
        }
        if ($this.NumberOfMatch -eq 0) {
            $this.Point = 0
        }
        else {
            $this.Point = [System.Math]::Pow(2,$This.NumberOfMatch- 1)
        }
    }
}

[ArrayList]$CardList = @()
$Content = Get-Content ./input
[Hashtable]$NumberOfEachCard = @{}
foreach ($Line in $Content) {
    $null = $CardList.Add([card]::new($line,$NumberOfEachCard))
}
$ResultPart1 = ($CardList | Measure-Object -Property Point -Sum).Sum


foreach ($Card in $CardList) {
    if ($Card.NumberOfMatch -ne 0) {
        $KeyCard = "Card$($Card.Id)"
        $NumberOfRepetition = $NumberOfEachCard.$KeyCard
        for ($i = 0; $i -lt $NumberOfRepetition; $i++) {
            for ($j = 1; $j -lt $Card.NumberOfMatch + 1; $j++) {
                $Key = "Card$($Card.Id + $j)"
                $NumberOfEachCard.$Key++
            }
        }
    }    
}

$ResultPart2 = ($NumberOfEachCard.Values | Measure-Object -Sum).Sum
Write-Host "Partie 1 = " -NoNewline; Write-Host $ResultPart1 -ForegroundColor Green
Write-Host "Partie 2 = " -NoNewline; Write-Host $ResultPart2 -ForegroundColor Green