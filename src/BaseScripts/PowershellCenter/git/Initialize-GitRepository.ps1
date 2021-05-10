
param (
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [switch]
    $InitialCommit
    )

#####################################################
# @Autor = Arsalan Fallahpour    
#----------------------------------------------------
# @Script Identity = 871f4a66-d453-4eca-886b-69c7274ee3ea
#----------------------------------------------------
# @Script File Name = Initialize-GitRepository.ps1
#----------------------------------------------------
# @Usage1 = Invoke-Expression "& '$global:powershellCenterPath\powershell-scripting-utilities\project-development\tools-and-utilities\git\Initialize-Default-GitRepository.ps1' -Path `'C:\Users\arsal\Desktop\Test\`'";
# @Usage2 = Invoke-Expression "& '$global:powershellCenterPath\powershell-scripting-utilities\project-development\tools-and-utilities\git\Initialize-Default-GitRepository.ps1' -Path `'C:\Users\arsal\Desktop\Test\`' -InitialCommit";
#----------------------------------------------------
# @Description = Initialize gitt repository in specific path and make initial commit and dev branch if the <InitialCommit> switch called.
#----------------------------------------------------
# @Development Note = -
#----------------------------------------------------
# @Date Created = Monday, June 1, 2020 10:00:03 PM
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter"){break;} }
#----------------------------------------------------
Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
AutoImportModule -FileName "Git-Configuration";
#____________________________________________________#

ConfigureGitTrueAutoClrf -ConfigurationOption Auto -Global;
ConfigureGitSafeClrf -ConfigurationOption DisableWarning -Global;

git init $Path | Out-Null;

PowershellLogger -Message "Initialize the git repository was successfully" -LogType Success;

if($InitialCommit)
{
    git -C $Path add ".";

    git -C $Path commit --quiet --message "Initial Commit";

    PowershellLogger -Message "Initial Commit on master branch was successfully" -LogType Success;

    git -C $Path tag "Empty/master" | Out-Null;

    PowershellLogger -Message "<Empty/master> tag created successfully on the <InitialCommit> was successfully" -LogType Success;

    git -C $Path checkout --merge  -b "dev" --quiet;

    PowershellLogger -Message "<dev> branch created and switched successfully" -LogType Success;
    ConfigureGitSafeClrf -ConfigurationOption EnableWarning -Global;
}




