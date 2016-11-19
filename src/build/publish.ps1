$msbuild = join-path -path (Get-ItemProperty "HKLM:\software\Microsoft\MSBuild\ToolsVersions\14.0")."MSBuildToolsPath" -childpath "msbuild.exe"
&$msbuild ..\main\HttpMachine.csproj /t:Build /p:Configuration="Release"


$version = [Reflection.AssemblyName]::GetAssemblyName((resolve-path '..\main\bin\release\HttpMachine.dll')).Version.ToString(3)
Remove-Item .\NuGet -Force -Recurse
New-Item -ItemType Directory -Force -Path .\NuGet
NuGet.exe pack HttpMachine.nuspec -Verbosity detailed -Symbols -OutputDir "NuGet" -Version $version

Nuget.exe push ".\NuGet\HttpMachine.PCL.$version.symbols.nupkg" -Source https://www.nuget.org