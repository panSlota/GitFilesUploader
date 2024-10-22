<#
.SYNOPSIS
Tato funkce `Push-ChangesToRepo` prov�d� p�id�n�, commit a push zm�n do zadan�ho Git repozit��e a v�tve.

.DESCRIPTION
Funkce inicializuje pracovn� adres�� na zadan� cest�, provede kontrolu existence repozit��e pomoc� funkce `Get-GitRepo`, 
p�id� v�echny zm�ny, vytvo�� commit se zpr�vou obsahuj�c� aktu�ln� datum a �as a n�sledn� pushne zm�ny do zadan� v�tve v repozit��i. 
Na z�v�r vol� funkci `Move-ChangesToMaster`, kter� pravd�podobn� zaji��uje p�esun zm�n do hlavn� v�tve.

.PARAMETER Path
Cesta k pracovn�mu adres��i, ve kter�m se prov�d� zm�ny. Tento parametr je nepovinn�; pokud nen� zad�n, pou�ije se aktu�ln� cesta.

.PARAMETER RepoURL
URL vzd�len�ho repozit��e, do kter�ho se maj� zm�ny pushnout. Tento parametr je povinn�.

.PARAMETER BranchName
N�zev v�tve, do kter� se maj� zm�ny pushnout. Tento parametr je povinn�.

.EXAMPLE
Push-ChangesToRepo -RepoURL "https://github.com/user/repo.git" -BranchName "main"

Tento p��klad provede push v�ech zm�n do v�tve `main` v uveden�m repozit��i.
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

    $BranchRemovedMsg = "---------------------------------------------------`nV�TEV '{0}' SMAZ�NA.`n---------------------------------------------------"
    $ChangesPushedMsg = "---------------------------------------------------`nZM�NY Z V�TVE '{0}' NAHR�NY.`n---------------------------------------------------"

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
