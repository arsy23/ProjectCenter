
#####################################################
# @Module Identity = b31e1726-e885-4418-a4ac-9f1a93b80228 
#----------------------------------------------------
# @Module File Name = Powershell-Logger.psm1
#----------------------------------------------------
# @Module Description = Centralize logging  on powershell console.
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Monday, June 1, 2020 9:34:25 PM
#____________________________________________________#
function PowershellLogger {
param (
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Message,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $LogType,
    [switch]
    $IncludeExtraLine,
    [switch]
    $IncludeBottomExtraLine,
    [switch]
    $NoFlag
    )
    
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = e2751475-e3b6-4c49-aadd-005ede75a9a1
    #----------------------------------------------------
    # @Function Name = PowershellLogger
    #----------------------------------------------------
    # @Usage = PowershellLogger -Message -LogType
    #----------------------------------------------------
    # @Description = Log a message on powershell console.
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 9:34:25 PM
    #____________________________________________________#

    $colors = GetPowershellLoggerColors -LogType $LogType;
    $flag = GetPowershellLoggerFlags -LogType $LogType;

    if($IncludeExtraLine)
    {
        $outputMessage = "`n";
    }
    if(!$NoFlag){
        $outputMessage += "$flag ";
    }
    $outputMessage += $Message;
    Write-Host $outputMessage  -BackgroundColor $colors.BackgroundColor -ForegroundColor $colors.ForegroundColor;
    if($IncludeBottomExtraLine)
    {
        [System.Console]::WriteLine();
    }
}

function GetPowershellLoggerFlags {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $LogType
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4a4f500a-4fa9-405d-af91-919456e72d24  
    #----------------------------------------------------
    # @Function Name = GetPowershellLoggerFlags
    #----------------------------------------------------
    # @Usage1 = GetPowershellLoggerFlags -LogType Error
    # @Usage2 = GetPowershellLoggerFlags -LogType Success
    # @Usage3 = GetPowershellLoggerFlags -LogType Information
    #----------------------------------------------------
    # @Description = Get log message flag base on log type.
    #----------------------------------------------------
    # @Return = Return flag of a log message base on the LogType.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 9:34:25 PM
    #____________________________________________________#
    
        switch ($LogType) {
            "Error" { return "---error: " } 
            "Success"   { return "~~~success: " } 
            "Report"   { return "***Report: " }
            "Information"   { return "!!!information: " }
            "Title"   { return "@@@title: " }
            "Warning"   { return "!-->warning: " }
            "Question"   { return "???question: " }
            "GitCommited"   { return "(git commited): " }
            "GitBranchCheckout"   { return "(git cechkout branch): " }
            "GitBranchCheckoutNew"   { return "(git checkout new branch): " }
            "GitBranchNew"   { return "(git create new branch): " }
            "GitUnStageChanges"   { return "(git unstage changes): " }
            Default { return "   : "}
        }
    }

function LogEndBody {
    
    $color = GetPowershellLoggerColors -LogType EndInformationBody 
    Write-Host "+++++++++++++++++++++++++++++++++" -BackgroundColor $color.BackgroundColor -ForegroundColor $color.ForegroundColor;
    
}
function GetPowershellLoggerColors {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $LogType
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 1789e6f8-ec5b-4c58-95fc-b49dbb4b7f8f 
    #----------------------------------------------------
    # @Function Name = NumericOptionProvider
    #----------------------------------------------------
    # @Usage = -
    #----------------------------------------------------
    # @Description = Get log message flag base on log type.
    #----------------------------------------------------
    # @Return = Return foreground and background for log message base on the LogType.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 9:34:25 PM
    #____________________________________________________#
    
        switch ($LogType) {
            "Error" { return  @{"ForegroundColor" = "DarkRed"; "BackgroundColor" = "White" } }
            "Success"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "Yellow" } }
            "Information"   { return  @{"ForegroundColor" = "DarkYellow"; "BackgroundColor" = "Black" } }
            "Information"   { return  @{"ForegroundColor" = "DarkCyan"; "BackgroundColor" = "DarkYellow" } }
            "Report"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "DarkYellow" } }
            "Title"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "DarkGray" } }
            "Question"   { return  @{"ForegroundColor" = "Yellow"; "BackgroundColor" = "Black" } }
            "EndInformationBody"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "DarkGray" } }
            "GitCommited"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "Yellow" } }
            "GitBranchCheckout"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "DarkGray" } }
            "GitUnStageChanges"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "DarkGray" } }
            "GitBranchNew"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "DarkGray" } }
            "GitBranchCheckoutNew"   { return  @{"ForegroundColor" = "Black"; "BackgroundColor" = "DarkYellow" } }
            Default {return  @{"ForegroundColor" = [console]::ForegroundColor; "BackgroundColor" =  [Console]::BackgroundColor } }
        }
    }