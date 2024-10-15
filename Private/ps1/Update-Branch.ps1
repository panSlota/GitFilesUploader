function Update-Branch{

    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName,

        [Parameter(Mandatory = $true)]
        [string]$MainBranchName
    )

    git checkout $MainBranchName
    git pull

    $Branches = git branch --list | ForEach-Object { $_.Trim() }
    if($Branches -contains $BranchName -or $branches -contains "remotes/origin/$branchName"){
        git checkout $BranchName
    }
    else{
        (git checkout -b $BranchName) 2>&1 | Out-Null
        (git push -u origin $BranchName) 2>&1 | Out-Null
    }
}
