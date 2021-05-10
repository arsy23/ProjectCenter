

#####################################################
# @Module Identity = 2284708a-0366-45af-8a7f-f28d11ca12306
#----------------------------------------------------
# @Module File Name = Resolve-PowershellCenter-FilePath.psm1
#----------------------------------------------------
# @Module Description = Resolve relative or absolute path for a exsited module.
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Tuesday, June 2, 2020 9:33:08 AM
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#____________________________________________________#

function PowershellCenterFilesPathByNameAndExtension {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileExtension,
        [switch]
        $MakeRelative
    )
    #####################################################
    # @Autor = Arsalan Fallahpour
    #----------------------------------------------------
    # @Function Identity = 40a4645a-9690-4982-a388-6b3c7757c584
    #----------------------------------------------------
    # @Function Name = GetPowershellCenterFilePathByFileName
    #----------------------------------------------------
    # @Usage = GetPowershellCenterFilePathByFileName -FileName
    #----------------------------------------------------
    # @Description = Find file in the PowershellCneter by file name.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 3:49:53 PM
    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\file\File-Lookup.psm1";
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\file\File-Extension.psm1";
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\file\File-Name.psm1";
    #____________________________________________________#
    $_fileName = PrepareFileName -FileName $FileName -FileExtension $FileExtension -WithoutExtension;
    $_fileExtension = PrepareFileExtension -FileExtension $FileExtension -ThrowException;

    SupportFileExtension -FileExtension $_fileExtension -SupportedFileExtensions @(".psm1", ".ps1", ".psd1") -ThrowException;

    return FileLookingupByNameAndExtension -Path $global:powershellCenterPath -FileName $_fileName -FileExtension $_fileExtension -ThrowIfNotExistException;
}

function PowershellCenterFilesPathByName {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileName,
        [switch]
        $MakeRelative
    )
    #####################################################
    # @Autor = Arsalan Fallahpour
    #----------------------------------------------------
    # @Function Identity = 7542e40e-0ec0-46b4-a639-ef2336b691cf
    #----------------------------------------------------
    # @Function Name = GetPowershellCenterFilePathByFileName
    #----------------------------------------------------
    # @Usage = GetPowershellCenterFilePathByFileName -FileName
    #----------------------------------------------------
    # @Description = Find file in the PowershellCneter by file name.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 3:49:53 PM
    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\Path.psm1";
    #____________________________________________________#
    $FileName = PrepareFileName -FileName $FileName;
    return FileLookingupByName -Path $global:powershellCenterPath -FileName $FileName;
}