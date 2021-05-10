
#####################################################
# @Module Identity = 765c2a92-34be-4f5e-aca6-b6668544bb9a
#----------------------------------------------------
# @Module File Name = Console.psm1
#----------------------------------------------------
# @Module Description = -
#----------------------------------------------------
# @Module Development Note = -
#----------------------------------------------------
# @Module Date Created = Wednesday, June 3, 2020 9:19:47 PM
#----------------------------------------------------
if ([string]::IsNullOrEmpty($global:powershellCenterPath)) { $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } } }

#____________________________________________________#
function ChangePowershellConsoleCursorPosition {
      param (
            [int]
            $RewriteRowCount = 0,
            [string]
            $BackgroundColor = [Console]::BackgroundColor,
            [string]
            $ForegroundColor = [Console]::ForegroundColor
      )


      #####################################################
      # @Script Name = ChangePowershellConsoleCursorPosition
      #----------------------------------------------------
      # @File Name = Change-Powershell-Console-Cursor-Position
      #----------------------------------------------------
      # @Identity = 5c0f373e-9693-48c9-9665-ee68777769f2
      #----------------------------------------------------
      # @Autor = Arsalan Fallahpour
      #----------------------------------------------------
      # @Usage = -
      #----------------------------------------------------
      # @Description = Change position of powershell console cursor
      #----------------------------------------------------
      # @Return = -
      #----------------------------------------------------
      # @Development Note = -
      #----------------------------------------------------
      # @Date Created = Monday, June 1, 2020 1:05:52 PM
      #____________________________________________________#
      $offsetY = [Console]::WindowTop;
      $cursorPosition = $Host.UI.RawUI.CursorPosition;
      $noScrolledConsole = ($cursorPosition.X -ge 0 -and $cursorPosition.Y -ge 0 -and $cursorPosition.X -le [Console]::WindowWidth -and $cursorPosition.Y -le [Console]::WindowHeight);
      try {
            if ($noScrolledConsole) {
                  $cursorPosition.Y -= $RewriteRowCount;
                  [Console]::SetCursorPosition($cursorPosition.X, $offsetY + $cursorPosition.Y);
            }
            else {
                  $saveY = [Console]::CursorTop ;
                  [Console]::SetCursorPosition( $cursorPosition.X, $saveY - $RewriteRowCount );
            }
      }
      catch { }
}
function ClearCurrentPowershellConsoleRow {

      ##                Arsalan Fallahpour                ##
      # @File Name = Clear-Current-Powershell-Console-Row
      #----------------------------------------------------
      # @Identity = ab1706ae-6c9d-4ecd-9539-ab423593decc
      #----------------------------------------------------
      # @Usage = ClearCurrentPowershellConsoleRow
      #----------------------------------------------------
      # @Description = Clear current powershell console row
      #----------------------------------------------------
      # @Return = -
      #----------------------------------------------------
      # @Development Note = -
      #----------------------------------------------------
      # @Date Created = Monday, June 1, 2020 1:11:57 PM
      #____________________________________________________#

      $consoleWidth = $Host.UI.RawUI.BufferSize.Width;
      [Console]::Write("{0, -$consoleWidth}" -f " ");


}


function RewriteConsoleOption {
      param (
            [Parameter(Mandatory = $true)]
            [string]
            $ErrorMessage,
            #Number of row to re-write on console
            [Parameter(Mandatory = $true)]
            [int]
            $RewriteRowCount,
            #Number of row to clear at first
            [Parameter(Mandatory = $true)]
            [int]
            $ClearRowCount
      )
      #####################################################
      # @Autor = Arsalan Fallahpour
      #----------------------------------------------------
      # @Function Identity = 075309d2-a488-4d97-9198-4bde56f054b3
      #----------------------------------------------------
      # @Function Name = RewriteConsoleOption
      #----------------------------------------------------
      # @Usage = RewriteConsoleOption -ErrorMessage $ErrorMessage  -RewriteRowCount  -ClearRowCount -ErrorMessage
      #----------------------------------------------------
      # @Description = Write the ErrorMessage, then clear user input.
      #----------------------------------------------------
      # @Return = -
      #----------------------------------------------------
      # @Development Note = -
      #----------------------------------------------------
      # @Date Created = Monday, June 1, 2020 3:49:53 PM
      #----------------------------------------------------
      $global:powershellCenterPath = ""; foreach ($pathPart in ((Get-Location).Path).Split('\')) { $global:powershellCenterPath += "$pathPart\"; if ($pathPart -eq "PowershellCenter") { break; } }
      #----------------------------------------------------
      Invoke-Expression "& '$global:powershellCenterPath\Import-Useful-Modules.ps1'";

      #____________________________________________________#
      # $CursorPosition = $Host.UI.RawUI.CursorPosition;
      # $noScrolledConsole = ($CursorPosition.X -ge 0 -and $CursorPosition.Y -ge 0 -and $CursorPosition.X -le [Console]::WindowWidth -and $CursorPosition.Y -le [Console]::WindowHeight);
      # if ($noScrolledConsole) { $optionCounter += 3; }
      # else{ $optionCounter += 3;  }

      PowershellLogger -Message $ErrorMessage -LogType Error -NoFlag;
      ChangePowershellConsoleCursorPosition -RewriteRowCount $ClearRowCount;
      ClearCurrentPowershellConsoleRow;
      ChangePowershellConsoleCursorPosition -RewriteRowCount $RewriteRowCount;

}