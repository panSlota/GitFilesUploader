<#
.SYNOPSIS
Tato funkce `New-GitRepo` inicializuje nový Git repozitáø v zadané cestì a pøipojí jej k danému vzdálenému repozitáøi.

.DESCRIPTION
Funkce inicializuje Git repozitáø v zadaném adresáøi, pøidává vzdálený repozitáø podle zadané URL a provádí naètení vìtví z originu.
Pokud již existuje vìtev se zadaným názvem, funkce provede pøepnutí na tuto vìtev. Pokud vìtev neexistuje, vytvoøí ji a pushne na vzdálený repozitáø.

.PARAMETER Path
Cesta k adresáøi, kde má být nový Git repozitáø inicializován. Tento parametr je povinný.

.PARAMETER RepoURL
URL vzdáleného repozitáøe, který má být pøipojen jako origin. Tento parametr je povinný.

.PARAMETER BranchName
Název vìtve, na kterou se má provést pøepnutí, nebo která se má vytvoøit, pokud neexistuje. Tento parametr je povinný.

.EXAMPLE
New-GitRepo -Path "C:\Projects\MyRepo" -RepoURL "https://github.com/user/repo.git" -BranchName "main"

Tento pøíklad inicializuje nový Git repozitáø v uvedené cestì, pøipojí jej k danému URL a vytvoøí nebo pøepne na vìtev `main`.
#>

function New-GitRepo{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$RepoURL,

        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )

    Set-Location -Path $Path

    git init
    git remote add origin $RepoURL -Force
    git fetch origin

    $Branches = git branch --list | ForEach-Object { $_.Trim() }
    if($Branches -contains $BranchName -or $branches -contains "remotes/origin/$branchName"){
        git checkout $BranchName
    }
    else{
        git checkout -b $BranchName
        git push -u origin $BranchName
    }
}
