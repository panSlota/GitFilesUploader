<#
.SYNOPSIS
Tato funkce `Test-GitRepo` kontroluje, zda se ve zadané cestì nebo v jejích nadøazených složkách nachází složka `.git`, která indikuje pøítomnost Git repozitáøe.

.DESCRIPTION
Funkce prochází zadanou cestu a její nadøazené složky a hledá složku `.git`. 
Pokud je složka nalezena, vrátí její cestu a zobrazí zprávu o úspìšném nalezení. 
Pokud složka není nalezena v zadané cestì ani v žádné z nadøazených složek, vrátí prázdný øetìzec a zobrazí chybovou zprávu.

.PARAMETER Path
Cesta, ve které má funkce hledat složku `.git`. Tento parametr je povinný.

.EXAMPLE
Test-GitRepo -Path "C:\Projects\MyRepo"

Tento pøíklad zkontroluje, zda se ve složce `C:\Projects\MyRepo` nebo v její nadøazené struktuøe nachází složka `.git`.

.NOTES
Funkce vrací prázdný øetìzec v pøípadì, že složka `.git` není nalezena. 
Pokud je složka nalezena, je vrácena její cesta.
#>

function Test-GitRepo{
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    Set-Location -Path $Path

    $GitFolderFoundMsg = "Složka .git byla nalezena na cestì: $gitFolderPath"
    $GitFolderNotFounfErr = "Složka .git nebyla nalezena na zadané cestì ani v nadøazených složkách."

    $currentPath = Resolve-Path $Path
    $gitToken = ".git"

    while ($currentPath) {
        $gitFolderPath = Join-Path $currentPath $gitToken
        
        if (Test-Path -Path $gitFolderPath -PathType Container) {
            Write-Host $GitFolderFoundMsg -ForegroundColor Green
            return $gitFolderPath
        }

        $parentPath = Get-Item $currentPath | Select-Object -ExpandProperty Parent
        if ($parentPath -eq $null) {
            break
        }
        
        $currentPath = $parentPath
    }

    Write-Host $GitFolderNotFoundErr -ForegroundColor Red
    return ''
}
