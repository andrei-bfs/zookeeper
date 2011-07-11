properties { 
	$projectName = "ZooKeeperNet"
	$rootDir  = Resolve-Path ..\
	$buildOutputDir = "$rootDir\build\$projectName"
	$srcDir = "$rootDir\src\dotnet"
	$solutionFilePath = "$srcDir\$projectName.sln"
    $repositoryPath
}

task default -depends Compile, CopyBuildOutput, CreateNuGetPackage

task Clean {
	Remove-Item $buildOutputDir -Force -Recurse -ErrorAction SilentlyContinue
	exec { msbuild $solutionFilePath /t:Clean }
}

task Compile -depends Clean { 
	exec { msbuild $solutionFilePath /p:Configuration=Release }
}

task CopyBuildOutput -depends Compile {
	$binOutputDir = "$buildOutputDir\bin"
	New-Item $binOutputDir -Type Directory

    Copy-Item "$srcDir\ZooKeeperNet\bin\Release\*.dll" $binOutputDir
    Copy-Item "$srcDir\ZooKeeperNet\bin\Release\*.pdb" $binOutputDir
}

task CreateNuGetPackage -depends CopyBuildOutput {
    [string]$version = Get-Version "$rootDir\build.xml"
	exec { .\NuGet.exe pack ".\$projectName.nuspec" -o "$buildOutputDir" -BasePath .\ -version $version }
}

task PublishPackage {
	$packages = Get-ChildItem $buildOutputDir\*.nupkg
	foreach($package in $packages){
		Copy-Item $package "$repositoryPath"
	}
}

function Get-Version {
    param 
    (
        [string]$filePath
    )
    
    [xml]$nuspecXml = Get-Content $filePath
    return ($nuspecXml.project.property | where { $_.name -eq "version" }).value
}