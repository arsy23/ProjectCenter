    #####################################################
    # @Module Identity = f00647f3-760c-456f-a4a4-67fbd2bfbac2
    #----------------------------------------------------
    # @Module File Name = AutoMapper-NugetPackage-Collection
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\dotnet\nuget-package-sets\AutoMapper-NugetPackage-Collection.psm1'";
    # @CallUsage2 = AutoInvokeScript "AutoMapper-NugetPackage-Collection";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/16/2020 14:27:59
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    AutoImportModule -FileName "hashtable";
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
   
function GetDefaultMicrosoftExtensionsDependencyInjectionAbstractionsPackages(
    [Parameter(Mandatory =  $true)]
    [hashtable]
    $HashtableToAppend
)  {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 37fa0b19-3f98-4bc8-bba5-56f3feb06617
    #----------------------------------------------------
    # @Function Name = GetDefaultAutoMapperPackages
    #----------------------------------------------------
    # @Usage = GetDefaultAutoMapperPackages
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/16/2020 14:29:09
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    return AppendToHashtale -HashtableToAppend $HashtableToAppend -SourceHashtable @(
        "Microsoft.Extensions.DependencyInjection.Abstractions"
    );
}
