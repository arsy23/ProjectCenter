    
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
# ----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule -FileName "File-Lookup";
AutoImportModule -FileName "ApiKeys.Secret";

function PublishNugetPackage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NugetPackageFilePath,
        [switch]
        $IncludeNugetPackageSymbol
    )   
    PowershellLogger -Message "Try Push NugetPackage <$NugetPackageFilePath> with DotNet Cli to the Nuget server" -LogType Report -IncludeExtraLine;
    if ($IncludeNugetPackageSymbol) {
        PowershellLogger -Message "Try Push with Nuget Package Symbol <$NugetPackageFilePath> with DotNet Cli to the Nuget server" -LogType Report -IncludeExtraLine;
        $fileDirectoryName = [System.IO.Path]::GetDirectoryName($NugetPackageFilePath);
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($NugetPackageFilePath);
        $symbolFileExtension = '.snupkg' ;
        $symboFilePath = $fileDirectoryName + '\' + $fileName + $symbolFileExtension;
        $isSymbolExist = FileExistInRootPath -FileExtension $symbolFileExtension -FileBasePath $fileDirectoryName -FileName $fileName;
        if (!$isSymbolExist) {
            PowershellLogger -Message "Nuget Package Symbol <$symboFilePath> file  not find in nuget package place" -LogType Success -IncludeExtraLine;
            $symbolCommand = '--no-symbols';
        }
    }
    else {
        $symbolCommand = '--no-symbols';
    } 
    $apiKey = GetApiKey -Source 'Nuget';
    dotnet nuget push $NugetPackageFilePath --skip-duplicate --source 'https://api.nuget.org/v3/index.json'  --api-key $apiKey $symbolCommand;
};