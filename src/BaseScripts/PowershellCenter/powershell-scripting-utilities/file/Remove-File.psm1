#####################################################
# @Module Identity = 8c8353a3-bff4-42da-ace7-fa94cc81ae60
#----------------------------------------------------
# @Module File Name = Remove-File
#----------------------------------------------------
# @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\powershell-scripting-utilities\file\Remove-File.psm1'";
# @CallUsage2 = AutoInvokeScript "Remove-File";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/30/2020 16:59:46
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
#----------------------------------------------------
#Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
#AutoImportModule -FileName "";
#AutoInvokeScript -FileName "" -Arguments @{"" =""; };
#____________________________________________________#
    
        
function RemoveFileExistInSubFolder {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileExtension
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 98b2dd24-0614-4bc7-913e-82bd20b40896
    #----------------------------------------------------
    # @Function Name = RemoveFileExistInSubFolder
    #----------------------------------------------------
    # @Usage = RemoveFileExistInSubFolder
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/30/2020 17:02:36
    #----------------------------------------------------
    AutoImportModule -FileName "File-Name";
    #____________________________________________________#
    $itemPath = FileLookingupByNameAndExtension -Path $Path -FileName $FileName -FileExtension $FileExtension -ThrowIfNotExistException;
    Start-Process powershell -ArgumentList ("Remove-Item " + " `'$itemPath`'" + " -InformationAction SilentlyContinue") -WindowStyle Hidden;
    $fullFileName = $FileName + $FileExtension;
    PowershellLogger -Message ("File <$fullFileName> removed from project <$itemPath> successfully!") -LogType Success -IncludeExtraLine;
}

