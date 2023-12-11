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
    [void] SetGalaxyCord([List[int]]$EmptyX,[List[int]]$EmptyY,[int]$SizeExpanxe) {
        $this.LineIndex = ($EmptyY | Where-Object {$_ -lt $this.LineIndex}).count*$SizeExpanxe + $this.LineIndex
        $this.LineNumber = ($EmptyX | Where-Object {$_ -lt $this.LineNumber}).count*$SizeExpanxe + $this.LineNumber
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

[list[string]]$Content = Get-Content ../input/day11.txt
$EmptyX = Get-EmptyGalaxy -Content $Content -mode Row
$EmptyY = Get-EmptyGalaxy -Content $Content -mode Collumn
[list[Galaxy]]$ListGalaxy = @()
$GalaxyID=1
for ($i = 0; $i -lt $Content.Count; $i++) {
    $FoundStar = ($Content[$i] | Select-String -Pattern "#" -AllMatches).Matches
    for ($j = 0; $j -lt $FoundStar.Count; $j++) {
        $ListGalaxy.Add([Galaxy]::new($GalaxyID,$i,$FoundStar[$j].Index))
        $GalaxyID++
    }
}

foreach ($Galaxy in $ListGalaxy) {
    $Galaxy.SetGalaxyCord($EmptyX,$EmptyY,999999)
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

foreach ($Galaxy in $ListGalaxyDistant) {
    $Galaxy.SetGalaxyCord($EmptyX,$EmptyY,999999)
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