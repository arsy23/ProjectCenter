#####################################################
# @Module Identity = 3c24bff9-e3ac-45b1-bc18-3db5e25fa490  
#----------------------------------------------------
# @Module File Name = Special-Character-Checker.psm1
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Monday, June 1, 2020 3:49:53 PM
#____________________________________________________#

function SpecialCharacterChecker {
    param(
        [Parameter(Mandatory = $True)]
        [string]
        $Text
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0374c57c-5c83-42fd-aa9f-6e2b501c4585  
    #----------------------------------------------------
    # @Function Name = SpecialCharacterChecker
    #----------------------------------------------------
    # @Usage = SpecialCharacterChecker -Text $text
    #----------------------------------------------------
    # @Description = Invoke a powershell script that documented in the PowershellCenter assets.
    #----------------------------------------------------
    # @Return =  If object type is one of numeric types returned value is true, otherwise returned false.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 3:49:53 PM
    #____________________________________________________#

    $specialChars = GetAllSpecialCharecters -OutputType CharArray;

    $userInputChars = $Text.ToCharArray();


    foreach ($userInputChar in $userInputChars) {

        foreach ($specialChar in $specialChars) { if ($userInputChar -eq $specialChar) { return $true; } }
    }

    return $false;
}

function GetAllSpecialCharecters {
    param (
        # Parameter help description
        [Parameter(Mandatory = $True)]
        [string]
        $OutputType
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = f6cdb02f-d770-478d-bae9-b1567ee2abda  
    #----------------------------------------------------
    # @Function Name = GetAllSpecialCharecters
    #----------------------------------------------------
    # @Usage = GetAllSpecialCharecters -OutputType CharecterArray
    #----------------------------------------------------
    # @Description = Get all keyboard special character.
    #----------------------------------------------------
    # @Return = Base on type that pass in $OutputType argument, return all special characters.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 3:49:53 PM
    #____________________________________________________#

    [string]$characters = "`~@#$%^&*()_+=-*/-+.|\><!}{[];:'`"";
    
    switch($OutputType) {
        "CharArray" { return $characters.ToCharArray() };
    }
}        
function IncludeAnyOfCharacters {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Text,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [char[]]
        $Characters,
        [switch]
        $IncludeIllegalChars
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = c1dc03e2-be8c-40cc-a1ec-c8027addf94b
    #----------------------------------------------------
    # @Function Name = IncludeAnyOfCharacters
    #----------------------------------------------------
    # @Usage = IncludeAnyOfCharacters
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/08/2020 17:58:45
    #----------------------------------------------------
    AutoImportModule -FileName "Get-Illegal-Path-Characters";
    #____________________________________________________#
    if($IncludeIllegalChars)
    {
        $Characters += GetDefaultIllegalPathCharacters -OutputType CharArray;
    }
    $textChars = $Text.ToCharArray();
    foreach ($textChar in $textChars) {
      foreach ($includeChar in $Characters) { 
        if ($textChar -eq $includeChar) { return $true; } 
      }
    }
    return $false;
}
function IncludeCharacterMoreThanOne {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $Text,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [char]
        $Character 
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = e5216f3d-694c-4bad-ab05-af8f6866abe1
    #----------------------------------------------------
    # @Function Name = IncludeCharacterMoreThanOne
    #----------------------------------------------------
    # @Usage = IncludeCharacterMoreThanOne
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/08/2020 18:19:50
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $chars = $Text.ToCharArray();
    $quoteCount = 0
    foreach ($char in $chars) {
        if ($char -eq ':') { $quoteCount++; }     
    }
    if ($quoteCount -gt 1) {
        return $true;
    }
    return $true
}

