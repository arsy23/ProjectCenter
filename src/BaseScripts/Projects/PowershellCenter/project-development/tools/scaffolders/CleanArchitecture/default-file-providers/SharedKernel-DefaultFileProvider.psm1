#####################################################
# @Module Identity = 60103fbc-2fab-494c-bc5c-6eab1fb87917
#----------------------------------------------------
# @Module File Name = CleanArchitecture-Scaffolder.psm1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\project-development\tools\scaffolders\CleanArchitectureScaffolder.psm1'";
# @Usage2 = AutoInvokeScript "CleanArchitectureScaffolder";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Thursday, June 4, 2020 3:05:54 AM
#----------------------------------------------------
if ([string]::IsNullOrEmpty($global:powershellCenterPath)) { $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } } }

#----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
# AutoImportModule -FileName "File-Name";

#----------------------------------------------------

function CreateAddSharedKernelFilesToSolution{
param (
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $ProjectName
)

use ReplaceAddCsFileToSolution to create every single content
tesst to create 
commit begin and end of this method
create other layers function in single file
use the CreateAddSharedKernelFilesToSolution and others to CleanArch Scaffolder
Crate  Base File Center and Folder -> Clean Architecture for Centralize cs files =>
and get content of them and pass as FileContent
***foreach we need .replace file for keys and a common replace file
in the powershell center create project to manage base files 
retrive .replaces and add AppendToHashtable for using repaces
then using this project methods for Geting FileContent
    $fileExtension = ".cs";

    $fileName1 = '';
    $projectName = '';

    ReplaceAddCsFileToSolution

}