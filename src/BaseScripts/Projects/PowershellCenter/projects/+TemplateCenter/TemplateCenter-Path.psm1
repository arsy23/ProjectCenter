    #####################################################
    # @Module Identity = 7ee0bd4b-6d2c-44a7-b172-d73d9cfb5563
    #----------------------------------------------------
    # @Module File Name = TemplateCenter-Path
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\projects\TemplateCenter\TemplateCenter-Path.psm1'";
    # @CallUsage2 = AutoInvokeScript "TemplateCenter-Path";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/30/2020 22:55:39
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
function ResolveTemplateCenterPath {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 2fda2a52-587b-433c-b3b1-0980fefe6a05
    #----------------------------------------------------
    # @Function Name = ResolveTemplateCenterPath
    #----------------------------------------------------
    # @Usage = ResolveTemplateCenterPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/30/2020 22:58:23
    #____________________________________________________#
    $ProjectsPath = ResolveProjectsPath;
    return "$ProjectsPath\TemplateCenter";
}

