#####################################################
# @Autor = Arsalan Fallahpour    
#----------------------------------------------------
# @Script Identity = cda4068d-e0d6-4739-9909-3ea11bddf2f2
#----------------------------------------------------
# @Script File Name = Build-DotNet-Project
#----------------------------------------------------
# @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\dotnet\'";
# @CallUsage2 = AutoInvokeScript "Build-DotNet-Project";
#----------------------------------------------------
# @Description = -
#----------------------------------------------------
# @Development Note = -
#----------------------------------------------------
# @Date Created = Get-Date
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
# ----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule -FileName "Dotnet-Cli-Command-Provider";
#____________________________________________________#

$option1 = "Build all csproj file of a project";
$option2 = "Build a csproj file";
$optionExit = "Exit build dotNet project";
do {
    $selectedProjectType = NumericOptionProvider -Message "Choose one of restore options:" -Options @($option1, $option2, $optionExit );
    switch ($selectedProjectType) {
        $option1 { 
            $projectBasePath  = ShowFolderBrowserDialogForProjects -IncludeInSubFolders;
            $csprojFiles =  Get-ChildItem -Path $projectBasePath -Filter "*.csproj" -Recurse;
            $projectName = Split-path -Path $projectBasePath -Leaf;
            foreach ($file in $csprojFiles) {
                BuildProject -CsprojFileName $file.BaseName -ProjectName $projectName;
            }
               
        }
        $option2 { 
            $csprojFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "Csproj" -Filter "dotnet csproj file (*.csproj)|*.csproj";
            $csprojFilePathParts = ((Get-Item -Path $csprojFilePath).DirectoryName).Split("\");
            $projectName = $csprojFilePathParts[$csprojFilePathParts.IndexOf("Projects") + 1];
            BuildProject -CsprojFileName (Split-Path -Path $csprojFilePath -Leaf) -ProjectName $projectName;
        }
    }
} while ($selectedProjectType -ne $optionExit);