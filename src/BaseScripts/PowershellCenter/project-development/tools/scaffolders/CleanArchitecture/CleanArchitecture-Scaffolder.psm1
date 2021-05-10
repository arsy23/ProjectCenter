#####################################################
# @Module Identity = 60103fbc-2fab-494c-bc5c-6eab1fb87917
#----------------------------------------------------
# @Module File Name = CleanArchitecture-Scaffolder.psm1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\project-development\tools\scaffolders\CleanArchitectureScaffolder.psm1'";
# @Usage2 = AutoInvokeScript "CleanArchitectureScaffolder";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Thursday, June 4, 2020 3:05:54 AM
#----------------------------------------------------
if ([string]::IsNullOrEmpty($global:powershellCenterPath)) { $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } } }

#----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
AutoImportModule -FileName "File-Name";
AutoImportModule -FileName "Folder";
AutoImportModule -FileName "Project-Name-Utilities";
AutoImportModule -FileName "GitRepository-Initialization";
#----------------------------------------------------

#____________________________________________________#
function ScaffoldCleanArchitectureProject {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = d10da89c-7b27-477c-95f1-c5e370c77ec8
    #----------------------------------------------------
    # @Function Name = ScaffoldCleanArchitectureProject
    #----------------------------------------------------
    # @Usage = ScaffoldCleanArchitectureProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 07:38:09
    #____________________________________________________#
    $options = "Scaffold new project", "Scaffold new specific project", "Scaffold new component", "Scaffold presentation for a component";
    $selectedOption = NumericOptionProvider -Message "Scaffolding options:" -Options $options;
    switch ($selectedOption) {
        "Scaffold new project" { ScaffoldNewProject; }
        "Scaffold new specific project" { ScaffoldNewSpecificProject; }
        "Scaffold new component" { ScaffoldNewComponent; }
        "Scaffold presentation for a component" { ScaffoldCleanArchitectureComponentPresentationItrative; }
    }
}

function ScaffoldNewComponent {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 7b89649f-753f-43f8-a8d4-21142bf77b32
    #----------------------------------------------------
    # @Function Name = ScaffoldNewComponent
    #----------------------------------------------------
    # @Usage = ScaffoldNewComponent
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 08:59:00
    #----------------------------------------------------
    #AutoImportModule -FileName ""
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; }
    #____________________________________________________#
    $projectName = ShowFolderBrowserDialogForSelectOneOfProjectInProjects -ReturnProjectName -IncludeInSubFolders;
    MakeNewComponentIterative -Message  "do you need to scaffold more component in the <$projectName> project?" -ProjectName $projectName;
}

function ScaffoldNewProject {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 1f00ce9d-c512-4cd2-995f-ef5f3822cd8f
    #----------------------------------------------------
    # @Function Name = ScaffoldNewProject
    #----------------------------------------------------
    # @Usage = ScaffoldNewProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 09:00:18
    #____________________________________________________#
    $Projects = ResolveProjectsPath;
    [string] $projectName = GetValidFolderName -Message "Enter the Project name:" -Path $Projects -ErrorMessage "Invalid Project Name! The Project name must unique in the PrjectResources!";
    InitializeDefaultDotnetProject -ProjectName $projectName;
    OptionalMakeComponent -Message "do you need to scaffold authentication component?" -ComponentName "Auth" -ProjectName $projectName
    OptionalMakeComponent -Message "do you need scaffold more component for the <$projectName> project?" -ProjectName $projectName -Iterative;
}
function ScaffoldNewSpecificProject {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 1f00ce9d-c512-4cd2-995f-ef5f3822cd8f
    #----------------------------------------------------
    # @Function Name = ScaffoldNewProject
    #----------------------------------------------------
    # @Usage = ScaffoldNewProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/04/2020 09:00:18
    #____________________________________________________#
    $Projects = ResolveProjectsPath;
    [string] $projectName = GetValidFolderName -Message "Enter the Project name:" -Path $Projects -ErrorMessage "Invalid Project Name! The Project name must unique in the PrjectResources!";
    InitializeDefaultDotnetProject -ProjectName $projectName;
    MakeComponents -ProjectName $projectName;
}
function InitializeDefaultDotnetProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 8f4b1388-c31c-4486-bb03-43dfc252e0ab
    #----------------------------------------------------
    # @Function Name = InitializeDefaultDotnetProject
    #----------------------------------------------------
    # @Usage = InitializeDefaultDotnetProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = Project path.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/09/2020 21:06:01
    #----------------------------------------------------
    AutoImportModule -FileName "Folder";
    AutoImportModule -FileName "Dotnet-Cli-Command-Provider";
    #____________________________________________________#
    $projectBasePath = ShowFolderBrowserDialogForProjects;
        if (!(Test-Path -Path "$projectBasePath\$ProjectName")) {
        mkdir -Path $projectBasePath -Name $ProjectName | Out-Null;
    }
    $_projectBasePath = "$projectBasePath\$ProjectName\";
    MakeNewDotnetSolution -SolutionFileName $ProjectName -ProjectName $ProjectName;
    AutoInvokeScript -FileName "Setup-New-Project-Files" -Arguments  @{"ProjectName" = $ProjectName ; "SolutionFileName" = $ProjectName };
    AutoInvokeScript -FileName "Initialize-GitRepository" -Arguments  @{"Path" = $_projectBasePath } -Switches "-InitialCommit";
    $currentBranch = "dev";
    GitStashAllChanges -ProjectName $ProjectName;
    GitCheckoutBranch -ProjectName $ProjectName -BranchName $currentBranch;
    $sharedKernelProjectName = "$projectName.SharedKernel";
    MakeNewDotnetClasslib -SolutionFileName $projectName -SolutionFolderPath "\Source\SharedKernel\" -OutputPath '\Source\SharedKernel\Source' -ClasslibName $sharedKernelProjectName -ProjectName $ProjectName -TestProjectName "$projectName.SharedKernel.UnitTest" -TestCoverage;
    $infrastructureProjectName = "$projectName.Infrastructure";
    MakeNewDotnetClasslib -ProjectReferences @($sharedKernelProjectName) -SolutionFileName $projectName -SolutionFolderPath "\Source\Infrastructure\" -OutputPath '\Source\Infrastructure\Source' -ClasslibName $infrastructureProjectName -ProjectName $ProjectName -TestProjectName "$projectName.Infrastructure.UnitTest" -TestCoverage;
    GitAddCommitToBranchOfProject -ProjectName $ProjectName -Message "Make main class libraries" -DirectoryList @("SharedKernel", "Infrastructure") -FileList @{$ProjectName = "sln";} -CheckoutExistedBranch -BranchName $currentBranch;
}
function MakeCleanArchitectureProjectComponent {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ComponentName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $false)]
        [string]
        $ProjectNameAbbreviation
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 3437cf21-4cdb-4bf6-bbeb-822db175f68f
    #----------------------------------------------------
    # @Function Name = MakeCleanArchitectureProjectComponent
    #----------------------------------------------------
    # @Usage = MakeCleanArchitectureProjectComponent
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/11/2020 12:35:48-
    #----------------------------------------------------
    AutoImportModule -FileName "AutoMapper-NugetPackage-Collection";
    AutoImportModule -FileName "MicrososftExtensions-NugetPackage-Collection";
    AutoImportModule -FileName "MediatR-NugetPackage-Collection";
    AutoImportModule -FileName "FlunetValidation-NugetPackage-Collection";
    
    AutoImportModule -FileName "Project-Name-Utilities";
    AutoImportModule -FileName "DotNetCenter-Info";
    AutoImportModule -FileName "Csharp-File";
    #____________________________________________________#

    GitStashAllChanges -ProjectName $ProjectName;
    GitCheckoutBranch -ProjectName $ProjectName -BranchName "dev";
    $currentBranch = "component/$ComponentName";
    GitCheckoutNewBranch -ProjectName $ProjectName -BranchName $currentBranch;
    ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException | Out-Null;
    $prefixedProjectName = (MakeProjectNamePrifix -ProjectName $ProjectName -ProjectNameAbbreviation $ProjectNameAbbreviation);
    $prefixedComponentName = (MakeComponentNamePrifix -ProjectName $ProjectName -ComponentName $ComponentName);
    $_projectName = "$prefixedProjectName.$prefixedComponentName";

    $slnFileName = $ProjectName +"."+ $ComponentName;
    MakeNewDotnetSolution -ProjectName $ProjectName -SolutionFileName $slnFileName;

    $dotNetCenterCoreRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Core";
    $dotNetCenterExtensionsAspNetCoreCoreRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.AspNetCore.Core";
    $dotNetCenterCryptoRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Cryptography";
    $dotNetCenterCryptoCoreRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Cryptography.Core";
    $dotNetCenterExtensionsAspNetCoreIdentityInfrastructureSqlServerRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.AspNetCore.Identity.Infrastructure.SqlServer";
    $dotNetCenterExtensionsAspNetCoreIdentityCoreRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.AspNetCore.Identity.Core";
    $dotNetCenterExtensionsAspNetCoreIdentityServicesRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.AspNetCore.Identity.Services";
    $dotNetCenterExtensionsEfCoreRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.EfCore";
    $dotNetCenterExtensionsAspNetCoreIdentityEfCore = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.AspNetCore.Identity.EfCore";
    $dotNetCenterExtensionsAutoMapperCoreRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.AutoMapper.Core";
    $dotNetCenterExtensionsMediatRBehavioursRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.MediatR.Behaviours";
    $dotNetCenterExtensionsMediatRRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.Extensions.MediatR";
    $dotNetCenterDateTimesRefName = GetDotNetCenterSubProjectName -DotNetCenterProjectName "DotNetCenter.DateTimes";

    # shared kernel
    $sharedKernelProjectName = "$_projectName.SharedKernel";
    $sharedKernelProjectDotNetCenterReferences = @(
        $dotNetCenterCoreRefName;
        $dotNetCenterDateTimesRefName;
        $dotNetCenterCryptoRefName;
        $dotNetCenterCryptoCoreRefName
    );
    $sharedKernelProjectReferences = @();
    # $sharedKernelProjectReferences = @($, $);
    MakeNewDotnetClasslib -DotNetCenterProjectReferences $sharedKernelProjectDotNetCenterReferences -ProjectReferences $sharedKernelProjectReferences -SolutionFileName $slnFileName -SolutionFolderPath "\Source\SharedKernel\" -OutputPath "\Source\Components\$ComponentName\SharedKernel\Source" -ClasslibName $sharedKernelProjectName -ProjectName $ProjectName -TestProjectName "$_projectName.SharedKernel.UnitTest" -TestCoverage;
    AddNugetPackageToProject -ProjectName $ProjectName -CsprojFileName $sharedKernelProjectName -PackageNames @(GetDefaultMicrosoftExtensionsDependencyInjectionAbstractionsPackages; );
    #end shared kernel
    
    # domain
    $domainProjectName = "$_projectName.Domain";
    $domainProjectReferences = @($sharedKernelProjectName);
    $domainProjectDotNetCenterReferences = @(
        dotNetCenterExtensionsAutoMapperCoreRefName
    );
    MakeNewDotnetClasslib -ProjectReferences $domainProjectReferences -DotNetCenterProjectReferences $domainProjectDotNetCenterReferences -SolutionFileName $slnFileName -SolutionFolderPath "\Source\Core\Domain\" -OutputPath "\Source\Components\$ComponentName\Core\Domain\Source" -ClasslibName $domainProjectName -ProjectName $ProjectName -TestProjectName "$_projectName.Domain.UnitTest" -TestCoverage;
    $domainProjectNugetPackageNames = GetDefaultMicrosoftExtensionsDependencyInjectionAbstractionsPackages -HashTableToAppend @();
    AddNugetPackageToProject -ProjectName $ProjectName -CsprojFileName $domainProjectName -PackageNames  $domainProjectNugetPackageNames;
    #end domain

    # application
    $applicationReferenceProjects = @($domainProjectName; $sharedKernelProjectName);
    $applicationProjectName = "$_projectName.Application";
    $applicationProjectDotNetCenterReferences = @(
        $dotNetCenterExtensionsMediatRRefName;
        $dotNetCenterExtensionsMediatRBehavioursRefName;
        $dotNetCenterDateTimesRefName;
        $dotNetCenterExtensionsAutoMapperCoreRefName
    );
    MakeNewDotnetClasslib -DotNetCenterProjectReferences $applicationProjectDotNetCenterReferences -ProjectReferences $applicationReferenceProjects -SolutionFileName $slnFileName -SolutionFolderPath "\Source\Core\Application\" -OutputPath "\Source\Components\$ComponentName\Core\Application\Source" -ClasslibName $applicationProjectName -ProjectName $ProjectName -TestProjectName "$_projectName.Application.UnitTest" -TestCoverage;
    $applicationProjectNugetPackageNames = GetDefaultApplicationLayerAutoMapperPackages -HashTableToAppend @();
    $applicationProjectNugetPackageNames = GetDefaultApplicationLayerMediatRPackages -HashTableToAppend $applicationProjectNugetPackageNames;
    $applicationProjectNugetPackageNames = GetDefaultApplicationLayerFlunetValidationPackages -HashTableToAppend $applicationProjectNugetPackageNames;
    AddNugetPackageToProject -ProjectName $ProjectName -CsprojFileName $applicationProjectName -PackageNames $applicationProjectNugetPackageNames;
    #end application


    # persistenceSharedKernelProjectName
    $persistenceSharedKernelReferenceProjects = @($sharedKernelProjectName);
    $persistenceSharedKernelProjectName = "$_projectName.Persistence.SharedKernel";
    $persistenceSharedKernelProjectDotNetCenterReferences = @(
        $dotNetCenterExtensionsAspNetCoreIdentityCoreRefName;
    );
    MakeNewDotnetClasslib -DotNetCenterProjectReferences $persistenceSharedKernelProjectDotNetCenterReferences -ProjectReferences $persistenceSharedKernelReferenceProjects -SolutionFileName $slnFileName -SolutionFolderPath "\Source\Infrastructure\Persistence\" -OutputPath "\Source\Components\$ComponentName\Infrastructure\Persistence\SharedKernel\Source" -ClasslibName $persistenceSharedKernelProjectName -ProjectName $ProjectName -TestProjectName "_projectName.Persistence.SharedKernel.UnitTest" -TestCoverage;
    # $persistenceSharedKernelProjectNugetPackageNames = GetDefault???Packages  -HashTableToAppend @();
    # $persistenceSharedKernelProjectNugetPackageNames = GetDefault???Packages -HashTableToAppend $persistenceSharedKernelProjectNugetPackageNames;
    # $persistenceSharedKernelProjectNugetPackageNames = GetDefault???Packages  -HashTableToAppend $persistenceSharedKernelProjectNugetPackageNames;
    AddNugetPackageToProject -ProjectName $ProjectName -CsprojFileName $persistenceSharedKernelProjectName -PackageNames $persistenceSharedKernelProjectNugetPackageNames;
    #end persistenceSharedKernelProjectName

    #efcore
    $efSqlPersistenceReferenceProjects = @(
        $applicationProjectName;
        $persistenceSharedKernelProjectName;
        $sharedKernelProjectName;
        );
    $efSqlProjectDotNetCenterReferences = @(
         $dotNetCenterExtensionsAutoMapperCoreRefName;
         $dotNetCenterExtensionsAspNetCoreIdentityInfrastructureSqlServerRefName;
         $dotNetCenterExtensionsAspNetCoreIdentityEfCore;
         $dotNetCenterExtensionsEfCoreRefName;
    );
    $efSqlPersistenceProjectName = "$_projectName.Persistence.EFCore.SqlServer";    
    MakeNewDotnetClasslib -DotNetCenterProjectReferences $efSqlProjectDotNetCenterReferences -ProjectReferences $efSqlPersistenceReferenceProjects -SolutionFileName $slnFileName -SolutionFolderPath  "\Source\Infrastructure\Persistence" -OutputPath "\Source\Components\$ComponentName\Infrastructure\Persistence\Source" -ClasslibName $efSqlPersistenceProjectName -ProjectName $ProjectName -TestProjectName "$_projectName.Persistence.EFCore.SqlServer.UnitTest" -TestCoverage;
    $efSqlProjectNugetPackageNames = GetDefaultEfCoreSqlPersistenceLayerAutoMapperPackages -HashTableToAppend @();
    AddNugetPackageToProject -ProjectName $ProjectName -CsprojFileName $efSqlPersistenceProjectName -PackageNames $efSqlProjectNugetPackageNames;
    #end efcore

    # infrastructure
    $infrastructureProjectReferences = @($applicationProjectName, $sharedKernelProjectName, $efSqlPersistenceProjectName);
    $infrastructureProjectDotNetCenterReferences = @(
        $dotNetCenterExtensionsAspNetCoreIdentityInfrastructureSqlServerRefName;
        $dotNetCenterExtensionsAspNetCoreIdentityServicesRefName;
        $dotNetCenterExtensionsEfCoreRefName
    );
    $infrastructureProjectName = "$_projectName.Infrastructure";
    MakeNewDotnetClasslib -DotNetCenterProjectReferences $infrastructureProjectDotNetCenterReferences -ProjectReferences $infrastructureProjectReferences -SolutionFileName $slnFileName -SolutionFolderPath "\Source\Infrastructure\" -OutputPath "\Source\Components\$ComponentName\Infrastructure\Source" -ClasslibName $infrastructureProjectName -ProjectName $ProjectName -TestProjectName "$_projectName.Infrastructure.UnitTest" -TestCoverage;
    $infrastructureProjectNugetPackageNames = GetDefaultEfCoreSqlPersistenceLayerAutoMapperPackages -HashTableToAppend @();
    $infrastructureProjectNugetPackageNames = GetDefaultInfrastructureLayerAutoMapperPackages -HashTableToAppend $infrastructureProjectNugetPackageNames;
    $infrastructureProjectNugetPackageNames = GetDefaultInfrastructureLayerMediatRPackages -HashTableToAppend $infrastructureProjectNugetPackageNames;
    $infrastructureProjectNugetPackageNames = GetDefaultInfrastructureLayerFlunetValidationPackages -HashTableToAppend $infrastructureProjectNugetPackageNames;
    AddNugetPackageToProject -ProjectName $ProjectName -CsprojFileName $infrastructureProjectName -PackageNames $infrastructureProjectNugetPackageNames;
    #end infrastructure

    #add presentation component

    GitAddCommitToBranchOfProject -ProjectName $ProjectName -Message "Make component <$ComponentName>" -DirectoryList @($ComponentName) -FileList @{$slnFileName = "sln";} -CheckoutExistedBranch -BranchName $currentBranch;
    GitCheckoutBranch -ProjectName $ProjectName -BranchName "dev";
}

        
function OptionalMakeComponent {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Message, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $false)]
        $ComponentName,
        [switch]
        $Iterative
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = c2d0a6e7-a127-422d-8957-caf89ad6efe4
    #----------------------------------------------------
    # @Function Name = OptionalMakeAuthenticationComponent
    #----------------------------------------------------
    # @Usage = OptionalMakeAuthenticationComponent
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/12/2020 21:39:43
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    if($Iterative -and ![string]::IsNullOrEmpty($ComponentName))
    {
        throw [System.Exception]::new("Using the <Iterative> switch not valid when the <$ComponentName> pass to function>!");
    }
    do {
        $selectedOption = NumericOptionProvider -Message $Message -Options @("Yes", "No");
        switch ($selectedOption) {
            "Yes" {
                if ([string]::IsNullOrEmpty($ComponentName)) {
                    [string] $_componentName = GetValidProjectName -Path "$projectBasePath\Source\Components\" -Message  "Enter Project Component Name(just component name exclude project name)" -ErrorMessage "Invalid Component Name!" ;
                }
                else {
                    $_componentName = PrepareFileName -FileName $ComponentName;
                }
                $projectName = Split-Path -Path $projectBasePath -Leaf;
                MakeCleanArchitectureProjectComponent -ProjectName $projectName -ComponentName $_componentName;
            }
        }
            
    } while ($selectedOption -eq "Yes" -and $Iterative);
}

function MakeComponents {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = c2d0a6e7-a127-422d-8957-caf89ad6efe4
    #----------------------------------------------------
    # @Function Name = OptionalMakeAuthenticationComponent
    #----------------------------------------------------
    # @Usage = OptionalMakeAuthenticationComponent
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/12/2020 21:39:43
    AutoImportModule -FileName "Project-ComponentProvider"
    #____________________________________________________#
    $projectNameAbbreviation = "";
    $selectedOption = NumericOptionProvider -Message "Are you need to choose general project name for system components?" -Options @("Yes", "No");
    switch ($selectedOption) {
        "Yes" {
            $projectNameAbbreviation = GetValidFolderName -Path (ResolveProjectsPath) -Message "Enter Abbrivation For Project Name(just project name exclude sub projects and components name)" -ErrorMessage "Invalid Project Name";
        }
        "No"{
            $projectNameAbbreviation = $null;
        }
    }

    ProvideProjectComponent -ProjectName $ProjectName -ProjectNameAbbreviation $projectNameAbbreviation;
}

function MakeNewComponentIterative {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Message, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = c2d0a6e7-a127-422d-8957-caf89ad6efe4
    #----------------------------------------------------
    # @Function Name = OptionalMakeAuthenticationComponent
    #----------------------------------------------------
    # @Usage = OptionalMakeAuthenticationComponent
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/12/2020 21:39:43
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    do {
        $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
        [string] $_componentName = GetValidProjectName -Path "$projectBasePath\Source\Components\"  -Message "Enter Project Component Name(just component name exclude project name)" -ErrorMessage "Invalid Component Name!";
        MakeCleanArchitectureProjectComponent -ProjectName $ProjectName -ComponentName $_componentName;
        $selectedOption = NumericOptionProvider -Message $Message -Options @("Yes", "No");
    } while ($selectedOption -eq "Yes");
}        
function ScaffoldCleanArchitectureComponentPresentationItrative {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = cabb6a95-7731-47c4-83aa-5382b6632a98
    #----------------------------------------------------
    # @Function Name = ScaffoldComponentPresentation
    #----------------------------------------------------
    # @Usage = ScaffoldComponentPresentation
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/30/2020 15:52:42
    #----------------------------------------------------
    AutoImportModule -FileName "Folder-Lookup";
    AutoImportModule -FileName "DotNet-Cli-Command-Provider-For-TemplateCenter";
    #____________________________________________________#
    do {
        $slnFileName = ShowOpenFileDialogForProjects -FileTypeTitle "Solution" -Filter "dotnet project solution file (*.sln)|*.sln" -ResolveFileName;
        $slnFileNameParts = $slnFileName.Split('.');
        $projectName = $slnFileNameParts[0];
        $componentName = $slnFileNameParts[1];
        $projectBasePath = ProjectLookupInProjects -ProjectName $projectName -ThrowIfNotExistException;
        $componentPresentationSubDirectory = "\Source\Components\$componentName\Presentation";
        $componentPresentationFolderPath = ($projectBasePath + $componentPresentationSubDirectory);
        if(!(Test-Path -Path $componentPresentationFolderPath))
        {
            mkdir -Path $componentPresentationFolderPath | Out-Null;
            PowershellLogger -Message "The Presentation folder created in <$componentPresentationFolderPath>" -LogType Success -IncludeExtraLine;
        }
        $outputPath = ResolveClasslibraryOutputPath -SubDirectory $componentPresentationSubDirectory -ProjectName $projectName -Description "Select a output folder for the component presentation in for the <$componentName> component in <$projectName>";
        MakeNewDotnetPresentationFromTemplateCenter -OutputPath $outputPath  -SolutionFileName $slnFileName -EnableRuntimeCompilation;
        $selectedOption = NumericOptionProvider -Message "Are you need scaffold more component presentation?" -Options @("Yes", "No")
    } while ($selectedOption -ne "Yes")
}