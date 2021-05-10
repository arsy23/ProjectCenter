    #####################################################
    # @Module Identity = 1f30a9fa-81e1-4cc8-b84b-caa8c8e70fb9
    #----------------------------------------------------
    # @Module File Name = Git
    #----------------------------------------------------
    # @Usage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\Git.psm1'";
    # @Usage2 = AutoInvokeScript "Git";
    #----------------------------------------------------
    # @Module Description = -
    #----------------------------------------------------
    # @Module Development Note = -
    #----------------------------------------------------
    # @Module Date Created = 06/09/2020 07:32:53
    #----------------------------------------------------
    $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
    #----------------------------------------------------
    #Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    
        
function ConfigureGitTrueAutoClrf {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ConfigurationOption,
        [switch]
        $Global
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0230ff50-8a8d-4f94-8b8a-ca3d1ec3b00b
    #----------------------------------------------------
    # @Function Name = ConfigureGitTrueAutoClrf
    #----------------------------------------------------
    # @Usage = ConfigureGitTrueAutoClrf
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/09/2020 07:33:30
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $globalCommandParameter = [string]::Empty;
    if($Global)
    {
        $globalCommandParameter = '--global';
    }
    switch($ConfigurationOption)
    {
        "Auto" {git config $($globalCommandParameter) core.autocrlf true;}
        "Input" {git config $($globalCommandParameter) core.autocrlf input;}
        "False" {git config $($globalCommandParameter) core.autocrlf false;}
        default {
            throw [System.Exception]::new("The <$ConfigurationOption> option is'nt a valid configuration option");
        }
    }
}

        
function ConfigureGitSafeClrf {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ConfigurationOption,
        [switch]
        $Global
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 5370283d-b6d5-4d83-818e-bf2bf84484e5
    #----------------------------------------------------
    # @Function Name = ConfigureGitSafeClrf
    #----------------------------------------------------
    # @Usage = ConfigureGitSafeClrf
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/09/2020 07:46:46
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $globalCommandParameter = [string]::Empty;
    if($Global)
    {
        $globalCommandParameter = '--global';
    }
    switch($ConfigurationOption)
    {
        "DisableWarning" {git config $($globalCommandParameter) core.safecrlf false;}
        "EnableWarning" {git config $($globalCommandParameter) core.safecrlf true;}
        default {
            throw [System.Exception]::new("The <$ConfigurationOption> option is'nt a valid configuration option");
        }
    }
}

