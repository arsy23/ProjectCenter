function ProvideProjectComponent{

    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectName,
        [Parameter(Mandatory = $false)]
        [string]
        $ProjectNameAbbreviation 
    )
    $projectBasePath = ProjectLookupInProjects -ProjectName $ProjectName -ThrowIfNotExistException;

        switch ($projectName) {
            "MaintenanceManagementSystem" {
                $projectComponents = ProvideProjectComponentName -ProjectName $ProjectName;
                foreach($component in $projectComponents) {
                $_componentName = PrepareFileName -FileName $component;
                $projectName = Split-Path -Path $projectBasePath -Leaf;
                MakeCleanArchitectureProjectComponent -ProjectName $projectName -ComponentName $_componentName -ProjectNameAbbreviation $ProjectNameAbbreviation;
            }
        }
        "EEntertainmentReservationSystem" {
            $projectComponents = ProvideProjectComponentName -ProjectName $ProjectName;
            foreach($component in $projectComponents) {
            $_componentName = PrepareFileName -FileName $component;
            $projectName = Split-Path -Path $projectBasePath -Leaf;
            MakeCleanArchitectureProjectComponent -ProjectName $projectName -ComponentName $_componentName -ProjectNameAbbreviation $ProjectNameAbbreviation;
        }
    }

    }

}
function ProvideProjectComponentName{

    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectName
    )

    switch ($ProjectName) {
        "EEntertainmentReservationSystem"{
            $projectComponentNames = @(
                "ConcertInfoCatalog"
                "CinemaMovieInfoCatalog",
                "CartManagement",
                "Ordering",
                "Invoicing"
                "Authorization"
            );
            return $projectComponentNames;
        }
        #create diagram show level of dada insight or user insight
        "MaintenanceManagementSystem" { 
            $projectComponentNames = @(
                "EmploeeRelationManagement"
                "HumanResourceManagement"
                "WaresManagement"
                "Warehousing"
                "DepartmentManagement"
                "Rating"
                "Ranking"
                "Granting"
                "FeatureTraining"
                "Helping"
                "MultiTenancyManagement"
                "AssetManagement"
                "SettingManagement"
                "TaskManagement"
                "MessageQueueManagement"
                "Inspection"
                "Intercepting"
                "ThemeManagement"
                "ServerManagement"
                "CodingManagement"
                "EmploeeShiftManagement"
                "Detection"
                "ProductionControl"
                "Printing"
                "Converting"
                "Scheduling"
                "Searching"
                "FileHandler"
                "SecurityManagement"
                "Communicating"
                "Manufacturing"
                "DiscountingManagement"
                "Supplying"
                "Marketing"
                "BusinessAffairs"
                "ProjectManagement"
                "PaymentManagement"
                "SalesManagement"
                "QualityControl"
                "Engineering"
                "Planning"
                "Accounting"
                "Financing"
                "CostAccounting"
                "Ticketing"
                "Supporting"
                "Administration"
                "Feedback"
                "Contacting"
                "DataAnalysis"
                "Monitoring"
                "Logginng"
                "Observing"
                "Authorization"
                "UserConfigurationHandler"
                "SystemManagement"
                "NotificationHandler"
                "MessageHandler"
                "EventHandler"
            );
            return $projectComponentNames;
        }
    }

}