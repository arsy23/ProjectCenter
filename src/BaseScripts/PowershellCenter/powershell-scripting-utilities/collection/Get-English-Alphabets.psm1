#####################################################
# @Module Identity = 07984c64-4265-402a-9a33-b76ae0bdb4a  
#----------------------------------------------------
# @Module File Name = Get-English-Alphabets.psm1
#----------------------------------------------------
# @Module Description = Each function provide all or some of the English Alphabet. 
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Monday, June 1, 2020 11:03:49 PM
#____________________________________________________#
function GetAllEnglishAlphabets {
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $OutputType
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = b81ebf19-c17c-4c09-b5c4-192fc5e197d6 
    #----------------------------------------------------
    # @Function Name = GetAllEnglishAlphabets
    #----------------------------------------------------
    # @Usage = GetAllEnglishAlphabets -OutputType CharArray
    #----------------------------------------------------
    # @Description = Get english alphabet characters.
    #----------------------------------------------------
    # @Return = Return english alphabet characters base on the OutputType.
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 11:03:49 PM
    #____________________________________________________#

    $characters = "abcdefhijklmnopqrstuvwxyz";

    if ($OutputType -eq "CharArray") {
        return $characters.ToCharArray();
    }

}