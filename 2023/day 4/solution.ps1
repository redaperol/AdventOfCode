using namespace System.Collections
class card {
    [int]$Id
    [ArrayList]$WinningNumber
    [ArrayList]$PlayerNumber
    [ArrayList]$PlayerNumberWinner
    [int]$NumberOfMatch
    [int]$Point
    [Int]$NumberOfCard

    card([string]$Line,[hashtable]$NumberOfEachCard) {
        $this.NumberOfCard       = 1
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
    [void] SpawnCard([ArrayList]$CardList) {
        if ($this.NumberOfMatch -ne 0) {
            for ($k = 1; $k -lt $this.NumberOfMatch+1; $k++) {
                $IdCardToIncrease = $this.Id + $k
                $CardToModify = $CardList | Where-Object Id -EQ $IdCardToIncrease
                $CardToModify.NumberOfCard+=1*$this.NumberOfCard
            }
        }
    }
}

[ArrayList]$CardList = @()
$Content = Get-Content ./input.txt
[Hashtable]$NumberOfEachCard = @{}
foreach ($Line in $Content) {
    $null = $CardList.Add([card]::new($line,$NumberOfEachCard))
}
$ResultPart1 = ($CardList | Measure-Object -Property Point -Sum).Sum

$CardToProcess = $CardList | Where-Object NumberOfMatch -ne 0
foreach ($Card in $CardToProcess) {
    $Card.SpawnCard($CardList)
}
$ResultPart2 = ($CardList | Measure-Object -Property NumberOfCard -Sum).Sum

($CardList.NumberOfCard | Measure-Object -Sum).Sum
Write-Host "Partie 1 = " -NoNewline; Write-Host $ResultPart1 -ForegroundColor Green
Write-Host "Partie 2 = " -NoNewline; Write-Host $ResultPart2 -ForegroundColor Green