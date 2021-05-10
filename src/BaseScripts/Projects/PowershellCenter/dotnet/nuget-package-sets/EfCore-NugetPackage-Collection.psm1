    #####################################################
    # @Module Identity = a8ad55f4-17c5-483c-b7f6-3acb842876ef
    #----------------------------------------------------
    # @Module File Name = Dotnet-Cli-NugetPackage-Sets
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\dotnet\cli\Dotnet-Cli-NugetPackage-CleanArchitecture-Sets.psm1'";
    # @CallUsage2 = AutoInvokeScript "Dotnet-Cli-NugetPackage-CleanArchitecture-Sets";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/16/2020 13:38:24
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    AutoImportModule -FileName "hashtable";
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
function GetDefaultEfCoreNugetPackages(
    [Parameter(Mandatory =  $true)]
    [hashtable]
    $HashtableToAppend
)  {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 3a4326d8-4094-4fd8-9fc7-9faa1ce42519
    #----------------------------------------------------
    # @Function Name = DefaultEfCoreNugetPackages
    #----------------------------------------------------
    # @Usage = DefaultEfCoreNugetPackages
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/16/2020 13:47:58
    #____________________________________________________#
    return AppendToHashtale -HashtableToAppend $HashtableToAppend -SourceHashtable @(
        "Microsoft.EntityFrameworkCore";
        "Microsoft.EntityFrameworkCore.Relational";
        "Microsoft.EntityFrameworkCore.SqlServer";
        "Microsoft.EntityFrameworkCore.Tools"
    );
}

