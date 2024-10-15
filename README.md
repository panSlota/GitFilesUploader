<pre>
GitFilesUploader  
|  
|__ GitFilesUploader.psd1  
|__ GitFilesUploader.psm1  
|__ Private  
|	|  
|	|__ ps1  
|		|  
|		|__ Get-GitRepo.ps1  
|		|__ Move-ChangesToMaster.ps1  
|		|__ New-GitRepo.ps1  
|		|__ Test-GitRepo.ps1  
|   |__ Update-Branch.ps1
|__ Public  
|	|  
|	|__ ps1  
|		|  
|		|__ Push-ChangesToRepo.ps1  
|
|__init.ps1
|__README.md
</pre>

Import-Module GitFilesUploader.psd1 -Verbose

Push-ChangesToRepo -Path <PATH> -RepoURL <REPO_URL> -BranchName <BRANCH_NAME> -MainBranchName <MASTER> -DeleteSourceBranch $true/$false
vychozi hodnota parametru DeleteSourceBranch je $false
