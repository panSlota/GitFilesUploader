<#
.SYNOPSIS
Tato funkce `Move-ChangesToMaster` prov�d� slou�en� zm�n z aktu�ln� v�tve do hlavn� v�tve repozit��e.

.DESCRIPTION
Funkce zjist� n�zev hlavn� v�tve repozit��e pomoc� p��kazu `git symbolic-ref`, pot� p�epne na tuto v�tev, 
na�te nejnov�j�� zm�ny z originu a slou�� do n� zm�ny z aktu�ln� v�tve. 
Zpr�va o slou�en� obsahuje n�zev v�tve a aktu�ln� �asov� �daj ve form�tu Unix timestamp.

.EXAMPLE
Move-ChangesToMaster

Tento p��klad slou�� aktu�ln� v�tev do hlavn� v�tve repozit��e.

.NOTES
Funkce vy�aduje, aby byla prom�nn� `$branchName` definov�na s n�zvem aktu�ln� v�tve, 
kter� se m� slou�it do hlavn� v�tve. 
P�edpokl�d� se tak�, �e Git je nainstalov�n a dostupn� v syst�mu PATH.
#>

function Move-ChangesToMaster{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )


    $mainBranch = git symbolic-ref refs/remotes/origin/HEAD 2>&1 | ForEach-Object {
        $_ -replace 'refs/remotes/origin/', ''
    }

    $currentTimestamp = [int][double]::Parse((Get-Date -UFormat %s))

    git checkout $mainBranch
    git pull origin $mainBranch
    git merge --no-ff $BranchName -m "merged $BranchName to $mainBranch @$currentTimestamp"
    git push origin $mainBranch
}
