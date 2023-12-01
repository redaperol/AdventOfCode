$content = Get-Content ./input
foreach ($line in $content) {
    $Digit = [regex]::Matches("$line","\d")
    [string]$StringNumber = $Digit[0].Value + $Digit[-1].Value
    $Result+=[int]$StringNumber
}
return $Result
