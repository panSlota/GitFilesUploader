<pre>
GitFilesUploader  
|  
|__ GitFilesUploader.psd1  
|__ GitFilesUploader.psm1  
|
|__ Public  
|	|  
|	|__ ps1  
|	     |  
|	     |__ Push-ChangesToRepo.ps1  
|
|__init.ps1
|__README.md
</pre>

Import-Module GitFilesUploader.psd1 -Verbose

Push-ChangesToRepo -Path <PATH> -RepoURL <REPO_URL> -BranchName <BRANCH_NAME> -MainBranchName <MASTER> -DeleteSourceBranch $true/$false -MergeChangesToMaster $true/$false

vychozi hodnota parametru DeleteSourceBranch je **$false**

vychozi hodnota parametru MergeChangesToMaster je **$false**

skript smaze slozku .git pokud v adresari je

premisti soubory z adresare na temp lokaci

inicializuje repozitar, nastavi remote url (RepoURL), pullne master (MainBranchName)

premisti soubory z temp lokace zpet do adresare

checkoutne do novy vetve (BranchName), prida zmeneny soubory, commitne (commit message obsahuje dateTime) & pushne

smaze soubory z temp lokace

pokud je hodnota parametru MergeChangesToMaster = $true, provede merge nove vetve do masteru (merge message obsahuje nazev nove vetve + dateTime)

pokud je hodnota parametru DeleteSourceBranch = $true, smaze novou vetev
