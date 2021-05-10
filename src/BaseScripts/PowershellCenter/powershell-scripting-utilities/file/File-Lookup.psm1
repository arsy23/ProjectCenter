#####################################################
# @Module Identity = 3528e174-efb8-4018-b317-05ad18deb548
#----------------------------------------------------
# @Module File Name = File-Lookup.psm1
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Wednesday, June 3, 2020 8:34:46 PM
#----------------------------------------------------
if ([string]::IsNullOrEmpty($global:powershellCenterPath)) { $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } } }

#----------------------------------------------------
Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\Path.psm1";
Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\collection\Get-Illegal-Path-Characters.psm1";
#____________________________________________________#
function FileExistInRootPath {
  param (
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $FileBasePath,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $FileExtension,
    [Parameter(Mandatory = $false)]
    [string]
    $FileName = [string]::Empty,
    [switch]
    $ThrowException
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 8d036315-a8ab-4659-9a80-c35e1a89e6cf
  #----------------------------------------------------
  # @Function Name = FileExist
  #----------------------------------------------------
  # @Usage = FileExist -FileName -FileExtension -Path
  #----------------------------------------------------
  # @Description = Check the <Path> contain file provided by <FileName>.
  #----------------------------------------------------
  # @Return = Return $true if the file exist on the path, otherwise return $false;
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = Wednesday, June 3, 2020 9:33:51 PM
  #----------------------------------------------------
  AutoImportModule -FileName "Console";
  AutoImportModule -FileName "File-Extension";
  #____________________________________________________#   
  $_fileBasePath = PrepareAbsolutePath -Path $FileBasePath;
  $_fileExtension = PrepareFileExtension -FileExtension $FileExtension -ThrowException;
  $_fileName = PrepareFileName -FileName $FileName -FileExtension $_fileExtension -WithoutExtension ;
  $_fileBasePath = "$_fileBasePath\" + $_fileName + $_fileExtension;
  if ((Test-Path -Path $_fileBasePath)) {
    $pathType = (Get-Item $_fileBasePath).Gettype();
    if ("FileInfo" -eq $pathType.Name) { 
      return $true;
    }
    elseif ("DirectoryInfo" -eq $pathType.Name) { 
      if ($ThrowException) {
        throw [System.Exception]::new("The <`$FileBasePath> <$_fileBasePath> <`$name> type is a director, and not a file!!");
      }
      return $false; 
    }
  }
  if ($ThrowException -and !$fileExist) {
    throw [System.Exception]::new("The <`$FileBasePath> not exist!");

    return $false;
  }
}             
function FileExistInSubFolders {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [Parameter(Mandatory = $false)]
    [string]
    $FileName, 
    [Parameter(Mandatory = $true)]
    [string]
    $FileExtension,
    [switch]
    $ThrowException
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 9084fb8f-b044-4741-9b18-459fa4bbb8cc
  #----------------------------------------------------
  # @Function Name = FileExistInSubFolder
  #----------------------------------------------------
  # @Usage = FileExistInSubFolder
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/05/2020 23:17:51
  #----------------------------------------------------
  #AutoImportModule -FileName "";
  #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
  #____________________________________________________#
  $_fileExtension = PrepareFileExtension -FileExtension $FileExtension -ThrowException;
  $_fileName = PrepareFileName -FileName $FileName -FileExtension $_fileExtension -WithoutExtension;
  $_filePath = PrepareAbsolutePath -Path $Path;

  $findedInHistories = $false;
  $fileInfoHistory = "$($_filePath)>$($_fileName)$($_fileExtension)";
  if ($null -eq $global:powershellCenterFileExistHistory) {
    $global:powershellCenterFileExistHistory = [System.Collections.Hashtable]::new();
  }
  else {
    if ($global:powershellCenterFileExistHistory.Contains($fileInfoHistory)) {
        $findedInHistories = $true;
        return $findedInHistories;
    }
  }
  if (!$findedInHistories) {
    $exist = $false;
    foreach ($file in (Get-ChildItem -Path $_filePath -Recurse -File)) {
      if ( $file.Name -eq $($_fileName + $_fileExtension)) { 
          $global:powershellCenterFileExistHistory.Add($fileInfoHistory, $true);
        $exist = $true;
        return $exist;
      }
      else{
        $makedfileInfoHistory = "$($_filePath)>$($file.BaseName)$($file.Extension)";
        if(!$global:powershellCenterFileExistHistory.Contains($makedfileInfoHistory))
        {
          $global:powershellCenterFileExistHistory.Add($makedfileInfoHistory, $false);
        }
      }
    }
    if ($ThrowException -and !$fileExist) {
      throw [System.Exception]::new("the <$($_fileName + $_fileExtension)> File not find in <$_filePath> path or that child folders!");
    }
  }
  return $exist; 
}
function FileLookingupByNameAndExtension {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [string]
    $FileName = [string]::Empty,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $FileExtension,
    [switch]
    $MakeRelative,
    [switch]
    $ThrowIfNotExistException,
    [switch]
    $IncludeDot
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = e04d178f-60e6-4b05-b2db-41d61a90321b
  #----------------------------------------------------
  # @Function Name = FileExistInChildDirectory
  #----------------------------------------------------
  # @Usage = FileExistInChildDirectory
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/05/2020 22:46:03
  #----------------------------------------------------
  Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\file\File-Extension.psm1";
  Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\file\File-Name.psm1";
  #____________________________________________________#
  $_fileExtension = PrepareFileExtension -FileExtension $FileExtension -ThrowException;
  $_fileName = PrepareFileName -FileName $FileName -FileExtension $_fileExtension -WithoutExtension;
  $_filePath = PrepareAbsolutePath -Path $Path;
  $findedInHistories = $false;
  $outputPath = [string]::Empty;
  $fileInfoHistory = "$($_filePath)>$($_fileName).($_fileExtension)";
  if ($MakeRelative) {
    if ($null -eq $global:powershellCenterFileLookupRelativeHistory) {
      $global:powershellCenterFileLookupRelativeHistory = [System.Collections.Hashtable]::new();
    }
    else {
      if ($global:powershellCenterFileLookupRelativeHistory.Contains($fileInfoHistory)) {
        $outputPath = $global:powershellCenterFileLookupRelativeHistory.$fileInfoHistory;
        $findedInHistories = $true;
      }
    }
  }
  else {
    if ($null -eq $global:powershellCenterFileLookupHistory) {
      $global:powershellCenterFileLookupHistory = [System.Collections.Hashtable]::new();
    }
    else {
      if ($global:powershellCenterFileLookupHistory.Contains($fileInfoHistory)) {
        $outputPath = $global:powershellCenterFileLookupHistory.$fileInfoHistory;
        $findedInHistories = $true;
      }
    }
  }
  if (!$findedInHistories) {
    $directories =  Get-ChildItem -Path $_filePath -Recurse -File;
   foreach($directory in $directories) {
      $exist = $directory.Name -eq $($_fileName + $_fileExtension);
      if ($exist) {
        if ($MakeRelative) {
          $outputPath = MakeRelativeToPathPart -Path $directory.FullName -PathPart $(Split-Path -Path $_filePath -Leaf) -IncludeDot:$IncludeDot;
          $global:powershellCenterFileLookupRelativeHistory.Add("$fileInfoHistory", $outputPath);
          return  $outputPath;
        }
        else {
          $outputPath = $directory.FullName.ToString().Trim();
          $global:powershellCenterFileLookupHistory.Add("$fileInfoHistory", $outputPath);
          return  $outputPath;
        }
      }   
    }
  }
  if ($ThrowIfNotExistException -and [string]::IsNullOrEmpty($outputPath)) {
    throw [System.Exception]::new("the <$($_fileName + $_fileExtension)> File not find in <$_filePath> path or that child folders!");
  }
  return $outputPath; 
}
function FileLookingupByName {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $FileName,
    [switch]
    $MakeRelative,
    [switch]
    $ThrowException
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 3f52d0e8-4655-4473-a88e-800c11dcf933
  #----------------------------------------------------
  # @Function Name = FileExistInChildDirectory
  #----------------------------------------------------
  # @Usage = FileExistInChildDirectory
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/05/2020 22:46:03
  #----------------------------------------------------
  #AutoImportModule -FileName "";
  #____________________________________________________#
  $findedInHistories = $false;
  $paths = [System.Collections.ArrayList]::new();
  $fileInfoHistory = "$($Path)>$($FileName)|";
  if ($MakeRelative) {
    if ($null -eq $global:powershellCenterFileLookupRelativeHistory) {
      $global:powershellCenterFileLookupRelativeHistory = [System.Collections.Hashtable]::new();
    }
    else {
      if ($global:powershellCenterFileLookupRelativeHistory.Contains($fileInfoHistory)) {
        $paths.Add($global:powershellCenterFileLookupRelativeHistory.$fileInfoHistory);
        $findedInHistories = $true;
      }
    }
  }
  else {
    if ($null -eq $global:powershellCenterFileLookupHistory) {
      $global:powershellCenterFileLookupHistory = [System.Collections.Hashtable]::new();
    }
    else {
      if ($global:powershellCenterFileLookupHistory.Contains($fileInfoHistory)) {
        $paths.Add($global:powershellCenterFileLookupHistory.$fileInfoHistory);
        $findedInHistories = $true;
      }
    }
  }
  if (!$findedInHistories) {
    Get-ChildItem -Path $Path -Recurse -File | ForEach-Object {
      $exist = $_.Name -like "$FileName.*";
      if ($exist) {
        if ($MakeRelative) {
          $findedPath = MakeRelativeToPathPart -Path $_.FullName -PathPart $(Split-Path -Path $Path -Leaf);
          $paths.Add($findedPath) | Out-Null;
          $global:powershellCenterFileLookupRelativeHistory.Add("$fileInfoHistory", $findedPath);
        }
        else {
          $findedPath = $_.FullName.ToString().Trim();
          $paths.Add($findedPath) | Out-Null;
          $global:powershellCenterFileLookupHistory.Add("$fileInfoHistory", $findedPath);
        }
      }   
    }
  }
  if ($ThrowException) {
    if ($paths.Count -lt 1) {
      throw [System.Exception]::new("the <$FileName> File in the not find <$Path>!");
    }
  }
  return $paths; 
}
  
