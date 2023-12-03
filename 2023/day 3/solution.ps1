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

$Content = Get-Content ./input.txt
$Length = $Content.Length

$ValidPosition = @{}
for ($i = 0; $i -lt $Content.Count; $i++) {
    $ValidPosition.Add($i,[System.Collections.ArrayList]@())
}

for ($i = 0; $i -lt $Content.Count; $i++) {
    $SymbolOfLine = ($Content[$i] | Select-String -Pattern "[^\d|\.]" -AllMatches).Matches
    foreach ($Symbol in $SymbolOfLine) {
        Add-ValidPositionFromSymbol -line $i -SymbolIndex $Symbol.Index -Length 139 -ValidPosition $ValidPosition
    }
}
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