$content = Get-Content ./input.txt
foreach ($line in $content) {
    $line = $line -replace "one","o1e" -replace "two","t2o" -replace "three","t3e" -replace "four","f4r" -replace "five","f5e" -replace "six","s6x" -replace "seven","s7n" -replace "eight","e8t" -replace "nine","n9e"
    $Digit = [regex]::Matches($line,"\d")
    [string]$StringNumber = $Digit[0].Value + $Digit[-1].Value
    $Result+= [int]$StringNumber
}
return $Result