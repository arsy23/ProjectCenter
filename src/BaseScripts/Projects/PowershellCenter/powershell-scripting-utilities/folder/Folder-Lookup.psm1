function FolderExistInSubFolders {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [string]
        $FolderName = [string]::Empty, 
        [switch]
        $ThrowIfNotExistException,
        [switch]
        $ThrowIfExistException
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 9084fb8f-b044-4741-9b18-459fa4bbb8cc
    #----------------------------------------------------
    # @Function Name = FolderExistInSubFolders
    #----------------------------------------------------
    # @Usage = FolderExistInSubFolders
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/05/2020 23:17:51
    #----------------------------------------------------
    AutoImportModule -FileName "ProjectResources";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $folderPath = FolderLookingupByNameInSubFolders -Path $Path -FolderName $FolderName -ThrowIfExistException:$ThrowIfExistException -ThrowIfNotExistException:$ThrowIfNotExistException;
    if ([string]::IsNullOrEmpty($folderPath)) {
        return $false;   
    }
    elseif (Test-Path -Path $folderPath -ErrorAction SilentlyContinue) {
        return $true;
    }
    return $false;
}
function FolderLookingupByNameInSubFolders {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FolderName,
        [switch]
        $MakeRelative,
        [switch]
        $ThrowIfNotExistException,
        [switch]
        $ThrowIfExistException,
        [switch]
        $ReturnAllResult
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
    if($(Split-Path -Path $Path -Leaf) -eq $FolderName)
    {
        $exist = Test-Path -Path $Path;
        if ($ThrowIfNotExistException -and $exist) {
            throw [System.Exception]::new("the <$FolderName> Folder not exist in the <$Path>!");
        }
        elseif($ThrowIfExistException -and $exist)
        {
            throw [System.Exception]::new("the <$FolderName> Folder exist in the <$Path>!");
        }
        if($exist)
        {
            return $Path;
        }
    }
    $findedInHistories = $false;
    $paths = [System.Collections.ArrayList]::new();
    $folderInfoHistory = "$($Path)>$($FolderName)";
    if (!$ReturnAllResult) {
        
        if ($MakeRelative) {
            if ($null -eq $global:powershellCenterFolderLookupRelativeHistory) {
                $global:powershellCenterFolderLookupRelativeHistory = [System.Collections.Hashtable]::new();
            }
            else {
                if ($global:powershellCenterFolderLookupRelativeHistory.Contains($folderInfoHistory)) {
                    return $global:powershellCenterFolderLookupRelativeHistory.$folderInfoHistory;

                }
            }
        }
        else {
            if ($null -eq $global:powershellCenterFolderLookupHistory) {
                $global:powershellCenterFolderLookupHistory = [System.Collections.Hashtable]::new();
            }
            else {
                if ($global:powershellCenterFolderLookupHistory.Contains($folderInfoHistory)) {
                    return $global:powershellCenterFolderLookupHistory.$folderInfoHistory;
                }
            }
        }
    }
    if (!$findedInHistories) {
        if ($null -eq $global:powershellCenterRecurceDirectories) {
            $global:powershellCenterRecurceDirectories = [System.Collections.Hashtable]::new();
            $directories = Get-ChildItem -Path $Path -Recurse -Directory;
            $global:powershellCenterRecurceDirectories.Add($Path,$directories);
        }
        else{
            if(GetSubFoldersCountOfProjects -ne $global:powershellCenterRecurceDirectories.Count)
            {
                $global:powershellCenterRecurceDirectories = [System.Collections.Hashtable]::new();
                $directories = Get-ChildItem -Path $Path -Recurse -Directory;
                $global:powershellCenterRecurceDirectories.Add($Path, $directories);
            }
        }
         foreach($directory in $global:powershellCenterRecurceDirectories.$Path) {
            $exist = $directory.Name -eq $FolderName;
            if ($exist) {
                if ($MakeRelative) {
                    $findedPath = MakeRelativeToPathPart -Path $directory.FullName -PathPart $(Split-Path -Path $Path -Leaf);
                    $paths.Add($findedPath) | Out-Null;
                    $global:powershellCenterFolderLookupRelativeHistory.Add("$folderInfoHistory", $findedPath);
                    if (!$ReturnAllResult) {
                        return $paths;
                    }
                }
                else {
                    $findedPath = $directory.FullName.ToString().Trim();
                    $paths.Add($findedPath) | Out-Null;
                    $global:powershellCenterFolderLookupHistory.Add("$folderInfoHistory", $findedPath);
                    if (!$ReturnAllResult) {
                        return $paths;
                    }
                }
            }   
        }
    }
    if ($ThrowIfNotExistException -and ($paths.Count -lt 1)) {
        throw [System.Exception]::new("the <$FolderName> Folder not find in the <$Path>!");
    }
    elseif ($ThrowIfExistException -and ($paths.Count -ge 1)) {
        throw [System.Exception]::new("the <$FolderName> Folder exist in the <$Path>!");
    }
    elseif (!$ThrowIfExistException -and ($paths.Count -gt 1)) {
        throw [System.Exception]::new("the <$FolderName> Folder Find in More Than One Directory in the <$Path>!");
    }
    if ($FolderName -eq ("Projects")) {
        return ResolveProjectsPath;
    }
    $projectBasePath = $null;
    if ($FolderName.Contains("Center")) {
        if ($FolderName -eq "PowershellCenter") {
            $projectBasePath = $global:powershellCenterPath;
        }
        if (![string]::IsNullOrEmpty($projectBasePath)) {
            return $projectBasePath;
        }
    }
    if ($ReturnAllResult) {
        return $paths; 
    }
    if ($null -eq $projectBasePath -and $paths.Count -gt 1 -and !$ReturnAllResult) {
        throw [System.Exception]::new("Too Many Folder Exist with the Project <$Path> exist in the Path <$ProjectsPath>!");
    }

}
    
function FolderLookingupByNameInRootDirectory {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FolderName,
        [switch]
        $MakeRelative,
        [switch]
        $ThrowIfNotExistException,
        [switch]
        $ThrowIfExistException
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
    $folderInfoHistory = "$($Path)>$($FolderName)";
    if (!$ReturnAllResult) {
        
        if ($MakeRelative) {
            if ($null -eq $global:powershellCenterFolderLookupRelativeHistory) {
                $global:powershellCenterFolderLookupRelativeHistory = [System.Collections.Hashtable]::new();
            }
            else {
                if ($global:powershellCenterFolderLookupRelativeHistory.Contains($folderInfoHistory)) {
                    $paths.Add($global:powershellCenterFolderLookupRelativeHistory.$folderInfoHistory);
                    $findedInHistories = $true;
                }
            }
        }
        else {
            if ($null -eq $global:powershellCenterFolderLookupHistory) {
                $global:powershellCenterFolderLookupHistory = [System.Collections.Hashtable]::new();
            }
            else {
                if ($global:powershellCenterFolderLookupHistory.Contains($folderInfoHistory)) {
                    $paths.Add($global:powershellCenterFolderLookupHistory.$folderInfoHistory);
                    $findedInHistories = $true;
                }
            }
        }
    }
    if (!$findedInHistories) {

        Get-ChildItem -Path $Path -Directory | ForEach-Object {
            $exist = $_.Name -like "$FolderName";
            if ($exist) {
                if ($MakeRelative) {
                    $findedPath = MakeRelativeToPathPart -Path $_.FullName -PathPart $(Split-Path -Path $Path -Leaf);
                    $paths.Add($findedPath) | Out-Null;
                    $global:powershellCenterFolderLookupRelativeHistory.Add("$folderInfoHistory", $findedPath);

                }
                else {
                    $findedPath = $_.FullName.ToString().Trim();
                    $paths.Add($findedPath) | Out-Null;
                    $global:powershellCenterFolderLookupHistory.Add("$folderInfoHistory", $findedPath);
                }
            }   
        }
    }
    if ($ThrowIfNotExistException -and ($paths.Count -lt 1) -and $ThrowIfExistException.IsPresent -eq $false) {
        throw [System.Exception]::new("the <$FolderName> Folder not find in root directory of the <$Path>!");
    }
    elseif ($ThrowIfExistException -and ($paths.Count -ge 1) -and !$ThrowIfNotExistException.IsPresent -eq $false) {
        throw [System.Exception]::new("the <$FolderName> Folder exist in root directory of the <$Path>!");
    }
    return $paths; 
}
    
function FolderExistRootDirectory {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FolderName,
        [switch]
        $ThrowIfNotExistException,
        [switch]
        $ThrowIfExistException
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
    $folderInfoHistory = "$($Path)>$($FolderName)";
    if ($null -eq $global:powershellCenterFolderExistHistory) {
        $global:powershellCenterFolderExistHistory = [System.Collections.Hashtable]::new();
    }
    else {
        if ($global:powershellCenterFolderExistHistory.Contains($folderInfoHistory)) {
            return $global:powershellCenterFolderExistHistory.$folderInfoHistory;
            $findedInHistories = $true;
        }
    }
    if (!$findedInHistories) {
        $exist = $false;
        foreach ($folder in (Get-ChildItem -Path $Path -Directory -Recurse)) {
            $exist = $folder.Name -eq $FolderName;
            if ($exist) {
                $global:powershellCenterFolderExistHistory.Add("$folderInfoHistory", $true);
                break;
            }
            else{
                $global:powershellCenterFolderExistHistory.Add("$folderInfoHistory", $false);
            }
        }
    }
    if ($ThrowIfNotExistException -and !$exist -and !$ThrowIfExistException) {
        throw [System.Exception]::new("the <$FolderName> Folder not find in root directory of the <$Path>!");
    }
    elseif ($ThrowIfExistException -and $exist -and $ThrowIfNotExistException) {
        throw [System.Exception]::new("the <$FolderName> Folder exist in root directory of the <$Path>!");
    }
    return $exist; 
}
