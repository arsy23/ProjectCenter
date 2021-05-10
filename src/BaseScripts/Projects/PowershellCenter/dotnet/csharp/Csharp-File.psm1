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
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    AutoImportModule -FileName "Dotnet-Solution";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    function ReplaceAddCsFileToSolution(
        [Parameter(Mandatory =  $true)]
        [string]
        $ProjectName,
        [Parameter(Mandatory =  $true)]
        [hashtable]
        $RepalcesCollection,
        [Parameter(Mandatory =  $true)]
        [string]
        $FileContent,
        [Parameter(Mandatory =  $true)]
        [string[]]
        $SolutionFoldeName,
        [Parameter(Mandatory =  $false)]
        [switch]
        $CreatePhysicalFolder
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
        $_fileContent = $FileContent;
        if($null -ne $RepalcesCollection.Keys)
        {
            $RepalcesCollection.Keys | ForEach-Object { 
                $_fileContent.Replace("$_", "$($RepalcesCollection[$_].ToString())" 
            }
        }

        CreateAddFilesToSolution -ProjectName $ProjectName -FileContent $_fileContent -SolutionFileName $SolutionFileName -SolutionFolderName $SolutionFoldeName -CreatePhysicalFolder:$CreatePhysicalFolder;
    }