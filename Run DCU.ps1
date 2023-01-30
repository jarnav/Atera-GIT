 #Verify manufacturer is Dell
 $Manufacturer = (Get-WMIObject -Class win32_ComputerSystem).Manufacturer
 if ($Manufacturer -notlike "*Dell*") {
     Write-Host "Computer is not a Dell."
     exit
 }
  #Test potential Dell Command Update Paths
 $dcupaths =
  "$env:ProgramFiles\Dell\CommandUpdate\dcu-cli.exe",
  "${env:ProgramFiles(x86)}\Dell\CommandUpdate\dcu-cli.exe"

$correctPath = foreach( $path in $dcupaths ) {
  if( Test-Path -PathType Leaf $path ) {
    $path
    break
  }
}

if( !$correctPath ) {
  throw "Could not find dcu-cli.exe at any of the following paths: $(@( $dcupaths) -join ', ')"
}

# Execute Configuration and Apply Updates, Reboot
& $correctPath /applyUpdates -reboot=enable -autoSuspendBitLocker=enable -outputLog="c:\temp\DellCommandUpdate%dt%.log"