#####################################################
# @Module Identity = 8e657a7d-3cd6-4ef6-928d-a23190d3e5bb  
#----------------------------------------------------
# @Module File Name = Get-Illegal-Path-Charecters
#----------------------------------------------------
# @Module Description = Each function provide all or some of the Illegal characters that include in path. 
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Monday, June 1, 2020 11:03:49 PM
#____________________________________________________#
function GetDefaultIllegalPathCharacters {
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $OutputType
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 0c3fdec4-5993-4438-8434-554fde066f6f 
    #----------------------------------------------------
    # @Function Name = GetDefaultIllegalPathCharacters
    #----------------------------------------------------
    # @Usage = GetDefaultIllegalPathCharacters -OutputType CharArray
    #----------------------------------------------------
    # @Description = Get characters that illegal to include in path. eg. in folder-name or file-name
    #----------------------------------------------------
    # @Return = Return illegal characters base on the OutputType.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 11:13:10 PM
    #____________________________________________________#
    
    [string] $characters = "#<>*?|`"";

    switch ($OutputType) {
        "CharArray" { return $characters.ToCharArray(); }
        Default {}
    }
}