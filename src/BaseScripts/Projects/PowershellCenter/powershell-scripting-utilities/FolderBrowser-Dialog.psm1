#####################################################
# @Module Identity = 9cc27971-3030-4abc-b8a5-021364c9f7e4  
#----------------------------------------------------
# @Module File Name = FolderBrowser-Dialog.psm1
#----------------------------------------------------
# @Module Description = Provide folder dialog in powershell console.
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Wednesday, June 3, 2020 1:13:27 PM
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}
#____________________________________________________#

function ShowFolderBrowserDialogForPowershellCenter {

    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0eb305ff-4032-4932-a9ee-f4588bca727c
    #----------------------------------------------------
    # @Function Name = ShowFolderBrowserDialog
    #----------------------------------------------------
    # @Usage = ShowFolderBrowserDialog -MakeRelative
    #----------------------------------------------------
    # @Description = Show a folder dialog in the PowershellCenter path.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:40:24 PM
    #____________________________________________________#   
    $Description = "Select folder in the PowershellCenter project";
    $selectedPath = ShowFolderBrowserDialogForPath -Path $global:powershellCenterPath -Description $Description;
    return $selectedPath;
}
function ShowFolderBrowserDialogForProjects {
    param(
        [switch]
        $ResolveFolderName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0eb305ff-4032-4932-a9ee-f4588bca727c
    #----------------------------------------------------
    # @Function Name = ShowFolderBrowserDialog
    #----------------------------------------------------
    # @Usage = ShowFolderBrowserDialog -MakeRelative
    #----------------------------------------------------
    # @Description = Show a folder dialog in the PowershellCenter path.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:40:24 PM
    #____________________________________________________#   
    $selectedPath = ResolveProjectsPath;
    $Description = "Select folder on the Projects";
    $selectedPath = ShowFolderBrowserDialogForPath -Path $selectedPath -Description $Description -IncludeInSubFolders;
    if($ResolveFolderName)
    {
        $selectedPath = Split-Path -Path $selectedPath -Leaf;
    }
    return $selectedPath;
}
function ShowFolderBrowserDialogForSelectOneOfProjectInProjects {
    param(
        [switch]
        $ReturnProjectName,
        [switch]
        $IncludeInSubFolders
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0eb305ff-4032-4932-a9ee-f4588bca727c
    #----------------------------------------------------
    # @Function Name = ShowFolderBrowserDialog
    #----------------------------------------------------
    # @Usage = ShowFolderBrowserDialog -MakeRelative
    #----------------------------------------------------
    # @Description = Show a folder dialog in the PowershellCenter path.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:40:24 PM
    #----------------------------------------------------
    AutoImportModule -FileName "Path";
    #____________________________________________________#   
    $Description = "Select a project root folder on the Projects";
    if($IncludeInSubFolders)
    {
        $Description += " Include Projects Sub-Folders"
    }
    $ProjectsPath = PrepareAbsolutePath -Path (ResolveProjectsPath) -ExcludeLastBackSlash;
    do {
        $selectedPath = PrepareAbsolutePath -Path (ShowFolderBrowserDialogForPath -Path $ProjectsPath -Description $Description -IncludeInSubFolders:$IncludeInSubFolders) -ExcludeLastBackSlash;
        $selectedFolderParent = PrepareAbsolutePath -Path (Split-Path -Path $selectedPath -Parent) -ExcludeLastBackSlash;
        $_powershellCenterPath = PrepareAbsolutePath -Path $global:powershellCenterPath -ExcludeLastBackSlash;
        # //not tested
        $inProjectsPath = $ProjectsPath -ne (Split-Path -Path $selectedPath -Parent);
    } while (($inProjectsPath)  -or ($selectedFolderParent -ne $ProjectsPath) -or ($selectedPath -eq $_powershellCenterPath) -and !$IncludeInSubFolders);
    if($ReturnProjectName)
    {
        return Split-Path -Path $selectedPath -Leaf;
    }
    return $selectedPath;
}

function ShowFolderBrowserDialogForPath {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Description,
        [Parameter(Mandatory = $false)]
        [string]
        $Path,
        [switch]
        $IncludeInSubFolders
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0eb305ff-4032-4932-a9ee-f4588bca727c
    #----------------------------------------------------
    # @Function Name = ShowFolderBrowserDialog
    #----------------------------------------------------
    # @Usage = ShowFolderBrowserDialog -MakeRelative
    #----------------------------------------------------
    # @Description = Show a folder dialog in the PowershellCenter path.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:40:24 PM
    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\Screens.psm1";
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\Path.psm1";
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\folder\Folder-Lookup.psm1";
    #____________________________________________________#   

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = [Environment]::GetFolderPath('Desktop');
    }
    $selectedPath = PrepareAbsolutePath -Path $Path;
    $pathIsValid = (Test-Path -Path $selectedPath -ErrorAction SilentlyContinue);
    if (!$pathIsValid) {
        throw [System.Exception]::new("the path <$selectedPath> is invalid!");
    }
    if ([string]::IsNullOrEmpty($Description)) {
        $Description = "Select a folder on $selectedPath";
    }
    else {
        $Description = $Description.Trim();
    }
    Add-Type -AssemblyName System.Windows.Forms;
    $screenResolution = GetScreenResolution;
    while ($dialogResult -ne [Windows.Forms.DialogResult]::OK) {
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{ 
            SelectedPath        = $selectedPath;
            ShowNewFolderButton = $true;
            Description         = $Description;
        }
        $dialogResult = $folderBrowser.ShowDialog((
                New-Object System.Windows.Forms.Form -Property @{
                    Name     = "WrapperForm";
                    TopMost  = $true;
                    TopLevel = $true ;
                    Width    = $screenResolution.Width;
                    Height   = $screenResolution.Height;
                }));
        if($dialogResult -eq [Windows.Forms.DialogResult]::Cancel -or [string]::IsNullOrEmpty($folderBrowser.SelectedPath))
        {
            $dialogResult = [Windows.Forms.DialogResult]::Cancel;
            continue;
        }
        $leafFolderName = Split-Path -Path $folderBrowser.SelectedPath -Leaf;
        $parentFolderPath = Split-Path -Path $folderBrowser.SelectedPath -Parent;
        if([string]::IsNullOrEmpty($parentFolderPath) -or "PowershellCenter" -eq $leafFolderName){
            $dialogResult = [Windows.Forms.DialogResult]::Cancel;
            continue;
        }
        else{
            $parentFolderName = $parentFolderPath | Split-Path -Leaf;
        }
        $selectedPathLeaf = Split-Path -Path $selectedPath -Leaf;
        if ($IncludeInSubFolders) {
            $existInProjectsSubFolders =  FolderExistInProjects -ProjectName (Split-Path -Path $folderBrowser.SelectedPath  -Leaf);
            if($existInProjectsSubFolders){
                break;
            }

        }
        else {
            if($selectedPathLeaf -eq $leafFolderName){
                break;
            }      
        }

        $leafFolderExist = FolderExistInSubFolders -Path $selectedPath -FolderName $leafFolderName;
        $parentFolderExist = FolderExistInSubFolders -Path $selectedPath -FolderName $parentFolderName;
        if (!$leafFolderExist -or (!$parentFolderExist -and !($parentFolder -ne $selectedPathLeaf) -and $parentFolderName -ne "Projects")) {
            $dialogResult = [Windows.Forms.DialogResult]::Cancel;
        }
    }
    return $folderBrowser.SelectedPath;
}