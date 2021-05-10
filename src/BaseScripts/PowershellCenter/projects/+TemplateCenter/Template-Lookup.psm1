    #####################################################
    # @Module Identity = 124c13b7-acfe-4a6d-98a3-57b440f25ce1
    #----------------------------------------------------
    # @Module File Name = Template-Lookup
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\projects\TemplateCenter\Template-Lookup.psm1'";
    # @CallUsage2 = AutoInvokeScript "Template-Lookup";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/30/2020 23:20:00
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
function TemplateLookupInTemplateCenter {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $TemplateName,
        [switch] 
        $ThrowIfNotExistException
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = cdecd701-5543-46ef-95a6-02f81074cf80
    #----------------------------------------------------
    # @Function Name = TemplateLookupInTemplateCenter
    #----------------------------------------------------
    # @Usage = TemplateLookupInTemplateCenter
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/30/2020 23:20:55
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $templateCenterPath = ResolveTemplateCenterPath;
    Get-ChildItem -Path $templateCenterPath -Recurse -File | Foreach-Object {
        if($_.Name -eq "template.json"){
            $json =  Get-Content -Path $_.FullName -Raw | ConvertFrom-Json ;
            if($json.shortName -eq $TemplateName){
                return $_.FullName;
            }
        }
    }
    if($ThrowExceptionIfNotExist)
    {
        throw [System.Exception]::new("The Template <$TmplateName> not exist in the <TemplateCenter>!");
    }
}

