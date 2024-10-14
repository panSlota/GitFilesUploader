$year = (Get-Date).Year
$moduleName = 'GitFilesUploader'
$author = 'Don Alberto'
$companyName = 'Aricoma Enterprise Applications s.r.o.'
$description = 'Uploads files at the specified path to a specified git repo.'
$version = '1.0'

New-Item -ItemType Directory -Name $moduleName
New-Item -Path "$PWD\$moduleName\Private\ps1" -ItemType Directory -Force
New-Item -Path "$PWD\$moduleName\Public\ps1" -ItemType Directory -Force


New-Item -Path "$PWD\$moduleName\$moduleName.psm1" -ItemType File


$moduleManifestParameters = @{
    Path = "$PWD\$moduleName\$moduleName.psd1"
    Author = $author
    CompanyName = $companyName
    Copyright = "$year $moduleName by $author"
    ModuleVersion = $version
    Description = $description
    RootModule = "$moduleName.psm1"
}

New-ModuleManifest @moduleManifestParameters