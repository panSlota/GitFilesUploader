
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

        [Parameter(Mandatory = 0)]
        [bool]$DeleteSourceBranch = $false,

        [Parameter(Mandatory = $false)]
        [bool]$MergeChangesToMaster = $false
    )

    $startTime = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()

    $BranchRemovedMsg          = "---------------------------------------------------`nV�TEV '{0}' SMAZ�NA.`n---------------------------------------------------"
    $TempFolderCreatedMsg      = "---------------------------------------------------`nTEMP SLO�KA VYTVO�ENA NA CEST� '{0}'`n---------------------------------------------------"
    $FilesMovedToTempFolderMsg = "---------------------------------------------------`nSOUBORY P�EM�ST�NY DO TEMP SLO�KY`n---------------------------------------------------"
    $FilesMovedBackMsg         = "---------------------------------------------------`nSOUBORY P�EM�ST�NY ZP�T NA CESTU '{0}'`n---------------------------------------------------"
    $ChangesPushedMsg          = "---------------------------------------------------`nZM�NY PUSHNUTY DO NOV� V�TVE '{0}'`n---------------------------------------------------"
    $TempFilesRemovedMsg       = "---------------------------------------------------`nTEMP SOUBORY SMAZ�NY`n---------------------------------------------------"
    $BranchRemovedMsg          = "---------------------------------------------------`nV�TEV '{0}' SMAZ�NA`n---------------------------------------------------"
    $ScriptExecutionTimeMsg    = "---------------------------------------------------`n�AS B�HU: '{0}' ms.`n---------------------------------------------------"

    $TempFolderName            = "BC14_OBJECTS_TXT_2GIT_$(New-Guid)"
    $CommitMsg                 = "feat: changes from $((Get-Date).ToString("yyyy-dd-MM HH:mm:ss"))"
    $MergeMsg                  = "merged '{0}' to '{1}' @ $((Get-Date).ToString('yyyy-dd-MM HH:mm:ss.fff'))"

    Set-Location -Path $Path

    $sourcePath = Get-Location
    $tempPath = [System.IO.Path]::GetTempPath() + $TempFolderName

    if(Test-Path -Path (Join-Path $sourcePath ".git")){
        Remove-Item (Join-Path $sourcePath ".git") -Force -Recurse
    }

    if (!(Test-Path -Path $tempPath)) {
        New-Item -ItemType Directory -Path $tempPath
    }

    Write-Host $($TempFolderCreatedMsg -f $tempPath) -ForegroundColor Green

    Copy-Item -Path "$sourcePath\*" -Destination $tempPath -Recurse -Force
    Remove-Item -Path "$sourcePath\*" -Recurse

    Write-Host $FilesMovedToTempFolderMsg -ForegroundColor Green

    cd $sourcePath
    git init
    git remote add origin $RepoURL
    git fetch origin
    git checkout $MainBranchName
    git pull 

    Move-Item -Path "$tempPath\*" -Destination $sourcePath -Force
    write-host $($FilesMovedBackMsg -f $sourcePath) -ForegroundColor Green

    git checkout -b $BranchName
    git add .
    git commit -m $CommitMsg
    git push

    Write-Host $($ChangesPushedMsg -f $BranchName) -ForegroundColor Green

    Remove-Item -Path $tempPath -Recurse -Force

    Write-Host $($TempFilesRemovedMsg) -ForegroundColor Green

    if($MergeChangesToMaster){
        git checkout $MainBranchName
        git pull
        $GitMergeOutput = git merge --no-ff origin/$BranchName -m $($MergeMsg -f $BranchName, $MainBranchName) #--allow-unrelated-histories
        git push
        Write-Host $GitMergeOutput -ForegroundColor Yellow
    }

    if($DeleteSourceBranch){
        git checkout $MainBranchName
        git branch -D $BranchName
        git push
        Write-Host ($BranchRemovedMsg -f $BranchName) -ForegroundColor Green
    }

    Write-Host $($ScriptExecutionTimeMsg -f $([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() - $startTime)) -ForegroundColor Yellow
}
