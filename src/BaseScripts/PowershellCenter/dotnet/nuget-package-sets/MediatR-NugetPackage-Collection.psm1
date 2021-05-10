    #####################################################
    # @Module Identity = 07e71d4a-7b63-4ecf-bcdc-22357fc5d9ae
    #----------------------------------------------------
    # @Module File Name = MediatR-NugetPackage-Collection
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\dotnet\nuget-package-sets\MediatR-NugetPackage-Collection.psm1'";
    # @CallUsage2 = AutoInvokeScript "MediatR-NugetPackage-Collection";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/16/2020 14:23:47
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    AutoImportModule -FileName "hashtable";
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
    function GetDefaultMediatRPackages(
        [Parameter(Mandatory =  $true)]
        [hashtable]
        $HashtableToAppend
    )  {
        #####################################################
        # @Autor = Arsalan Fallahpour    
        #----------------------------------------------------
        # @Function Identity = 69810d10-d860-4ac7-b75e-763db1ed2b7a
        #----------------------------------------------------
        # @Function Name = GetDefaultMediatRPackages
        #----------------------------------------------------
        # @Usage = GetDefaultMediatRPackages
        #----------------------------------------------------
        # @Description = -
        #----------------------------------------------------
        # @Return = -
        #----------------------------------------------------
        # @Development Note = -
        #----------------------------------------------------
        # @Date Created = 06/16/2020 14:24:43
        #----------------------------------------------------
        #AutoImportModule -FileName "";
        #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
        #____________________________________________________#
        return AppendToHashtale -HashtableToAppend $HashtableToAppend -SourceHashtable @(
            "MediatR";
            # "MediatR.Extensions.Autofac.DependencyInjection";
            "MediatR.Extensions.Microsoft.DependencyInjection"
        );
    }
    function GetDefaultApplicationLayerMediatRPackages(
        [Parameter(Mandatory =  $true)]
        [hashtable]
        $HashtableToAppend
    )  {
        #####################################################
        # @Autor = Arsalan Fallahpour    
        #----------------------------------------------------
        # @Function Identity = 69810d10-d860-4ac7-b75e-763db1ed2b7a
        #----------------------------------------------------
        # @Function Name = GetDefaultMediatRPackages
        #----------------------------------------------------
        # @Usage = GetDefaultMediatRPackages
        #----------------------------------------------------
        # @Description = -
        #----------------------------------------------------
        # @Return = -
        #----------------------------------------------------
        # @Development Note = -
        #----------------------------------------------------
        # @Date Created = 06/16/2020 14:24:43
        #----------------------------------------------------
        #AutoImportModule -FileName "";
        #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
        #____________________________________________________#
        return AppendToHashtale -HashtableToAppend $HashtableToAppend -SourceHashtable @(
            "MediatR";
        );
    }
        
