param(
	[int]$buildNumber = 0,
    [string]$version
	)

Import-Module .\psake.psm1
Invoke-Psake BuildTasks.ps1 default -framework "4.0" -properties @{ buildNumber=$buildNumber; version=$version }
Remove-Module psake