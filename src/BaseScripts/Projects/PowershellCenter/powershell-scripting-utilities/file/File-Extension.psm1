function SupportFileExtension {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileExtension,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string[]]
        $SupportedFileExtensions,
        [switch]
        $ThrowException
    )
    $preparedFileExtension = PrepareFileExtension -FileExtension $FileExtension -ThrowException;
    $supported = $false;
    foreach ($extension in $SupportedFileExtensions) {
        if ($preparedFileExtension -ceq $extension) {
            $supported = $true;
            break;
        }
    }
    if ($ThrowException) {
        if ($supported -eq $false) {
            throw [System.Exception]::new("the FileExtension <$preparedFileExtension> not supported!");
        }
    }
    else {
        return $supported;
    }
}
function UnsupportFileExtension {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileExtension,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string[]]
        $UnspportedFileExtensions,
        [switch]
        $ThrowException
    )
    $preparedFileExtension = PrepareFileExtension -FileExtension $FileExtension  -ThrowException;
    $validExtension = $true;
    foreach ($extension in $UnspportedFileExtensions) {
        if ($preparedFileExtension -ceq $extension) {
            $validExtension = $false;
            break;
        }
    }
    if ($ThrowException) {
        if ($validExtension -eq $false) {
            throw [System.Exception]::new("the FileExtension <$preparedFileExtension> is unsupported extension!");
        }
    }
    else {
        return $validExtension;
    }
}

function PrepareFileExtension {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $FileExtension,
        [switch]
        $ThrowException
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 53813033-da99-473c-85e9-769d1a2dd0e8
    #----------------------------------------------------
    # @Function Name = PrepareFileExtension
    #----------------------------------------------------
    # @Usage = PrepareFileExtension
    #----------------------------------------------------
    # @Description = -
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = 06/06/2020 01:24:36
    #----------------------------------------------------
    #AutoImportModule -FileName "";
    #AutoInvokeScript -FileName "" -Arguments @{"" =""; };
    #____________________________________________________#
    $outputFileExtension = $FileExtension.Trim();
    $outputFileExtension = $outputFileExtension.ToLower();
    $outputFileExtension = $outputFileExtension.Replace('\\', '');
    $outputFileExtension = $outputFileExtension.Replace('//', '');
    $outputFileExtension = $outputFileExtension.Replace('\', '');
    $outputFileExtension = $outputFileExtension.Replace('/', '');
    if (!$outputFileExtension.StartsWith('.')) {
        $outputFileExtension = ".$outputFileExtension";
    }
    if ($ThrowException) {
        if ($outputFileExtension.EndsWith('.')) {
            throw [System.Exception]::new("The file extension ends with <$outputFileExtension>!")
        }
    }
    return $outputFileExtension;
}