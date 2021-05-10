    #####################################################
    # @Module Identity = 1f5b6a80-f415-446f-a81b-405f1ab57663
    #----------------------------------------------------
    # @Module File Name = DotNet-Cli-Command-Provider-For-TemplateCenter
    #----------------------------------------------------
    # @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\projects\TemplateCenter\DotNet-Cli-Command-Provider-For-TemplateCenter.psm1'";
    # @CallUsage2 = AutoInvokeScript "DotNet-Cli-Command-Provider-For-TemplateCenter";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 07/01/2020 13:11:55
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #____________________________________________________#
    function MakeNewDotnetPresentationFromTemplateCenter {
        param(
            [ValidateNotNullOrEmpty()]
            [Parameter(Mandatory = $true)]
            $SolutionFileName,
            [ValidateNotNullOrEmpty()]
            [Parameter(Mandatory = $true)]
            $OutputPath,
            [switch]
            $EnableRuntimeCompilation
        )
        #####################################################
        # @Autor = Arsalan Fallahpour    
        #----------------------------------------------------
        # @Function Identity = 9cb66370-8baf-4b20-8b61-dcf15f87c06f
        #----------------------------------------------------
        # @Function Name = MakeNewDotnetPresentation
        #----------------------------------------------------
        # @Usage = MakeNewDotnetPresentation
        #----------------------------------------------------
        # @Description = -
        #----------------------------------------------------
        # @Return = -
        #----------------------------------------------------
        # @Development Note = -
        #----------------------------------------------------
        # @Date Created = 06/30/2020 16:22:22
        #----------------------------------------------------
        AutoImportModule -FileName "DotNet-Cli-Command-Provider-For-TemplateCenter";
        AutoImportModule -FileName "Project-Path-Utilities";
        AutoImportModule -FileName "DotNet-Cli-Command-Provider";   
        #____________________________________________________#
        $projectName = $SolutionFileName.Split('.')[0];
        if([string]::IsNullOrEmpty($TemplateName)){
            $TemplateName  = NumericOptionProvider -Message "Choose one of template presentation option" -Options @("Razor Page", "Web Api", "MVC");
        }
        switch ($TemplateName) {
            "Razor Page" {  
               MakeNewDotnetRazorPageFromTemplateCenter -ProjectName $projectName -RazorPageProjectName "RazorPage" -OutputPath $OutputPath -SolutionFileName $SolutionFileName  -EnableRuntimeCompilation:$EnableRuntimeCompilation
            }
            "Web Api" {  }
            "MVC" {  }
            Default {
                throw [System.Exception]::new("The Template <$TemplateName> not supported!");
            }
        }
    }
        
function MakeNewDotnetRazorClasslibraryFromTemplateCenter{
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ClasslibName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderPath,
        [Parameter(Mandatory = $false)]
        [string]
        $TestProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $OutputPath,
        [Parameter(Mandatory = $false)]
        [string]
        $SolutionFileName,
        [switch]
        $TestCoverage,
        [switch]
        $Force
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 5514136d-98bd-4204-96d1-bf4eb4de60d5
    #----------------------------------------------------
    # @Function Name = MakeNewDotnetRazorClasslibraryFromTemplateCenter
    #----------------------------------------------------
    # @Usage = MakeNewDotnetRazorClasslibraryFromTemplateCenter
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 07/01/2020 13:13:25
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    if ($TestCoverage -and [string]::IsNullOrEmpty($TestProjectName)) {
        $TestProjectName = "TestEnvironment";
    }
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $_classlibName = PrepareDotnetProjectName -ProjectName $ClasslibName;
    $outputPath = PrepareCsprojFileOutputPath -OutputPath $OutputPath;
    $argumentList = ProvideDotnetCliNewRazorClasslibCommandArgsFromTemplateCenter -ClasslibName $_classlibName -OutputPath $outputPath -NoStore:$NoStore -Force:$Force; 
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -WindowStyle Hidden -Wait;
    $outputFullPath = PrepareAbsolutePath "$_projectBasePath\$outputPath";
    PowershellLogger -Message "The Razor Class Library <$_classlibName> in <$outputPath> solution folder project created successfully in <$outputFullPath> solution folder!" -LogType Success -IncludeExtraLine;
    RemoveDefaultProjectTemplateFiles -TemplateName "razorclasslib" -ProjectPath $outputFullPath;
    AddProjectToSolution -CsprojFileName $_classlibName -ProjectName $ProjectName -SolutionFileName $SolutionFileName -SolutionFolderPath $SolutionFolderPath; 
    if ($TestCoverage) {
        TestCoverageRazorClasslibrary -TestProjectName $TestProjectName -ProjectToCoverageName $ClasslibName -SolutionFileName $SolutionFileName -ProjectName $ProjectName -ProjectToCoverage -NoStore:$NoStore -EnablePack:$EnablePack -Force:$Force;
    }
}
function TestCoverageRazorClasslibraryFromTemplateCenter {
    
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 74df211d-eb7b-4cee-980a-3968a70ebde3
    #----------------------------------------------------
    # @Function Name = TestCoverageRazorClasslibraryFromTemplateCenter
    #----------------------------------------------------
    # @Usage = TestCoverageRazorClasslibraryFromTemplateCenter
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/30/2020 16:35:41
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
    $_testOutputFolder = MakeTestOutputPathForCsprojFile -ProjectName  $ProjectName -TestProjectName $TestProjectName -CsprojFileName $ProjectToCoverageName;
    $_testSlnFolder = MakeTestSolutionFolderPathForCsprojFile -ProjectName $ProjectName -ProjectToCoverageName $ProjectToCoverageName -SolutionFileName $SolutionFileName;
    $projectToCoverageNamePassed = !([string]::IsNullOrEmpty($ProjectToCoverageName));
    if ($ProjectToCoverage -and !$projectToCoverageNamePassed) {
        throw [System.Exception]::new('The Project to coverage not specified while function called with the switch <ProjectCoverage>!');
    }
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName;
    $_outputFolder = PrepareRelativePath -Path "\$_testOutputFolder" -IncludeDot;
    $outputFullPath = PrepareAbsolutePath -Path "$_projectBasePath\$_outputFolder";
    $_testProjectName = PrepareDotnetProjectName -ProjectName $TestProjectName;
    $argumentList = ProvideDotnetCliNewRazorClasslibraryTestCoverageCommandArgs -TestProjectTemplateName "razorpages" -TestProjectName $TestProjectName -OutputPath $_outputFolder -Force:$Force -EnablePack:$EnablePack -NoStore:$NoStore; 
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -WindowStyle Hidden -Wait;
    PowershellLogger -Message "The Test project <$_testProjectName> in <$outputFullPath> created successfully!" -LogType Success -IncludeExtraLine;
    RemoveDefaultProjectTemplateFiles -ProjectPath $outputFullPath  -TemplateName "xunit";
    if ($projectToCoverageNamePassed) {
        AddReferenceToDotnetProject -ProjectName $ProjectName -ProjectDependentName $_testProjectName -ProjectReferenceName $ProjectToCoverageName;
    }
    AddProjectToSolution -ProjectName $ProjectName -CsprojFileName $TestProjectName -SolutionFileName $SolutionFileName -SolutionFolderPath $_testSlnFolder;
}
        
function ProvideDotnetCliNewRazorClasslibCommandArgsForTemplateCenterTemplate {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ClasslibName,
        [Parameter(Mandatory = $false)]
        [string]
        $OutputPath = "./",
        [switch]
        $NoStore,
        [switch]
        $UnSupportPagesAndViews,
        [switch]
        $Force
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = b81fe045-27c3-4e34-aac1-6a16f4eb2826
    #----------------------------------------------------
    # @Function Name = ProvideDotnetCliNewRazorClasslibCommandArgsFromTemplateCenterTemplate
    #----------------------------------------------------
    # @Usage = ProvideDotnetCliNewRazorClasslibCommandArgsFromTemplateCenterTemplate
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 07/01/2020 13:14:55
    #----------------------------------------------------
    AutoImportModule -FileName "Dotnet-Project-TargetFramework";
    #____________________________________________________#
    $outputPath = PrepareRelativePath -Path $OutputPath -IncludeDot;
    [hashtable]$Options = New-Object -TypeName System.Collections.Hashtable;
    [string]$argumentList = "new razorclasslib "; 
   
    $Options = @{
        "output" = "$outputPath";
         "name" = "$ClasslibName";;
        "language" = "c#";
     };
    if ($NoStore) {
        $Options += @{ "no-restore" = '$true' };
    }
    if ($UnSupportPagesAndViews) {
        $Options += @{ "support-pages-and-views" = '$false' };
    }
    $Options.Keys | ForEach-Object { 
        $argumentList += (" --$_ " + $Options[$_] + " ");
    }
    if ($Force) {
        $argumentList += " --force ";
    }
    return $argumentList;
}

        
function TestCoverageRazorClasslibraryFromTemplateCenter {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $TestProjectTemplateName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $TestProjectName,
        [Parameter(Mandatory = $false)]
        [string]
        $OutputPath = "./"
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4efbc2bb-93c2-4cdc-b09f-1683a71793df
    #----------------------------------------------------
    # @Function Name = TestCoverageRazorClasslibraryFromTemplateCenterForTemplateCenterTemplate
    #----------------------------------------------------
    # @Usage = TestCoverageRazorClasslibraryFromTemplateCenterForTemplateCenterTemplate
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 07/01/2020 13:17:25
    #----------------------------------------------------
    AutoImportModule -FileName "Install-Template";
    #____________________________________________________#
    AutoImportModule -FileName "Dotnet-Project-TargetFramework";
    $_testProjectName = PrepareDotnetProjectName -ProjectName $TestProjectName; 
    $outputPath = PrepareRelativePath -Path $OutputPath -IncludeDot;
    $testFramework = $TestProjectTemplateName.Trim().ToLower();
    [string]$argumentList = " new "; 
    switch ($testFramework) {
        "razorpages" {
            $command = "templatecenter-razorclasslib-razorpages-test";
            InstallDotNetTmplateFromTemplateCenter -TemplateName $command;
            $argumentList += $command;
        }
        # "blazor server" {
        #     $argumentList += "templatecenter-blazorserver-test-coverge";
        # }
        Default { 
            throw [System.Exception]::new("The <$TestProjectTemplateName> test project template not recognize as known installed test template!");
        }
    }
    [hashtable]$Options = New-Object -TypeName System.Collections.Hashtable;
    $Options += @{"output" = "$outputPath" }
    $Options += @{ "name" = "$_testProjectName" };
    $Options.Keys | ForEach-Object { 
        $argumentList += (" --$_ " + $Options[$_] + " ");
    }
    return $argumentList;
}

        
function MakeNewDotnetRazorPageFromTemplateCenter {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $RazorPageProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $OutputPath,
        [Parameter(Mandatory = $false)]
        [string[]]
        $ProjectReferences,
        [Parameter(Mandatory = $false)]
        [string]
        $SolutionFileName,
        [switch]
        $EnableRuntimeCompilation
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0af819e4-07a6-4c76-b4f6-1e943a7bf2c5
    #----------------------------------------------------
    # @Function Name = MakeNewDotnetRazorPageFromTemplateCenter
    #----------------------------------------------------
    # @Usage = MakeNewDotnetRazorPageFromTemplateCenter
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 07/01/2020 14:33:26
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $_razorPageProjectName = PrepareDotnetProjectName -ProjectName $RazorPageProjectName;
    $_outputPath = PrepareCsprojFileOutputPath -OutputPath $OutputPath;
    $userSelectArgumentList = ProvideRazorPageCliOptions; 
    MakeNewRazorPage -RazorPageProjectName -AuthenticationType "Individual" $RazorPageProjectName -ProjectReferences $ProjectReferences -ProjectName $ProjectName -OutputPath $_outputPath -SolutionFileName $SolutionFileName -SolutionFolderPath $SolutionFolderPath -Domain $userSelectArgumentList.Domain -EditProfilePolicyId $userSelectArgumentList.EditProfilePolicyId -ResetPasswordPolicyId $userSelectArgumentList.ResetPasswordPolicyId -ClientId $userSelectArgumentList.ClientId -AzureAdInstance $userSelectArgumentList.AzureAdInstance -AzureAdB2cInstance $userSelectArgumentList.AzureAdInstance -TenantId $userSelectArgumentList.TenantId  -OrgReadAccess $userSelectArgumentList.OrgReadAccess -UseLocalDb:$userSelectArgumentList.UseLocalDb -NoHttps:$userSelectArgumentList.NoHttps -UseBrowserLink:$userSelectArgumentList.UseBrowserLink;
    $argumentList = ProvideDotnetCliNewRazorPageCommandArgsFromTemplateCenter -RazorPageProject $_razorPageProjectName -OutputPath $outputPath -NoStore:$NoStore -Force:$Force; 
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -WindowStyle Hidden -Wait;
    $outputFullPath = PrepareAbsolutePath "$_projectBasePath\$outputPath";
    PowershellLogger -Message "The Razor Page web app <$_razorPageProjectName> in <$outputPath> solution folder project created successfully in <$outputFullPath> solution folder!" -LogType Success -IncludeExtraLine;
    RemoveDefaultProjectTemplateFiles -TemplateName "razorclasslib" -ProjectPath $outputFullPath;
    AddProjectToSolution -CsprojFileName $_razorPageProjectName -ProjectName $ProjectName -SolutionFileName $SolutionFileName -SolutionFolderPath $SolutionFolderPath; 
}
function ProvideDotnetCliNewRazorPageCommandArgsFromTemplateCenter {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $RazorPageProject,
        [Parameter(Mandatory = $false)]
        [string]
        $OutputPath = "./",
        [switch]
        $NoStore,
        [switch]
        $Force
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 825c419f-6839-462c-9dd1-3a1eac525ff5
    #----------------------------------------------------
    # @Function Name = ProvideDotnetCliNewRazorPageCommandArgsFromTemplateCenter
    #----------------------------------------------------
    # @Usage = ProvideDotnetCliNewRazorPageCommandArgsFromTemplateCenter
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 07/01/2020 14:40:00
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $outputPath = PrepareRelativePath -Path $OutputPath -IncludeDot;
    [hashtable]$Options = New-Object -TypeName System.Collections.Hashtable;
    [string]$argumentList = "new  "; 
    $Options = @{
        "output" = "$outputPath";
        "name" = "$RazorPageProject";
        "language" = "c#";
     };
    if ($NoStore) {
        $Options += @{ "no-restore" = '$true' };
    }
    if ($UnSupportPagesAndViews) {
        $Options += @{ "support-pages-and-views" = '$false' };
    }
    $Options.Keys | ForEach-Object { 
        $argumentList += (" --$_ " + $Options[$_] + " ");
    }
    $argumentList += " --force ";
    return $argumentList;
}

