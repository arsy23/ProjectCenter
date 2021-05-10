AutoImportModule -FileName "DoNetCenter-Path";
function ProvideDotNetCenterSubProjectInfos {
    if($null -ne $global:dotnetcenterSubProjectInfos)
    {
        if(!(GetSubFoldersCountOfDotNetCenter -eq $global:dotnetcenterSubProjectInfos.Count)){
            return $global:dotnetcenterSubProjectInfos;
        }
    }
    else {
        $global:dotnetcenterSubProjectInfos = New-Object -TypeName System.Collections.Hashtable;
    }
    $dotnetCenterPath = ResolveDotNetCenterPath;
    $dotnetcenterSubProjects = Get-ChildItem -Path $dotnetCenterPath -Recurse -File -Filter "*.csproj";
    $dotnetcenterSubProjects | Foreach-Object {
        if(!$global:dotnetcenterSubProjectInfos.Contains("$($_.BaseName)")){
            $global:dotnetcenterSubProjectInfos.Add("$($_.BaseName)", "$($_.FullName)");
        }
    }
    return $global:dotnetcenterSubProjectInfos;
}
function DotNetCenterProjectInfo  {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $DotNetCenterProjectName
    )
    $DotNetCenterProjectInfos = ProvideDotNetCenterSubProjectInfos;
    foreach ($projectName in $DotNetCenterProjectInfos.Keys) {
        if($projectName -eq $DotNetCenterProjectName )
        {
            return @{$projectName = $DotNetCenterProjectInfos.$projectName}
        }
    }
    return ProvideDotNetCenterSubProjectInfos.Keys;
    
}
function GetDotNetCenterSubProjectName {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $DotNetCenterProjectName
    )
    $subProjectInfos = ProvideDotNetCenterSubProjectInfos;
    return $subProjectInfos.Keys.GetEnumerator()  | Where-Object { $_ -Eq $DotNetCenterProjectName}
}
function GetDotNetCenterSubProjectPath {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $DotNetCenterProjectName
    )
    $subProjectInfos = ProvideDotNetCenterSubProjectInfos;
    return $subProjectInfos.$DotNetCenterProjectName;
}
function GetSubFoldersCountOfDotNetCenter {

    return @([System.IO.Directory]::EnumerateDirectories($(ResolveDotNetCenterPath) , "*", "AllDirectories")).Count;
}