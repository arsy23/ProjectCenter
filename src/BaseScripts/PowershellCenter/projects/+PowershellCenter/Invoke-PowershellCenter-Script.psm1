#####################################################
# @Module Identity = 94bce402-2b26-40ce-be70-6ebbed524009  
#----------------------------------------------------
# @Module File Name = Invoke-PowershellCenter-Script.psm1
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Monday, June 1, 2020 3:49:53 PM
#----------------------------------------------------
if([string]::IsNullOrEmpty($global:powershellCenterPath)){$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }}

#____________________________________________________#

function AutoInvokeScript {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileName,
        [hashtable]
        $Arguments,
        [string]
        $Switches
        )
        #####################################################
        # @Autor = Arsalan Fallahpour    
        #----------------------------------------------------
        # @Function Identity = ed5c53e8-493f-4d3d-9c43-a2236ed380e0  
        #----------------------------------------------------
        # @Function Name = AutoInvokeScript
        #----------------------------------------------------
        # @Usage1 = AutoInvokeScript -FileName  -Arguments @{ "" = ""; "" : "" }
        # @Usage1 = AutoInvokeScript -FileName "Auto-Import-PowershellCenter-Module" -Arguments @{"FileName" = "Powershell-Logger"}
        #----------------------------------------------------
        # @Description = Invoke a powershell script that documented in the PowershellCenter assets.
        #----------------------------------------------------
        # @Return = -
        #----------------------------------------------------
        # @Development Note = -
        #----------------------------------------------------
        # @Date Created = Monday, June 1, 2020 3:49:53 PM
        #----------------------------------------------------
        Import-Module "$global:powershellCenterPath\projects\+PowershellCenter\Resolve-PowershellCenter-FilePath.psm1";
        #____________________________________________________#

        $FileName = $FileName.Replace('.ps1', '');
        $path = (PowershellCenterFilesPathByNameAndExtension -FileName $FileName -FileExtension '.ps1');
        if($path.EndsWith('.psm1') -eq $true)
        {
            throw [System.Exception]::new("The File <$FileName> is a powershell module and can't invoked as powershell script!");
        }
        
        if([string]::IsNullOrEmpty($path))
        {
            throw [System.Exception]::new("The File <$FileName> not find in PoewershellCenter!");
        }

        $path = "$path".Trim();
        $command = "& '$path'" ;

        if($null -ne $Arguments.Keys)
        {
            $Arguments.Keys | ForEach-Object { 
                $command  += " -$_ `'$($Arguments[$_].ToString())`'" 
            }
        }
        $command += " $Switches";
        Invoke-Expression -Command $command;
    }