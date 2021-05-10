#####################################################
# @Module Identity = 1b5603de-71cc-449e-9aa7-0b91af83e029
#----------------------------------------------------
# @Module File Name = ManagedClasslibrary-Scaffolder
#----------------------------------------------------
# @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\project-development\tools\scaffolders\ManagedClasslibrary-Scaffolder.psm1'";
# @CallUsage2 = AutoInvokeScript "ManagedClasslibrary-Scaffolder";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/12/2020 22:34:59
#----------------------------------------------------
if ([string]::IsNullOrEmpty($global:powershellCenterPath)) { $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } } }
#----------------------------------------------------
#Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule -FileName "Dotnet-Cli-Command-Provider";
AutoImportModule -FileName "Folder";
#____________________________________________________#  
function ScaffoldManagedClasslibraryProject {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0395df36-e82b-42db-8b7f-39c671e406b2
    #----------------------------------------------------
    # @Function Name = ScaffoldManagedClasslibraryProject
    #----------------------------------------------------
    # @Usage = ScaffoldManagedClasslibraryProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/12/2020 22:35:46
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $options = "Scaffold new managed classlibrary project" ,"Scaffold new component for a managed classlibrary", "Add reference to a classlibrary from outside project","Scaffold new classlibrary for solution", "Add reference to a classlibrary";
    $selectedOption = NumericOptionProvider -Message "Scaffolding options:" -Options $options;
    switch ($selectedOption) {
        "Add reference to a classlibrary" { 
            do{
                AddReferenceToClasslib;
                $selectedOption = NumericOptionProvider -Message "do you need add reference to another project?" -Options @("Yes", "No");
            } while ($selectedOption -eq "Yes");

        }
        "Add reference to a classlibrary from outside project" { 
            do{
                AddReferenceToClasslibFromOutsideProject;
                $selectedOption = NumericOptionProvider -Message "do you need add reference to another project?" -Options @("Yes", "No");
            } while ($selectedOption -eq "Yes");

        }
        "Scaffold new managed classlibrary project" { ScaffoldNewManagedClasslibraryProject; }
        "Scaffold new component for a managed classlibrary" { ScaffoldNewComponentForAManagedClasslibrary; }
        "Scaffold new classlibrary for solution" {
            do{

                $solutionFilePath = ShowOpenFileDialogForProjects -FileTypeTitle "Solution" -Filter "dotnet project solution file (*.sln)|*.sln";
                $slnFileName = Split-Path -Path $solutionFilePath -Leaf;
                $solutionFilePathParts = $solutionFilePath.Split('\');
                $projectName = $solutionFilePathParts[$solutionFilePathParts.Count -2 ];
                $projectBasePath = ProjectLookupInProjects -ProjectName $projectName -ThrowIfNotExistException;
                [string] $classlibName = GetValidFolderName -Message "Enter the Classlibrary project name:" -Path $projectBasePath;
                $testCoverageSelectedOption = (NumericOptionProvider -Message "do you need test coverage for <$classlibName>?" -Options @("Yes", "No"));
                $haveTestCoverage = $testCoverageSelectedOption -eq "Yes" | ??? $true : $false;
                $classlibOutputPath = ResolveClasslibraryOutputPath -ProjectName $projectName -SubDirectory "/Source" -Description "Select a output folder for the <$classlibName> class library in the <$slnFileName> solution for <$projectName> project <Source> folder";
                $classlibSlnPath = ResolveSolutionFolderPath -SolutionFileName $slnFileName -OutputPath $classlibOutputPath;
                MakeNewDotnetClasslib -SolutionFileName $slnFileName -SolutionFolderPath $classlibSlnPath -OutputPath $classlibOutputPath -ClasslibName $classlibName -ProjectName $projectName -TestProjectName ($classlibName +".UnitTest") -TestCoverage:$haveTestCoverage;
                $selectedOption = NumericOptionProvider -Message "Do you need scaffold more <classlibrary> for the <$slnFileName> solution?" -Options @("Yes", "No");
            } while ($selectedOption -eq "Yes");
        }
    }
}
function ScaffoldNewManagedClasslibraryProject {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = fd83b5b6-6c78-4c09-8eb5-8f3ce87a3965
    #----------------------------------------------------
    # @Function Name = ScaffoldNewManagedClasslibraryProject
    #----------------------------------------------------
    # @Usage = ScaffoldNewManagedClasslibraryProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/12/2020 22:42:38
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $Projects = ResolveProjectsPath;
    [string] $projectName = GetValidFolderName -Message "Enter the Project name:" -Path $Projects;
    [bool] $folderExist = (Test-Path -Path "$Projects\$ProjectName");
    if ( !$folderExist ) {
        mkdir -Path $Projects -Name $ProjectName | Out-Null;
    }
    elseif ($folderExist) {
        throw [System.Exception]::new("There is a project name <$ProjectName> in project resources!");
    }
    InitializeDefaultManagedClasslibraryProject -ProjectName $projectName;
    MakeClasslibraryIterative -ProjectName $projectName;;
}        
function InitializeDefaultManagedClasslibraryProject {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 39f147e3-b3f6-4a6c-a572-3cd86f938372
    #----------------------------------------------------
    # @Function Name = InitializeDefaultManagedClasslibraryProject
    #----------------------------------------------------
    # @Usage = InitializeDefaultManagedClasslibraryProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/13/2020 22:47:40
    #----------------------------------------------------
    AutoImportModule -FileName "GitRepository-Initialization";
    #____________________________________________________#
    AutoInvokeScript -FileName "Setup-New-Project-Files" -Arguments  @{"ProjectName" = $ProjectName };
    InitializeDefaultGitRepositoryInAProject -ProjectName $ProjectName;
}       
function MakeClasslibraryIterative {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 62b568a2-c077-447a-a3ec-10b8e7eea166
    #----------------------------------------------------
    # @Function Name = MakeComponentIterative
    #----------------------------------------------------
    # @Usage = MakeComponentIterative
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/13/2020 22:52:37
    #____________________________________________________#
    do {
        MakeManagedClasslibraryComponent -ProjectName $ProjectName;
        $slnSelectedSlnOption = NumericOptionProvider -Message "Do you need more solution for the <$ProjectName> project?" -Options @("Yes", "No");
    } while ($slnSelectedSlnOption -eq "Yes")
}        
function MakeManagedClasslibraryComponent {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = bb803c70-4e01-4c62-a597-f64ef43b34a2
    #----------------------------------------------------
    # @Function Name = MakeManagedClasslibraryComponent
    #----------------------------------------------------
    # @Usage = MakeManagedClasslibraryComponent
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/16/2020 10:41:19
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $_projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    [string] $slnFileName = GetValidFolderName -Message "Enter the solution file name:" -Path $_projectBasePath;
    MakeNewDotnetSolution -SolutionFileName $slnFileName -ProjectName $ProjectName;
    do {
        [string] $_classlibName = GetValidFolderName -Message "Enter the class library name:" -Path $_projectBasePath;
        $currentBranch = $_classlibName;
        GitCheckoutNewBranch -ProjectName $ProjectName -BranchName $currentBranch;
        # $projectSourcePath = "$_projectBasePath\Source";
        $testCoverageSelectedOption = (NumericOptionProvider -Message "do you need test coverage for <$_classlibName>?" -Options @("Yes", "No"));
        $haveTestCoverage = $testCoverageSelectedOption -eq "Yes" | ??? $true : $false;
        $classlibOutputPath = ResolveClasslibraryOutputPath -ProjectName $ProjectName -SubDirectory "/Source" -Description "Select a output folder for the <$_classlibName> class library in the <$slnFileName> solution for <$ProjectName> project <Source> folder";;
        $slnFolderPath = ResolveSolutionFolderPath -OutputPath $classlibOutputPath -SolutionFileName $slnFileName;
        MakeNewDotnetClasslib -SolutionFileName $slnFileName -SolutionFolderPath $slnFolderPath -OutputPath $classlibOutputPath -ClasslibName $_classlibName -ProjectName $ProjectName -TestProjectName "$_classlibName.UnitTest" -TestCoverage:$haveTestCoverage;
        GitAddCommitToBranchOfProject -ProjectName $ProjectName -Message "Managed Classlibrary Component Maked" -CheckoutExistedBranch -BranchName $currentBranch;
        $classlibSelectedOption = NumericOptionProvider -Message "Do you need scaffold more classlibrary for the <$slnFileName> solution?" -Options @("Yes", "No");
    } while ($classlibSelectedOption -eq "Yes")
    
}
function ScaffoldNewComponentForAManagedClasslibrary {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 3f37d585-034b-4047-8768-d2a377df60d7
    #----------------------------------------------------
    # @Function Name = ScaffoldNewComponentForAManagedClasslibrary
    #----------------------------------------------------
    # @Usage = ScaffoldNewComponentForAManagedClasslibrary
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/25/2020 14:16:31
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $Description = "Select a project folder on the Projects sub-folders";
    $ProjectsPath = ResolveProjectsPath;
    $projectName = (Split-Path -Path (ShowFolderBrowserDialogForPath -Path $ProjectsPath -Description $Description ) -Leaf);
    MakeClasslibraryIterative -ProjectName $projectName;
}

        
function ResolveSolutionFolderPath {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $OutputPath, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SolutionFileName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 5619cf3e-aa18-4ca8-a386-1201cab7c376
    #----------------------------------------------------
    # @Function Name = ResolveSolutionFolderPath
    #----------------------------------------------------
    # @Usage = ResolveSolutionFolderPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/26/2020 18:32:14
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $_outputPath = $OutputPath;
    $slnFileNameParts = $SolutionFileName.Split('.');
    $excludeStartIndex = 1;
    $excludeEndIndex = $slnFileNameParts.Count;
    for ($i = $excludeStartIndex; $i -lt $excludeEndIndex; $i++) {
        $_outputPath = $_outputPath.Replace($slnFileNameParts[$i], '@_@_@');
    }
    $_outputPath = $_outputPath.Replace("@_@_@", '');
    if ($_outputPath.EndsWith("\Source")) {
        $_outputPath =  $_outputPath.Remove($_outputPath.Length - 7,7);
    }
   
    return PrepareRelativePath -Path $_outputPath;
}

        
function ResolveClasslibraryOutputPath {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $SubDirectory,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Description
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 4d45012e-7be9-4e07-b30a-de9c04bd85bc
    #----------------------------------------------------
    # @Function Name = ResolveClasslibraryOutputPath
    #----------------------------------------------------
    # @Usage = ResolveClasslibraryOutputPath
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/26/2020 18:35:09
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
    $_subDirectory = PrepareRelativePath -Path $SubDirectory;
    if($_subDirectory.StartsWith('.'))
    {
        $_subDirectory = $_subDirectory.Remove(0, 1);
    }
    $projectBasePath +=  "\$SubDirectory";
    $classlibSelectedPath = ShowFolderBrowserDialogForPath -Path $projectBasePath  -Description $Description;
    $classlibOutputPath = MakeRelativeToPathPart -Path $classlibSelectedPath -PathPart $ProjectName;
    if(!$classlibOutputPath.EndsWith('/Source'))
    {
        $classlibOutputPath = ($classlibOutputPath + '/Source');
    }
    return PrepareAbsolutePath -Path $classlibOutputPath;
}

        
function AddReferenceToClasslib {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = ecf59ce1-8fa7-45fd-bf82-796d7dbe6262
    #----------------------------------------------------
    # @Function Name = AddReferenceToClasslib
    #----------------------------------------------------
    # @Usage = AddReferenceToClasslib
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/30/2020 01:02:20
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $projectPath  = ShowFolderBrowserDialogForProjects;
    $projectName = [System.IO.Path]::GetFileNameWithoutExtension($projectPath);
    $title = "Select the <Csproj Source Project> @@@ on the <$projectName> project";
    $sourceProjectName = ShowOpenFileDialogForPath -Title $title.Replace("@@@", "Csproj Dependent Project") -Filter "dotnet csproj file (*.csproj)|*.csproj" -Path $projectPath -ResolveFileName;
    $targetProjectName = ShowOpenFileDialogForPath -Title $title.Replace("@@@", "Csproj Target Project") -Filter "dotnet csproj file (*.csproj)|*.csproj" -Path $projectPath -ResolveFileName;
    AddReferenceToDotnetProject -ProjectReferenceName $targetProjectName -ProjectDependentName $sourceProjectName -ProjectName $ProjectName;
}

        
function AddReferenceToClasslibFromOutsideProject {
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = f1b85298-7ad4-4a26-8077-293d0d9eff24
    #----------------------------------------------------
    # @Function Name = AddReferenceToClasslibFromOutsideProject
    #----------------------------------------------------
    # @Usage = AddReferenceToClasslibFromOutsideProject
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/30/2020 02:18:09
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $Projects = ResolveProjectsPath;
    $title = "Select the <Csproj Source Project> @@@ on the <$Projects>";
    $sourceProjectName = ShowOpenFileDialogForPath -Title $title.Replace("@@@", "Csproj Source Project") -Filter "dotnet csproj file (*.csproj)|*.csproj" -Path $Projects -ResolveFileName;
    $targetProjectName = ShowOpenFileDialogForPath -Title $title.Replace("@@@", "Csproj Target Project") -Filter "dotnet csproj file (*.csproj)|*.csproj" -Path $Projects -ResolveFileName;
    AddReferenceToDotnetProjectFromOutside -ProjectReferenceName $targetProjectName -ProjectDependentName $sourceProjectName;
}

