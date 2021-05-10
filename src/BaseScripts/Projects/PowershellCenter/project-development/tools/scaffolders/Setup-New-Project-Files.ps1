param (
    [Parameter(Mandatory = $false)]
    [string]
    $SolutionFileName,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $ProjectName
)
#####################################################
# @Autor = Arsalan Fallahpour    
#----------------------------------------------------
# @Script Identity = 54302440-cd68-46fc-bbe1-df676ecaa08b
#----------------------------------------------------
# @Script File Name = Setup-New-Project-Files.ps1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\project-development\tools\scaffolders\Setup-New-Project-Files.ps1'";
# @Usage2 = AutoInvokeScript "Setup-New-Project-Files";
#----------------------------------------------------
# @Description = -
#----------------------------------------------------
# @Development Note = -
#----------------------------------------------------
# @Date Created = Get-Date
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
Invoke-Expression "& 'C:\Projects\PowershellCenter\\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule -FileName "Dotnet-Solution";
#____________________________________________________#
$_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
if (!(Test-Path -Path $_projectBasePath)) { mkdir -Path $_projectBasePath; }
[string[]] $fileList = "$global:powershellCenterPath\project-development\tools\scaffolders\assets\README.md",
"$global:powershellCenterPath\project-development\tools\scaffolders\assets\.gitignore",
"$global:powershellCenterPath\project-development\tools\scaffolders\assets\.gitattributes";

foreach ($file in $fileList) { 
    Copy-Item -Path $file -Destination $_projectBasePath -InformationAction  SilentlyContinue; 
    $fileName = Split-Path -Path $file -Leaf;
    PowershellLogger -Message "<$fileName> file copied in <$_projectBasePath> path successfully" -LogType Success;
}
    
$folders = "Source", "Libraries", "Documents", "Scripts", "Build", "Databases", "UserInterface";
    
foreach ($folder in $folders) { 
    New-Item -Path "$_projectBasePath\" -Name $folder -ItemType "Directory" | Out-Null;  
    PowershellLogger -Message "<$folder> folder maked in <$_projectBasePath> path successfully" -LogType Success;
}
if (![string]::IsNullOrEmpty($SolutionFileName)) {
        AddExistingFilesToSolution -ProjectName $ProjectName -ExistingFilePath @("README.md", ".gitignore", ".gitattributes") -SolutionFileName $SolutionFileName -SolutionFolderName "Solution Items";
}
