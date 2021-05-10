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
Invoke-Expression "& 'C:\Projects\PowershellCenter\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule -FileName "Dotnet-Cli-Command-Provider";
#____________________________________________________#

do {
    $selectedProjectType = NumericOptionProvider -Message "Choose one of restore options:" -Options @("Build all csproj file of a project", "Build a csproj file", "Exit build dotNet droject" );
    switch ($selectedProjectType) {
        "Build all csproj file of a project" { 
            $projectBasePath  = ShowFolderBrowserDialogForProjects -IncludeInSubFolders;
            Get-ChildItem -Path $projectBasePath -Filter "*.csproj" -Recurse | ForEach-Object {
                BuildProject -CsprojFileName $_.BaseName -ProjectName (Split-path -Path $projectBasePath -Leaf);
            };
        }
        "Build a csproj file" { 
            $csprojFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "Csproj" -Filter "dotnet csproj file (*.csproj)|*.csproj";
            $csprojFilePathParts = ((Get-Item -Path $csprojFilePath).DirectoryName).Split("\");
            $projectName = $csprojFilePathParts[$csprojFilePathParts.IndexOf("Projects") + 1];
            BuildProject -CsprojFileName (Split-Path -Path $csprojFilePath -Leaf) -ProjectName $projectName;
        }
    }
} while ($selectedProjectType -ne "Exit build dotNet droject");