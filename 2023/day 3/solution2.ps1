class Gear {
    [int]$line
    [Int]$Index
    [hashtable]$ValidPosition
    [int[]]$Neighboor

    GearStar([int]$line,[Int]$Index,[int]$Length,[int]$Count) {
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

<#
function Add-ValidPositionFromSymbol {
    param (
        [int]
        $line,
        
        [int]
        $SymbolIndex,

        [int]
        $Length,

        [hashtable]
        $ValidPosition

    )
    #Left and right Position
    if ($SymbolIndex -gt 0) {
        $Null = $ValidPosition[$line].Add($SymbolIndex - 1)
    }

    if ($SymbolIndex -lt $Length) {
        $Null = $ValidPosition[$line].Add($SymbolIndex + 1)
    }

    #Down and up
    if ($line -gt 0) {
        if ($SymbolIndex -gt 0) {
            $Null = $ValidPosition[$line - 1].Add($SymbolIndex - 1)
        }
    
        if ($SymbolIndex -lt $Length) {
            $Null = $ValidPosition[$line - 1].Add($SymbolIndex + 1)
        }

        $Null = $ValidPosition[$line - 1].Add($SymbolIndex)
    }

    if ($line -lt 140) {
        if ($SymbolIndex -gt 0) {
            $Null = $ValidPosition[$line + 1].Add($SymbolIndex - 1)
        }
    
        if ($SymbolIndex -lt $Length) {
            $Null = $ValidPosition[$line + 1].Add($SymbolIndex + 1)
        }

        $Null = $ValidPosition[$line + 1].Add($SymbolIndex)
    }
}
#>

$Content = Get-Content ./input.txt
$Length = $Content.Length

[System.Collections.ArrayList]$GearList = @()
for ($i = 0; $i -lt $Content.Count; $i++) {
    $SymbolOfLine = ($Content[$i] | Select-String -Pattern "\*" -AllMatches).Matches
    foreach ($Symbol in $SymbolOfLine) {
        $null = $GearList.Add([GearStar]::new($i,$Symbol.Index,139,139))
    }
}
<#
[System.Collections.ArrayList]$ValidNumber = @()
for ($i = 0; $i -lt $Content.Count; $i++) {
    $NumberOfLine = ($Content[$i] | Select-String -Pattern "\d+" -AllMatches).Matches
    foreach ($Number in $NumberOfLine) {
        for ($j = 0; $j -lt $Number.Value.Length; $j++) {
            if (($Number.Index+$j) -in $ValidPosition[$i]) {
                write-host "line : $i, Number : $($Number.Value) , position : $($Number.Index + $j)"
                $null = $ValidNumber.Add($Number.Value)
                break
            }
        }
    }
}
$ValidPosition
$ValidNumber
Return ($ValidNumber | Measure-Object -Sum).Sum
#>
$GearList