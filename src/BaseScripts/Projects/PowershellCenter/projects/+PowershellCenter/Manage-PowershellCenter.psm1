#####################################################
# @Module Identity = 3d6bff2f-5231-4da0-bafd-618f87435eac
#----------------------------------------------------
# @Module File Name = Manage-PowershellCenter.psm1
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Wednesday, June 3, 2020 1:07:02 PM
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#____________________________________________________#
function MakePowershellCenterScriptFile {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 63a085c4-89bb-48a7-969d-bfb069b245ca 
    #----------------------------------------------------
    # @Function Name = MakePowershellCenterScriptFile
    #----------------------------------------------------
    # @Usage = MakePowershellCenterScriptFile 
    #----------------------------------------------------
    # @Description = Making a powershell script file in the PowershellCenter.
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:13:27 PM
    #----------------------------------------------------
    AutoImportModule -FileName "File-Name"
    AutoImportModule -FileName "File-Extension"
    #____________________________________________________#    
    $selectedPath = GetPowershellCenterChildPath;
    $fileName = GetValidFileName -Message "Enter the Script file name:" -Path $selectedPath -FileExtension ".ps1";
    $content = @"
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Script Identity = $(New-Guid)
    #----------------------------------------------------
    # @Script File Name = $FileName
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& '$selectedPath\$fullFileName'";
    # @CallUsage2 = AutoInvokeScript "$fileName";
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Get-Date
    #----------------------------------------------------
    `$global:powershellCenterPath = ""; foreach (`$pathPart in ((Get-Location).Path).Split('\')) { `$global:powershellCenterPath += "`$pathPart\"; if (`$pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName ;
    #____________________________________________________#

"@;
    
    $content | Out-File -FilePath "$selectedPath\$fileName.ps1" -Encoding utf8;
    PowershellLogger -Message "Script file <$fileName> created successfully in <$selectedPath> path!" -LogType Success;
}
function GetPowershellCenterChildPath {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = a186bfda-04ee-49d2-8702-34ffa7ef3621
    #----------------------------------------------------
    # @Function Name = GetPowershellCenterChildPath
    #----------------------------------------------------
    # @Usage = GetPowershellCenterChildPath 
    #----------------------------------------------------
    # @Description = Get folder path inside the PowershellCenter project via folder browser dialog.
    #----------------------------------------------------
    # @Return = Absolute path of selected folder
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:13:27 PM
    #____________________________________________________# 
    do {   
    $selectedPath = ShowFolderBrowserDialogForPowershellCenter;
        $basePathOfSelectedPath = "";
        foreach ($pathPart in ($selectedPath).Split('\')) { 
            $basePathOfSelectedPath += "$pathPart\";
            if ($pathPart -eq "PowershellCenter") {
                break;
            }
        }
        if ($basePathOfSelectedPath -eq $global:powershellCenterPath) {
            return $selectedPath;
        }
    } while ($basePathOfSelectedPath -ne $global:powershellCenterPath);
}
function MakePowershellCenterModuleFile {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 6c5f222b-758d-4775-a9dd-f04f6f9f1a7e
    #----------------------------------------------------
    # @Function Name = MakePowershellCenterModuleFile
    #----------------------------------------------------
    # @Usage = MakePowershellCenterScriptFile 
    #----------------------------------------------------
    # @Description = Making a powershell module file in the PowershellCenter.
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:13:27 PM
    #----------------------------------------------------
    AutoImportModule -FileName "File-Name";
    #____________________________________________________#    
    $selectedPath = GetPowershellCenterChildPath;
    $fileName = GetValidFileName -Message "Enter the module file name:" -Path $selectedPath -FileExtension ".psm1";
    $content = @"
    #####################################################
    # @Module Identity = $(New-Guid)
    #----------------------------------------------------
    # @Module File Name = $FileName
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& '$selectedPath\$fileName.psm1'";
    # @CallUsage2 = AutoInvokeScript "$fileName";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = $(Get-Date)
    #----------------------------------------------------
    `$global:powershellCenterPath = ""; foreach (`$pathPart in ((Get-Location).Path).Split('\')) { `$global:powershellCenterPath += "`$pathPart\"; if (`$pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '`$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
"@;
    
    $content | Out-File -FilePath "$selectedPath\$fileName.psm1" -Encoding utf8;
    PowershellLogger -Message "Module file <$fileName> created successfully in <$selectedPath> path!" -LogType Success;

}
function GetValidModuleFunctionName {
    param(
        
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Message
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = d2939700-df25-4d58-800e-54ca0c1810af
    #----------------------------------------------------
    # @Function Name = GetValidModuleFunctionName
    #----------------------------------------------------
    # @Usage = GetValidModuleFunctionName 
    #----------------------------------------------------
    # @Description = Get user-input for module file name from powershell conole.
    #----------------------------------------------------
    # @Return = Module name.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:13:27 PM
    #____________________________________________________# 
    AutoImportModule -FileName "File-Name";
    AutoImportModule -FileName "Console";
    #____________________________________________________#    
    $userInputIsValid = $true;
    $userInput = "";
    $firstTime = $true;
    do {
        if (!$firstTime) {
            RewriteConsoleOption -ErrorMessage $Message -RewriteRowCount 2 -ClearRowCount 2;
        }
        $firstTime = $false;
        PowershellLogger -Message $Message -LogType Question -IncludeExtraLine -NoFlag;
        $userInput = Read-Host;
        $userInput = PrepareFileName -FileName $userInput -FileExtension '.psm1' -WithoutExtension;
        [char[]] $additionalIllegalCharacters = '_', '@', '-', '.', '\' , '/' , '-', '~', '`', ';', '$', '@', '!', '(', ')', '^', '%', '+', '"', '`', "'", ':', '=', ',', '{', '}', '&', ' ', '>', '<' ;
        $userInputIsValid = ValidateFileName -FileName $userInput -AdditionalIllegalCharacters $additionalIllegalCharacters
    }
    while (!$userInputIsValid)
    ClearCurrentPowershellConsoleRow;
    return $userInput;
}
function GetPowershellCenterChildModuleFile {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 54c3a562-9b52-4a76-ae5b-a3e374015bff
    #----------------------------------------------------
    # @Function Name = GetPowershellCenterChildModuleFile
    #----------------------------------------------------
    # @Usage = GetPowershellCenterChildModuleFile 
    #----------------------------------------------------
    # @Description = Get a module file inside the PowershellCenter project via open file dialog.
    #----------------------------------------------------
    # @Return = Absolute path of selected folder
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:13:27 PM
    #____________________________________________________# 
    do {   
        $selectedModulePath = ShowOpenFileDialogForPowershellCenter  -FileTypeTitle "Powershell module" -Filter "powershell module file (*.psm1)|*.psm1";
        $basePathOfSelectedPath = "";
        foreach ($pathPart in ($selectedModulePath).Split('\')) { 
            $basePathOfSelectedPath += "$pathPart\";
            if ($pathPart -eq "PowershellCenter") {
                break;
            }
        }
        if ($basePathOfSelectedPath -eq $global:powershellCenterPath) {
            return $selectedModulePath;
        }
    } while ($basePathOfSelectedPath -ne $global:powershellCenterPath);
}
function AddDefaultFunctionToPowershellCenterModuleFile {
    param(
        [switch]
        $AdvanceFunction
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 73d03bf5-f0a2-4c92-8b10-a8d7a2893ff6
    #----------------------------------------------------
    # @Function Name = AddDefaultFunctionToPowershellCenterModuleFile
    #----------------------------------------------------
    # @Usage = AddDefaultFunctionToPowershellCenterModuleFile 
    #----------------------------------------------------
    # @Description = Add a default powershell function in a PowershellCenter module.
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 1:13:27 PM
    #____________________________________________________# 

    $selectedModulePath = GetPowershellCenterChildModuleFile;
    $functionName = GetValidModuleFunctionName -Message "Enter function name:"; 
    if ($AdvanceFunction) {
        $content = @"
        
function $functionName {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = `$true)]
        [string]
        `$Variable 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = $(New-Guid)
    #----------------------------------------------------
    # @Function Name = $functionName
    #----------------------------------------------------
    # @Usage = $functionName
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = $(Get-Date)
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
}

"@;
    }
    else {
    $content = @"
        
function $functionName {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = `$true)]
        [string]
        `$Variable 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = $(New-Guid)
    #----------------------------------------------------
    # @Function Name = $functionName
    #----------------------------------------------------
    # @Usage = $functionName
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = $(Get-Date)
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
}

"@;
    
 
    }
    $content | Out-File -FilePath $selectedModulePath -Encoding utf8 -Append ;
    PowershellLogger -Message "Function <$functionName> maked successfully in <$selectedModulePath> module!" -LogType Success;
    
}