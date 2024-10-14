Get-ChildItem -Path "$PSScriptRoot\Public\ps1\*.ps1" | ForEach-Object {
    . $_.FullName
}

Get-ChildItem -Path "$PSScriptRoot\Private\ps1\*.ps1" | ForEach-Object {
    . $_.FullName
}
