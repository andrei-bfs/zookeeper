param(
	[string]$repositoryPath
	)

Import-Module .\psake.psm1
Invoke-Psake BuildTasks.ps1 PublishPackage -framework "4.0" -parameters @{ repositoryPath = $repositoryPath }
Remove-Module psake