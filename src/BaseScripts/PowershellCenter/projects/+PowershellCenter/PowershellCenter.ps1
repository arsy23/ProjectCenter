#####################################################
# @Autor = Arsalan Fallahpour    
#----------------------------------------------------
# @Script Identity = 8f6a54ee-5a6d-40f0-97af-a5308dd12b2a
#----------------------------------------------------
# @Script File Name = PowershellCenter.ps1
#----------------------------------------------------
# @Usage = Invoke-Expression "& '$global:powershellCenterPath\projects\+PowershellCenter\PowerhsellCenter.ps1'";
#----------------------------------------------------
# @Description = Manage the PowershellCenter project.
#----------------------------------------------------
# @Development Note = -
#----------------------------------------------------
# @Date Created = Tuesday, June 2, 2020 10:17:37 AM
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
#----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule -FileName "Manage-PowershellCenter";
#____________________________________________________#

do{
    $selectedOption = NumericOptionProvider -Message "Choose an action" -Options @("Make an empty powershell script file", "Make an empty poweshell module file", "Add default function to a module", "Add advance function to a module") -IncludeExit;
    switch ($selectedOption) {
        "Make an empty powershell script file" {  
            MakePowershellCenterScriptFile;
        }
        "Make an empty poweshell module file" { 
            MakePowershellCenterModuleFile;
        }
        "Add default function to a module" {
            AddDefaultFunctionToPowershellCenterModuleFile;
        }
        "Add advance function to a module" {
            AddDefaultFunctionToPowershellCenterModuleFile -AdvanceFunction;
        }
        "Exit" {}
    }
} while ($selectedOption -ne "Exit");
