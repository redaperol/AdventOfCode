using namespace System.Collections.Generic

class Galaxy {
    [int]$Id
    [int]$LineNumber
    [int]$LineIndex

    Galaxy([int]$Id,[int]$LineNumber,[int]$LineIndex) {
        $this.Id         = $Id
        $this.LineIndex  = $LineIndex
        $this.LineNumber = $LineNumber
    }

    [int] GetPathToGalaxy([Galaxy]$DistantGalaxy) {
        $DistanceX=[System.Math]::Abs($this.LineNumber - $DistantGalaxy.LineNumber)
        $DistanceY=[System.Math]::Abs($this.LineIndex - $DistantGalaxy.LineIndex)

        return $DistanceX + $DistanceY
    }
}

function Get-EmptyGalaxy {
    param (
        [list[string]]$Content,
        [ValidateSet("Row","Collumn")]$mode
    )

    [List[int]]$Empty = @()
    if ($mode -like "Row") {
        for ($i = 0; $i -lt $Content.Count; $i++) {
            if (!($Content[$i] | select-String -Pattern "#" -Quiet)) {
                $Empty.Add($i)
            }
        }
    }

    elseif ($mode -like "Collumn") {
        for ($i = 0; $i -lt $Content[0].length; $i++) {

            $Galaxyrow =""
            for ($j = 0; $j -lt $Content.Count; $j++) {
                $Galaxyrow += $Content[$j][$i]
            }
            if (!($Galaxyrow | select-String -Pattern "#" -Quiet)) {
                $Empty.Add($i)
            }
        }
    }
    return $Empty
}

function Add-GalaxyExpanse {
    param (
        [List[int]]$Empty,
        [ValidateSet("Row","Collumn")]$mode,
        [list[string]]$Content
    )
    $Drift = 0
    if ($mode -like "Row") {

        $EmptyLine ="" 
        for ($i = 0; $i -lt $Content[0].Length; $i++) {
            $EmptyLine+="."
        }
        foreach ($Cord in $Empty) {
            $Content.Insert($Cord+$Drift,$EmptyLine)
            $Drift++
        }
    }
    elseif ($mode -like "Collumn") {
        foreach ($Cord in $Empty) {
            for ($i = 0; $i -lt $Content.Count; $i++) {
                $Content[$i] = $Content[$i].Insert($Cord+$Drift,".")
            }
            $Drift++
        }
    }
Return $Content
}

function Write-Galaxy {
    param(
        [List[string]]$Content
    )
    foreach ($Line in $Content) {
        Write-Host $Line
    }
    Write-Host `n
}

[list[string]]$Content = Get-Content ../input/day11.txt
#Write-Galaxy -Content $Content
$Empty = Get-EmptyGalaxy -Content $Content -mode Row
$Content = Add-GalaxyExpanse -Content $Content -mode Row -Empty $Empty
#Write-Galaxy -Content $Content
$Empty = Get-EmptyGalaxy -Content $Content -mode Collumn
$Content = Add-GalaxyExpanse -Content $Content -mode Collumn -Empty $Empty
#Write-Galaxy -Content $Content
[list[Galaxy]]$ListGalaxy = @()
$GalaxyID=1
for ($i = 0; $i -lt $Content.Count; $i++) {
    $FoundStar = ($Content[$i] | Select-String -Pattern "#" -AllMatches).Matches
    for ($j = 0; $j -lt $FoundStar.Count; $j++) {
        $ListGalaxy.Add([Galaxy]::new($GalaxyID,$i,$FoundStar[$j].Index))
        $GalaxyID++
    }
}
$GalaxyID=1
[List[Galaxy]]$ListGalaxyDistant = @()
for ($i = 0; $i -lt $Content.Count; $i++) {
    $FoundStar = ($Content[$i] | Select-String -Pattern "#" -AllMatches).Matches
    for ($j = 0; $j -lt $FoundStar.Count; $j++) {
        $ListGalaxyDistant.Add([Galaxy]::new($GalaxyID,$i,$FoundStar[$j].Index))
        $GalaxyID++
    }
}

[List[string]]$listPair =@()
[List[int]]$Result = @()

for ($i = 0; $i -lt $ListGalaxy.Count; $i++) {
    $PercentComplete = $i*100/$ListGalaxy.Count
    Write-Progress -Id 1 -Activity Galaxy -Status $ListGalaxy[$i].ID -PercentComplete $PercentComplete
    $ProgressGalaxyPair = 0
    
    for ($j = 0; $j -lt $ListGalaxyDistant.Count; $j++) {
        
        if (!($ListGalaxy[$i].Id -eq $ListGalaxyDistant[$j].ID)) {
            $Result.Add($ListGalaxy[$i].GetPathToGalaxy($ListGalaxyDistant[$j]))
            
            $ProgressGalaxyPair++
            $PercentCompletePair = $ProgressGalaxyPair*100/$ListGalaxyDistant.Count
            Write-Progress -ParentId 1 -Activity "Distant Galaxy" -Status $ListGalaxyDistant[$j].Id -PercentComplete $PercentCompletePair
            [string]$pair = "$($ListGalaxy[$i].Id)-$($ListGalaxyDistant[$j].Id)"
            $null = $listPair.Add($pair)
        }
    }

    $toRemove = $ListGalaxyDistant | Where-Object Id -EQ $ListGalaxy[$i].Id
    $null = $ListGalaxyDistant.remove($toRemove)
    $ProgressGalaxy++
}
return ($Result | Measure-Object -Sum).Sum