#####################################################
# @Autor = Arsalan Fallahpour    
#----------------------------------------------------
# @Script Identity = fb0db6fb-fbe1-4f89-a499-3e3f3305aac4
#----------------------------------------------------
# @Script File Name = Import-Useful-Modules.ps1
#----------------------------------------------------
# @Usage = Invoke-Expression "& '$global:powershellCenterPath\project-development\tools\scaffolders\Project-Scaffolder.ps1'";
#----------------------------------------------------
# @Description = Scaffold project base on project type.
#----------------------------------------------------
# @Development Note = -
#----------------------------------------------------
# @Date Created = Monday, June 1, 2020 3:49:53 PM2
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
#----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule  -FileName "CleanArchitecture-Scaffolder";
# AutoImportModule  -FileName "OnionArchitecture-Scaffolder";
#____________________________________________________#

while ($selectedProjectType -ne "Exit Project Scaffolder") {
   $selectedProjectType = NumericOptionProvider -Message "What type of project you need to scaffold?" -Options @( 
      "Restore Dotnet Projects",      
      "Build Dotnet Projects",
      "Publish Nuget Packages",
      "Managed Class Library",
      "Unit test coverage for classlibrary project",
      "Clean Architecture", "Packing Nuget Packges", 
      "Onion Architecture"
      , "Exit Project Scaffolder" );

   switch ($selectedProjectType) {
      "Publish Nuget Packages" {
         AutoInvokeScript -FileName "Publish-NugetPackage-Options";
      } 
      "Build Dotnet Projects" {
         AutoInvokeScript -FileName "Build-DotNet-Project";
      } 
      "Restore Dotnet Projects" {
         AutoInvokeScript -FileName "Restore-DotNet-Project";
      }
      "Managed Class Library" { 
         ScaffoldManagedClasslibraryProject;
      }
      "Clean Architecture" {
         ScaffoldCleanArchitectureProject;
      }
      "Packing Nuget Packges" {
         PackingOptions;
      }
      "Onion Architecture" {
         ScaffoldOnionArchitectureProject;
      }
      "Unit test coverage for classlibrary project" {
         $csprojFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "Csproj" -Filter "dotnet csproj file (*.csproj)|*.csproj";
         $solutionFileName = ShowOpenFileDialogForProjects -FileTypeTitle "Solution" -Filter "dotnet project solution file (*.sln)|*.sln" -ResolveFileName;
         $csprojFileName = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path -Path $csprojFilePath -Leaf));
         $testProjectName = $csprojFileName + ".UnitTest";
         $csprojFilePathParts = $csprojFilePath.Split('\');
         $csprojFilePathPartsComponentIndex = $csprojFilePathParts.IndexOf("Components");
         if ($csprojFilePathPartsComponentIndex -ne -1) {
            $componentName = $csprojFilePathParts[$csprojFilePathPartsComponentIndex + 1];
         }
         else { 
            $componentName = "";
         }
         $csprojFilePathPartsProjectsIndex = $csprojFilePathParts.IndexOf("Projects");
         $projectName = $csprojFilePathParts[$csprojFilePathPartsProjectsIndex + 1];
         MakeNewXUnitProject -ComponentName $componentName -TestProjectName $testProjectName -ProjectToCoverageName $csprojFileName -SolutionFileName $solutionFileName -ProjectName $projectName -ProjectToCoverage;
      }
      Default {}
   }
}
