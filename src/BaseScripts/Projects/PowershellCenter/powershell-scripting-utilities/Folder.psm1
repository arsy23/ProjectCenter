#####################################################
# @Module Identity = 4886c5e9-9053-4669-a7da-f1fafb66e07b
#----------------------------------------------------
# @Module File Name = Folder.psm1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\powershell-scripting-utilities\Folder.psm1'";
# @Usage2 = AutoInvokeScript "Folder";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/04/2020 12:18:36
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
#Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
#AutoImportModule -FileName "";
#AutoInvokeScript -FileName "" -Arguments @{"" =""; };
#____________________________________________________#
function GetValidFolderName {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Message,
    [string] 
    $Path,
    [Parameter(Mandatory = $false)]
    [string]
    $ErrorMessage
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 05dc42b8-60e3-4e3a-b8b7-82a225ce03bb
  #----------------------------------------------------
  # @Function Name = GetValidFolderName
  #----------------------------------------------------
  # @Usage = GetValidFolderName
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/04/2020 12:19:04
  #----------------------------------------------------
  AutoImportModule -FileName "File-Path";
  AutoImportModule -FileName "Console";
  #____________________________________________________# 
  if ([string]::IsNullOrEmpty($ErrorMessage)) {
    $ErrorMessage = "Input Folder Name Is Incorrect!!";
  }
  $userInputIsValid = $false;
  $userInput = "";
  $firstTime = $true;
  do {
    if (!$firstTime) {
      RewriteConsoleOption -ErrorMessage $ErrorMessage -RewriteRowCount 2 -ClearRowCount 2;
    }
    $firstTime = $false;
    PowershellLogger -Message $Message -LogType Question -IncludeExtraLine -NoFlag;
    $userInput = (Read-Host).ToString().Trim();
    $userInputIsNullOrEmpty = [string]::IsNullOrEmpty($userInput);
    $userInputStartsWithDot = $userInput.StartsWith('.');
    $userInputEndsWithDot = $userInput.EndsWith('.');
    if ($userInputStartsWithDot -or $userInputEndsWithDot -or $userInputIsNullOrEmpty) {
      continue;
    }
    $pathIsNullOrEmpty = [string]::IsNullOrEmpty($Path);
    [char[]] $AdditionalIllegalCharacters = '\' , '/' , '~', '`', ';', '$', '@', '!', '(', ')', '^', '%', '+', '"', '`', "'", ':', '=', ',', '{', '}', '&', ' ', '>', '[', ']' ;
    if ($pathIsNullOrEmpty) {
      $userInputIsValid = ValidateFolderName -FolderName $userInput -AdditionalIllegalCharacters $AdditionalIllegalCharacters;
    }
    else {
      $userInputIsValid = ValidateFolderName -FolderName $userInput -Path $Path -AdditionalIllegalCharacters $AdditionalIllegalCharacters;
    }
  }
  while (!$userInputIsValid)
  ClearCurrentPowershellConsoleRow;
  return $userInput;
}


function ValidateFolderName {
  param (
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $FolderName,
    [Parameter(Mandatory = $false)]
    [string]
    $Path,
    [char[]]
    $AdditionalIllegalCharacters
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 6cfaf97b-7ed3-41a6-bc74-85ce4521e137
  #----------------------------------------------------
  # @Function Name = ValidateFileName
  #----------------------------------------------------
  # @Usage1 = ValidateFileName -FileName
  #----------------------------------------------------
  # @Description = Get valid file name from user-input. if the Path pass in the <Path> argument, check the Path not conain any file with <FileName>.
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = Wednesday, June 3, 2020 9:00:25 PM
  #----------------------------------------------------
  AutoImportModule -FileName "Special-Character-Checker";
  AutoImportModule -FileName "Path";
  #____________________________________________________#  
  
  if ($FolderName.length -lt 3) { return $false; }
  if(IncludeAnyOfCharacters -Text $FolderName -Characters $AdditionalIllegalCharacters -IncludeIllegalChars){
    return $false;
  }
  $FolderName = PrepareFolderName -FolderName $FolderName;
  if (![string]::IsNullOrEmpty($Path)) {
    $Path = PrepareAbsolutePath -Path $Path;
    $folderExist = Test-Path -Path "$Path\$FolderName";
    if ($folderExist -eq $true) { return $false; }
  }
  return $true;
}        
function PrepareFolderName {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FolderName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = aa5c4665-206f-47cc-9950-cf56f1185bbd
    #----------------------------------------------------
    # @Function Name = PrepareFolderName
    #----------------------------------------------------
    # @Usage = PrepareFolderName
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/08/2020 18:09:37
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $outputFolderName = $FolderName.Trim();
    $outputFolderName = $outputFolderName.Replace('//', '');
    $outputFolderName = $outputFolderName.Replace('\\', '');
    $outputFolderName = $outputFolderName.Replace('/', '');
    $outputFolderName = $outputFolderName.Replace('\', '');
    $outputFolderName = $outputFolderName.Replace(':', '');
    $outputFolderName = $outputFolderName.Replace('"', '');
    return $outputFolderName;
}

