
#####################################################
# @Module Identity = ffb539b4-c5bf-4dd5-9b93-e918bee2eac8
#----------------------------------------------------
# @Module File Name = Import-PowershellCenter-Module.psm1
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Wednesday, June 3, 2020 11:19:59 AM
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
Import-Module "$global:powershellCenterPath\projects\+PowershellCenter\Resolve-PowershellCenter-FilePath.psm1";
#____________________________________________________#
function AutoImportModule {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = ef077ce4-0dde-4e2a-9efc-a16217540f64
    #----------------------------------------------------
    # @Function Name = AutoImportModule
    #----------------------------------------------------
    # @Usage = AutoImportModule -FileName 
    #----------------------------------------------------
    # @Description = Import PowershellCenter module.
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Tuesday, June 2, 2020 9:06:00 PM
    #____________________________________________________#
    $fileNameWithoutExtension = $FileName.Replace('.psm1', '');
    $filePath = PowershellCenterFilesPathByNameAndExtension -FileName $fileNameWithoutExtension -FileExtension ".psm1";
    $isAnyImported = $global:AllImportedModules.Count -gt 0;
    if ($isAnyImported) {
        foreach ($module in $global:AllImportedModules) {
            if ($module -eq $fileNameWithoutExtension) {
                return; 
            }
        }
    }
    else{
        $Global:AllImportedModules = New-Object -TypeName System.Collections.ArrayList;
    }
    $global:AllImportedModules.Add($fileNameWithoutExtension) | Out-Null;
    if ([string]::IsNullOrEmpty($filePath)) {
        throw [System.Exception]::new("The File <$fileNameWithoutExtension.psm1> not find in PoewershellCenter!");
    }
    $filePath = $filePath.Trim();
    Import-Module $filePath -Global;
}