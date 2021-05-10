#####################################################
# @Autor = Arsalan Fallahpour    
#----------------------------------------------------
# @Script Identity = dd03717d-7cb6-442e-9b25-d2dc35554910 
#----------------------------------------------------
# @Script File Name = Test-Environment.ps1
#----------------------------------------------------
# @Usage = Invoke-Expression "& '$global:powershellCenterPath\powershell-scripting-utilities\Test-Environment.ps1'";
#----------------------------------------------------
# @Description = Import useful modules.`
#----------------------------------------------------
# @Development Note = -
#----------------------------------------------------
# @Date Created = Monday, June 1, 2020 10:00:03 PM
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }

#powershellCenterPath test
# Write-Host "$global:powershellCenterPath" -BackgroundColor DarkBlue -ForegroundColor White
#----------------------------------------------------
# $ProjectsPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $sourceProjectsPath += "$pathPart\"; if ($pathPart -eq "Source Projects"){break;} }

#ProjectsPath test
# Write-Host "$ProjectsPath" -BackgroundColor DarkBlue -ForegroundColor White
#----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#____________________________________________________#

# # NumericOptionProvider test
# $selectedOption = NumericOptionProvider -Message "are u need more scaffolding?"  -Options @( "Yes", "No") -IncludeForeachOption;
#----------------------------------------------------
# # PowershellLogger test
# PowershellLogger -Message $selectedOption -LogType Information;
#----------------------------------------------------

# # Initialize-Default-GitRepository.ps1 test
# Invoke-Expression "& '$global:powershellCenterPath\project-development\utilities\git\Initialize-GitRepository.ps1' -Path `'C:\Users\arsal\Desktop\TEST\`'";
#----------------------------------------------------

# # PowershellHashtableLogger test
# $Message = "The files find in <c:\\asd\asdasd\> path";
# $Collection = @{ 
#     "FileName" = "PowershellHashtableLogger.ps1" ;
#     "ScriptIdentity" = "01cb0599-5fde-4131-842e-fcbfcd775bee " ;
#     "Author" = "Arsalan Fallahpour" ;
#     "CreatedDate" = "Monday, June 1, 2020 9:34:25 PM" ;
# }

# PowershellHashtableLogger -Message $Message  -Collection $Collection;
#----------------------------------------------------

#GetPowershellCenterFilePathByFileName test
# $path = GetPowershellCenterFilePathByFileName -FileName "Invoke-PowershellCenter-Script"
# $relativePath = GetPowershellCenterFilePathByFileName -FileName "Invoke-PowershellCenter-Script" -MakeRelative;

# PowershellLogger -Message $path -LogType Information;
# PowershellLogger -Message $relativePath -LogType Information;
#----------------------------------------------------




