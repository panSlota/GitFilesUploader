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
        [string]$BranchName,

        [Parameter(Mandatory = $true)]
        [string]$MainBranchName
    )

    $currentTimestamp = [int][double]::Parse((Get-Date -UFormat %s))

    $ChangesMergedToMasterMsg = "---------------------------------------------------`nZM�NY VE V�TVI '{0}' NAHR�NY DO V�TVE '{1}'.`n---------------------------------------------------"
    
    git checkout $MainBranchName
    git pull
    $GitMergeOutput = git merge --no-ff $BranchName -m "merged $BranchName to $MainBranchName @ $((Get-Date).ToString('yyyy-dd-MM HH:mm:ss.fff'))" --allow-unrelated-histories
    git push

    Write-Host ($ChangesMergedToMasterMsg -f $BranchName, $MainBranchName) -ForegroundColor Green
    
    #formatovani mirne nefunguje
    Write-Host "---------------------------------------------------" -ForegroundColor Yellow
    Write-Host $GitMergeOutput -ForegroundColor Yellow
    Write-Host "---------------------------------------------------" -ForegroundColor Yellow
    
}
