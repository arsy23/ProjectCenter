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

$option1 = "Restore Dotnet Projects";
$option2 = "Build Dotnet Projects";
$option3 = "Publish Nuget Packages";
$option4 = "Packing Nuget Packges";
$option5 = "Clean Architecture";
$option6 = "Managed Class Library";
$option7 = "Onion Architecture";
$option8 = "Unit test coverage for classlibrary project";
$optionExit = "Exit Project Scaffolder";
while ($selectedProjectType -ne $optionExit) {
   $selectedProjectType = NumericOptionProvider -Message "What type of project you need to scaffold?" -Options @( 
      $option1,      
      $option2,
      $option3,
      $option4,
      $option5,
      $option6,
      $option7,
      $option8,
      $optionExit );

   switch ($selectedProjectType) {
      $option1 {
         AutoInvokeScript -FileName "Restore-DotNet-Project";
      } 
      $option2 {
         AutoInvokeScript -FileName "Build-DotNet-Project";
      } 
      $option3 {
         AutoInvokeScript -FileName "Publish-NugetPackage-Options";
      }
      $option4 { 
         PackingOptions;
      }
      $option5 {
         ScaffoldCleanArchitectureProject;
      }
      $option6 {
         ScaffoldManagedClasslibraryProject;
      }
      $option7 {
         ScaffoldOnionArchitectureProject;
      }
      $option8 {
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
