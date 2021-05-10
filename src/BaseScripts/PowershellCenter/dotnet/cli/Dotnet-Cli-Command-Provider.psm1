#####################################################
# @Module Identity = 99d581ec-057e-4997-81d3-492f2ac4cb11
#----------------------------------------------------
# @Module File Name = Dotnet-Cli-New
#----------------------------------------------------
# @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\dotnet\cli\Dotnet-Cli-New.psm1'";
# @CallUsage2 = AutoInvokeScript "Dotnet-Cli-New";
# @Usage3 = MakeNewDotnetSolution -SolutionFileName $projectName -ProjectName $projectName -OutputPath "Geasdsad/asdsadsad/;
# @Usage4 = MakeNewDotnetSolution -SolutionFileName $projectName -ProjectName $projectName $Projects
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/09/2020 12:30:38
#----------------------------------------------------
if ([string]::IsNullOrEmpty($global:powershellCenterPath)) { $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } } }
#----------------------------------------------------
Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\file\File-Lookup.psm1";
Import-Module "$global:powershellCenterPath\powershell-scripting-utilities\Folder.psm1";
Import-Module "$global:powershellCenterPath\dotnet\Dotnet-Solution.psm1";
AutoImportModule -FileName "Dotnet-Project-TargetFramework";

#____________________________________________________#

function MakeNewDotnetSolution {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [Parameter(Mandatory = $false)]
        [string]
        $OutputPath = "./",
        [switch]
        $Force
    )
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $slnFullPath = "$_projectBasePath\$SolutionFileName.sln";
    if (!$Force) {
        $slnExist = FileExistInSubFolders -Path $_projectBasePath -FileName $SolutionFileName -FileExtension ".sln";
        if ($slnExist) {
            throw [System.Exception]::new("the Solution file <$slnFullPath> early exist!")
        }
    }
    $argumentList = ProvideDotnetCliNewSlnCommandArgs -SolutionFileName $SolutionFileName -OutputPath $OutputPath -Force:$Force; 
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -WindowStyle Hidden  -Wait;
    PowershellLogger -Message "The solution file <$slnFullPath> project created successfully in <$slnFullPath>!" -LogType Success -IncludeExtraLine;
} 
function ProvideDotnetCliNewSlnCommandArgs {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [Parameter(Mandatory = $false)]
        [string]
        $OutputPath = "./",
        [switch]
        $Force
    )
    $outputPath = PrepareRelativePath -Path $OutputPath -IncludeDot;
    [hashtable]$Options = New-Object -TypeName System.Collections.Hashtable;
    [string]$argumentList = "new sln "; 
    $Options = @{"output" = "$outputPath";
        "name"            = "$SolutionFileName" 
    };
    $Options.Keys | ForEach-Object { 
        $argumentList += (" --$_ " + $Options[$_] + " ");
    }
    if ($Force) {
        $argumentList += " --force ";
    }
    return $argumentList;
}    
function ProvideDotnetCliNewClasslibCommandArgs {
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
        $Force
    )
    $targetFramework = ProvideTargetFramework  -ProjectName $ClasslibName -ProjectType "classlib" -LatestVersion;
    $outputPath = PrepareRelativePath -Path $OutputPath -IncludeDot;
    [hashtable]$Options = New-Object -TypeName System.Collections.Hashtable;
    [string]$argumentList = "new classlib "; 
    $Options = @{
        "output"      = "$outputPath" ;
        "name"        = "$ClasslibName" ;
        "framework"   = $targetFramework ;
        "language"    = "c#" ;
        "langVersion" = "latest" ;
    }
    if ($NoStore) {
        $Options += @{ "no-restore" = '$true' };
    }
    $Options.Keys | ForEach-Object { 
        $argumentList += (" --$_ " + $Options[$_] + " ");
    }
    if ($Force) {
        $argumentList += " --force ";
    }
    return $argumentList;
}     
function MakeNewDotnetClasslib {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ClasslibName,
        [Parameter(Mandatory = $false)]
        [string[]]
        $ProjectReferences,
        [Parameter(Mandatory = $false)]
        [string[]]
        $DotNetCenterProjectReferences,
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
    # @Function Identity = 6a39f938-364c-4c78-bc3e-d926d5bfe1b0
    #----------------------------------------------------
    # @Function Name = DotnetCliNew
    #----------------------------------------------------
    # @Usage = DotnetCliNew
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/09/2020 12:31:22
    #____________________________________________________#
    if ($TestCoverage -and [string]::IsNullOrEmpty($TestProjectName)) {
        throw [System.Exception]::new('The Test projct name can''t be null when the project coverage test is expected!');
    }
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $_classlibName = PrepareDotnetProjectName -ProjectName $ClasslibName;
    $outputPath = PrepareCsprojFileOutputPath -OutputPath $OutputPath;
    $argumentList = ProvideDotnetCliNewClasslibCommandArgs -ClasslibName $_classlibName -OutputPath $outputPath -NoStore:$NoStore -Force:$Force; 
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -WindowStyle Hidden -Wait;
    $outputFullPath = PrepareAbsolutePath "$_projectBasePath\$outputPath";
    PowershellLogger -Message "The Class library <$_classlibName> in <$outputPath> solution folder project created successfully in <$outputFullPath> solution folder!" -LogType Success -IncludeExtraLine;
    RemoveDefaultProjectTemplateFiles -TemplateName "classlib" -ProjectPath $outputFullPath;
    AddProjectToSolution -CsprojFileName $_classlibName -ProjectName $ProjectName -SolutionFileName $SolutionFileName -SolutionFolderPath $SolutionFolderPath; 
    if ($TestCoverage) {
        MakeNewXUnitProject -TestProjectName $TestProjectName -ProjectToCoverageName $ClasslibName -SolutionFileName $SolutionFileName -ProjectName $ProjectName -ProjectToCoverage -NoStore:$NoStore -EnablePack:$EnablePack -Force:$Force;
    }
    $ProjectReferences | ForEach-Object {
        if (![string]::IsNullOrEmpty($_)) {
            AddReferenceToDotnetProject -ProjectReferenceName $_ -ProjectDependentName $_classlibName -ProjectName $ProjectName;
        }
    }
    # change clean architecture componets to contexts
    # add feature to support dotnet 5
    # // تا انجا درست کار می کند بعد میرود در اغما شاید در هر بار که از آرایه می خواند یک بار تابع اجرا میکند به احتمال کم
    $DotNetCenterProjectReferences | ForEach-Object {
        if (![string]::IsNullOrEmpty($_)) {
            AddReferenceToDotnetProjectFromOutside -ProjectReferenceName $_ -ProjectDependentName $_classlibName;
        }
    }
}   
function AddProjectToSolution {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $CsprojFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderPath
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 8fcdddbf-51e3-4685-8285-9390dc110bc0
    #----------------------------------------------------
    # @Function Name = AddProjectToSolution
    #----------------------------------------------------
    # @Usage = AddProjectToSolution
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/10/2020 03:29:43
    #----------------------------------------------------
    AutoImportModule -FileName "File-Name";
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName;
    $_projectPath = FileLookingupByNameAndExtension -FileName $CsprojFileName -Path $projectBasePath -FileExtension '.csproj' -MakeRelative -IncludeDot -ThrowIfNotExistException;
    $slnFilePath = FileLookingupByNameAndExtension -Path $projectBasePath -FileName $SolutionFileName -FileExtension '.sln' -ThrowIfNotExistException;
    $_slnFileName = PrepareFileName -FileName $SolutionFileName -FileExtension ".sln" -WithoutExtension;
    $slnFolderPath = PrepareSolutionFolderPath -SolutionFolderPath $SolutionFolderPath;
    $argumentList = " sln .\" + $_slnFileName + ".sln add " + $(Split-Path -Path $_projectPath -Parent) + " --solution-folder " + $slnFolderPath;
    Start-Process dotnet -WorkingDirectory $projectBasePath -ArgumentList $argumentList -WindowStyle Hidden -Wait ;
    PowershellLogger -Message "the Project <$ProjectName> in <$_projectPath> added to <$slnFilePath> solution successfully!" -LogType Success -IncludeExtraLine;    
}
function RemoveDefaultProjectTemplateFiles {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectPath,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $TemplateName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = da0492b8-e06a-4fd4-85d7-e49e4ef19545
    #----------------------------------------------------
    # @Function Name = RemoveDefaultProjectTemplateFiles
    #----------------------------------------------------
    # @Usage = RemoveDefaultProjectTemplateFiles
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/09/2020 17:55:24
    #----------------------------------------------------
    AutoImportModule -FileName "Remove-File";
    #____________________________________________________#
    switch ($TemplateName.Trim().ToLower()) {
        'classlib' { 
            RemoveFileExistInSubFolder -Path $ProjectPath -FileName "Class1" -FileExtension ".cs";
        }
        'razorclasslib' { 
            RemoveFileExistInSubFolder -Path $ProjectPath -FileName "ExampleJsInterop" -FileExtension ".cs";
            RemoveFileExistInSubFolder -Path $ProjectPath -FileName "Component1" -FileExtension ".razor";
        }
        { 'nunit', 'mstest', 'xunit' -eq $_ } { 
            RemoveFileExistInSubFolder -Path $ProjectPath -FileName "UnitTest1" -FileExtension ".cs";
        }
        Default {
            throw [System.Exception]::new("The Project template <$TemplateName> for dotnet.exe is not supported or not valid!");
        }
    }
}  
function MakeNewXUnitProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectToCoverageName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $TestProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $false)]
        [string]
        $SolutionFileName,
        [switch]
        $ProjectToCoverage,
        [switch]
        $Force,
        [switch]
        $EnablePack,
        [switch]
        $NoStore
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = a1108266-0942-4f45-bfd6-bcb21f6d149f
    #----------------------------------------------------
    # @Function Name = MakeTestNewTestProject
    #----------------------------------------------------
    # @Usage = MakeTestNewTestProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/10/2020 03:42:35
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
    $argumentList = ProvideDotnetCliNewTestCoverageCommandArgs -TestProjectTemplateName "xunit" -TestProjectName $TestProjectName -OutputPath $_outputFolder -Force:$Force -EnablePack:$EnablePack -NoStore:$NoStore; 
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -WindowStyle Hidden -Wait;
    PowershellLogger -Message "The Test project <$_testProjectName> in <$outputFullPath> created successfully!" -LogType Success -IncludeExtraLine;
    RemoveDefaultProjectTemplateFiles -ProjectPath $outputFullPath  -TemplateName "xunit";
    if ($projectToCoverageNamePassed) {
        AddReferenceToDotnetProject -ProjectName $ProjectName -ProjectDependentName $_testProjectName -ProjectReferenceName $ProjectToCoverageName;
    }
    AddProjectToSolution -ProjectName $ProjectName -CsprojFileName $TestProjectName -SolutionFileName $SolutionFileName -SolutionFolderPath $_testSlnFolder;
}
function ProvideDotnetCliNewTestCoverageCommandArgs {
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
        $OutputPath = "./",
        [switch]
        $NoStore,
        [switch]
        $EnablePack,
        [switch]
        $Force
    )
    $_testProjectName = PrepareDotnetProjectName -ProjectName $TestProjectName; 
    $outputPath = PrepareRelativePath -Path $OutputPath -IncludeDot;
    $testFramework = $TestProjectTemplateName.Trim().ToLower();
    switch ($testFramework) {
        "xunit" {
            $targetFramework = ProvideTargetFramework -ProjectName $_testProjectName -ProjectType "xunit" -LatestVersion;
        }
        "nunit" {
            $targetFramework = ProvideTargetFramework -ProjectName $_testProjectName -ProjectType "nunit" -LatestVersion;
        }
        "mstest" {
            $targetFramework = ProvideTargetFramework -ProjectName $_testProjectName -ProjectType "mstest" -LatestVersion;
        }
        Default { 
            throw [System.Exception]::new("The <$TestProjectTemplateName> test project template not recognize as known installed test template!");
        }
    }
    [string]$argumentList = " new " + $testFramework; 
    [hashtable]$Options = New-Object -TypeName System.Collections.Hashtable;
    $Options = @{
        "output"    = "$outputPath";
        "name"      = "$_testProjectName";
        "framework" = $targetFramework;
        "language"  = "c#";
    };
    if ($NoStore) {
        $Options += @{ "no-restore" = '$true' };
    }
    $Options.Keys | ForEach-Object { 
        $argumentList += (" --$_ " + $Options[$_] + " ");
    }
    if ($EnablePack) {
        $argumentList += "  --enable-pack ";
    }
    if ($Force) {
        $argumentList += " --force ";
    }
    return $argumentList;
}   
function AddReferenceToDotnetProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectReferenceName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectDependentName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 38283026-3150-4d70-aaed-b8eb410700ea
    #----------------------------------------------------
    # @Function Name = AddReferenceToDotnetProject
    #----------------------------------------------------
    # @Usage = AddReferenceToDotnetProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/10/2020 17:29:28
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $_projectDependentName = $ProjectDependentName.Trim();
    $_projectReferenceName = $ProjectReferenceName.Trim();
    PowershellLogger -Message "The Add-Reference Process for <$_projectReferenceName> project to <$_projectDependentName> now starting!" -LogType Report -NoFlag -IncludeExtraLine;
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $_projectDependentPath = FileLookingupByNameAndExtension -Path $_projectBasePath -FileName $_projectDependentName -FileExtension '.csproj' -ThrowIfNotExistException;
    $_projectReferencePath = FileLookingupByNameAndExtension -Path $_projectBasePath -FileName $_projectReferenceName -FileExtension '.csproj' -ThrowIfNotExistException;
    $argumentList = " add $_projectDependentPath  reference  $_projectReferencePath ";
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -NoNewWindow -Wait;
    PowershellLogger -Message "The process adding <$_projectReferenceName> project to the Project <$_projectDependentName> complited!" -LogType Report -IncludeBottomExtraLine;
}
function AddDotNetCenterReferenceToDotnetProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $DotNetCenterProjectName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectDependentName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 38283026-3150-4d70-aaed-b8eb410700ea
    #----------------------------------------------------
    # @Function Name = AddReferenceToDotnetProject
    #----------------------------------------------------
    # @Usage = AddReferenceToDotnetProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/10/2020 17:29:28
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $_projectDependentName = $ProjectDependentName.Trim();
    $_projectReferenceName = $ProjectReferenceName.Trim();
    PowershellLogger -Message "The Add-Reference Process for <$_projectReferenceName> project to <$_projectDependentName> now starting!" -LogType Report -NoFlag -IncludeExtraLine;
    $_projectDependentPath = FileLookingupByNameAndExtension -Path $_projectBasePath -FileName $_projectDependentName -FileExtension '.csproj' -ThrowIfNotExistException;
    $_projectReferencePath = CsprojLookupInDotNetCenter -DotNetCenterProjectName $_projectReferenceName;
    $argumentList = " add $_projectDependentPath  reference  $_projectReferencePath ";
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -NoNewWindow -Wait;
    PowershellLogger -Message "The process adding <$_projectReferenceName> project to the Project <$_projectDependentName> complited!" -LogType Report -IncludeBottomExtraLine;
}
function AddReferenceToDotnetProjectFromOutside {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectReferenceName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectDependentName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 38283026-3150-4d70-aaed-b8eb410700aa
    #----------------------------------------------------
    # @Function Name = AddReferenceToDotnetProject
    #----------------------------------------------------
    # @Usage = AddReferenceToDotnetProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/10/2020 17:29:28
    #----------------------------------------------------
    AutoImportModule -FileName "File-Lookup";
    AutoImportModule -FileName "File-Lookup";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $_projectDependentName = $ProjectDependentName.Trim();
    $_projectReferenceName = $ProjectReferenceName.Trim();
    PowershellLogger -Message "The Add-Reference Process for <$_projectReferenceName> project to <$_projectDependentName> now starting!" -LogType Report -NoFlag -IncludeExtraLine;
    $workingDirectory = ResolveProjectsPath;
    $_projectDependentPath = FileLookingupByNameAndExtension -Path $workingDirectory -FileName $_projectDependentName -FileExtension '.csproj' -ThrowIfNotExistException;
    $_projectReferencePath = FileLookingupByNameAndExtension -Path $workingDirectory -FileName $_projectReferenceName -FileExtension '.csproj' -ThrowIfNotExistException;
    if(!$_projectDependentName.EndsWith('.csproj'))
    {
        $_projectDependentName = $_projectDependentName + ".csproj";
    }
    $argumentList = " add .\$_projectDependentName  reference $_projectReferencePath";

    $workingDirectory = [system.io.path]::GetDirectoryName((PrepareAbsolutePath -Path $_projectDependentPath -ExcludeLastBackSlash)) ; 
    Start-Process dotnet -ArgumentList $argumentList -WorkingDirectory $workingDirectory -NoNewWindow -Wait ;
    PowershellLogger -Message "The process adding <$_projectReferenceName> project to the Project <$_projectDependentName> complited!" -LogType Report -IncludeBottomExtraLine;
}        
function PrepareDotnetProjectName {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 77635fa0-d02e-4428-990a-0c8aba731e7d
    #----------------------------------------------------
    # @Function Name = PrepareDotnetProjectName
    #----------------------------------------------------
    # @Usage = PrepareDotnetProjectName
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/11/2020 04:17:08
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $_projectName = $ProjectName.Trim();
    $_projectName = $ProjectName.Replace(' ', '');
    $_projectName = $ProjectName.Replace('//', '/');
    $_projectName = $ProjectName.Replace('\\', '');
    $_projectName = $ProjectName.Replace('\', '');
    $_projectName = $ProjectName.Replace('/', '');
    $_projectName = $ProjectName.Replace(':', '');
    $_projectName = $ProjectName.Replace('"', '');
    $_projectName = $ProjectName.Replace('''', '');
    return $_projectName;
    
}
function AddNugetPackageToProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $CsprojFileName, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string[]]
        $PackageNames
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 6769efb7-0c92-4409-abd1-f9d89c0649c2
    #----------------------------------------------------
    # @Function Name = AddNugetPackageToProject
    #----------------------------------------------------
    # @Usage = AddNugetPackageToProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/16/2020 13:57:45
    #____________________________________________________#
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $csprojFilePath = FileLookingupByNameAndExtension -Path $_projectBasePath -FileName $CsprojFileName -FileExtension ".csproj" -ThrowIfNotExistException;
    foreach ($package in $PackageNames) {
        $argumentList = " add " + $csprojFilePath + ' package ' + $package;
        Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -WindowStyle Hidden -Wait;
        PowershellLogger -Message "The package <$package> added to <$CsprojFileName> successfully!" -LogType Success;
    }
}

function PrepareCsprojFileOutputPath {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $OutputPath
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 705f066d-4a6e-4feb-a943-720a1b1d6970
    #----------------------------------------------------
    # @Function Name = PrepareSolutionFolderPath
    #----------------------------------------------------
    # @Usage = PrepareSolutionFolderPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/08/2020 19:23:34
    #----------------------------------------------------
    #____________________________________________________#
    $outputFolderPath = $OutputPath.Trim().Replace('\', '/');
    $outputFolderPath = ReplaceAnyOfCharactersWith -Text $outputFolderPath -Characters @( '\', '@', '`', '"', '*', '^', '|') -IncludeIllegalChars;
    if ($outputFolderPath.StartsWith('.')) {
        $outputFolderPath = $outputFolderPath.Remove(0, 1);
    }
    if ($outputFolderPath.StartsWith('/')) {
        $outputFolderPath = $outputFolderPath.Remove(0, 1);
    }
    if ($outputFolderPath.EndsWith('/')) {
        $outputFolderPath = $outputFolderPath.Remove($outputFolderPath.Length - 1 , 1);
    }
    if (!$outputFolderPath.StartsWith('Source')) {
        $outputFolderPath = "Source/" + $outputFolderPath;
    }
    if (!$outputFolderPath.EndsWith('/Source')) {
        $outputFolderPath = $outputFolderPath + "/Source";
    }
    return PrepareRelativePath -Path $outputFolderPath;
}        
function RestoreProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $CsprojFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 8af81759-051e-4a7f-a82f-8331b49ea87e
    #----------------------------------------------------
    # @Function Name = RestoreProject
    #----------------------------------------------------
    # @Usage = RestoreProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/29/2020 15:14:27
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $csprojFilePath = FileLookingupByNameAndExtension -Path $projectBasePath -FileName $CsprojFileName -FileExtension ".csproj" -ThrowIfNotExistException;
    $argumentList = "restore";
    Start-Process dotnet -WorkingDirectory (Split-Path -Path $csprojFilePath -Parent) -ArgumentList $argumentList -NoNewWindow -Wait;
    PowershellLogger -Message "The Csproj file <$CsprojFileName> restored completed!" -LogType Success;
}
function BuildProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $CsprojFileName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 8af81759-051e-4a7f-a82f-8331b49ea87e
    #----------------------------------------------------
    # @Function Name = RestoreProject
    #----------------------------------------------------
    # @Usage = RestoreProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/29/2020 15:14:27
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $csprojFilePath = FileLookingupByNameAndExtension -Path $projectBasePath -FileName $CsprojFileName -FileExtension ".csproj" -ThrowIfNotExistException;
    $argumentList = "build -c `"Release`" ";
    Start-Process dotnet -WorkingDirectory (Split-Path -Path $csprojFilePath -Parent) -ArgumentList $argumentList -NoNewWindow -Wait;
    PowershellLogger -Message "The Csproj file <$CsprojFileName> build completed!" -LogType Success;
}        
function DebugReinitDotnetTemplates {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 8c457076-ef98-4127-810e-bdbb51f9876b
    #----------------------------------------------------
    # @Function Name = DebugReinitDotnetTemplates
    #----------------------------------------------------
    # @Usage = DebugReinitDotnetTemplates
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 07/01/2020 14:46:57
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    Start-Process dotnet -ArgumentList " new --debug:reinit" -WindowStyle Hidden -Wait;
}

function ProvideDotnetCliNewMvcAndRazorPageCommandArgs {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $RazorPageProjectName,
        [Parameter(Mandatory = $false)]
        [string]
        $OutputPath = "./",
        [Parameter(Mandatory = $false)]
        [string]
        $AuthenticationType = "None",
        [Parameter(Mandatory = $false)]
        [string]
        $AzureAdB2cInstance,
        [Parameter(Mandatory = $false)]
        [string]
        $AzureAdInstance,
        [Parameter(Mandatory = $false)]
        [string]
        $ClientId,
        [Parameter(Mandatory = $false)]
        [securestring]
        $ResetPasswordPolicyId,
        [Parameter(Mandatory = $false)]
        [string]
        $EditProfilePolicyId,
        [Parameter(Mandatory = $false)]
        [string]
        $Domain,
        [Parameter(Mandatory = $false)]
        [string]
        $TenantId,
        [Parameter(Mandatory = $false)]
        [string]
        $OrgReadAccess,
        [switch]
        $UseLocalDb,
        [switch]
        $NoHttps,
        [switch]
        $NoStore,
        [switch]
        $UseBrowserLink,
        [switch]
        $UseRuntimeCompilation,
        [switch]
        $Force
    )

    $targetFramework = ProvideTargetFramework  -ProjectName $RazorPageProjectName -ProjectType "razorpage" -LatestVersion;
    $outputPath = PrepareRelativePath -Path $OutputPath -IncludeDot;
    [hashtable]$Options = New-Object -TypeName System.Collections.Hashtable;
    [string]$argumentList = "new webapp "; 
    $Options = @{
        "output"      = "$outputPath";
        "name"        = "$RazorPageProjectName";
        "framework"   = "$targetFramework";
        "language"    = "c#";
        "langVersion" = "latest";
    };
    if (![string]::IsNullOrEmpty($AuthenticationType)) {
        $Options += @{ "auth" = "$AuthenticationType" };
        switch ($AuthenticationType) {
            "None" {  }
            "Individual" { 

            }
            { "Individual", "IndividualB2c" -eq $_ } {  
                if (![string]::IsNullOrEmpty($UseLocalDb)) {
                    $Options += @{ "use-local-db" = "$AzureAdB2cInstance" };
                }
            }
            "IndividualB2C" { 
                if (![string]::IsNullOrEmpty($AzureAdB2cInstance) -and $AzureAdB2cInstance -ne "Default") {
                    $Options += @{ "aad-b2c-instance" = "$AzureAdB2cInstance" };
                }
                elseif ($AzureAdB2cInstance -eq "Default") {
                    $Options += @{ "aad-b2c-instance" = "" };
                }
                if (![string]::IsNullOrEmpty($SignInSignUpPolicyId)) {
                    $Options += @{ "susi-policy-id" = "$SignInSignUpPolicyId" };
                }
                if (![string]::IsNullOrEmpty($ResetPasswordPolicyId)) {
                    $Options += @{ "reset-password-policy-id" = "$ResetPasswordPolicyId" };
                }
                if (![string]::IsNullOrEmpty($EditProfilePolicyId)) {
                    $Options += @{ "edit-profile-policy-id" = "$EditProfilePolicyId" };
                }
            }
            "SingleOrg" {  
                if (![string]::IsNullOrEmpty($TenantId) -and $TenantId -ne "Default") {
                    $Options += @{ "tenant-id " = "$TenantId" };
                }                
                elseif ($TenantId -eq "Default") {
                    $Options += @{ "tenant-id" = "" };
                }  
            }
            { "MultiOrg", "SingleOrg", "IndividualB2C" -eq $_ } {  

                if (![string]::IsNullOrEmpty($ClientId)) {
                    $Options += @{ "client-id " = "$ClientId" };
                }
            }
            { "MultiOrg", "SingleOrg", "IndividualB2C", "Individual" -eq $_ } {  
                if ($NoHttps) {
                    $Options += @{ "no-https" = "" };
                }
            }
            { "MultiOrg", "SingleOrg" -eq $_ } {  
                if (![string]::IsNullOrEmpty($AzureAdInstance)) {
                    $Options += @{ "aad-instance " = "$AzureAdInstance" };
                }
                if (![string]::IsNullOrEmpty($AzureAdInstance)) {
                    $Options += @{ "org-read-access " = "" };
                }
            }
            { "SingleOrg", "IndividualB2C" -eq $_ } {  
                if (![string]::IsNullOrEmpty($AzureAdInstance)) {
                    $Options += @{ "domain" = "$Domain" };
                }
                if (![string]::IsNullOrEmpty($CallBackPath) -and $CallBackPath -ne "Default") {
                    $Options += @{ "callback-path" = "$CallBackPath" };
                }                
                elseif ($CallBackPath -eq "Default") {
                    $Options += @{ "callback-path" = "" };
                }  
            }
            "Windows" { 

            }
            Default {
                throw [System.Exception]::new("The Authentication type <$AuthenticationType> not supported!");
            }
        }
    }
    if ($NoStore) {
        $Options += @{ "no-restore" = '$true' };
    }
    if ($UseRuntimeCompilation) {
        $Options += @{ "razor-runtime-compilation" = '$true' };
    }
    if ($UseBrowserLink -and $targetFramework -ne "netcoreapp3.1" -and $targetFramework -ne "net5" -and $targetFramework -ne "netcoreapp2.2") {
        $Options += @{ "use-browserlink" = '$true' };
    }
    $Options.Keys | ForEach-Object { 
        $argumentList += (" --$_ " + $Options[$_] + " ");
    }
    if ($Force) {
        $argumentList += " --force ";
    }
    return $argumentList;
}     
function MakeNewRazorPage {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $RazorPageProjectName,
        [Parameter(Mandatory = $false)]
        [string[]]
        $ProjectReferences,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFolderPath,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $OutputPath,
        [Parameter(Mandatory = $false)]
        [string]
        $SolutionFileName,
        [Parameter(Mandatory = $false)]
        [string]
        $AuthenticationType,
        [Parameter(Mandatory = $false)]
        [string]
        $AzureAdInstance,
        [Parameter(Mandatory = $false)]
        [string]
        $OrgReadAccess,
        [Parameter(Mandatory = $false)]
        [string]
        $AzureAdB2cInstance,
        [Parameter(Mandatory = $false)]
        [SecureString]
        $ResetPasswordPolicyId,
        [Parameter(Mandatory = $false)]
        [string]
        $ClientId,
        [Parameter(Mandatory = $false)]
        [string]
        $Domain,
        [Parameter(Mandatory = $false)]
        [string]
        $EditProfilePolicyId,
        [Parameter(Mandatory = $false)]
        [string]
        $TenantId,
        [Parameter(Mandatory = $false)]
        [switch]
        $NoHttps,
        [switch]
        $Force,
        [switch]
        $UseLocalDb,
        [switch]
        $UseBrowserLink,
        [switch]
        $UseRuntimeCompilation
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 6a39f938-364c-4c78-bc3e-d926d5bfe1b0
    #----------------------------------------------------
    # @Function Name = DotnetCliNew
    #----------------------------------------------------
    # @Usage = DotnetCliNew
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/09/2020 12:31:22
    #____________________________________________________#
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $razorPageProjectName = PrepareDotnetProjectName -ProjectName $RazorPageProjectName;
    $outputPath = PrepareCsprojFileOutputPath -OutputPath $OutputPath;
    $argumentList = ProvideDotnetCliNewMvcAndRazorPageCommandArgs -RazorPageProjectName $razorPageProjectName -OutputPath $outputPath -AuthenticationType $AuthenticationType -AzureAdB2cInstance:$AzureAdB2cInstance -AzureAdInstance:$AzureAdInstance -ClientId:$ClientId -ResetPasswordPolicyId:$ResetPasswordPolicyId -EditProfilePolicyId:$EditProfilePolicyId -Domain:$Domain -TenantId:$TenantId -OrgReadAccess:$OrgReadAccess -UseLocalDb:$UseLocalDb -NoHttps:$NoHttps -UseBrowserLink:$UseBrowserLink -UseRuntimeCompilation:$UseRuntimeCompilation  -NoStore:$NoStore -Force:$Force; 
    Start-Process dotnet -WorkingDirectory $_projectBasePath -ArgumentList $argumentList -WindowStyle Hidden -Wait;
    $outputFullPath = PrepareAbsolutePath "$_projectBasePath\$outputPath";
    PowershellLogger -Message "The Razor Page web application <$razorPageProjectName> in <$outputPath> solution folder project created successfully in <$outputFullPath> solution folder!" -LogType Success -IncludeExtraLine;
    RemoveDefaultProjectTemplateFiles -TemplateName "razorpage" -ProjectPath $outputFullPath;
    AddProjectToSolution -CsprojFileName $razorPageProjectName -ProjectName $ProjectName -SolutionFileName $SolutionFileName -SolutionFolderPath $SolutionFolderPath; 
    $ProjectReferences | ForEach-Object {
        if (![string]::IsNullOrEmpty($_)) {
            AddReferenceToDotnetProject -ProjectReferenceName $_ -ProjectDependentName $razorPageProjectName -ProjectName $ProjectName;
        }
    }
}  