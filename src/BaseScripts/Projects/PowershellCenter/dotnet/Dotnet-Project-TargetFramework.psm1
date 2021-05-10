#####################################################
# @Module Identity = 27b66151-541e-4fb8-9411-2f8d8253e25f
#----------------------------------------------------
# @Module File Name = Dotnet-Project-TargetFramework.psm1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\dotnet\Dotnet-Project-TargetFramework.psm1'";
# @Usage2 = AutoInvokeScript "Dotnet-Project-TargetFramework";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/04/2020 08:09:11
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#----------------------------------------------------
#Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
#AutoImportModule -FileName "Dotnet-Project-TargetFramework"
#____________________________________________________#
function GetSupportedTargetFrameworks {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectTemplate,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [switch]
        $IncludeNetstandard,
        [switch]
        $IncludeNetFramework,
        [switch]
        $LatestVersion
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 21286d80-c478-4937-93e3-ca87f5881b9f
    #----------------------------------------------------
    # @Function Name = AllNetStandardTargetFrameworks
    #----------------------------------------------------
    # @Usage = AllNetStandardTargetFrameworks
    #----------------------------------------------------
    # @Description = Retrive all the Netstandard Target-Frameworks from dotnet cli informations. 
    #----------------------------------------------------
    # @Return = Netstandard Target-Frameworks.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 08:23:43
    #----------------------------------------------------
    #AutoImportModule -FileName ""
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; }
    #____________________________________________________#
    if ($IncludeNetstandard -and $IncludeNetframework) {
        throw [System.Exception]::new("Using both switch <IncludeNetframework> and <IncludeNetstandard> at the same time is not allow!");
    }
    $netcoreappPattern = "netcoreapp";
    $netStandardPattern = "netstandard";
    $netFrameworkPattern = "net";
    $frameworkOptions = (New-Object -TypeName System.Collections.ArrayList)::new();
    $content = dotnet new $ProjectTemplate -h;
    $netcoreappFrameworkTexts = $content | Select-String -Pattern $netcoreappPattern;
    $pojectTemplateIncludeNetCoreApp = $netcoreappFrameworkTexts.Count -gt 0;
    if ($pojectTemplateIncludeNetCoreApp) {
        $frameworkOptions.Add("NetCoreApp") | Out-Null;
    }
    $netstandardFrameworkTexts = $content | Select-String -Pattern $netStandardPattern;
    $pojectTemplateIncludeNetstandard = $netstandardFrameworkTexts.Count -gt 0;
    if ($pojectTemplateIncludeNetstandard -and $IncludeNetstandard) {
        $frameworkOptions.Add("NetStandard") | Out-Null;
    }
    $netFrameworkTexts = $content | Select-String -Pattern $netFrameworkPattern -Exclude @("netcoreapp" , "netstandard");
    $pojectTemplateIncludeNetFramework = $netFrameworkTexts.Count -gt 0;
    if ($pojectTemplateIncludeNetFramework -and $IncludeNetFramework) {
        $frameworkOptions.Add("NetFramework") | Out-Null; ;
    }
    if ($frameworkOptions.Count -gt 1) {
        $isProjectSetupAsDefaultNetstandard =
         $ProjectName.EndsWith(".SharedKernel")  -or $ProjectName.EndsWith(".Domain");

        $isProjectSetupAsDefaultNetCoreApp = 
        $ProjectName.EndsWith(".Infrastructure")  -or $ProjectName.EndsWith(".Persistence.SharedKernel")   -or $ProjectName.Contains(".AspNetCore");

        $isProjectSetupAsDefaultNetCoreApp =
        $isProjectSetupAsDefaultNetCoreApp  -or $ProjectName.Contains(".EfCore")  -or $ProjectName.Contains(".EntityFrameworkCore");
        
        $isProjectSetupAsDefaultNetCoreApp = 
        $isProjectSetupAsDefaultNetCoreApp -or $ProjectName.EndsWith(".Application")  -or $ProjectName.Contains(".Persistence");

        if ($isProjectSetupAsDefaultNetstandard) {
            $selectedOption = "NetStandard";
        }
        elseif ($isProjectSetupAsDefaultNetCoreApp) {
            $selectedOption = "NetCoreApp";
        }
        else {
            $selectedOption = NumericOptionProvider -Message "Choose one of supported targetting options for the <$ProjectName> <$ProjectTemplate> template :" -Options $frameworkOptions;
        }
        switch ($selectedOption) {
            "NetStandard" {  
                $selectedPattern = $netStandardPattern;
                $frameworkTexts = $netstandardFrameworkTexts;
            }
            "NetCoreApp" { 
                $selectedPattern = $netcoreappPattern;
                $frameworkTexts = $netcoreappFrameworkTexts;
            }
            "NetFramework" { 
                $selectedPattern = $netFrameworkPattern;
                $frameworkTexts = $netFrameworkTexts;
            }
        }
    }
    if ($frameworkOptions.Count -eq 1){
        switch ($frameworkOptions[0]) {
            "NetStandard" {  
                $selectedPattern = $netStandardPattern;
                $frameworkTexts = $netstandardFrameworkTexts;
            }
            "NetCoreApp" { 
                $selectedPattern = $netcoreappPattern;
                $frameworkTexts = $netcoreappFrameworkTexts;
            }
            "NetFramework" { 
                $selectedPattern = $netFrameworkPattern;
                $frameworkTexts = $netFrameworkTexts;
            }
        }
    }
    if ($frameworkOptions.Count -eq 0) {
        throw [System.Exception]::new("the Project template <$ProjectTemplate> not support any target framework that you include it!");
    }
    $targetFrameworks = New-Object  System.Collections.ArrayList;
    foreach ($text in $frameworkTexts) {
        $framework = $text.ToString().Trim().Split(' ')[0];
        if ($framework -cmatch $selectedPattern) { 
            $targetFrameworks.Add($framework) | Out-Null;
        }
    }
    if ($LatestVersion) {
        return $targetFrameworks[0];
    }
    return $targetFrameworks;
}
function ProvideTargetFramework {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectType,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [switch]
        $LatestVersion
    )
    $targetedType = $ProjectType.Trim().ToLower();
    switch ($targetedType) {
        "razorpage" {
            return GetSupportedTargetFrameworks -ProjectName $ProjectName -ProjectTemplate "razorpage" -LatestVersion:$LatestVersion;
        }
        "classlib" {
            return GetSupportedTargetFrameworks -ProjectName $ProjectName -ProjectTemplate "classlib" -LatestVersion:$LatestVersion -IncludeNetstandard;
        }
        "xunit" {
            return GetSupportedTargetFrameworks -ProjectName $ProjectName -ProjectTemplate "xunit" -LatestVersion:$LatestVersion;
        }
        "nunit" {
            return GetSupportedTargetFrameworks -ProjectName $ProjectName -ProjectTemplate "nunit" -LatestVersion:$LatestVersion -IncludeNetFramework;
        }
        "mstest" {
            return GetSupportedTargetFrameworks -ProjectName $ProjectName -ProjectTemplate "mstest" -LatestVersion:$LatestVersion -IncludeNetFramework;
        }
        Default { 
            throw [System.Exception]::new("The <$targetedType> project type for dotnet.exe is not supported or not valid!");
        }
    }
}