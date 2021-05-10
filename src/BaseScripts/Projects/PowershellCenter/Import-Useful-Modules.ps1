#####################################################
# @Autor = Arsalan Fallahpour    
#----------------------------------------------------
# @Script Identity = 39a3a631-3806-43b8-9eb9-aa046ce21c12 
#----------------------------------------------------
# @Script File Name = Import-Useful-Modules.ps1
#----------------------------------------------------
# @Usage = Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
# @Description = Import useful modules.
#----------------------------------------------------
# @Development Note = -
#----------------------------------------------------
# @Date Created = Monday, June 1, 2020 3:49:53 PM
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ($PSScriptRoot).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;}}
#____________________________________________________#

Import-Module "$global:powershellCenterPath\projects\+PowershellCenter\Import-PowershellCenter-Module.psm1";
AutoImportModule -FileName "Operators";
ImportUsefulOperators;

AutoImportModule -FileName "Powershell-Logger";
Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\loggers\Powershell-Hashtable-Logger.psm1";
AutoImportModule -FileName "FolderBrowser-Dialog";
AutoImportModule -FileName "String";
AutoImportModule -FileName "OpenFile-Dialog";
AutoImportModule -FileName "Numeric-Option-Provider";
AutoImportModule -FileName "PowershellCenter-Path";
AutoImportModule -FileName "Invoke-PowershellCenter-Script";
AutoImportModule -FileName "Import-PowershellCenter-Module";
AutoImportModule -FileName "Resolve-PowershellCenter-FilePath";
AutoImportModule -FileName "ProjectResources";
AutoImportModule -FileName "TemplateCenter-Path";
