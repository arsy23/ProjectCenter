#####################################################
# @Module Identity = 2d915155-78da-4363-b65c-8be1fe1ee8ba   
#----------------------------------------------------
# @Module File Name = Projects.psm1
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Monday, June 1, 2020 3:49:53 PM
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in (Get-Location).Path.Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
#____________________________________________________#
function ResolveProjectsPath {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = d756b964-4f65-425c-8ffc-7eb54372ecf6    
    #----------------------------------------------------
    # @Function Name = ResolveProjectsPath
    #----------------------------------------------------
    # @Usage = ResolveProjectsPath
    #----------------------------------------------------
    # @Description = Resolve 'AValuableCollection\Projects' absolute path from the Powershell script root path.
    #----------------------------------------------------
    # @Return = Return the Projects path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 3:49:53 PM
    #____________________________________________________#

    if([string]::IsNullOrEmpty($global:ProjectsPath)){$global:ProjectsPath = ""; foreach ($pathPart in (Get-Location).Path.Split('\')) { $global:ProjectsPath += "$pathPart\"; if ($pathPart -eq "Projects"){break;} }}
    return $global:ProjectsPath.Replace('\\', '\');
}        
function GetProjectsChildPath {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = a701a4e1-8fa8-4d40-be9c-4b34797b66e6
    #----------------------------------------------------
    # @Function Name = GetProjectsChildPath
    #----------------------------------------------------
    # @Usage = GetProjectsChildPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/14/2020 14:40:27
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    do {   
        $selectedPath = ShowFolderBrowserDialogForProjects;
        $ProjectsPath = ResolveProjectsPath;
        $basePathOfSelectedPath = "";
        foreach ($pathPart in ($selectedPath).Split('\')) { 
            $basePathOfSelectedPath += "$pathPart\";
            if ($pathPart -eq "Projects") {
                break;
            }
        }
        if ($basePathOfSelectedPath -eq $ProjectsPath) {
            return $selectedPath;
        }
    } while ($basePathOfSelectedPath -ne $ProjectsPath);
}
function ProjectLookupInProjects {
    param([Parameter(Mandatory = $true)]
    [string]
    $ProjectName,
    [switch]
    $ThrowIfNotExistException,
    [switch]
    $ThrowIfExistException,
    [switch]
    $MakeRelative,
    [switch]
    $InRoot,
    [switch]
    $ReturnAllResult
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = a701a4e1-8fa8-4d40-be9c-4b34797b66e6
    #----------------------------------------------------
    # @Function Name = GetProjectsChildPath
    #----------------------------------------------------
    # @Usage = GetProjectsChildPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/14/2020 14:40:27
    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\folder\Folder-Lookup.psm1";
    #____________________________________________________#
    $projectBasePaths = [string]::Empty;
    $ProjectsPath = (ResolveProjectsPath);
    if($InRoot)
    {
        $projectBasePaths = FolderLookingupByNameInRootDirectory -Path $ProjectsPath -FolderName $ProjectName -MakeRelative:$MakeRelative -ThrowIfExistException:$ThrowIfExistException -ThrowIfNotExistException:$ThrowIfNotExistException;
    }
    else{
        $projectBasePaths = FolderLookingupByNameInSubFolders -Path $ProjectsPath -ReturnAllResult:$ReturnAllResult -FolderName $ProjectName -MakeRelative:$MakeRelative -ThrowIfExistException:$ThrowIfExistException -ThrowIfNotExistException:$ThrowIfNotExistException;
    }
    if(($projectBasePaths.Count -gt 1) -and ($ThrowIfExistException) -and ($ThrowIfNotExistException.IsPresent -eq $false))
    {
        throw [System.Exception]::new("More than one project find in the Projects path with <$ProjectName>!");
    }
    if(($projectBasePaths.Count -lt 1) -and ($ThrowIfExistException.IsPresent -eq $false) -and ($ThrowIfNotExistException))
    {
        throw [System.Exception]::new("Not Find project <$ProjectName>  in the Projects path!");
    }
    return $projectBasePaths;
}

function FolderExistInProjects {
    param([Parameter(Mandatory = $true)]
    [string]
    $ProjectName,
    [switch]
    $ThrowIfNotExistException,
    [switch]
    $ThrowIfExistException,
    [switch]
    $InRoot
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = a701a4e1-8fa8-4240-be9c-4b34797b66e6
    #----------------------------------------------------
    # @Function Name = 
    #----------------------------------------------------
    # @Usage = 
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/14/2020 14:40:27
    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\folder\Folder-Lookup.psm1";
    #____________________________________________________#
    if($InRoot)
    {
        $projectExist = FolderExistRootDirectory -Path (ResolveProjectsPath) -FolderName $ProjectName -ThrowIfExistException:$ThrowIfExistException -ThrowIfNotExistException:$ThrowIfNotExistException;
    }
    else{
        $projectExist = FolderExistInSubFolders -Path (ResolveProjectsPath) -FolderName $ProjectName -ThrowIfExistException:$ThrowIfExistException -ThrowIfNotExistException:$ThrowIfNotExistException;
    }
    $projectBasePath = $null;
    if(($projectBasePath.Count -gt 1) -and ($ThrowIfExistException) -and ($ThrowIfNotExistException.IsPresent -eq $false))
    {
        throw [System.Exception]::new("More than one project find in the Projects path with <$ProjectName>!");
    }
    return $projectExist;

}
function GetSubFoldersCountOfProjects {

    return @([System.IO.Directory]::EnumerateDirectories($(ResolveProjectsPath) , "*", "AllDirectories")).Count;
}