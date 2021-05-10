    #####################################################
    # @Module Identity = aba35765-184b-4f06-ae47-cb80be2a36fd
    #----------------------------------------------------
    # @Module File Name = Project-Path-Utilities
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\project-development\utilities\Project-Path-Utilities.psm1'";
    # @CallUsage2 = AutoInvokeScript "Project-Path-Utilities";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 07/01/2020 19:41:12
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
function PrepareComponentPresentationOutputPath {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $PresentationFolderName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $OutputPath,
        [switch]
        $MakeRelative 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 03b98605-016f-4f61-937b-0cc52b73b401
    #----------------------------------------------------
    # @Function Name = PrepareComponentPresentationOutputPath
    #----------------------------------------------------
    # @Usage = PrepareComponentPresentationOutputPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 07/01/2020 19:41:50
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $outputFolderPath = $OutputPath.Trim().Replace('\', '/');
    $outputFolderPath = ReplaceAnyOfCharactersWith -Text $outputFolderPath -Characters @( '\', '@', '`', '"', '*', '^', '|') -IncludeIllegalChars;
    if ($outputFolderPath.StartsWith('.'))
    {
        $outputFolderPath = $outputFolderPath.Remove(0, 1);
    }
    if ($outputFolderPath.StartsWith('/'))
    {
        $outputFolderPath = $outputFolderPath.Remove(0, 1);
    }
    if($outputFolderPath.EndsWith('/'))
    {
        $outputFolderPath = $outputFolderPath.Remove($outputFolderPath.Length -1 , 1);
    }
    if(!$outputFolderPath.StartsWith('/Source'))
    {
        $outputFolderPath = "Source/" + $outputFolderPath;
    }
    if($MakeRelative){
        $razorPageProjectPath = PrepareAbsolutePath -Path $outputFolderPath;
    }
    else{
        $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
        $razorPageProjectPath = PrepareAbsolutePath -Path ($projectBasePath +"\" + $outputFolderPath);
    }
    $razorPageProjectPath = $razorPageProjectPath + "/Presentation/" + $PresentationFolderName;
    if(!$razorPageProjectPath.EndsWith('/Source'))
    {
        $razorPageProjectPath = $razorPageProjectPath + "/Source";
    }
    return PrepareRelativePath -Path $razorPageProjectPath;
}

