    #####################################################
    # @Module Identity = e8288ced-2328-48c2-b68c-a5ff93d1845d
    #----------------------------------------------------
    # @Module File Name = Install-Template
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\projects\TemplateCenter\Install-Template.psm1'";
    # @CallUsage2 = AutoInvokeScript "Install-Template";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/30/2020 22:46:49
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
function InstallDotNetTmplateFromTemplateCenter {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $TemplateName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = ea89af39-12d1-458b-8430-d936f70a4e61
    #----------------------------------------------------
    # @Function Name = InstallDotNetTmplateFromTemplateCenter
    #----------------------------------------------------
    # @Usage = InstallDotNetTmplateFromTemplateCenter
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/30/2020 22:47:08
    #----------------------------------------------------
    AutoImportModule -FileName "Template-Lookup";
    #____________________________________________________#
    $templatePath = TemplateLookupInTemplateCenter -TemplateName $TemplateName -ThrowIfNotExistException;
    $templateBasePath = Split-Path -Path $templatePath -Parent | Split-Path -Parent;
    Start-Process dotnet -ArgumentList " new -i $templateBasePath" -WindowStyle Hidden -Wait;
    PowershellLogger -Message "The <$TemplateName> template installation is completed!" -LogType Success;
}   

