 gi#Test potential Dell Command Update Paths
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
& $correctPath /configure -updatetype='bios,firmware,driver,application,utility,others'
& $correctPath /applyupdates -reboot=enable -autosuspendbitlocker=enable