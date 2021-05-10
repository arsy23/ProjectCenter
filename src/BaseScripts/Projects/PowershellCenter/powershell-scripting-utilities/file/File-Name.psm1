#####################################################
# @Module Identity = 7a7b2853-defe-4853-881d-73a5074757f1
#----------------------------------------------------
# @Module File Name = File-Name.psm1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\powershell-scripting-utilities\file\File-Name.psm1'";
# @Usage2 = AutoInvokeScript "File-Path";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/06/2020 14:51:12
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
#Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
#AutoImportModule -FileName "";
#AutoInvokeScript -FileName "" -Arguments @{"" =""; };
#____________________________________________________#
        
function PrepareFileName {
  param(
    [Parameter(Mandatory = $false)]
    [string]
    $FileName,
    [Parameter(Mandatory = $false)]
    [string]
    $FileExtension,
    [switch]
    $WithoutExtension
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 37314fae-dcc9-4883-bc79-7cfe772b4761
  #----------------------------------------------------
  # @Function Name = PrepareFileName
  #----------------------------------------------------
  # @Usage = PrepareFileName
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/06/2020 15:17:24
  #____________________________________________________#
  $_fileName = $FileName.Trim();
  $_fileName = $_fileName.Replace('\\', '');
  $_fileName = $_fileName.Replace('//', '');
  $_fileName = $_fileName.Replace('\', '');
  $_fileName = $_fileName.Replace('/', '');
  if (![string]::IsNullOrEmpty($FileExtension)) {
    $outputFileExtension = $FileExtension.Trim();
    if (!$FileExtension.StartsWith('.')) {
      $outputFileExtension = ".$FileExtension";
    }
    if ($WithoutExtension) {
      $_fileName = $_fileName.Replace($outputFileExtension, ' ').Trim();
    }
  }
  return $_fileName;
}
function GetValidFileName {
  param(
          
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Message,
    [string]
    $FileExtension,
    [string]
    $Path
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 665dfdf5-e802-40ce-92fe-9f93e36dbe77
  #----------------------------------------------------
  # @Function Name = GetValidFileName -Message
  #----------------------------------------------------
  # @Usage = GetValidFileName
  #----------------------------------------------------
  # @Description = Get valid file name from user-input. if the Path pass in the <Path> argument, check the Path not conain any file with <FileName>.
  #----------------------------------------------------
  # @Return = -
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = Wednesday, June 3, 2020 9:00:25 PM
  #----------------------------------------------------
  AutoImportModule -FileName "File-Lookup"
  #____________________________________________________#    
  $userInputIsValid = $false;
  $userInput = "";
  $firstTime = $true;
  do {
    if (!$firstTime) {
      RewriteConsoleOption -ErrorMessage "Input File Name Is Incorrect!!" -RewriteRowCount 2 -ClearRowCount 2;
    }
    $firstTime = $false;
    PowershellLogger -Message $Message -LogType Question -IncludeExtraLine -NoFlag;
    $userInput = Read-Host;
    $userInputIsNullOrEmpty = [string]::IsNullOrEmpty($userInput);
    $userInputStartsWithDot = $userInput.StartsWith('.');
    $userInputEndsWithDot = $userInput.EndsWith('.');
    if ($userInputIsNullOrEmpty -or $userInputStartsWithDot -or $userInputEndsWithDot) {
      continue;
    }
    $userInput = PrepareFileName -FileName $userInput -FileExtension '';
    [char[]] $AdditionalIllegalCharacters = '$', '[', ']', '\' , '/' , '~', '`', ';', '$', '@', '!', '(', ')', '^', '%', '+', '"', '`', "'", ':', '=', ',', '{', '}', '&', ' ', '>', '<' ;
    $userInputIsValid = ValidateFileName -FileName $userInput -AdditionalIllegalCharacters $AdditionalIllegalCharacters;
    if (![string]::IsNullOrEmpty($Path)) {
      if ([string]::IsNullOrEmpty($FileExtension)) {
        throw [System.Exception]::new("Looking in a file in path without pass the File extension cause invalid operation!")
      }
      $userInputIsValid = !(FileExistInRootPath -FileExtension $FileExtension -FileBasePath $Path -FileName $userInput);
    }
  
  }
  while (!$userInputIsValid)
  ClearCurrentPowershellConsoleRow;
  return $userInput.ToString().Trim();
}
function ValidateFileName {
  param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $FileName,
    [Parameter(Mandatory = $false)]
    [char[]]
    $AdditionalIllegalCharacters 
  )
  #####################################################
  # @Autor = Arsalan Fallahpour    
  #----------------------------------------------------
  # @Function Identity = 58ae8f18-76d2-4d02-a80a-483bbbc79966
  #----------------------------------------------------
  # @Function Name = ValidateFileName
  #----------------------------------------------------
  # @Usage = ValidateFileName
  #----------------------------------------------------
  # @Description = -
  #----------------------------------------------------
  # @Return = True if the module name is valid, otherwise return false.
  #----------------------------------------------------
  # @Development Note = -
  #----------------------------------------------------
  # @Date Created = 06/06/2020 15:23:39
  #----------------------------------------------------
  AutoImportModule -FileName "Special-Character-Checker"; 
  #____________________________________________________#
  $includeIllegalChars = IncludeAnyOfCharacters -Text $FileName -Characters $AdditionalIllegalCharacters -IncludeIllegalChars;
  $fileNameIncludeLessThanThreeChar = $FileName.length -lt 3;
  $fileNameEndsWithDot = $FileName.EndsWith('.');
  $fileNameStartsWithDot = $FileName.StartsWith('.');
  if ($includeIllegalChars -or $fileNameEndsWithDot -or $fileNameStartsWithDot -or $fileNameIncludeLessThanThreeChar) { return $false; }
  return $true;
}

