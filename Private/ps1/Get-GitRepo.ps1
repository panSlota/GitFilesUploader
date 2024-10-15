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
        [string]$BranchName,

        [Parameter(Mandatory = $true)]
        [string]$MainBranchName
    )

    Set-Location -Path $Path

    $PathNotValidErr    = "---------------------------------------------------`nCESTA K SOUBORÙM '$Path' JE NEPLATNÁ.`n---------------------------------------------------"
    $RepoUrlNotValidErr = "---------------------------------------------------`nURL K REPOZITÁØI JE NEPLATNÁ NEBO NEDOSTUPNÁ.`n---------------------------------------------------"


    if(-not (Test-Path -Path $Path)){
        Write-Error -Message $PathNotValidErr -ErrorAction Stop
    }

    $statusCode = (Invoke-WebRequest -Uri $RepoURL -UseBasicParsing -TimeoutSec 5).StatusCode 
    if($statusCode -ne 200 -and $statusCode -ne 203){
        Write-Error -Message $RepoUrlNotValidErr -ErrorAction Stop
    }

    $GitRepoPath = Test-GitRepo -Path $Path
   
    if($GitRepoPath -eq ''){
        New-GitRepo -Path $Path -RepoURL $RepoURL -BranchName $BranchName -MainBranchName $MainBranchName
    }
    elseif(-not (Test-Path -Path $GitRepoPath)){
        New-GitRepo -Path $Path -RepoURL $RepoURL -BranchName $BranchName -MainBranchName $MainBranchName
    }

    Update-Branch -BranchName $BranchName -MainBranchName $MainBranchName
    
}
