#####################################################
# @Module Identity = a6e6ead5-5a84-482a-b341-d1fe7c9248e4  
#----------------------------------------------------
# @Module File Name = Numeric-Option-Provider.psm1
#----------------------------------------------------
# @Module Description = This module provides a way to select an option through the index.
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Monday, June 1, 2020 3:49:53 PM
#____________________________________________________#
function NumericOptionProvider {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Message = "Enter option index you want to choose:  ",
        [Parameter(Mandatory = $false)]
        [string]
        $ErrorMessage = "Wrong Input!",
        [Parameter(Mandatory = $true)]
        [string[]]
        $Options,
        [switch]
        $IncludeAllOption,
        [switch]
        $IncludeCustomOption,
        [switch]
        $IncludeForeachOption,
        [switch]
        $IncludeExitOption
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = c279a0fc-f0f5-4e0b-8751-eebe37693fd8  
    #----------------------------------------------------
    # @Function Name = NumericOptionProvider
    #----------------------------------------------------
    # @Usage1 = NumericOptionProvider -Message $Message -Options @( "Option 1"
    # @Usage3 = NumericOptionProvider -Message $Message -Options @( "Option 1"; "Option 2")
    # @Usage2 = NumericOptionProvider -Message $Message -Options @( "Option 1"; "Option 2"; "Option 3") -ErrorMessage $ErrorMessage 
    #----------------------------------------------------
    # @Description = Get an user input from powershell console and compare with options that pass it to this function.
    #----------------------------------------------------
    # @Return = The Selected option text.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 3:49:53 PM
    #----------------------------------------------------
    if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

    #----------------------------------------------------
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\Console.psm1";
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\value-checkers\Special-Character-Checker.psm1";
    Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\type-validators\Numeric-Validator.psm1";
    #____________________________________________________#
    if ($IncludeAllOption -and ($Options.Count -ne 0)) { $Options += , @("All"); }
    if ($IncludeCustomOption) { $Options += , @("Custom"); }
    if ($IncludeForeachOption) { $Options += , @("Foreach"); }
    if ($IncludeExitOption) { $Options += , @("Exit"); }
    $userInputIsValid = $false;
    $userInput = 0;
    $firstTime = $true;
    do {
        if (!$firstTime) {
            RewriteConsoleOption -ErrorMessage $ErrorMessage -RewriteRowCount ($Options.Count + 3 ) -ClearRowCount 2;
        }
        $firstTime = $false;
        $optionIndex = 1;
        PowershellLogger -Message $Message -LogType Question -IncludeExtraLine -IncludeBottomExtraLine -NoFlag;
        foreach ($option in $Options) {
            $consoleBackColor = "White";
            $consoleForeColor = "Black";
            if ($optionIndex % 2 -eq 0) {
                $consoleBackColor = "Black";
                $consoleForeColor = "White";
            }
            Write-Host "$($optionIndex)- $($option) " -BackgroundColor $consoleBackColor -ForegroundColor $consoleForeColor;
            $optionIndex++;
        }
        try { [long]$userInput = Read-Host; } catch { }
        $userInputIsNullOrEmpty = [string]::IsNullOrEmpty($userInput);
        $userInputHasSpecialCharacter = SpecialCharacterChecker -Text $userInput;
        if ($userInputHasSpecialCharacter -or $userInputIsNullOrEmpty) {
            continue;
        }
        [int]$userInput = $userInput;
        $userInputInRange = ($userInput -gt 0) -and ($userInput -le $Options.Count);
        if ($userInputInRange) {
            $userInputIsValid = $true;
            ClearCurrentPowershellConsoleRow;
        }
    } while (!$userInputIsValid);
    return $Options[--$userInput];
}