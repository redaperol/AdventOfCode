using namespace System.Collections.Generic

class Node {
    [string]$Name
    [List[node]]$ParentNode
    [node]$LeftChild
    [node]$RightChild
    hidden [string] $LeftChildName
    hidden [string] $RightChildName

    Node([string]$RawNode) {
        $this.ParentNode     = @()
        $this.Name           = ($RawNode | Select-String -Pattern "[A-Z]{3}").Matches.Value
        $this.LeftChildName  = ($RawNode | Select-String -Pattern "\(([A-Z]{3})").Matches.Groups[1].Value
        $this.RightChildName = ($RawNode | Select-String -Pattern "([A-Z]{3})\)").Matches.Groups[1].Value
    }

    [void] AddChild([List[Node]]$NodeList) {
        $ChildNode = $NodeList | Where-Object {($_.Name -eq $this.LeftChildName) -or ($_.Name -eq $this.RightChildName)}
        foreach ($Node in $ChildNode) {
            if ($this.LeftChildName -like $this.RightChildName) {
                $this.LeftChild = $Node
                $this.RightChild = $Node
            }
            elseif ($Node.Name -eq $this.LeftChildName) {
                $this.LeftChild = $Node
            }
            else {
                $this.RightChild = $Node
            }
            $null = $Node.ParentNode.Add($this)
        }
    }

    [string[]] GetNodeChild() {
        $ChildNodeName = @(
            $this.LeftChildName
            $this.RightChildName
        )
        return $ChildNodeName
    }
}

class Tree {
    [Node]$StartNode
    [List[Node]]$NodeToAssemble

    Tree([string[]]$RawNode,[string]$StartNodeName) {
        $this.NodeToAssemble = @()
        foreach ($Line in $RawNode) {
            $null = $this.NodeToAssemble.Add([Node]::new($Line))
        }
        $this.StartNode = $this.NodeToAssemble | Where-Object Name -EQ $StartNodeName

        foreach ($Node in $this.NodeToAssemble) {
            $Node.AddChild($this.NodeToAssemble)
        }
    }

    [Node] WalkTree([string]$Direction,[Node]$StartNode) {
            if ($Direction -match "L") {
                $EndNode = $StartNode.LeftChild
            }
            else {
                $EndNode = $StartNode.RightChild
            }
    
        return $EndNode
    }
}

function Write-DisplayGrid {
    param (
        [Tree]$Tree,
        [string]$NodeNameToDisplay
    )
    $Grid = "`e[3J"
    $Grid+="_______________________________________________________________________________________________________________________________`n"
    $Grid+="Steps : $Steps`n"
    $Grid+="_______________________________________________________________________________________________________________________________`n|"
    $j=0
    for ($i = 0; $i -lt $Tree.NodeToAssemble.Count; $i++) {
        $NodeName = $Tree.NodeToAssemble[$i].Name
        if ($NodeName -like $NodeNameToDisplay) {
            $NodeName= "`e[7m$NodeName`e[0m"
        }
        
        if ($j -eq 20) {
            $Grid+= " $NodeName |`n|"
            $j = 0
        }
        else {
            $Grid+=" $NodeName |"
            $j++
        }
        
    }
    $Grid+="`n_______________________________________________________________________________________________________________________________"
    $Grid+="`e[0m"
    Write-Host $Grid
}

function Get-StepsToGoal {
    param (
        [Tree]
        $Tree,

        [Parameter(ValueFromPipeline=$true)]
        [Node]
        $FirstNode,

        [string]
        $Direction,

        [string[]]
        $Goal
    )
    begin {
        $Steps = 0
        $NotFound = $true
    }
    
    process {
        $CurrentNode = $FirstNode
        while ($NotFound) {
            for ($i = 0; $i -lt $Direction.length; $i++) {
                $Steps++
                $CurrentNode = $Tree.WalkTree($Direction[$i],$CurrentNode)
                #Write-Host "Processing : $($FirstNode.Name) ; current node $($CurrentNode.Name) ; Steps : $Steps"
                Write-Progress -Id 2 -Activity Processing -CurrentOperation $CurrentNode.Name -Status $Steps
                Write-DisplayGrid -Tree $Tree -NodeNameToDisplay $CurrentNode.Name
                Start-Sleep -Milliseconds 1
                if ($CurrentNode.Name -in $Goal) {
                    $NotFound = $false
                }
            }
        }
    }
    end {
        return $Steps
    }
}

Function Get-LCM {
    PARAM (
    [Parameter(ValueFromPipeline=$true)]
    [int[]]$Numbers
    )
    [System.Collections.ArrayList]$List=@()
    [System.Double]$product=1
    foreach ($Number in $Numbers) {
        $sqrt=[math]::sqrt($number)
        $Factor=2
        $count=0
        while ( ($Number % $Factor) -eq 0) {
            $count+=1
            $Number=$Number/$Factor
            if (($List | Where-Object {$_ -eq $Factor}).count -lt $count) {
                $Null = $List.Add($Factor)
            }
        }
        $count=0
        $Factor=3
        while ($Factor -le $sqrt) {
            while ( ($Number % $Factor) -eq 0) {
                $count+=1
                $Number=$Number/$Factor
                if (($List | Where-Object {$_ -eq $Factor}).count -lt $count) {
                    $null = $List.Add($Factor)
                    }
                }           
            $Factor+=2
            $count=0
        }
        if ($List -notcontains $Number) {
            $null = $List.Add($Number)
        }
    }
    foreach($arra in $List) {
        $product = $product * $arra
    }
    return $product
}

$Content = Get-Content ../input/day8.txt
$Movement = $Content[0]
$NodeContent = $Content[2..$Content.Length]

$Tree = [Tree]::new($NodeContent,"AAA")
$EndingName = ($Tree.NodeToAssemble | Where-Object Name -Match "[A-Z]{2}Z").Name
$StartingPosition = $Tree.NodeToAssemble | Where-Object Name -Match "[A-Z]{2}A"
$Total = $StartingPosition.Count
Write-Host $Total
$Results = @{}
$j=0
foreach ($Node in $StartingPosition) {
    $Steps = Get-StepsToGoal -Tree $Tree -Direction $Movement -Goal $EndingName -FirstNode $Node
    $Results.Add($Node.Name,$Steps)
    $j++
    Write-Progress -Activity $Node.Name -Id 1 -PercentComplete ($j*100/$Total)
}
$Answer = Get-LCM -Numbers $Results.Values
Write-Host "Answer Part1 :"  -NoNewline; Write-Host $Results.AAA -ForegroundColor Green
Write-Host "Answer Part2 :"  -NoNewline; Write-Host $Answer -ForegroundColor Green