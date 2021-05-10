    #####################################################
    # @Module Identity = 9300cca0-5cd3-4ec4-a01b-cea43c4f4275
    #----------------------------------------------------
    # @Module File Name = Uninstll-Template
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\projects\TemplateCenter\Uninstll-Template.psm1'";
    # @CallUsage2 = AutoInvokeScript "Uninstll-Template";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 07/01/2020 01:37:58
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    AutoImportModule -FileName "Template-Lookup"
    #____________________________________________________#

function UninstallDotNetTmplateFromTemplateCenter {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $TemplateName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 7c96b2ed-e961-428f-b4a8-b454bd554b8f
    #----------------------------------------------------
    # @Function Name = UninstallDotNetTmplateFromTemplateCenter
    #----------------------------------------------------
    # @Usage = UninstallDotNetTmplateFromTemplateCenter
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 07/01/2020 01:38:36
    #____________________________________________________#.
    $templatePath = TemplateLookupInTemplateCenter -TemplateName $TemplateName -ThrowIfNotExistException;
    $templateBasePath = Split-Path -Path $templatePath -Parent | Split-Path -Parent;
    Start-Process dotnet -ArgumentList " new -u $templateBasePath" -WindowStyle Hidden -Wait;
    PowershellLogger -Message "The <$TemplateName> template uninstalled!" -LogType Success;
}

