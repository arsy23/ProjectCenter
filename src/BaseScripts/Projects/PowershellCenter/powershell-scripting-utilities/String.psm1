    #####################################################
    # @Module Identity = 6848add8-b5d8-4ad5-bbce-e78371fe1159
    #----------------------------------------------------
    # @Module File Name = String
    #----------------------------------------------------
    # @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\powershell-scripting-utilities\String.psm1'";
    # @Usage2 = AutoInvokeScript "String";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/08/2020 19:29:35
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #____________________________________________________#
function ReplaceAnyOfCharactersWith {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Text,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [char[]]
        $Characters,
        [Parameter(Mandatory = $false)]
        [char]
        $ReplaceChar = "`0",
        [switch]
        $IncludeIllegalChars
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 01ef85ec-cdd6-4d87-a8d8-462bb14b85db
    #----------------------------------------------------
    # @Function Name = ReplaceAnyOfCharactersWith
    #----------------------------------------------------
    # @Usage = ReplaceAnyOfCharactersWith
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/08/2020 19:30:13
    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\collection\Get-Illegal-Path-Characters.psm1";
    #____________________________________________________#
    $outputText = $Text;
    if($IncludeIllegalChars)
    {
        $allChars = GetDefaultIllegalPathCharacters -OutputType CharArray;
        $allChars += $Characters;
    }
    foreach ($char in $allChars) {
        $outputText = $outputText.Replace($char, $ReplaceChar)
    }
    return $outputText;
}

