using namespace System.Collections
$Content = Get-Content ./input.txt

class TrialToyRace {
    [bool]$IsSuccessful
    [int64]$ButtonHoldingTime
    [int64]$Speed
    [int64]$TravelTime
    [int64]$TravelLength

    TrialToyRace([int64]$Time,[int64]$ButtonHoldingTime,[int64]$Distance) {
        $this.ButtonHoldingTime = $ButtonHoldingTime
        $this.Speed             = $ButtonHoldingTime
        $this.TravelTime        = $Time - $ButtonHoldingTime
        $this.TravelLength      = $this.TravelTime * $this.Speed

        if ($this.TravelLength -ge $Distance ) {
            $this.IsSuccessful = $true
        }
        else {
            $this.IsSuccessful = $false
        }
    }
}

class ToyRace {
    [int64]$Distance
    [int64]$Time
    [ArrayList]$TrialRaceSuccesful
    [ArrayList]$TrialRaceUnSuccesful

    ToyRace([int64]$Time,[int64]$Distance) {
        $this.Distance             = $Distance
        $this.Time                 = $Time
        $this.TrialRaceSuccesful   = @()
        $this.TrialRaceUnSuccesful = @()

        foreach ($i in (0..$Time)) {
            Write-Progress -Activity Trial -Id 1 -Status "  $i - $Time"
            $Trial = [TrialToyRace]::new($Time,$i,$Distance)
            if ($Trial.IsSuccessful) {
                $null = $this.TrialRaceSuccesful.Add($Trial)
            }
            else {
                $null = $this.TrialRaceUnSuccesful.Add($Trial)
            }
        }
    }
}

$RawTime = $Content[0] -replace "Time:",''
$RawDistance = $Content[1] -replace "Distance:",''

$TimePart2 = ""
$DistancePart2 = ""
[ArrayList]$Time = @()
foreach ($T in ($RawTime | Select-String -Pattern "\d+" -AllMatches).Matches.Value) {
    $null = $Time.Add($T)
    $TimePart2+=$T
}

[ArrayList]$Distance = @()
foreach ($D in ($RawDistance | Select-String -Pattern "\d+" -AllMatches).Matches.Value) {
    $null = $Distance.Add($D)
    $DistancePart2+=$D
}

[int]$ResultPart1 = 0
for ($i = 0; $i -lt $Distance.Count; $i++) {
    $ToyRace = [ToyRace]::new($Time[$i],$Distance[$i])
    $WayToBeat = $ToyRace.TrialRaceSuccesful.Count
    if ($i -eq 0) {
        $ResultPart1+=$WayToBeat
    }
    else {
        $ResultPart1*=$WayToBeat
    }
}
$ToyRacePart2 = [ToyRace]::new([int64]$TimePart2,[int64]$DistancePart2)
$ResultPart2 = $ToyRacePart2.TrialRaceSuccesful.Count

Write-Host "Partie 1 : " -NoNewline; Write-Host $ResultPart1 -ForegroundColor Green
Write-Host "Partie 2 : " -NoNewline; Write-Host $ResultPart2 -ForegroundColor Green
