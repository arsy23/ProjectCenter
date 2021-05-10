#####################################################
# @Module Identity = 1eba6139-db26-47ec-bd21-2bda1367ec41
#----------------------------------------------------
# @Module File Name = project-name-utilities
#----------------------------------------------------
# @CallUsage1 = Invoke-Expression "& 'C:\Projects\PowershellCenter\project-development\utilities\project-name-utilities.psm1'";
# @CallUsage2 = AutoInvokeScript "project-name-utilities";
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = 06/29/2020 01:59:37
#----------------------------------------------------
$global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
#----------------------------------------------------
#Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";
#----------------------------------------------------
#AutoImportModule -FileName "";
#AutoInvokeScript -FileName "" -Arguments @{"" =""; };
#____________________________________________________#
    
        
function MakeProjectNamePrifix {
    param(
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
    # @Function Identity = 9f905c5e-4e2a-4951-af1c-8a9323de4c92
    #----------------------------------------------------
    # @Function Name = MakeProjectNamePrifix
    #----------------------------------------------------
    # @Usage = MakeProjectNamePrifix
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/29/2020 01:59:59
    #----------------------------------------------------
    AutoImportModule -FileName "Projects";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    if (![string]::IsNullOrEmpty($ProjectNameAbbreviation)) {
        return $ProjectNameAbbreviation;
    }
    elseif ($ProjectName.Length -gt 11) {
        FolderExistInProjects -ProjectName $ProjectName -ThrowIfNotExistException | Out-Null;
        return GetValidFolderName -Path (ResolveProjectsPath) -Message "Enter Abbrivation For Project Name(just project name exclude sub projects and components name)" -ErrorMessage "Invalid Project Name";
    }
    else {
        return $ProjectName;
    }
}

function MakeComponentNamePrifix {
    param(
        
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ComponentName 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 9f905c5e-4e2a-4951-af1c-8a9323de4c92
    #----------------------------------------------------
    # @Function Name = MakeProjectNamePrifix
    #----------------------------------------------------
    # @Usage = MakeProjectNamePrifix
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/29/2020 01:59:59
    #----------------------------------------------------
    AutoImportModule -FileName "Folder-Lookup";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    #generalization (seprated by common terms)
    #name globalization (seprated by specific terms that institutional to a insight)
    #unique cases (seprated by insight)
    switch ($ProjectName) {
        "EEntertainmentReservationSystem" {
            switch ($ComponentName) {
                { 'concertinfocatalog' -eq $_ } { return 'ConcertInfoCatalog' }
                { 'cinemamovieinfocatalog' -eq $_ } { return 'CinemaMovieInfoCatalog' }
                { 'invoicing' -eq $_ } { return 'Invoicing' }
                { 'ordering' -eq $_ } { return 'Ordering' }
                { 'cartmanagement' -eq $_ } { return 'CartManagement' }
                { 'auth', 'authorization'  -eq $_ } { return 'Authorization' }
            }
        }
        "MaintenanceManagementSystem" {
            switch ($ComponentName.ToLower()) {
                #global coding system 
                #1-without '#' separator
                #=unique cases
                #2-with (n) sparator
                #
                #3-with ...

                #form user insight but depends on user use case for thairs
                { 'h', 'hrm', "humanresourcemanagement", "humanresourcem", "humanrmanagement", "hresourcemanagement", 'humanresources', 'hr', 'houmanresource', 'hresource', 'hresources', 'humans', 'hus', '' -eq $_ } { return 'HumanResourceManagement' }
                { 'ware', 'wares', 'waremanagement', 'waresmanagement', 'wm', 'wama', '' -eq $_ } { return 'WaresManagement' }
                { 'w', 'wareho', 'wh' , 'warehousing' , 'wareh', 'whousing', '' -eq $_ } { return 'Warehousing' }
                { 'departmentManagement', 'dmanagement', 'departmentm', 'depmanage', '' -eq $_ } { return 'DepartmentManagement' }  
        
                #globalize
                #^^^
                { 'manufacturing', 'manufact', 'mar', '' -eq $_ } { return 'Manufacturing' }
                { 'rating' -eq $_ } { return 'Rating' }
                { 'fileHandler' -eq $_ } { return 'FileHandler' }
                { 'searching' -eq $_ } { return 'Searching' }
                { 'printing' -eq $_ } { return 'Printing' }
                { 'productionControl' -eq $_ } { return 'ProductionControl' }
                { 'inspection' -eq $_ } { return 'Inspection' }
                { 'intercepting' -eq $_ } { return 'Intercepting' }
                { 'servermanagement' -eq $_ } { return 'ServerManagement' }
                { 'codingmanagement' -eq $_ } { return 'CodingManagement' }
                { 'emploeeshiftmanagement' -eq $_ } { return 'EmploeeShiftManagement' }
                { 'detection' -eq $_ } { return 'Detection' }
                { 'messagequeuemanagement' -eq $_ } { return 'MessageQueueManagement' }
                { 'taskmanagement' -eq $_ } { return 'TaskManagement' }
                { 'scheduling' -eq $_ } { return 'Scheduling' }
                { 'settingmanagement' -eq $_ } { return 'SettingManagement' }
                { 'assetmanagement' -eq $_ } { return 'AssetManagement' }
                { 'multitenancymanagement' -eq $_ } { return 'MultiTenancyManagement' }
                { 'helping', 'help' -eq $_ } { return 'Helping' }
                { 'featuretraining' -eq $_ } { return 'FeatureTraining' }
                { 'ranking' -eq $_ } { return 'Ranking' }
                { 'granting' -eq $_ } { return 'Granting' }
                { 'thememanagement' -eq $_ } { return 'ThemeManagement' }
                { 'securitymanagement' -eq $_ } { return 'SecurityManagement' }
                { 'communicating' -eq $_ } { return 'Communicating' }
                { 'discountingmanagement', 'discounting', '' -eq $_ } { return 'DiscountingManagement' }
                { 'supplying', 'spplying', 'suplying', 'supplnyg', 'supplyig', 'supplyin', 'suppl', 'supp', '' -eq $_ } { return 'Supplying' }
                { 'm', 'marketing', 'market', 'mar', 'market', 'mark', 'marke', '' -eq $_ } { return 'Marketing' }
                { 'businessaffairs', 'buaf', 'ba', 'businessa', 'baffairs', '' -eq $_ } { return 'BusinessAffairs' }
                { 'p', 'pm' , 'projectmanagement' , 'pmanagement' , 'projectm' , 'prma', '' -eq $_ } { return 'ProjectManagement' }
                #globalize
                { 'paymentmanagement', 'payment', 'paymentsystem', 'paymentsmanagement', '' -eq $_ } { return 'paymentmanagement' }
                { 'salesmanagement', 'sales', 'smanagement', 'sama', '' -eq $_ } { return 'SalesManagement' }
                { 'qc', 'qualitycontrol', 'qualityc', 'quco', 'quacon', 'qcontorl', 'qco', '' -eq $_ } { return 'QualityControl' }
                { 'eng', 'engineering', 'plan', 'engineer', '' -eq $_ } { return 'Engineering' }
                { 'p', 'planning', 'plan', 'plann', 'pla', '' -eq $_ } { return 'Planning' }
                { 'accounting' , 'acc' , '' -eq $_ } { return 'Accounting' }
                { 'financing', 'finan', 'fi', 'fin', 'financ', 'financin', '' -eq $_ } { return 'Financing' }
                { 'costaccounting', 'cacc' -eq $_ } { return 'CostAccounting' }     
                { 'ticketing', 'ticketing', 'ticksystem', 'ticksys', 'tsys', 'ticketingsystem', 'tic', '' -eq $_ } { return 'Ticketing' }
                { 'supporting', 'support', '' -eq $_ } { return 'Supporting' }
                { 'administration', 'admin', 'administer', 'administerator', '' -eq $_ } { return 'Administration' }
                { 'feedback', 'feed', 'feedback', 'fb', 'feba' -eq $_ } { return 'Feedback' }
                { 'contacting', '' -eq $_ } { return 'Contacting' }
                { 'dataanalysis', 'danalysis', 'dataa', 'daal', '' -eq $_ } { return 'DataAnalysis' }
                #^^^
                { 'monitoring', 'monitor', '' -eq $_ } { return 'Monitoring' }
                { 'logging', 'log', '' -eq $_ } { return 'Logging' }
                { 'observing', 'ob', '' -eq $_ } { return 'Observing' }
                { 'auth' , 'authorization', '' -eq $_ } { return 'Authorization' }
                { 'reportinghub', 'repohub', 'reporting', 'repo', '' -eq $_ } { return 'Reporting' }
                { 'emploeerelationmanagement', '' -eq $_ } { return 'EmploeeRelationManagement' }
                { 'emploeerelations', '' -eq $_ } { return 'EmploeeRelations' }
                { 'uconfigurationhandler', 'userconfigurationhandler', 'uconfigurationh', 'uch', '' -eq $_ } { return 'UserConfigurationHandler' }
                { 'systemmanagement', 'eventh', 'ehandler', 'eh', '' -eq $_ } { return 'SystemManagement' }
                { 'n', 'nh', 'notificationhandler', 'notihandler', 'nhandler', 'notificationh', 'notifying', '' -eq $_ } { return 'NotificationHandler' }
                { 'messagehandler', 'messageh', 'mhandler' , '' -eq $_ } { return 'MessageHandler' }
                { 'eventhandler', 'eventh', 'ehandler', 'eh', '' -eq $_ } { return 'EventHandler' }
                Default {}
            } 
        }
        Default {}
    }
    if ($ComponentName.Length -gt 4) {
        $projectPath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;
        FolderExistInSubFolders -Path $projectPath -FolderName $ComponentName -ThrowIfExistException | Out-Null;
        return GetValidFolderName -Path "$projectPath\Source\Components\" -Message "Enter Abbrivation For Project Component Name(just component name exclude project name)" -ErrorMessage "Invalid Compoent Name";
    }
    else {
        return $ComponentName;
    }
}

        
function GetValidProjectName {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $ErrorMessage, 
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Message 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 9351da3c-c255-454e-b042-c09a52100fb7
    #----------------------------------------------------
    # @Function Name = GetValidProjectName
    #----------------------------------------------------
    # @Usage = GetValidProjectName
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/29/2020 03:39:56
    #----------------------------------------------------
    AutoImportModule -FileName "Console";
    #____________________________________________________#
    [string] $_projectName = "";
    $firstTime = $true;
    do {
        if (!$firstTime) {
            RewriteConsoleOption -ErrorMessage "The Name was entered include more than 30 character!" -RewriteRowCount 2 -ClearRowCount 2;
        }
        $firstTime = $false;
        $_projectName = GetValidFolderName -Message $Message -ErrorMessage $ErrorMessage  -Path $Path;
        ChangePowershellConsoleCursorPosition -RewriteRowCount 1;
        if ($_projectName.Length -gt 60) {
            continue;
        }
        else {
            break;
        }
    } while ($ture);
    ClearCurrentPowershellConsoleRow;
    return $_projectName;
}

