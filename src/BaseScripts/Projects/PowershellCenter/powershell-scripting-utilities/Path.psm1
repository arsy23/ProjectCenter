#####################################################
# @Module Identity = 20f473c4-b931-423c-ae10-5ae90e9c62d1
#----------------------------------------------------
# @Module File Name = Path.psm1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\powershell-scripting-utilities\Path.psm1'";
# @Usage2 = AutoInvokeScript "Path";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/04/2020 13:37:46
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
#Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
#AutoImportModule -FileName "";
#AutoInvokeScript -FileName "" -Arguments @{"" =""; };
#____________________________________________________#
function PrepareRelativePath {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [switch]
    $IncludeDot
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = d643ab0a-c8ed-4bc8-a522-6e45ff05a2a4
  #----------------------------------------------------
  # @Function Name = PrepareRelativePath
  #----------------------------------------------------
  # @Usage = PrepareRelativePath
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/04/2020 11:28:54
  #----------------------------------------------------
  #AutoImportModule -FileName "";
  #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
  #____________________________________________________#
  $outputPath = $Path.Trim();
  $outputPath = $outputPath.Replace('\\', '/');
  $outputPath = $outputPath.Replace('//', '/');
  $outputPath = $outputPath.Replace('\', '/');
  $outputPath = $outputPath.Replace('./', '/');
  if (($outputPath.EndsWith('/')) -eq $true) {
    $outputPath = $outputPath.Remove($outputPath.Length - 1, 1);
  }
  if ($IncludeDot) {
    $outputPath = "./$outputPath";
  }
  $outputPath = $outputPath.Replace('//', '/');
  return $outputPath;
}
function PrepareAbsolutePath {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [switch]
    $ExcludeLastBackSlash
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 9127ff5f-453b-4295-b9b1-88fb6d6fdbc3
  #----------------------------------------------------
  # @Function Name = PrepareAbsolutePath]
  #----------------------------------------------------
  # @Usage = PrepareAbsolutePath]
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/04/2020 11:30:57
  #----------------------------------------------------
  #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
  #____________________________________________________#
  $outputPath = $Path.Trim();
  $outputPath = $outputPath.Replace('///', '/');
  $outputPath = $outputPath.Replace('//', '/');
  $outputPath = $outputPath.Replace('./', '\');
  $outputPath = $outputPath.Replace('/', '\');
  $outputPath = $outputPath.Replace('\\\', '\');
  $outputPath = $outputPath.Replace('\\', '\');
  if($outputPath.EndsWith('\') -and $ExcludeLastBackSlash)
  {
      $outputPath = $outputPath.Remove($outputPath.Length-1, 1);
  }
  return $outputPath;
}
function ValidateAbsolutePath () {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [char[]]
    $AdditionalIllegalCharacters
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 7d22b000-efd9-42e5-ac87-7da4384c8f68
  #----------------------------------------------------
  # @Function Name = PathValidator
  #----------------------------------------------------
  # @Usage = PathValidator -Path $path -AdditionalIllegalCharacters $AdditionalIllegalCharacters
  #----------------------------------------------------
  # @Description = Validate a path.
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = Monday, June 1, 2020 3:49:53 PM
  #----------------------------------------------------
  AutoImportModule -FileName "Special-Character-Checker";
  #____________________________________________________#
  $Path = PrepareAbsolutePath $Path;
  $isValidPath = Split-Path -Path $Path -Qualifier | Test-Path;
  $isValidPath = (Test-Path -Path $Path -IsValid);
  $isValidPath = $Path.Length -gt 3;
  [char[]] $AdditionalIllegalCharacters = '@', '.', , '/' , '-', '~', '`', ';', '$', '!', '(', ')', '^', '%', '+', '"', '`', "'", '=', ',', '{', '}', '&', '>', '<' ;
  $includeIllegalChars = IncludeAnyOfCharacters -Text $FolderName -Characters $AdditionalIllegalCharacters -IncludeIllegalChars;
  $includeColonCharMoreThanOne = IncludeCharacterMoreThanOne -Text $FolderName -Character ':';     
  if ($isValidPath -eq $false -or $includeIllegalChars -or $includeColonCharMoreThanOne) {
    return $false;
  }
  return $true;
}        
function MakeRelativeToPathPart {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $PathPart,
    [switch]
    $IncludeDot,
    [switch]
    $ThrowException
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = a66089fc-c32d-4dad-9dca-b9a2ef3ff931
  #----------------------------------------------------
  # @Function Name = MakeRelaticeToPath
  #----------------------------------------------------
  # @Usage = MakeRelaticeToPath
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/05/2020 19:45:27
  #----------------------------------------------------
  #AutoImportModule -FileName "";
  #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
  #____________________________________________________#
  $Path = PrepareAbsolutePath -Path $Path;
  $pathParts = $Path.Split('\');
  $outputPath = "";
  $canInclude = $false;
  for ($i = 0; $i -lt $pathParts.Count ; $i++) {
        
    if ($pathParts[$i] -eq $PathPart) { 
      $canInclude = $true;
      continue;
    }

    if ($canInclude) {
      $outputPath += "\$($pathParts[$i])";
    }
        
  }
  if (!$canInclude -and $ThrowException) {
    throw [System.Exception]::new("The path part not exist in the path!");
  }
  elseif (!$canInclude -and !$ThrowException.IsPresent) {
    return PrepareRelativePath -Path $Path;
  }
  $outputPath = PrepareRelativePath -Path ".\$outputPath";
  if ($IncludeDot) {
    $outputPath = ".$outputPath"
  }
  return $outputPath;
}

function MakePathFromPathPart
{
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $PathPart,
    [switch]
    $ThrowException
  )
  # !! not tested
  $_path = PrepareAbsolutePath -Path $Path;
  $_pathQualifier = Split-Path $_path -Qualifier;
  $outputPath = $_pathQualifier;
  $pathParts = $Path.Replace("$_pathQualifier\", '').Split('\');
  $canInclude = $false;
  for ($i = 0; $i -lt $pathParts.Count ; $i++) {
        
    if ($pathParts[$i] -eq $PathPart) { 
      $canInclude = $true;
      continue;
    }

    if ($canInclude) {
      $outputPath += "\$($pathParts[$i])";
    }
        
  }
  if (!$canInclude -and $ThrowException) {
    throw [System.Exception]::new("The path part not exist in the path!");
  }
  elseif (!$canInclude -and !$ThrowException.IsPresent) {
    return PrepareAbsolutePath -Path $Path;
  }
  $outputPath = PrepareAbsolutePath -Path $outputPath -ExcludeLastBackSlash;
  return $outputPath;

}