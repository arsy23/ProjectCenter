    #####################################################
    # @Module Identity = 152bdaf9-5e3e-47b5-a1b9-9a236312bffe
    #----------------------------------------------------
    # @Module File Name = GitRepository-Initialization
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\git\GitRepository-Initialization.psm1'";
    # @CallUsage2 = AutoInvokeScript "GitRepository-Initialization";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/24/2020 19:54:49
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    AutoImportModule -FileName "Git-Configuration";
    #____________________________________________________#
    
        
function InitializeDefaultGitRepositoryInAProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = b13f0f94-f867-483e-8214-62cfb1509b68
    #----------------------------------------------------
    # @Function Name = InitializeDefaultGitRepositoryInAProject
    #----------------------------------------------------
    # @Usage = InitializeDefaultGitRepositoryInAProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/24/2020 19:56:51
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName;
    if ($InitialCommit) {
        AutoInvokeScript -FileName "Initialize-GitRepository"  -Arguments  @{"Path" = $projectBasePath } -Switches "-InitialCommit";
    }
    else
    {
        AutoInvokeScript -FileName "Initialize-GitRepository"  -Arguments  @{"Path" = $projectBasePath };
    }
    
}
function GitAddCommitToBranchOfProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Message,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [hashtable]
        $FileList,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string[]]
        $DirectoryList,
        [Parameter(Mandatory = $false)]
        [string]
        $BranchName,
        [switch]
        $CheckoutNewBranch,
        [switch]
        $CheckoutExistedBranch
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4210b97b-e8f9-46f8-b82b-66bd3b6b5553
    #----------------------------------------------------
    # @Function Name = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Usage = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 08/07/2020 15:15:54
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    if(([string]::IsNullOrEmpty($BranchName) -and ($CheckoutWithCreateBranch) -or ([string]::IsNullOrEmpty($BranchName) -and $CheckoutExistedBranch))){
        throw [System.Exception]::new('The Branch name cannot be null when the CheckoutWithCreateBranch is presented in the Source Code!');
    }
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    ConfigureGitTrueAutoClrf -ConfigurationOption Auto -Global;
    ConfigureGitSafeClrf -ConfigurationOption DisableWarning -Global;
    if($CheckoutNewBranch)
    {
        GitCheckoutNewBranch -ProjectName $projectBasePath -BranchName $BranchName;
    }
    elseif($CheckoutExistedBranch)
    {
        # $currentBranch = git -C $projectBasePath branch| Select-String -Pattern "\*";
        $currentBranch = GitReturnCurrentBranch -ProjectName $ProjectName;
        if($currentBranch -ne $BranchName)
        {
            $requestedBranchExsit = $false;
             foreach($branch in GitReturnBranchList) {
                if($branch -eq $BranchName)
                {
                    $requestedBranchExsit = $true;
                }
            }
            if($requestedBranchExsit)
            {
                if($currentBranch -ne $BranchName)
                {
                    GitCheckoutNewBranch -ProjectName $projectBasePath -BranchName $BranchName;
                }
            }
            elseif(!$requestedBranchExsit)
            {
                git -C $projectBasePath checkout -b $BranchName;
                PowershellLogger -Message "Git Created New Branch <$BranchName>. the branch checkouted by default" -LogType GitBranchCheckoutNew;
            }
        }
    }
    # git -C $projectBasePath commit --quiet --message $Message;
    UnStageAllChanges -ProjectName $ProjectName;
    GitAddDirectories -ProjectName $ProjectName -DirectoryList $DirectoryList -ThrowIfNotExistException;
    GitAddFiles -ProjectName $ProjectName  -FileList $FileList -ThrowIfNotExistException;
    git -C $projectBasePath commit --quiet --message $Message;
    PowershellLogger -Message "Add commit on <$BranchName> branch was successfully" -LogType GitCommited;
    ConfigureGitSafeClrf -ConfigurationOption EnableWarning -Global;
}
function GitStashAllChanges {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4210b97b-e8f9-46f8-b82b-66bd3b6b5553
    #----------------------------------------------------
    # @Function Name = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Usage = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 08/07/2020 15:15:54
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#

    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    ConfigureGitTrueAutoClrf -ConfigurationOption Auto -Global;
    ConfigureGitSafeClrf -ConfigurationOption DisableWarning -Global;
    #git restore --staged <file>
    git -C $projectBasePath stash;
    PowershellLogger -Message "Unstage all changes <$ProjectName> with the Git Stash." -LogType GitUnStageChanges;
    ConfigureGitSafeClrf -ConfigurationOption EnableWarning -Global;
}
function UnStageAllChanges {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4210b97b-e8f9-46f8-b82b-66bd3b6b5553
    #----------------------------------------------------
    # @Function Name = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Usage = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 08/07/2020 15:15:54
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    ConfigureGitTrueAutoClrf -ConfigurationOption Auto -Global;
    ConfigureGitSafeClrf -ConfigurationOption DisableWarning -Global;
    git -C $projectBasePath restore --staged *;
    PowershellLogger -Message "Unstage all changes <$ProjectName> with the Git Restore All." -LogType GitUnStageChanges;
    ConfigureGitSafeClrf -ConfigurationOption EnableWarning -Global;
}
function GitCheckoutBranch {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $false)]
        [string]
        $BranchName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4210b97b-e8f9-46f8-b82b-66bd3b6b5553
    #----------------------------------------------------
    # @Function Name = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Usage = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 08/07/2020 15:15:54
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#

    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    ConfigureGitTrueAutoClrf -ConfigurationOption Auto -Global;
    ConfigureGitSafeClrf -ConfigurationOption DisableWarning -Global;
    $currentBranch = GitReturnCurrentBranch -ProjectName $ProjectName;

    if($currentBranch -ne $BranchName)
    {
        git -C $projectBasePath checkout $BranchName;
        PowershellLogger -Message "Git Checkout Branch <$BranchName>." -LogType GitBranchCheckoutNew;
    }
    ConfigureGitSafeClrf -ConfigurationOption EnableWarning -Global;
}
function GitNewBranch {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $false)]
        [string]
        $BranchName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4210b97b-e8f9-46f8-b82b-66bd3b6b5553
    #----------------------------------------------------
    # @Function Name = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Usage = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 08/07/2020 15:15:54
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#

    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    ConfigureGitTrueAutoClrf -ConfigurationOption Auto -Global;
    ConfigureGitSafeClrf -ConfigurationOption DisableWarning -Global;
    $currentBranch = GitReturnCurrentBranch -ProjectName $ProjectName;

    if($currentBranch -ne $BranchName)
    {
        git -C $projectBasePath branch $BranchName;
        PowershellLogger -Message "Git Create New Branch <$BranchName>." -LogType GitBranchNew;
    }
    else{
        PowershellLogger -Message "Git Cannot Create New Branch from current branch with name <$BranchName>." -LogType GitBranchNew;
    }
    ConfigureGitSafeClrf -ConfigurationOption EnableWarning -Global;
}
function GitCheckoutNewBranch {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $false)]
        [string]
        $BranchName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4210b97b-e8f9-46f8-b82b-66bd3b6b5553
    #----------------------------------------------------
    # @Function Name = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Usage = GitAddCommitToBranchOfProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 08/07/2020 15:15:54
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#

    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    ConfigureGitTrueAutoClrf -ConfigurationOption Auto -Global;
    ConfigureGitSafeClrf -ConfigurationOption DisableWarning -Global;
    $currentBranch = GitReturnCurrentBranch -ProjectName $ProjectName;

    if($currentBranch -ne $BranchName)
    {
        git -C $projectBasePath checkout -b $BranchName;
        PowershellLogger -Message "Git Checkout New Branch <$BranchName>." -LogType GitBranchCheckoutNew;
    }
    ConfigureGitSafeClrf -ConfigurationOption EnableWarning -Global;
}
function GitAddDirectories {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $true)]
        [string[]]
        $DirectoryList,
        [switch]
        $ThrowIfExistException,
        [switch]
        $ThrowIfNotExistException
    )
    AutoImportModule -FileName "Folder-Lookup";
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    foreach ($folder in $DirectoryList) {
        $folderPath = FolderLookingupByNameInSubFolders -Path $projectBasePath -FolderName $folder -ThrowIfExistException:$ThrowIfExistException -ThrowIfNotExistException:$ThrowIfNotExistException;
        git -C $projectBasePath add $folderPath;
       PowershellLogger -Message "The Folder <$folder> added with git command." -LogType GitUnStageChanges;
    }
}
function GitAddFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $true)]
        [hashtable]
        $FileList,
        [switch]
        $ThrowIfNotExistException
    )
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    foreach ($file in $FileList.Keys) {
        $filePath = FileLookingupByNameAndExtension -Path $projectBasePath -FileName $file -FileExtension $FileList[$file] -ThrowIfNotExistException:$ThrowIfNotExistException;
        git -C $projectBasePath add $filePath;
        PowershellLogger -Message "The file <$($file).$($FileList[$file])> added with git command." -LogType GitUnStageChanges;
    }
}
function GitReturnCurrentBranch {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    return git -C $projectBasePath branch --show-current;

}
function GitReturnBranchList {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    return git -C $projectBasePath branch --list;
}
