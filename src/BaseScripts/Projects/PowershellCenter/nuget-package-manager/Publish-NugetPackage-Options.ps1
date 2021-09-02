$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
# ----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
# AutoImportModule -FileName "";
AutoImportModule -FileName "Publish-NugetPackage";
AutoImportModule -FileName "FolderBrowser-Dialog";
AutoImportModule -FileName "Folder";
AutoImportModule -FileName "ClearNugetPackages";

$option1 = "Clear all package file of a project";
$option2 = "Publish all NugetPackage<.nupkg> and <SymbolPackage>.snupkg file of a project";
$option3 = "Publish all NugetPackage<.nupkg> and <SymbolPackage>.snupkg file of a project";
$option4 = "Publish all NugetPackage<.nupkg> file of a project";
$option5 = "Publish all <SymbolPackage>.snupkg file of a project";
$option6 = "Publish a NugetPackage<.nupkg> and <SymbolPackage>.snupkg file";
$option7 = "Publish a NugetPackage<.nupkg> file";
$option8 = "Publish a <SymbolPackage>.snupkg file";
$optionExit = "Exit Publish nuget services";
do {
    $selectedProjectType = NumericOptionProvider -Message "Choose one of restore options:" -Options @(
        $option1,
        $option2,
        $option3
        $option4,
        $option5,
        $option6,
        $option7,
        $optionExit );
    switch ($selectedProjectType) {
        $option1{ 
            $projectBasePath = ShowFolderBrowserDialogForProjects -IncludeInSubFolders;
            ClearNugetPackages -Path $projectBasePath;
        }
        $option2{ 
            $projectBasePath = ShowFolderBrowserDialogForProjects -IncludeInSubFolders;
            Get-ChildItem -Path $projectBasePath -Filter "*.nupkg" -Recurse | ForEach-Object {
                if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                    ClearNugetPackages -NugetPackageFilePath $_.FullName  -IncludeNugetPackageSymbol;
                }
            };
        }
        $option3{ 
            $projectBasePath = ShowFolderBrowserDialogForProjects -IncludeInSubFolders;
            Get-ChildItem -Path $projectBasePath -Filter "*.nupkg" -Recurse | ForEach-Object {
                if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                    PublishNugetPackage -NugetPackageFilePath $_.FullName  -IncludeNugetPackageSymbol;
                }
            };
        }
        $option4 { 
            $projectBasePath = ShowFolderBrowialogForProjects -IncludeInSubFolders;
            Get-ChildItem -Path $projectBasePath -Filter "*.snupkg" -Recurse | ForEach-Object {
                if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                    PublishNugetPackage -NugetPackageFilePath $_.FullName;
                }
            };
        }
        $option5 { 
            $nugetPackageFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "NugetPackage" -Filter "nuget package file (*.nupkg)|*.nupkg";
            if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                PublishNugetPackage -NugetPackageFilePath  $nugetPackageFilePath -IncludeNugetPackageSymbol;
            }
        }
        $option6 { 
            $nugetPackageFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "NugetPackage" -Filter "nuget package file (*.nupkg)|*.nupkg";
            if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                PublishNugetPackage -NugetPackageFilePath  $nugetPackageFilePath;
            }
        }
        $option7 { 
            $nugetPackageFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "SymbolPackage" -Filter "nuget symbol package file (*.snupkg)|*.snupkg";
            if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                PublishNugetPackage -NugetPackageFilePath  $nugetPackageFilePath;
            }
        }
    }
} while ($selectedProjectType -ne $optionExit);