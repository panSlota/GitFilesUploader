<#
.SYNOPSIS
Tato funkce `Push-ChangesToRepo` provádí pøidání, commit a push zmìn do zadaného Git repozitáøe a vìtve.

.DESCRIPTION
Funkce inicializuje pracovní adresáø na zadané cestì, provede kontrolu existence repozitáøe pomocí funkce `Get-GitRepo`, 
pøidá všechny zmìny, vytvoøí commit se zprávou obsahující aktuální datum a èas a následnì pushne zmìny do zadané vìtve v repozitáøi. 
Na závìr volá funkci `Move-ChangesToMaster`, která pravdìpodobnì zajišuje pøesun zmìn do hlavní vìtve.

.PARAMETER Path
Cesta k pracovnímu adresáøi, ve kterém se provádí zmìny. Tento parametr je nepovinný; pokud není zadán, použije se aktuální cesta.

.PARAMETER RepoURL
URL vzdáleného repozitáøe, do kterého se mají zmìny pushnout. Tento parametr je povinný.

.PARAMETER BranchName
Název vìtve, do které se mají zmìny pushnout. Tento parametr je povinný.

.EXAMPLE
Push-ChangesToRepo -RepoURL "https://github.com/user/repo.git" -BranchName "main"

Tento pøíklad provede push všech zmìn do vìtve `main` v uvedeném repozitáøi.
#>
function Push-ChangesToRepo{
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-Location),

        [Parameter(Mandatory = $true)]
        [string]$RepoURL,
        
        [Parameter(Mandatory = $true)]
        [string]$BranchName,

        [Parameter(Mandatory = $true)]
        [string]$MainBranchName,

        [bool]$DeleteSourceBranch = $false
    )
    Set-Location -Path $Path

    Set-Credentials

    $BranchRemovedMsg = "---------------------------------------------------`nVÌTEV '{0}' SMAZÁNA.`n---------------------------------------------------"
    $ChangesPushedMsg = "---------------------------------------------------`nZMÌNY Z VÌTVE '{0}' NAHRÁNY.`n---------------------------------------------------"

    Get-GitRepo -Path $Path -RepoURL $RepoURL -BranchName $BranchName -MainBranchName $MainBranchName

    git add .
    git commit -m "changes from $((Get-Date).ToString("yyyy-dd-MM HH:mm:ss"))"
    git push

    
    Move-ChangesToMaster -BranchName $BranchName -MainBranchName $MainBranchName

    if($DeleteSourceBranch){
        git checkout $MainBranchName
        git branch -D $BranchName
        git push
        Write-Host ($BranchRemovedMsg -f $BranchName) -ForegroundColor Green
    }

    Write-Host ($ChangesPushedMsg -f $BranchName) -ForegroundColor Green
    
}
