#####################################################
# @Module Identity = 35dd5a46-8480-4153-bc3c-f78a26e5e7e6
#----------------------------------------------------
# @Module File Name = Dotnet-Solution.psm1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\dotnet\Dotnet-Solution.psm1'";
# @Usage2 = AutoInvokeScript "Dotnet-Solution";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/04/2020 09:30:53
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule -FileName "File-Lookup";
#____________________________________________________#
    
function AddSolutionFolder {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        # This parameter accept relative folder structure value. e.g. "Source/Core/Test"
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderName,
        [switch]
        $CreatePhysicalFolder
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 475f59f1-7a3d-4c22-ae83-8a63ac71fdf6
    #----------------------------------------------------
    # @Function Name = AddSolutionFolder
    #----------------------------------------------------
    # @Usage = AddSolutionFolder
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 09:58:23
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $slnFilePath = FileLookingupByNameAndExtension -FileName $SolutionFileName -FileExtension ".sln" -Path $projectBasePath -ThrowIfNotExistException;
    SolutionFolderExist -SolutionFolderName $SolutionFolderName -ProjectName $ProjectName -SolutionFileName $SolutionFileName -ThrowIfExistException;
    $_slnFolderName = PrepareSolutionFolderName -SolutionFolderName $SolutionFolderName;
    $content = "`n" + (MakeSolutionFolderInformationRaw -SolutionFolderName $_slnFolderName -ProjectName $ProjectName -SolutionFileName $SolutionFileName).Replace('{}', "{$(New-Guid)}") + "`nEndProject`n";
    $solutionFile = Get-Content -Path $slnFilePath -ErrorAction SilentlyContinue -Raw;
    $index = $solutionFile.IndexOf("Global");
    $solutionFile = $solutionFile.Insert( $index, $content);
    Set-Content -Path $slnFilePath -Value $solutionFile -Force;
    PowershellLogger -Message "Solution folder <$_slnFolderName> created for <$slnFilePath> solution."  -LogType Success;

    if ($CreatePhysicalFolder) {
        mkdir -Path "$projectBasePath/$_slnFolderName" -Force | Out-Null;
        PowershellLogger -Message "Physical folder <$_slnFolderName> created in <$slnFilePath> path." -LogType Success;
    }
}
function AddExistingFileToSolutionFolder {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ExistingFilePath,
        [switch]
        $CreatePhysicalFolder
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 475f59f1-7a3d-4c22-ae83-8a63ac71fdf6
    #----------------------------------------------------
    # @Function Name = AddSolutionFolder
    #----------------------------------------------------
    # @Usage = AddSolutionFolder
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 09:58:23
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName;
    FileExistInSubFolders -Path $projectBasePath -FileName $SolutionFileName -FileExtension ".sln" -ThrowException | Out-Null;
    SolutionFolderExist -ProjectName $ProjectName -SolutionFileName $SolutionFileName -SolutionFolderName $SolutionFolderName -ThrowIfNotExistException
    $filePath = PrepareAbsolutePath -Path $ExistingFilePath;
    $existingFileItem = Get-Item -Path $filePath;
    $fileDirectoryName = [System.IO.Path]::GetDirectoryName($filePath);
    $fileExtension = [System.IO.Path]::GetExtension($filePath);
    $fileName = !([string]::IsNullOrEmpty($existingFileItem.BaseName)) | ??? $existingFileItem.BaseName : "";
    $inRootOfProject = FileExistInRootPath -FileBasePath $fileDirectoryName -FileExtension $fileExtension -FileName $fileName;
    if (!$inRootOfProject) {
        throw [System.Exception]::new("The existing file <$filePath> is not in root path of project!");
    }
    FileExistInSubFolders -Path $existingFileItem.DirectoryName -FileName $fileName -FileExtension $existingFileItem.Extension -ThrowException | Out-Null;
    $slnFilePath = FileLookingupByNameAndExtension -FileName $SolutionFileName -FileExtension ".sln"  -Path $projectBasePath -ThrowIfNotExistException;
    $earlyHaveFileItem = EarlySolutionFolderHaveSolutionItem -SolutionFileName $SolutionFileName -ProjectName $ProjectName -SolutionFolderName $SolutionFolderName;
    $slnFolderInfoRaw = MakeSolutionFolderInformationRaw -SolutionFileName $SolutionFileName -SolutionFolderName $SolutionFolderName -ProjectName $ProjectName;
    $solutionFile = Get-Content -Path $slnFilePath -ErrorAction SilentlyContinue -Raw ;
    $index = $solutionFile.IndexOf($slnFolderInfoRaw);
    $index += $slnFolderInfoRaw.Length;
    if ($earlyHaveFileItem) {
        $index += "`n`tProjectSection(SolutionItems) = preProject".Length;
        $content = "`n`t`t$($existingFileItem.Name) = $($existingFileItem.Name)";
    }
    else {
        $content = "`n`tProjectSection(SolutionItems) = preProject`n`t`t$($existingFileItem.Name) = $($existingFileItem.Name)`n`tEndProjectSection";
    }
    if ($index -eq -1) {
        throw [System.Exception]::new("The Solution folder <$SolutionFolderName> with specified info not find in <$slnFilePath>!");
    }
    $solutionFile = $solutionFile.Insert($index, $content);
    Set-Content -Path $slnFilePath -Value $solutionFile -Force;
    PowershellLogger -Message "Solution item <$($existingFileItem.Name)> added <$SolutionFolderName> solution folder in the <$slnFilePath> solution." -LogType Success -IncludeExtraLine -IncludeBottomExtraLine;
}
function CreateAddFileToSolutionFolder {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileContent,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $RelativeFilePathToProjectBasePath,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileExtension,
        [switch]
        $CreatePhysicalFolder
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 475f59f1-7a3d-4c22-ae83-8a63ac71fdf6
    #----------------------------------------------------
    # @Function Name = AddSolutionFolder
    #----------------------------------------------------
    # @Usage = AddSolutionFolder
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 09:58:23
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
    $slnFilePath = FileLookingupByNameAndExtension -FileName $SolutionFileName  -FileExtension ".sln" -Path ResolveProjectsPath -ThrowIfNotExistException | Out-Null;
    $projectBasePath = [System.IO.Path]::GetDirectoryName($slnFilePath);
    $newFilePath = (PrepareAbsolutePath -Path "$($projectBasePath)\$($RelativeFilePathToProjectBasePath)\" -ExcludeLastBackSlash);
    $newFileFullName = "$($FileName).$($FileExtension)";
    $newFileFullPath = "$($newFilePath)\$($newFileFullName)";
    New-Item -Path $newFilePath  -FileName $newFileFullName -ItemType "File" -Value $FileContent |Out-Null;
    PowershellLogger -Message "File <$newFileFullName> created in <$newFilePath>" -LogType "Success";

    AddExistingFileToSolutionFolder -SolutionFileName $SolutionFileName -ProjectName $ProjectName -ExistingFilePath $newFileFullPath -SolutionFolderName $SolutionFolderName;

}
function SolutionFolderExist {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderName,
        [switch]
        $ThrowIfNotExistException,
        [switch]
        $ThrowIfExistException,
        [switch]
        $WriteWarningLog
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = d3a5841d-4f54-44c5-a7d6-1356fa30dbbc
    #----------------------------------------------------
    # @Function Name = SolutionFolderExist
    #----------------------------------------------------
    # @Usage = SolutionFolderExist
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 10:00:24
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    FileLookingupByNameAndExtension -FileName $SolutionFileName  -FileExtension ".sln" -Path $projectBasePath -ThrowIfNotExistException | Out-Null;
    $slnFileAttributes = SolutionFileAttributes -SolutionFileName $SolutionFileName -ProjectName $ProjectName;
    $slnFolderExist = $false;
   
    foreach ($info in $slnFileAttributes) {
        $fileExtension = (Get-Item -Path "$projectBasePath\$($info.File)" -ErrorAction SilentlyContinue).Extension;
        $hasFileExtension = [string]::IsNullOrEmpty($fileExtension);
        $fileExist = Test-Path -Path "$projectBasePath\$($info.File)";
        $isSolutionItem = $fileExist -and $hasFileExtension;
        if ($isSolutionItem) {
            $slnFolderExist = $false;
        }
        if ($info.Name -eq $SolutionFolderName) { 
            $slnFolderExist = $true;
        }   
    }
    if ($ThrowIfNotExistException -and !$slnFolderExist) {
        throw [System.Exception]::new("The Solution folder <$SolutionFolderName> not exist in the <$SolutionFileName> solution file.");
    }
    elseif ($ThrowIfExistException -and $slnFolderExist) {
        throw [System.Exception]::new("The Solution folder <$SolutionFolderName> earley exist in the <$SolutionFileName> solution file.");
    }
    elseif ($WriteWarningLog -and $slnFolderExist) {
        PowershellLogger -Message "The Solution folder <$SolutionFolderName> early exist in the <$SolutionFileName> solution file." -LogType Warning
    }
    elseif(!$ThrowIfNotExistException -and !$WriteWarningLog -and !$ThrowIfExistException) {
        return $slnFolderExist;
    }
}
function SolutionFolderProjectGuid {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = c19cab76-313a-47dd-94ae-f91edf17c281
    #----------------------------------------------------
    # @Function Name = DotnetSolutionGuids
    #----------------------------------------------------
    # @Usage = DotnetSolutionGuids
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 10:42:47
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #____________________________________________________#
    if ($isSameProgram) {
        $slnFolderProjectGuidEmpty = $([string]::IsNullOrEmpty($slnFolderInformation.SolutionFolderProjectGuid))
        if ($slnFolderProjectGuidEmpty) {
            throw [System.Exception]::new("The Solution folder <$SolutionFolderName> crashed for global variable<SolutionFolderInformation>!");
        }
        return $slnFolderInformation;
    }
    $moduleBasePath = (PowershellCenterFilesPathByName -FileName "Dotnet-Solution").Replace('.psm1', '');
    $moduleBasePath = Split-Path -Path $moduleBasePath -Parent;
    $moduleBasePath = $moduleBasePath.Replace('\\', '\');
    $moduleBasePath = $moduleBasePath.Replace('\', '/');
    $temporaryBasePath = "$moduleBasePath/temporary-files/";
    $slnBasePath = "$temporaryBasePath/DotnetSolutionGuids/";
    $slnFilePath = "$slnBasePath/temp.sln";
    $classLibPath = "$slnBasePath/temporary/classLib/";
    dotnet new sln --output $slnBasePath --name temp --force | Out-Null;
    dotnet new classlib --output $classLibPath --name temp.classLib --force | Out-Null;
    $slnFilePath = "$slnBasePath/temp.sln";
    dotnet sln $slnFilePath add $classLibPath | Out-Null;
    $classLibPath = $classLibPath.Replace('/', '\')
    $slnFileAttributes = SolutionFileAttributes -SolutionFileName "temp.sln" -ProjectName "PowershellCenter"; 
    foreach ($info in $slnFileAttributes) {
        $exist = (Get-ChildItem -Path "$slnBasePath\$($info.File)" -File -ErrorAction SilentlyContinue).Exists;
        if ($exist) { 
            $csprojFileProjectGuid = $info.ProjectGuid;
        }
        else { 
            $solutionFolderProjectGuid = $info.ProjectGuid;
        }
    }
    $j = Start-Job -ScriptBlock { Get-ChildItem *.ps1 | Remove-Item -Path $temporaryBasePath -Recurse; }
    $j | Wait-Job
    $global:isSameProgram = $true;
    $global:slnFolderInformation = @{ CsprojFileProjectGuid = $csprojFileProjectGuid.Trim(); SolutionFolderProjectGuid = $solutionFolderProjectGuid.Trim() };
    return $slnFolderInformation;
}
function SolutionFileAttributes {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = ac528ea6-24d0-4217-ac99-e3b0b4b153b4
    #----------------------------------------------------
    # @Function Name = SolutionFileAttributes
    #----------------------------------------------------
    # @Usage = SolutionFileAttributes -FilePath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 10:09:15
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $slnFilePath = FileLookingupByNameAndExtension -FileName $SolutionFileName -FileExtension '.sln' -Path $projectBasePath -ThrowIfNotExistException;
    $slnFileContent = Get-Content $slnFilePath;
    $informations = $slnFileContent | Select-String 'Project\(' | ForEach-Object {
        $projectParts = $_ -Split '[,=]' | ForEach-Object { $_.Trim('[ "{}]'); };
        New-Object PSObject -Property @{
            ProjectGuid = $projectParts[0];
            Name        = $projectParts[1];
            File        = $projectParts[2];
            Guid        = $projectParts[3];
            ParentGuid  = ($null -ne $projectParts[3]) | ??? (ParentSolutionFolderGuid -SolutionFileName $SolutionFileName -ProjectName $ProjectName -SolutionFolderGuid $projectParts[3]) : "";
        }
    }
    return $informations;
}        
function SolutionFolderGuid {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderName,
        [Parameter(Mandatory = $false)]
        [string]
        $ParentSolutionFolderGuid = ""
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = deccc5a8-d0ba-48d4-8fe7-1f0aee9ce58d
    #----------------------------------------------------
    # @Function Name = SolutionFolderGuid
    #----------------------------------------------------
    # @Usage = SolutionFolderGuid
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/06/2020 03:43:29
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName;
    FileExistInSubFolders -FileName $SolutionFileName -FileExtension ".sln" -Path $projectBasePath -ThrowException | Out-Null;
    $slnFileAttributes = SolutionFileAttributes -SolutionFileName $SolutionFileName -ProjectName $ProjectName;
    $slnFolderName = PrepareSolutionFolderName -SolutionFolderName $SolutionFolderName;
    foreach ($info in $slnFileAttributes) {

        $fileExtension = ([System.IO.Path]::GetExtension($info.File));
        $fileIsACsproj = $fileExtension -eq ".csproj";
        if ($fileIsACsproj) {
            continue;
        }
        $solutionFolderMathched = $info.Name -eq $slnFolderName;
        $parentSolutionFolderMathched = $info.ParentGuid -eq $ParentSolutionFolderGuid;
        if ($solutionFolderMathched -and $parentSolutionFolderMathched) { 
            return $info.Guid;
        }   
    }
}
function PrepareSolutionFolderPath {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderPath
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 705f066d-4a6e-4feb-a943-720a1b1d6970
    #----------------------------------------------------
    # @Function Name = PrepareSolutionFolderPath
    #----------------------------------------------------
    # @Usage = PrepareSolutionFolderPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/08/2020 19:23:34
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $outputSolutionFolderPath = $SolutionFolderPath.Replace('/', '\');
    $outputSolutionFolderPath = ReplaceAnyOfCharactersWith -Text $outputSolutionFolderPath -Characters @('/', '@', '`', '"', '*', '^', '|') -IncludeIllegalChars;
    if ($outputSolutionFolderPath.StartsWith('\'))
    {
        $outputSolutionFolderPath = $outputSolutionFolderPath.Remove(0, 1);
    }
    if($outputSolutionFolderPath.EndsWith('\'))
    {
        $outputSolutionFolderPath = $outputSolutionFolderPath.Remove($outputSolutionFolderPath.Length -1 , 1);
    }
    return PrepareAbsolutePath -Path $outputSolutionFolderPath;
}

function PrepareSolutionFolderName {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 705f066d-4a6e-4feb-a943-720a1b1d6970
    #----------------------------------------------------
    # @Function Name = PrepareSolutionFolderName
    #----------------------------------------------------
    # @Usage = PrepareSolutionFolderName
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/08/2020 19:23:34
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $outputSolutionFolderName = $SolutionFolderName.Trim();
    $outputSolutionFolderName = ReplaceAnyOfCharactersWith -Text $outputSolutionFolderName -Characters @('.', '/', '\', '@', '`', '.', '"', '*', '^', '|') -IncludeIllegalChars;
    return $outputSolutionFolderName;
}
function MakeSolutionFolderInformationRaw {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = e1188449-aa20-4dc4-8a8e-33e3069c4bff
    #----------------------------------------------------
    # @Function Name = MakeSoutionProjectRaw
    #----------------------------------------------------
    # @Usage = MakeSoutionProjectRaw
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/09/2020 04:52:41
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $slnFolderName = PrepareSolutionFolderName -SolutionFolderName $SolutionFolderName;
    $slnFolderProjectGuid = (SolutionFolderProjectGuid).SolutionFolderProjectGuid.ToString().Trim();
    $slnFolderGuid = SolutionFolderGuid -SolutionFileName $SolutionFileName -SolutionFolderName $SolutionFolderName -ProjectName $ProjectName;
    $slnFolderName = PrepareSolutionFolderName -SolutionFolderName $SolutionFolderName;
    return $slnFolderProjectGuid + ' = "' + $slnFolderName + '", ' + '"' + $slnFolderName + '", ' + '"{' + $slnFolderGuid + '}"'
}
function EarlySolutionFolderHaveSolutionItem {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 9d078cdd-2c60-4682-b9bc-5adf1fe57c2a
    #----------------------------------------------------
    # @Function Name = EarlyHaveSolutionItem
    #----------------------------------------------------
    # @Usage = EarlyHaveSolutionItem
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/09/2020 05:00:10
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $slnFoldercontainer = MakeSolutionFolderInformationRaw -SolutionFileName $SolutionFileName -ProjectName $ProjectName -SolutionFolderName $SolutionFolderName;
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName;
    $slnFilePath = FileLookingupByNameAndExtension -FileName $SolutionFileName -Path $projectBasePath -FileExtension ".sln" -ThrowIfNotExistException;
    $solutionFile = Get-Content -Path $slnFilePath -ErrorAction SilentlyContinue;
    $slnFoldercontainerIndex = $solutionFile.Indexof($slnFoldercontainer)
    $slnFoldercontent = "`tProjectSection(SolutionItems) = preProject";
    $slnFoldercontentIndex = $solutionFile.Indexof($slnFoldercontent)
    if (($slnFoldercontainerIndex -gt -1) -and ($slnFoldercontentIndex -eq $slnFoldercontainerIndex + 1) ) {
        return $true;
    }
    return $false;
}

        
# function AddSolutionFolderChain {
#     param(
#         [ValidateNotNullOrEmpty()]
#         [Parameter(Mandatory = $true)]
#         [string]
#         $SolutionFilePath,
#         [ValidateNotNullOrEmpty()]
#         [Parameter(Mandatory = $true)]
#         [string]
#         $SolutionFolderPath         
#     )
#     #####################################################
#     # @Autor = Arsalan Fallahpour    
#     #----------------------------------------------------
#     # @Function Identity = a607c3c9-5305-46b2-bcde-ef90c9d7bb81
#     #----------------------------------------------------
#     # @Function Name = AddSolutionFolderChain
#     #----------------------------------------------------
#     # @Usage = AddSolutionFolderChain
#     #----------------------------------------------------
#     # @Description = -
#     #----------------------------------------------------
#     # @Return = -
#     #----------------------------------------------------
#     # @Development Note = This Code is starting point and works 90%;
#     #----------------------------------------------------
#     # @Date Created = 06/11/2020 05:50:27
#     #----------------------------------------------------
#     #AutoImportModule -FileName "";
#     #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
#     #____________________________________________________#

#     $_slnFolderPath = PrepareRelativePath -Path $SolutionFolderPath;
#     $_slnFilePath = PrepareAbsolutePath -Path $SolutionFilePath;
#     foreach($folder in $_slnFolderPath.Split('/').Where({$_ -ne ''}))
#     {
#         AddSolutionFolder -SolutionFolderName $folder -SolutionFilePath $_slnFilePath;
#         if($null -ne $prevSlnFolder)
#         {
#             AssignSolutionFolderParent -SolutionFilePath $SolutionFilePath -SolutionFolderName $folder -ParentSolutionFolderName $prevSlnFolder;
#         }
#         $prevSlnFolder = $folder;
#     }
# }

    
# function AssignSolutionFolderParent {
#     param(
#         [ValidateNotNullOrEmpty()]
#         [Parameter(Mandatory = $true)]
#         [string]
#         $SolutionFilePath,
#         [ValidateNotNullOrEmpty()]
#         [Parameter(Mandatory = $true)]
#         [string]
#         $SolutionFolderName,
#         [ValidateNotNullOrEmpty()]
#         [Parameter(Mandatory = $true)]
#         [string]
#         $ParentSolutionFolderName
#     )
#     #####################################################
#     # @Autor = Arsalan Fallahpour    
#     #----------------------------------------------------
#     # @Function Identity = baacf97b-48f5-40cc-92fb-beb7dbd01303
#     #----------------------------------------------------
#     # @Function Name = AssignSolutionFolderParent
#     #----------------------------------------------------
#     # @Usage = AssignSolutionFolderParent
#     #----------------------------------------------------
#     # @Description = -
#     #----------------------------------------------------
#     # @Return = -
#     #----------------------------------------------------
#     # @Development Note = -
#     #----------------------------------------------------
#     # @Date Created = 06/11/2020 05:59:52
#     #----------------------------------------------------
#     #AutoImportModule -FileName "";
#     #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
#     #____________________________________________________#
#     $slnFilePath = PrepareAbsolutePath -Path $SolutionFilePath;
#     $childSlnFolderName = PrepareSolutionFolderName -SolutionFolderName $SolutionFolderName;
#     $parentSlnFolderName = PrepareSolutionFolderName -SolutionFolderName $ParentSolutionFolderName;
#     SolutionFileExist -SolutionFileName -BasePath -SolutionFileName -BasePath -SolutionFileName -BasePath -SolutionFileName -BasePath -SolutionFilePath $slnFilePath -ThrowException;
#     SolutionFolderExist -SolutionFilePath $slnFilePath -SolutionFolderName $childSlnFolderName -WriteWarningLog;
#     SolutionFolderExist -SolutionFilePath $slnFilePath -SolutionFolderName $parentSlnFolderName -WriteWarningLog
#     $parentSlnFolderGuid = SolutionFolderGuid -SolutionFolderName $parentSlnFolderName -SolutionFilePath $slnFilePath -ParentSolutionFolderGuid $parentSlnFolderGuid;
#     $childSlnFolderGuid = SolutionFolderGuid -SolutionFolderName $childSlnFolderName -SolutionFilePath $slnFilePath;
#     AppendNestedProjectsGlobalSection -SolutionFilePath $slnFilePath;
#     AppendExtensibilityGlobalsGlobalSection -SolutionFilePath $slnFilePath;
#     $content = "`n`t`t" + '{' + $childSlnFolderGuid + '}' + ' = ' + '{' + $parentSlnFolderGuid + '}';
#     $pattern = "GlobalSection(NestedProjects) = preSolution";
#     $solutionFile = Get-Content -Path $slnFilePath -ErrorAction SilentlyContinue -Raw;
#     $index = $solutionFile.IndexOf($pattern);
#     $index += $pattern.Length;
#     $solutionFile = $solutionFile.Insert( $index, $content);
#     Set-Content -Path $slnFilePath -Value $solutionFile -Force;
#     PowershellLogger -Message "Solution folder <$childSlnFolderName> add to <$parentSlnFolderName> sln folder successfully!"  -LogType Success;
# }

        
function ParentSolutionFolderGuid {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderGuid,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = c8464708-93ae-4736-b39e-1a41b130c0c8
    #----------------------------------------------------
    # @Function Name = ParentSolutionFolderGuid
    #----------------------------------------------------
    # @Usage = ParentSolutionFolderGuid
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/11/2020 07:33:32
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $slnFilePath =  FileLookingupByNameAndExtension -FileName $SolutionFileName -FileExtension '.sln' -Path $projectBasePath -ThrowIfNotExistException;
    $slnContent = Get-Content $slnFilePath;
    $infoRaw = $slnContent | Select-String ($SolutionFolderGuid + " = ") | Out-String;
    $parentGuid = $infoRaw.Split('=');
    if ($parentGuid.Count -gt 1) {
        return $parentGuid[1].ToString();
    }
    return "";
}

        
function AppendNestedProjectsGlobalSection {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFilePath 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 5e6e3066-829d-474e-b7ea-4e117be26f61
    #----------------------------------------------------
    # @Function Name = AppendNestedProjectsGlobalSection
    #----------------------------------------------------
    # @Usage = AppendNestedProjectsGlobalSection
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/11/2020 08:40:12
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $slnFilePath = PrepareAbsolutePath $SolutionFilePath;
    $pattern = "GlobalSection(NestedProjects) = preSolution";
    $solutionFile = Get-Content -Path $slnFilePath -Raw -ErrorAction SilentlyContinue;
    $index = $solutionFile.IndexOf($pattern);
    if ($index -eq -1) {
        $content = "`n`t$pattern`n`tEndGlobalSection";
        $pattern = "EndGlobalSection";
        $index = $solutionFile.IndexOf($pattern);
        $index += $pattern.Length;
        $solutionFile = $solutionFile.Insert( $index, $content);
        Set-Content -Path $slnFilePath -Value $solutionFile -Force;
        PowershellLogger -Message "Global section <NestedProjects> added to <$slnFilePath> successfully!" -LogType Success;
    }
}
function AppendExtensibilityGlobalsGlobalSection {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFilePath 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 5e6e3066-829d-474e-b7ea-4e117be26f61
    #----------------------------------------------------
    # @Function Name = AppendNestedProjectsGlobalSection
    #----------------------------------------------------
    # @Usage = AppendNestedProjectsGlobalSection
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/11/2020 08:40:12
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $slnFilePath = PrepareAbsolutePath $SolutionFilePath;
    $solutionFile = Get-Content -Path $SolutionFilePath -Raw -ErrorAction SilentlyContinue;
    $pattern = "GlobalSection(ExtensibilityGlobals) = postSolution";
    $index = $solutionFile.IndexOf($pattern);
    if ($index -eq -1) {
        $content = "`n`t$pattern`n`t`tSolutionGuid = {$(New-Guid)}`n`tEndGlobalSection";
        $pattern = "EndGlobalSection";
        $index = $solutionFile.IndexOf($pattern);
        $index += $pattern.Length;
        $solutionFile = $solutionFile.Insert( $index, $content);
        Set-Content -Path $slnFilePath -Value $solutionFile -Force;
        PowershellLogger -Message "Global section <ExtensibilityGlobals> added to <$slnFilePath> successfully!" -LogType Success;
    }
}


function AddExistingFilesToSolution {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionFolderName,
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ExistingFilePaths
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = deeab38c-7baa-4fdc-bf73-cac2cf1b4a6b
    #----------------------------------------------------
    # @Function Name = AddExistingFilesToSolution
    #----------------------------------------------------
    # @Usage = AddExistingFilesToSolution
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/16/2020 11:37:07
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    FileLookingupByNameAndExtension -Path $projectBasePath -FileName $SolutionFileName -FileExtension '.sln' -ThrowIfNotExistException | Out-Null;
    AddSolutionFolder -SolutionFileName $SolutionFileName -ProjectName $ProjectName -SolutionFolderName $SolutionFolderName;
    foreach ($existingFilePath in $ExistingFilePaths) {
        AddExistingFileToSolutionFolder -SolutionFileName $SolutionFileName -ProjectName $ProjectName -ExistingFilePath "$projectBasePath\$existingFilePath" -SolutionFolderName $SolutionFolderName;
    }
}
function CreateAddFilesToSolution {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionFolderName,
        [ValidateNotNullOrEmpty()]
        [string]
        $fileContent,
        [Parameter(Mandatory = $false)]
        [switch]
        $CreatePhysicalFolder
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = deeab38c-7baa-4fdc-bf73-cac2cf1b4a6b
    #----------------------------------------------------
    # @Function Name = AddExistingFilesToSolution
    #----------------------------------------------------
    # @Usage = AddExistingFilesToSolution
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/16/2020 11:37:07
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    FileLookingupByNameAndExtension -Path $projectBasePath -FileName $SolutionFileName -FileExtension '.sln' -ThrowIfNotExistException | Out-Null;
    AddSolutionFolder -SolutionFileName $SolutionFileName -ProjectName $ProjectName -SolutionFolderName $SolutionFolderName;
    
    CreateAddFileToSolutionFolder -SolutionFileName $SolutionFileName -ProjectName $ProjectName -FileContent $fileContent -SolutionFolderName $SolutionFolderName -CreatePhysicalFolder:$CreatePhysicalFolder;
}

        
function MakeSolutionFolderPathForCsprojFile {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $CsprojFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 6cf922b0-9eb5-4a9c-bc95-5def0dcec070
    #----------------------------------------------------
    # @Function Name = MakeSolutionFolderPath
    #----------------------------------------------------
    # @Usage = MakeSolutionFolderPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/16/2020 03:29:19
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $CsprojBasePath = FileLookingupByNameAndExtension -FileName $CsprojFileName -FileExtension ".csproj" -Path $projectBasePath -ThrowIfNotExistException; 
    $_path = MakeRelativeToPathPart -Path $CsprojBasePath -PathPart $ProjectName;
    $_path = Split-Path -Path $_path -Parent;
    $_path = PrepareRelativePath $_path -IncludeDot;
    
    $slnFileNameParts = $SolutionFileName.Split('.');
    $excludeStartIndex = 1;
    $excludeEndIndex = $slnFileNameParts.Count;
    for ($i = $excludeStartIndex; $i -lt $excludeEndIndex; $i++) {
        $_path = $_path.Replace($slnFileNameParts[$i], '@_@_@');
    }
    $_path = $_path.Replace('Source', '@_@_@');
    if ($_path.StartsWith('./@_@_@')) {
        $_path = $_path.Remove(0, 7);
        $_path = "./Source/$_path";
    }
    if ($_path.Contains("Components")) {
        $_path = $_path.Replace('Components', '@_@_@');
    }
    if(!$_path.StartsWith("./Source")){
        $_path = $_path.Replace("./", "./Source/");
    }
    $_path = $_path.Replace("@_@_@", '');
    $_path =  PrepareAbsolutePath -Path $_path;
    return PrepareSolutionFolderPath -SolutionFolderPath $_path;
}


        
function MakeTestOutputPathForCsprojFile  {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $CsprojFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $TestProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 94701818-ea1e-4897-a4bd-913674452539
    #----------------------------------------------------
    # @Function Name = MakeOutputPathForTestProject
    #----------------------------------------------------
    # @Usage = MakeOutputPathForTestProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/18/2020 12:43:00
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $csprojFilePath = FileLookingupByNameAndExtension -FileName $CsprojFileName -FileExtension ".csproj" -Path $projectBasePath -ThrowIfNotExistException -MakeRelative;
    $testProjectOutputPath = Split-Path -Path $csprojFilePath -Parent;
    if($testProjectOutputPath.EndsWith('\Source'))
    {
        $testProjectOutputPath = $testProjectOutputPath.Remove(($testProjectOutputPath.Length - "\Source".Length), "\Source".Length);
    }
    else{
        throw [System.Exception]::new("The Csharp project <$CsprojFileName> in <$ProjectName> project not include <Source> path at end, and may cuse problem for scaffold test project!");
    }
    $splitedTestProjectName = $TestProjectName.Split('.');
    $testFolderName = $splitedTestProjectName[$splitedTestProjectName.Count-1];
    return PrepareAbsolutePath -Path "$testProjectOutputPath\Tests\$testFolderName\Source";
}


function MakeTestSolutionFolderPathForCsprojFile {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectToCoverageName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 94701818-ea1e-4897-a4bd-913674452539
    #----------------------------------------------------
    # @Function Name = MakeOutputPathForTestProject
    #----------------------------------------------------
    # @Usage = MakeOutputPathForTestProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/18/2020 12:43:00
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $csprojSlnFolderPath = MakeSolutionFolderPathForCsprojFile -CsprojFileName $ProjectToCoverageName -ProjectName $ProjectName -SolutionFileName $SolutionFileName;
    return PrepareAbsolutePath -Path "$csprojSlnFolderPath\Tests".Replace($ProjectToCoverageName + '.csproj', '\');

}

        
# function MakeSolutionForClasslibraries {
#     #####################################################
#     # @Autor = Arsalan Fallahpour    
#     #----------------------------------------------------
#     # @Function Identity = 9097c4be-f8b2-4de3-bd11-3e6daf184d2f
#     #----------------------------------------------------
#     # @Function Name = MakeSolutionFor
#     #----------------------------------------------------
#     # @Usage = MakeSolutionFor
#     #----------------------------------------------------
#     # @Description = -
#     #----------------------------------------------------
#     # @Return = -
#     #----------------------------------------------------
#     # @Development Note = -
#     #----------------------------------------------------
#     # @Date Created = 06/14/2020 14:27:32
#     #----------------------------------------------------
#     AutoImportModule -FileName "Path";
#     #____________________________________________________#
#     $_projectBasePath = GetProjectsChildPath;
#     $slnFileName = GetValidFileName -Message "Enter the solution file name:" -Path $_projectBasePath -FileExtension ".sln";
#     $slnFilePath = "$_projectBasePath\$slnFileName";
#     MakeNewDotnetSolution -ProjectName $ProjectName -SolutionFileName $slnFileName;
#     do {
#         $selectedOption = NumericOptionProvider -Message "Select one of options" -Options @("Add classlibrary to <$slnFilePath> solution", "Remove classlibrary from <$slnFilePath> solution", "Exit")
#         switch ($selectedOption) {
#             "Add classlibrary to <$slnFilePath> solution" { 
#                 $selectedCsprojFilePath = ShowOpenFileDialogForPath -Path $_projectBasePath -Filter "dotnet csproj files (*.csproj)|*.csproj"
#                 $slnFolderPath = MakeRelativeToPathPart -Path $selectedCsprojFilePath -PathPart (Split-Path -Path $_projectBasePath -Leaf) -IncludeDot;
#                 $slnFolderPath = MakeSolutionFolderPathForCsprojFile -Cspr $slnFilePath;
#                 $_projectName = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path -Path $selectedCsprojFilePath -Leaf));
#                 AddProjectToSolution -SolutionFileName $slnFileName -ProjectName $_projectName -SolutionFolderPath $slnFolderPath ;
#             }
#         }
#     } while ($selectedOption -ne "Exit")
# }