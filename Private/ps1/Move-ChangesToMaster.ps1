<#
.SYNOPSIS
Tato funkce `Move-ChangesToMaster` provádí slouèení zmìn z aktuální vìtve do hlavní vìtve repozitáøe.

.DESCRIPTION
Funkce zjistí název hlavní vìtve repozitáøe pomocí pøíkazu `git symbolic-ref`, poté pøepne na tuto vìtev, 
naète nejnovìjší zmìny z originu a slouèí do ní zmìny z aktuální vìtve. 
Zpráva o slouèení obsahuje název vìtve a aktuální èasový údaj ve formátu Unix timestamp.

.EXAMPLE
Move-ChangesToMaster

Tento pøíklad slouèí aktuální vìtev do hlavní vìtve repozitáøe.

.NOTES
Funkce vyžaduje, aby byla promìnná `$branchName` definována s názvem aktuální vìtve, 
která se má slouèit do hlavní vìtve. 
Pøedpokládá se také, že Git je nainstalován a dostupný v systému PATH.
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

    $ChangesMergedToMasterMsg = "---------------------------------------------------`nZMÌNY VE VÌTVI '{0}' NAHRÁNY DO VÌTVE '{1}'.`n---------------------------------------------------"
    
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
