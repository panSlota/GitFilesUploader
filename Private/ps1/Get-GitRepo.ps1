<#
.SYNOPSIS
Tato funkce `Get-GitRepo` inicializuje Git repozit�� v zadan� cest�, pokud repozit�� je�t� neexistuje.

.DESCRIPTION
Funkce zkontroluje, zda je zadan� cesta platn�, a zda je URL repozit��e dostupn�. 
Pokud cesta neexistuje, nebo pokud nen� mo�n� z�skat odpov�� s k�dem 200 od zadan� URL, je vyvol�na chyba.
Pokud zadan� cesta obsahuje neexistuj�c� Git repozit��, funkce zavol� `New-GitRepo` pro jeho vytvo�en�. 

.PARAMETER Path
Cesta k adres��i, kde m� b�t repozit�� inicializov�n. Tento parametr je povinn�.

.PARAMETER RepoURL
URL vzd�len�ho repozit��e, kter� m� b�t p�ipojen. Tento parametr je povinn�.

.PARAMETER BranchName
N�zev v�choz� v�tve, kter� bude vytvo�ena p�i inicializaci repozit��e. Tento parametr je povinn�.

.EXAMPLE
Get-GitRepo -Path "C:\Projects\MyRepo" -RepoURL "https://github.com/user/repo.git" -BranchName "main"

Tento p��klad inicializuje Git repozit�� v uveden� cest�, pokud repozit�� neexistuje, a p�ipoj� jej k dan�mu URL.
#>

function Get-GitRepo{

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

    $PathNotValidErr = "Cesta k soubor�m '$Path' je neplatn�."
    $RepoUrlNotValidErr = "URL k repozit��i je neplatn� nebo nedostupn�."


    if(-not (Test-Path -Path $Path)){
        Write-Error -Message $PathNotValidErr -ErrorAction Stop
    }

    if((Invoke-WebRequest -Uri $RepoURL -UseBasicParsing -TimeoutSec 5).StatusCode -ne 200){
        Write-Error -Message $RepoUrlNotValidErr -ErrorAction Stop
    }

    $GitRepoPath = Test-GitRepo -Path $Path
    if(-not (Test-Path -Path $GitRepoPath)){
        New-GitRepo -Path $Path -RepoURL $RepoURL -BranchName $BranchName
    }
}
