$content = Get-Content ./input
$Result = 0
foreach ($line in $content) {
    $Digit = [regex]::Matches("$line","\d")
    $StringNumber = ""
    if ($Digit.Count -eq 1) {
        $StringNumber = $Digit.value + $Digit.value
    }
    elseif ($Digit.Count -gt 1) {
        $StringNumber = $Digit[0].Value + $Digit[-1].Value
    }
    [int]$Number = 0
    $Number = $StringNumber
    $Result+=$Number
}
return $Result