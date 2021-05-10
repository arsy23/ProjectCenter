    #####################################################
    # @Module Identity = 747b85fb-25ee-48ae-b4ac-cd16a8ca88ed
    #----------------------------------------------------
    # @Module File Name = Operators.psm1
    #----------------------------------------------------
    # @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\powershell-scripting-utilities\Operators.psm1'";
    # @Usage2 = AutoInvokeScript "Operators";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/05/2020 18:47:26
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
function TernaryOperatorCondition {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [bool]
        $ConditionResult,
        [Parameter(Mandatory = $true, Position = 0)]
        [PSObject]
        $ValueIfTrue,
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateSet(':')]
        [char]
        $Colon,
        [Parameter(Mandatory = $true, Position = 2)]
        [PSObject]
        $ValueIfFalse
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 75e85ee3-b63f-4b10-b751-676a277f04cf
    #----------------------------------------------------
    # @Function Name = TernaryOperatorCondition
    #----------------------------------------------------
    # @Usage = TernaryOperatorCondition
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/05/2020 18:48:18
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    process {
        if ($ConditionResult) {
            $ValueIfTrue;
        }
        else {
            $ValueIfFalse;
        }
    }
}

        
function ImportUsefulOperators {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 292563fb-5cef-475f-94da-9a6006fc5b8a
    #----------------------------------------------------
    # @Function Name = ImportUsefulOperators
    #----------------------------------------------------
    # @Usage1 = 1 -eq 1 |??? 'match' : 'nomatch'
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/05/2020 18:48:42
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    set-alias -Name '???' -Value 'TernaryOperatorCondition' -Scope Global
}

