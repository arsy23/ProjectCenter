
#####################################################
# @Module Identity = efb51a9f-fd71-45ae-8c9f-e91c2f3442c5
#----------------------------------------------------
# @Module File Name = Powershell-Hashtable-Logger.psm1
#----------------------------------------------------
# @Module Description = Centralize collection logging on powershell console.
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Tuesday, June 2, 2020 10:55:49 AM
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
#____________________________________________________#
function PowershellHashtableLogger {
param (
   [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Message,
    [ValidateNotNull]
    [Parameter(Mandatory = $true)]
    [hashtable]
    $Collection,
    [switch]
    $IncludeExtraLine
    )
    
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 99574dbf-d1be-4574-b026-044da711b4fe 
    #----------------------------------------------------
    # @Function Name = PowershellHashtableLogger
    #----------------------------------------------------
    # @Usage = PowershellHashtableLogger -Message -LogType -Collection -IncludeExtraLine
    #----------------------------------------------------
    # @Description = Log a collection of key-value pairs on powershell console.
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 9:34:25 PM
    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\loggers\Powershell-Logger.psm1";
    #____________________________________________________#

   
    if($IncludeExtraLine)
    {
       $Message = "`n$Message "
    }
    else{
       $Message = "$Message "
    }
    
    PowershellLogger -Message  $Message  -LogType Title;
    
    $Collection.Keys |  ForEach-Object { 
        PowershellLogger -Message "$_ $($Collection[$_])" -LogType Information;
    };
    LogEndBody;
}