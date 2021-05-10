#####################################################
# @Module Identity = 68d9cde8-d77f-4883-a2d0-7cb91449c81f  
#----------------------------------------------------
# @Module File Name = Screens.psm1
#----------------------------------------------------
# @Module Description = Each module provide custom attributes of current device screen.
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Wednesday, June 3, 2020 7:35:57 PM
#____________________________________________________#
function GetScreenResolution {            
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 28602e53-f073-44d9-8e86-9b6d14f1e3ab
    #----------------------------------------------------
    # @Function Name = GetScreenResolution
    #----------------------------------------------------
    # @Usage = -
    #----------------------------------------------------
    # @Description = Get the Screen Resolution.
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = -
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 7:38:03 PM
    #____________________________________________________#
    [void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")            
    [void] [Reflection.Assembly]::LoadWithPartialName("System.Drawing")            
    $Screens = [system.windows.forms.screen]::AllScreens            
    
    foreach ($Screen in $Screens) {            
        # $DeviceName = $Screen.DeviceName            
        # $IsPrimary = $Screen.Primary            
        $Width = $Screen.Bounds.Width            
        $Height = $Screen.Bounds.Height            
    
        $OutputObj = New-Object -TypeName PSobject             
        $OutputObj | Add-Member -MemberType NoteProperty -Name Width -Value $Width            
        $OutputObj | Add-Member -MemberType NoteProperty -Name Height -Value $Height            
        # $OutputObj | Add-Member -MemberType NoteProperty -Name DeviceName -Value $DeviceName            
        # $OutputObj | Add-Member -MemberType NoteProperty -Name IsPrimaryMonitor -Value $IsPrimary    

        return @{ 
            "Width" = "$($OutputObj.Width)";
            "Height" = "$($OutputObj.Height)";
        }
    }            
}
[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
function ScreenshotRectangle() {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]
        $OutputFilePath,
        [Drawing.Rectangle]
        $Bounds
    )
    #####################################################
    # @Autor = Arsalan Fallahpour    
    #----------------------------------------------------
    # @Function Identity = 84d6ecc6-c890-4e70-b44f-65a8d4a348ae
    #----------------------------------------------------
    # @Function Name = ScreenshotRectangle -OutputFilePath -Bounds
    #----------------------------------------------------
    # @Usage1 = $Bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1000, 900)
    # @Usage1   ScreenshotRectangle $Bounds "C:\screenshot.png"
    #----------------------------------------------------
    # @Description = Take screenshot rectangle of screen.
    #----------------------------------------------------
    # @Return = -
    #----------------------------------------------------
    # @Development Note = Not tested.
    #----------------------------------------------------
    # @Date Created = Wednesday, June 3, 2020 7:38:03 PM
    #____________________________________________________#
    $bmp = New-Object Drawing.Bitmap $Bounds.width, $Bounds.height
    $graphics = [Drawing.Graphics]::FromImage($bmp)

    $graphics.CopyFromScreen($Bounds.Location, [Drawing.Point]::Empty, $Bounds.size)

    $bmp.Save($OutputFilePath)

    $graphics.Dispose()
    $bmp.Dispose()
}

