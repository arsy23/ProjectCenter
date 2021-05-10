#####################################################
# @Module Identity = b63bb9c7-adc0-4602-9883-d3c166c84835  
#----------------------------------------------------
# @Module File Name = Numeric-Validator.psm1
#----------------------------------------------------
# @Module Description = Define a c# helper class with static method for type checking.   
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Monday, June 1, 2020 3:49:53 PM
#____________________________________________________#

Add-Type -Language CSharp @'
    public class ValidatorHelpers {
        public static bool ValidateNumericType(object o) {
            return o is byte  || o is short  || o is int  || o is long
                || o is sbyte || o is ushort || o is uint || o is ulong
                || o is float || o is double || o is decimal;
        }
    }
'@

filter NumericValidator
{
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Filter Identity = 2b3ab712-dffd-4c00-bace-d51a08851eb8  
    #----------------------------------------------------
    # @Filter Name = NumericValidator
    #----------------------------------------------------
    # @Usage = $isNumeric = $userInput  | NumericValidator;
    #----------------------------------------------------
    # @Description = Get an value from pipleline and use the <ValidatorHelpers> class for check that type is a numeric.
    #----------------------------------------------------
    # @Return = If the value that pass as pipeline variable is a numeric type, return true otherwise return false;
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Monday, June 1, 2020 3:49:53 PM
    #____________________________________________________#

    return [ValidatorHelpers]::ValidateNumericType($_)
}

# filter isNumeric() {
#     return $_ -is [byte]  -or $_ -is [int16]  -or $_ -is [int32]  -or $_ -is [int64]  `
#        -or $_ -is [sbyte] -or $_ -is [uint16] -or $_ -is [uint32] -or $_ -is [uint64] `
#        -or $_ -is [float] -or $_ -is [double] -or $_ -is [decimal]
# }