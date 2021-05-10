$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
# ----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
# AutoImportModule -FileName "";
AutoImportModule -FileName "Publish-NugetPackage";
AutoImportModule -FileName "FolderBrowser-Dialog";
AutoImportModule -FileName "Folder";
AutoImportModule -FileName "Folder";
do {
    $selectedProjectType = NumericOptionProvider -Message "Choose one of restore options:" -Options @(
        "Publish all NugetPackage<.nupkg> and <SymbolPackage>.snupkg file of a project",
        "Publish all NugetPackage<.nupkg> file of a project",
        "Publish all <SymbolPackage>.snupkg file of a project",
        "Publish a NugetPackage<.nupkg> and <SymbolPackage>.snupkg file",
        "Publish a NugetPackage<.nupkg> file",
        "Publish a <SymbolPackage>.snupkg file",
        "Exit Publish nuget services" );
    switch ($selectedProjectType) {
        "Publish all NugetPackage<.nupkg> and <SymbolPackage>.snupkg file of a project" { 
            $projectBasePath = ShowFolderBrowserDialogForProjects -IncludeInSubFolders;
            Get-ChildItem -Path $projectBasePath -Filter "*.nupkg" -Recurse | ForEach-Object {
                if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                    PublishNugetPackage -NugetPackageFilePath $_.FullName  -IncludeNugetPackageSymbol;
                }
            };
        }
        "Publish all <SymbolPackage>.snupkg file of a project" { 
            $projectBasePath = ShowFolderBrowserDialogForProjects -IncludeInSubFolders;
            Get-ChildItem -Path $projectBasePath -Filter "*.snupkg" -Recurse | ForEach-Object {
                if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                    PublishNugetPackage -NugetPackageFilePath $_.FullName;
                }
            };
        }
        "Publish a NugetPackage<.nupkg> and <SymbolPackage>.snupkg file" { 
            $nugetPackageFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "NugetPackage" -Filter "nuget package file (*.nupkg)|*.nupkg";
            if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                PublishNugetPackage -NugetPackageFilePath  $nugetPackageFilePath -IncludeNugetPackageSymbol;
            }
        }
        "Publish a NugetPackage<.nupkg> file" { 
            $nugetPackageFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "NugetPackage" -Filter "nuget package file (*.nupkg)|*.nupkg";
            if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                PublishNugetPackage -NugetPackageFilePath  $nugetPackageFilePath;
            }
        }
        "Publish a <SymbolPackage>.snupkg file" { 
            $nugetPackageFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "SymbolPackage" -Filter "nuget symbol package file (*.snupkg)|*.snupkg";
            if (([string][System.IO.Path]::GetDirectoryName($_.FullName)).Contains('bin\Release')) {
                PublishNugetPackage -NugetPackageFilePath  $nugetPackageFilePath;
            }
        }
    }
} while ($selectedProjectType -ne "Exit Publish nuget services");