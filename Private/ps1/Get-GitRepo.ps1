<#
.SYNOPSIS
Tato funkce `Get-GitRepo` inicializuje Git repozitáø v zadané cestì, pokud repozitáø ještì neexistuje.

.DESCRIPTION
Funkce zkontroluje, zda je zadaná cesta platná, a zda je URL repozitáøe dostupná. 
Pokud cesta neexistuje, nebo pokud není možné získat odpovìï s kódem 200 od zadané URL, je vyvolána chyba.
Pokud zadaná cesta obsahuje neexistující Git repozitáø, funkce zavolá `New-GitRepo` pro jeho vytvoøení. 

.PARAMETER Path
Cesta k adresáøi, kde má být repozitáø inicializován. Tento parametr je povinný.

.PARAMETER RepoURL
URL vzdáleného repozitáøe, který má být pøipojen. Tento parametr je povinný.

.PARAMETER BranchName
Název výchozí vìtve, která bude vytvoøena pøi inicializaci repozitáøe. Tento parametr je povinný.

.EXAMPLE
Get-GitRepo -Path "C:\Projects\MyRepo" -RepoURL "https://github.com/user/repo.git" -BranchName "main"

Tento pøíklad inicializuje Git repozitáø v uvedené cestì, pokud repozitáø neexistuje, a pøipojí jej k danému URL.
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

    $PathNotValidErr = "Cesta k souborùm '$Path' je neplatná."
    $RepoUrlNotValidErr = "URL k repozitáøi je neplatná nebo nedostupná."


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
