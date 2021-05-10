    #####################################################
    # @Module Identity = 232a46c5-adba-418c-a84f-d523727d4adf
    #----------------------------------------------------
    # @Module File Name = PowershellCenter-Path.psm1
    #----------------------------------------------------
    # @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\projects\+PowershellCenter\PowershellCenter-Path.psm1'";
    # @Usage2 = AutoInvokeScript "PowershellCenter-Path";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/05/2020 18:52:40
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #____________________________________________________#
function MakeRelativeToPowershellCenter {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 6da575fc-5330-4fbf-9dca-618303eeace3
    #----------------------------------------------------
    # @Function Name = MakeRelativeToPowershellCenter
    #----------------------------------------------------
    # @Usage = MakeRelativeToPowershellCenter
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/05/2020 18:53:28
    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\Path.psm1";
    #____________________________________________________#
    $Path = "C:\Projects\PowershellCenter\project-development\tools\scaffolders\CleanArchitecture-Scaffolder.psm1";
    $Path = PrepareAbsolutePath -Path $Path;
    return MakeRelativeToPathPart -Path $Path -PathPart "PowershellCenter";
}

