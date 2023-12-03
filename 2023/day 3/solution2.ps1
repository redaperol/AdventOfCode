class Gear {
    [int]$line
    [Int]$Index
    [hashtable]$ValidPosition
    [int[]]$Neighbour

    Gear([int]$line,[Int]$Index,[int]$Length,[int]$Count) {
        $this.Neighbour = @()
        $this.line = $line
        $this.Index =$Index
        $this.ValidPosition = @{$this.line=[System.Collections.ArrayList]@()}
        if ($this.Index -gt 0) {
            $Null = $This.ValidPosition[$this.line].Add($this.Index - 1)
        }

        if ($this.Index -lt $Length) {
            $Null = $This.ValidPosition[$this.line].Add($this.Index + 1)
        }

        if ($this.line -gt 0) {
            $this.ValidPosition.Add($this.line - 1,[System.Collections.ArrayList]@($this.Index))
            if ($this.Index -gt 0) {
                $Null = $This.ValidPosition[$this.line - 1].Add($this.Index - 1)
            }
    
            if ($this.Index -lt $Length) {
                $Null = $This.ValidPosition[$this.line - 1].Add($this.Index + 1)
            }
        }

        if ($this.line -lt $Count) {
            $this.ValidPosition.Add($this.line + 1,[System.Collections.ArrayList]@($this.Index))
            if ($this.Index -gt 0) {
                $Null = $This.ValidPosition[$this.line + 1].Add($this.Index - 1)
            }
    
            if ($this.Index -lt $Length) {
                $Null = $This.ValidPosition[$this.line + 1].Add($this.Index + 1)
            }
        }
    }
}

$Content = Get-Content ./input.txt
$Length = $Content.Length

[System.Collections.ArrayList]$GearList = @()
for ($i = 0; $i -lt $Content.Count; $i++) {
    $SymbolOfLine = ($Content[$i] | Select-String -Pattern "\*" -AllMatches).Matches
    foreach ($Symbol in $SymbolOfLine) {
        $null = $GearList.Add([Gear]::new($i,$Symbol.Index,139,139))
    }
}

for ($i = 0; $i -lt $Content.Count; $i++) {
    $NumberOfLine = ($Content[$i] | Select-String -Pattern "\d+" -AllMatches).Matches
    $neighbourGear = $GearList | Where-Object {($_.line -eq $i - 1) -or ($_.line -eq $i) -or ($_.line -eq $i + 1)}
    foreach ($Number in $NumberOfLine) {
        [System.Collections.ArrayList]$NumberIndexes = @()
        for ($j = 0; $j -lt $Number.Value.Length; $j++) {
            $null = $NumberIndexes.Add($Number.Index + $j)
        }
        foreach($Gear in $NeighbourGear) {
            $Compare = Compare-Object -ReferenceObject $Gear.ValidPosition[$i] -DifferenceObject $NumberIndexes -ExcludeDifferent -IncludeEqual
            if ($Compare) {
                $Null = $Gear.Neighbour+=$Number.Value
            }
            continue
        }
    }
}
[System.Collections.ArrayList]$Result = @()
$ValidGear = $GearList | Where-Object {$_.Neighbour.count -eq 2}
foreach ($Gear in $ValidGear) {
    $null = $Result.Add($Gear.Neighbour[0]*$Gear.Neighbour[1])
}
Return ($Result | Measure-Object -Sum).Sum