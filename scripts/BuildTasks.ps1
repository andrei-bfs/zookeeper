properties { 
	$projectName = "ZooKeeperNet"
    $version = "3.4.0"
	$buildNumber = 0
	$rootDir  = Resolve-Path ..\
	$buildOutputDir = "$rootDir\build\$projectName"
	$srcDir = "$rootDir\src\dotnet"
	$solutionFilePath = "$srcDir\$projectName.sln"
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
	exec { .\NuGet.exe pack ".\$projectName.nuspec" -o ..\build -version $version }
}