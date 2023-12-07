using namespace System.Collections.Generic
enum Combination {
    FiveOfAKind
    FourOfAKind
    FullHouse
    Brelan
    DoublePair
    Pair
    StrongCard
}

class Hand {
    [string]$Cards
    [int]$Bid
    [int]$Rank
    [Combination]$Combination
    hidden [Int64] $CardValue
    hidden [hashtable]$HashCard

    Hand([string]$RawHand) {
        $this.Cards = ($RawHand | Select-String -Pattern "^[A-Z,0-9]+").Matches.Value
        $this.Bid = ($RawHand | Select-String -Pattern "\d+$").Matches.Value
        $this.HashCard=@{}
        for ($i = 0; $i -lt $this.Cards.Length; $i++) {
            $this.HashCard.$($this.Cards[$i])++
        }
        
        if ($this.HashCard.Values -contains 5) {
            $this.Combination = [Combination]::FiveOfAKind
        }
        elseif ($this.HashCard.Values -contains 4) {
            $this.Combination = [Combination]::FourOfAKind
        }
        elseif (($this.HashCard.Values -contains 3) -and ($this.HashCard.Values -contains 2)) {
            $this.Combination = [Combination]::FullHouse
        }
        elseif ($this.HashCard.Values -contains 3) {
            $this.Combination = [Combination]::Brelan
        }
        elseif (($this.HashCard.Values.Where({$_ -eq 2}).count -eq 2 )) {
            $this.Combination = [Combination]::DoublePair
        }
        elseif (($this.HashCard.Values -contains 2 )) {
            $this.Combination = [Combination]::Pair
        }
        else {
            $this.Combination = [Combination]::StrongCard
        }

        #multiplexer
        $CardValueMap = @{
            A   = 14
            K   = 13
            Q   = 12
            J   = 11
            T   = 10
            "9" = 9
            "8" = 8
            "7" = 7
            "6" = 6
            "5" = 5
            "4" = 4
            "3" = 3
            "2" = 2
        }
        $this.CardValue = $CardValueMap.[string]$($this.Cards[4])*1 + $CardValueMap.[string]$($this.Cards[3])*100 + $CardValueMap.[string]$($this.Cards[3])*10000 + $CardValueMap.[string]$($this.Cards[3])*1000000 + $CardValueMap.[string]$($this.Cards[2])*100000000 + $CardValueMap.[string]$($this.Cards[1])*10000000000 + $CardValueMap.[string]$($this.Cards[0])*1000000000000

    }

    Hand() {
        $this.Cards    = ""
        $this.Bid      = 0
        $this.Rank     = 0
        $this.HashCard = @{}
    }

    [int] GetRankBidProduct () {
        $Results = $this.Hand.Bid * $this.Hand.Rank
        return $Results
    }
}

class PokerGame {
    [int]$CardNumber
    [List[Hand]]$FiveOfAKind
    [List[Hand]]$FourOfAKind
    [List[Hand]]$FullHouse
    [List[Hand]]$Brelan
    [List[Hand]]$DoublePair
    [List[Hand]]$Pair
    [List[Hand]]$StrongCard

    PokerGame([string[]]$Content) {
        [System.Collections.ArrayList]$AllGames = @()
        foreach ($RawHand in $Content) {
            $Null = $AllGames.Add([Hand]::new($RawHand))
        }
        $this.FiveOfAKind = $AllGames | Where-Object Combination -EQ FiveOfAKind
        $this.FourOfAKind = $AllGames | Where-Object Combination -EQ FourOfAKind
        $this.FullHouse   = $AllGames | Where-Object Combination -EQ FullHouse
        $this.Brelan      = $AllGames | Where-Object Combination -EQ Brelan
        $this.DoublePair  = $AllGames | Where-Object Combination -EQ DoublePair
        $this.Pair        = $AllGames | Where-Object Combination -EQ Pair
        $this.StrongCard  = $AllGames | Where-Object Combination -EQ StrongCard

        $this.CardNumber = $this.FiveOfAKind.count + $this.FourOfAKind.count + $this.FullHouse.count + $this.Brelan.count + $this.DoublePair.count + $this.Pair.count + $this.StrongCard.count
    }

    hidden [int] AssignRank([string]$CollectionName,[int]$StartingInt) {
        $OrderedList = $this.$CollectionName | Sort-Object -Property CardValue
        for ($i = 0; $i -lt $OrderedList.Count; $i++) {
            $OrderedList[$i].Rank = $StartingInt
            $StartingInt++
        }
        
        
        return $StartingInt
    }

    [void] AssignAllRank() {
        $StrongCardInt  = $this.AssignRank("StrongCard",1)
        $PairInt        = $this.AssignRank("Pair",$StrongCardInt)
        $DoublePairInt  = $this.AssignRank("DoublePair",$PairInt)
        $BrelanInt      = $this.AssignRank("Brelan",$DoublePairInt)
        $FullHouseInt   = $this.AssignRank("FullHouse",$BrelanInt)
        $FourOfAkindInt = $this.AssignRank("FourOfAKind",$FullHouseInt)
        $null           = $this.AssignRank("FiveOfAKind",$FourOfAkindInt)
    }

    [int] GetRankAllProduct() {
        $Results = 0
        $CollectionName = @(
            "FiveOfAKind"
            "FourOfAKind"
            "FullHouse"
            "Brelan"
            "DoublePair"
            "Pair"
            "StrongCard"
        )
        foreach ($Name in $CollectionName) {
            foreach ($Hand in $this.$Name) {
                $Results+=$Hand.Rank*$Hand.Bid
                $Results+=$Hand.GetRankBidProduct()
            }
        }
        return $Results
    }

}

$Content = Get-Content ../input/day7.txt
$PokerGame = [PokerGame]::new($Content)
$PokerGame.AssignAllRank()
$Results = $PokerGame.GetRankAllProduct()
Write-Host = $Results
return $PokerGame

