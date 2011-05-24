param(
	[int]$buildNumber = 0,
	[bool]$skipRestore = $false
	)

if(!$skipRestore){
	.\scripts\RestoreDependencies.ps1
}
Import-Module .\tools\psake\psake.psm1
Invoke-Psake BuildTasks.ps1 default -framework "4.0" -properties @{ buildNumber=$buildNumber }
Remove-Module psake