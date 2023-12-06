using namespace System.Collections
class ElvesMap {
    [Int64]$SourceMin
    [Int64]$SourceMax
    [Int64]$Range
    [Int64]$Destination

    ElvesMap([string]$RawMap) {
        $Captured = ($RawMap | Select-String -pattern "^(\d+)\s(\d+)\s(\d+)$").Matches.Groups
        $this.Destination = $Captured[1].Value
        $this.SourceMin = $Captured[2].Value
        $this.Range = $Captured[3].Value
        $this.SourceMax = $this.SourceMin + $this.Range -1
    }

    [Int64] CorespondingNumber([Int64]$Number) {
        $CalculatedRange = $Number - $this.SourceMin
        $MappedNumber = $CalculatedRange + $this.Destination
        return $MappedNumber
    }
}

class ElvesAgriculturalMap {
    [string]$Name
    [ArrayList]$Maps

    ElvesAgriculturalMap([string[]]$FullContent,[string]$Pattern) {
        $this.Name = ($Pattern | Select-String -Pattern "([\w-\w]*)\s").Matches.Groups[1].Value
        
        $StartIndex = $FullContent.IndexOf(($FullContent | Select-String -Pattern $Pattern).Matches.Value)
        [ArrayList]$Result = @()
        for ($i = $StartIndex+1; $i -lt $FullContent.Length; $i++) {
            $IsEmptyLine = ($FullContent[$i] | Select-String -Pattern "^$").Matches.success
            if ($IsEmptyLine) {
                Break
            }
            else {
                $null = $Result.Add($FullContent[$i])
            }
        }
        $this.Maps = @()
        foreach ($line in $Result) {
            $null = $this.Maps.Add([ElvesMap]::new($line))
        }
    }

    [int64] ConvertSeed([Int64]$Seed) {
        $MatchingMap = $this.Maps | Where-Object { ($_.SourceMin -le $Seed) -and ($_.SourceMax -ge $Seed)}
        if ($MatchingMap) {
            $ConvertedSeed = $MatchingMap.CorespondingNumber($Seed)
        }
        else {
            $ConvertedSeed = $Seed
        }
        return $ConvertedSeed
    }
}

$Content = Get-Content ./realinput.txt
$Line = ($Content | Select-String -Pattern "seeds: .*").Matches.Value
$RawSeeds = ($Line -replace "seeds:",''| Select-String -Pattern "\s(\d+)*" -AllMatches).Matches
[ArrayList]$Seeds = @()
foreach ($Seed in $RawSeeds) {
    $null = $Seeds.Add($Seed.Groups[1].Value)
}
<#
$Pattern = @(
    "seed-to-soil map:"
    "soil-to-fertilizer map:"
    "fertilizer-to-water map:"
    "water-to-light map:"
    "light-to-temperature map:"
    "temperature-to-humidity map:"
    "humidity-to-location map:"
)

[ArrayList]$AgriMap = @()
foreach ($i in $Pattern) {
    $null = $AgriMap.Add([ElvesAgriculturalMap]::new($Content,$i))
}
Write-Host $Seeds
return $AgriMap
#>
$SeedToSoil = [ElvesAgriculturalMap]::new($Content,"seed-to-soil map:")
$SoilToFertilizer = [ElvesAgriculturalMap]::new($Content,"soil-to-fertilizer map:")
$FertilizerToWater = [ElvesAgriculturalMap]::new($Content,"fertilizer-to-water map:")
$WaterToLight = [ElvesAgriculturalMap]::new($Content,"water-to-light map:")
$LightToTemperature = [ElvesAgriculturalMap]::new($Content,"light-to-temperature map:")
$TemperatureToHumidity = [ElvesAgriculturalMap]::new($Content,"temperature-to-humidity map:")
$HumidityToLocation = [ElvesAgriculturalMap]::new($Content,"humidity-to-location map:")

[ArrayList]$Locations =@()
foreach ($seed in $Seeds) {
    
    $Soil        = $SeedToSoil.ConvertSeed($Seed)
    $Ferti       = $SoilToFertilizer.ConvertSeed($Soil)
    $Water       = $FertilizerToWater.ConvertSeed($Ferti)
    $Light       = $WaterToLight.ConvertSeed($Water)
    $Temperature = $LightToTemperature.ConvertSeed($Light)
    $Humidity    = $TemperatureToHumidity.ConvertSeed($Temperature)
    $Location    = $HumidityToLocation.ConvertSeed($Humidity)
    $null        = $Locations.Add($Location)
    Write-Host "Seed     : $($Seed)" 
    Write-Host "Location : $Location`n"
}

$Locations | Measure-Object -Minimum