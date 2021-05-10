#####################################################
# @Module Identity = 4886c5e9-9053-4669-a7da-f1fafb66e07b
#----------------------------------------------------
# @Module File Name = Folder.psm1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\powershell-scripting-utilities\Folder.psm1'";
# @Usage2 = AutoInvokeScript "Folder";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/04/2020 12:18:36
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
#Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
#AutoImportModule -FileName "";
#AutoInvokeScript -FileName "" -Arguments @{"" =""; };
#____________________________________________________#

function AppendToHashtale()
{
    
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0eb555ff-4032-4932-a9ee-f4588bca727c
    #----------------------------------------------------
    # @Function Name = AppendToHashtale
    #----------------------------------------------------
    # @Usage = ShowFolderBrowserDialog -MakeRelative
    #----------------------------------------------------
    # @Description = Show a folder dialog in the PowershellCenter path.
    #----------------------------------------------------
    # @Return = Depends on the <$MakeRelative> switch this function return absolute path or relative path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:40:24 PM
    #____________________________________________________# 
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]
        $SourceHashtable,
        [Parameter(Mandatory = $true)]
        [hashtable]
        $HashtableToAppend
    ) 
    foreach ($sourceHashtableItem in $SourceHashtable) {
        $HashtableToAppend.Add($SourceHashtable);
    }
    return $HashtableToAppend;
}