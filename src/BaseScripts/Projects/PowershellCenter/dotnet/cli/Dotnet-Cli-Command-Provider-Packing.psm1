$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
AutoImportModule -FileName "FolderBrowser-Dialog";
AutoImportModule -FileName "Folder";
function PackAllPackages {

$selectedPath  = ShowFolderBrowserDialogForSelectOneOfProjectInProjects -IncludeInSubFolders;
$userinput = Read-Host -Prompt 'Pack Version Version';
Get-ChildItem -Path $selectedPath -Filter "*.nupkg" -Recurse | ForEach-Object {
    if ($_.FullName.Contains($userinput)) {
        PackNugetPackage -Path $_.FullName;
    }
};
}

function PackAPackage {
    $selectedFile = ShowOpenFileDialogForProjects -FileTypeTitle "Nuget Package" -Filter "nuget package file (*.nupkg)|*.nupkg";
    PackNugetPackage -Path $selectedFile;
    }
    
    function PackNugetPackage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )    
        dotnet nuget push $Path --api-key 'oy2mrilpe7jmymsadllanghbvm6xcb4uxgbi4gxs3esxqm' --source 'https://api.nuget.org/v3/index.json'
    }