    #####################################################
    # @Module Identity = e498142c-f1fe-4b8b-821e-55dfdf73fc76
    #----------------------------------------------------
    # @Module File Name = FlunetApi-NugetPackage-Collection
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\dotnet\nuget-package-sets\FlunetApi-NugetPackage-Collection.psm1'";
    # @CallUsage2 = AutoInvokeScript "FlunetApi-NugetPackage-Collection";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/16/2020 14:30:48
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    AutoImportModule -FileName "hashtable";
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
    function GetDefaultFlunetValidationPackages(
        [Parameter(Mandatory =  $true)]
        [hashtable]
        $HashtableToAppend
    )  {
        #####################################################
        # @Autor = Arsalan Fallahpour    
        #----------------------------------------------------
        # @Function Identity = 8fb95bd8-32d0-4465-bb18-f4015c337749
        #----------------------------------------------------
        # @Function Name = GetDefaultFlunetApiPackages
        #----------------------------------------------------
        # @Usage = GetDefaultFlunetApiPackages
        #----------------------------------------------------
        # @Description = -
        #----------------------------------------------------
        # @Return = -
        #----------------------------------------------------
        # @Development Note = -
        #----------------------------------------------------
        # @Date Created = 06/16/2020 14:31:18
        #----------------------------------------------------
        #AutoImportModule -FileName "";
        #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
        #____________________________________________________#
        return AppendToHashtale -HashtableToAppend $HashtableToAppend -SourceHashtable @(
            "FluentValidation";
            "FluentValidation.AspNetCore"
        );
    }
    function GetDefaultApplicationLayerFlunetValidationPackages(
        [Parameter(Mandatory =  $true)]
        [hashtable]
        $HashtableToAppend
    )  {
        #####################################################
        # @Autor = Arsalan Fallahpour    
        #----------------------------------------------------
        # @Function Identity = 8fb95bd8-32d0-4465-bb18-f4015c337749
        #----------------------------------------------------
        # @Function Name = GetDefaultFlunetApiPackages
        #----------------------------------------------------
        # @Usage = GetDefaultFlunetApiPackages
        #----------------------------------------------------
        # @Description = -
        #----------------------------------------------------
        # @Return = -
        #----------------------------------------------------
        # @Development Note = -
        #----------------------------------------------------
        # @Date Created = 06/16/2020 14:31:18
        #----------------------------------------------------
        #AutoImportModule -FileName "";
        #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
        #____________________________________________________#
        return AppendToHashtale -HashtableToAppend $HashtableToAppend -SourceHashtable @(
            "FluentValidation";
        );
    }

