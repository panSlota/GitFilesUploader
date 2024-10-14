<#
.SYNOPSIS
Tato funkce `New-GitRepo` inicializuje nov� Git repozit�� v zadan� cest� a p�ipoj� jej k dan�mu vzd�len�mu repozit��i.

.DESCRIPTION
Funkce inicializuje Git repozit�� v zadan�m adres��i, p�id�v� vzd�len� repozit�� podle zadan� URL a prov�d� na�ten� v�tv� z originu.
Pokud ji� existuje v�tev se zadan�m n�zvem, funkce provede p�epnut� na tuto v�tev. Pokud v�tev neexistuje, vytvo�� ji a pushne na vzd�len� repozit��.

.PARAMETER Path
Cesta k adres��i, kde m� b�t nov� Git repozit�� inicializov�n. Tento parametr je povinn�.

.PARAMETER RepoURL
URL vzd�len�ho repozit��e, kter� m� b�t p�ipojen jako origin. Tento parametr je povinn�.

.PARAMETER BranchName
N�zev v�tve, na kterou se m� prov�st p�epnut�, nebo kter� se m� vytvo�it, pokud neexistuje. Tento parametr je povinn�.

.EXAMPLE
New-GitRepo -Path "C:\Projects\MyRepo" -RepoURL "https://github.com/user/repo.git" -BranchName "main"

Tento p��klad inicializuje nov� Git repozit�� v uveden� cest�, p�ipoj� jej k dan�mu URL a vytvo�� nebo p�epne na v�tev `main`.
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
