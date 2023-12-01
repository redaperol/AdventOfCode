function Convert-StringToInt {
    param (
        [string]$InputString
    )
    [string]$Result=""
    if ($InputString.Length -eq 1) {
        $Result = $InputString
    }
    else {
        switch ($InputString) {
            one   { $result = "1" }
            two   { $result = "2" }
            three { $result = "3" }
            four  { $result = "4" }
            five  { $result = "5" }
            six   { $result = "6" }
            seven { $result = "7" }
            eight { $result = "8" }
            nine  { $result = "9" }
            Default { throw "Unexpect value : $InputString"}
        }
    }
    return $Result
}
$content = Get-Content ./input
$Pattern = "\d|one|two|three|four|five|six|seven|eight|nine"
foreach ($line in $content) {
    $StringNumber = (Convert-StringToInt([regex]::match($line,$Pattern).Value)) + (Convert-StringToInt([regex]::match($line,$Pattern,"RightToLeft").Value))
    $Result+=[int]$StringNumber
}
return $Result