    #####################################################
    # @Module Identity = 725ae6a8-a036-4e74-ba3c-7041dd733df4
    #----------------------------------------------------
    # @Module File Name = File-Path.psm1
    #----------------------------------------------------
    # @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\powershell-scripting-utilities\file\File-Path.psm1'";
    # @Usage2 = AutoInvokeScript "File-Path";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/06/2020 14:51:12
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
