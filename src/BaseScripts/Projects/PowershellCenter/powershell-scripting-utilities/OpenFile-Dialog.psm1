#####################################################
# @Module Identity = 9cc27971-3030-4abc-b8a5-021364c9f7e4  
#----------------------------------------------------
# @Module File Name = OpenFile-Dialog.psm1
#----------------------------------------------------
# @Module Description = Provide file dialog in powershell console.
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Thursday, June 4, 2020 12:10:40 AM
#----------------------------------------------------
if ([string]::IsNullOrEmpty($global:powershellCenterPath)) { $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } } }

#____________________________________________________#
function ShowOpenFileDialogForProjects {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileTypeTitle,
        [Parameter(Mandatory = $false)]
        [string]
        $Filter,
        [switch]
        $Multiselect,
        [switch]
        $ResolveFileName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4d9f8461-fe3d-4e1d-93db-dfc751536944
    #----------------------------------------------------
    # @Function Name = ShowOpenFileDialog
    #----------------------------------------------------
    # @Usage = ShowOpenFolderDialog -MakeRelative
    #----------------------------------------------------
    # @Description = Show a folder dialog in the PowershellCenter path.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path for selected file.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Thursday, June 4, 2020 12:10:40 AM
    #----------------------------------------------------
    AutoImportModule -FileName "Screens"
    AutoImportModule -FileName "Path"
    #____________________________________________________#   
    $ProjectsPath = ResolveProjectsPath;
    $initialDirectory = $ProjectsPath;
    $text = $Multiselect |??? "files" : "file";
    $Title = "Select the <$FileTypeTitle> $text on the Projects";
    $selectedPath = ShowOpenFileDialogForPath -Path $initialDirectory -Title $Title -Filter $Filter -Multiselect:$Multiselect;

    $output = $ResolveFileName |??? (Split-Path -Path $selectedPath -Leaf) : $selectedPath;
    return $output;
}
function ShowOpenFileDialogForPowershellCenter {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileTypeTitle,
        [Parameter(Mandatory = $false)]
        [string]
        $Filter,
        [switch]
        $Multiselect
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4d9f8461-fe3d-4e1d-93db-dfc751536944
    #----------------------------------------------------
    # @Function Name = ShowOpenFileDialog
    #----------------------------------------------------
    # @Usage = ShowOpenFolderDialog -MakeRelative
    #----------------------------------------------------
    # @Description = Show a folder dialog in the PowershellCenter path.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path for selected file.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Thursday, June 4, 2020 12:10:40 AM
    #----------------------------------------------------
    AutoImportModule -FileName "Screens";
    AutoImportModule -FileName "Path";
    #____________________________________________________#   
    $initialDirectory = $global:powershellCenterPath;
    $text = $Multiselect |??? "files" : "file";
    $Title = "Select the <$FileTypeTitle> $text on the PowershellCenter project";
    $selectedPath = ShowOpenFileDialogForPath -Path $initialDirectory -Title $Title -Filter $Filter -Multiselect:$Multiselect;
    return $selectedPath;
}
function ShowOpenFileDialogForPath {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Title,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [Parameter(Mandatory = $false)]
        [string]
        $Filter,
        [switch]
        $Multiselect,
        [switch]
        $ResolveFileName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4d9f8461-fe3d-4e1d-93db-dfc751536944
    #----------------------------------------------------
    # @Function Name = ShowOpenFileDialog
    #----------------------------------------------------
    # @Usage = ShowOpenFolderDialog -MakeRelative
    #----------------------------------------------------
    # @Description = Show a folder dialog in the PowershellCenter path.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path for selected file.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Thursday, June 4, 2020 12:10:40 AM
    #----------------------------------------------------
    AutoImportModule -FileName "Screens";
    AutoImportModule -FileName "Path";
    AutoImportModule -FileName "File-Lookup";
    #____________________________________________________#   
    if($Multiselect)
    {
        _multiselect = $true;
    }
    if ([string]::IsNullOrEmpty($Path)) {
        $Path = [Environment]::GetFolderPath('Desktop');
    }
    $initialDirectory = PrepareAbsolutePath -Path $Path;
    $pathIsValid = (Test-Path -Path $initialDirectory -ErrorAction SilentlyContinue);
    if (!$pathIsValid) {
        throw [System.Exception]::new("the path <$initialDirectory> is invalid!");
    }

    if ([string]::IsNullOrEmpty($Title)) {
        $Title = "Select a file in <$initialDirectory>";
    }
    else {
        $Title = $Title.Trim();
    }

    Add-Type -AssemblyName System.Windows.Forms;
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = $initialDirectory;
        Filter           = $Filter;
        Title            = $Title;
        Multiselect      = $_multiselect;
    }

    $screenResolution = GetScreenResolution;
    while ($dialogResult -ne [Windows.Forms.DialogResult]::OK) {
        
        $dialogResult = $openFileDialog.ShowDialog((
                New-Object System.Windows.Forms.Form -Property @{
                    Name     = "WrapperForm";
                    TopMost  = $true;
                    TopLevel = $true ;
                    Width    = $screenResolution.Width;
                    Height   = $screenResolution.Height;
                }));
                
        if([string]::IsNullOrEmpty($openFileDialog.FileName)){
            continue;
        }
        $selectedPathIsValid = $openFileDialog.CheckFileExists -or !$openFileDialog.CheckPathExists;
        $selectedFileFullName = Split-Path -Path $openFileDialog.FileName -Leaf;
        $selectedFileName = [System.IO.Path]::GetFileNameWithoutExtension($selectedFileFullName);
        $selectedFileExtension = [System.IO.Path]::GetExtension($selectedFileFullName);
        if (!$selectedPathIsValid) {
            $dialogResult = [Windows.Forms.DialogResult]::Cancel;
        }
        elseif (![string]::IsNullOrEmpty($selectedFileExtension) -and ![string]::IsNullOrEmpty($selectedFileName)) {
            $fileExistInSubFolders = FileExistInSubFolders -Path $initialDirectory -FileName $selectedFileName -FileExtension $selectedFileExtension;
            if (!$fileExistInSubFolders) {
                $dialogResult = [Windows.Forms.DialogResult]::Cancel;
            }
        }
    }
    if($ResolveFileName){
        return $openFileDialog.SafeFileName
    }
    return $openFileDialog.FileName;
}