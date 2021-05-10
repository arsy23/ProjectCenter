$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
AutoImportModule -FileName "Dotnet-Cli-Command-Provider-Packing";
AutoImportModule -FileName "Folder";
AutoImportModule -FileName "Numeric-Option-Provider";

function PackingOptions {
    $options = "Pack All Projects" , "Pack Specific Project";
    $selectedOption = NumericOptionProvider -Message "Nuget Packing options:" -Options $options;
    switch ($selectedOption) {
        "Pack All Projects" { 
            do{
                PackAllPackages;
                $selectedOption = NumericOptionProvider -Message "do you need add do packing all again?" -Options @("Yes", "No");
            } while ($selectedOption -eq "Yes");
        }
        "Pack Specific Project" {  

            do{
                PackAPackage;
                $selectedOption = NumericOptionProvider -Message "do you need add do packing again?" -Options @("Yes", "No");
            } while ($selectedOption -eq "Yes");
         }
        }
    }