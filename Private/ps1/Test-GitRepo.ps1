<#
.SYNOPSIS
Tato funkce `Test-GitRepo` kontroluje, zda se ve zadan� cest� nebo v jej�ch nad�azen�ch slo�k�ch nach�z� slo�ka `.git`, kter� indikuje p��tomnost Git repozit��e.

.DESCRIPTION
Funkce proch�z� zadanou cestu a jej� nad�azen� slo�ky a hled� slo�ku `.git`. 
Pokud je slo�ka nalezena, vr�t� jej� cestu a zobraz� zpr�vu o �sp�n�m nalezen�. 
Pokud slo�ka nen� nalezena v zadan� cest� ani v ��dn� z nad�azen�ch slo�ek, vr�t� pr�zdn� �et�zec a zobraz� chybovou zpr�vu.

.PARAMETER Path
Cesta, ve kter� m� funkce hledat slo�ku `.git`. Tento parametr je povinn�.

.EXAMPLE
Test-GitRepo -Path "C:\Projects\MyRepo"

Tento p��klad zkontroluje, zda se ve slo�ce `C:\Projects\MyRepo` nebo v jej� nad�azen� struktu�e nach�z� slo�ka `.git`.

.NOTES
Funkce vrac� pr�zdn� �et�zec v p��pad�, �e slo�ka `.git` nen� nalezena. 
Pokud je slo�ka nalezena, je vr�cena jej� cesta.
#>

function Test-GitRepo{
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    Set-Location -Path $Path

    $GitFolderFoundMsg = "Slo�ka .git byla nalezena na cest�: $gitFolderPath"
    $GitFolderNotFounfErr = "Slo�ka .git nebyla nalezena na zadan� cest� ani v nad�azen�ch slo�k�ch."

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
