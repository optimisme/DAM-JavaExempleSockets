$folderDevelopment = "Project"
$folderRelease = "Release"

# Get into the development directory
Set-Location $folderDevelopment

# Remove any existing .class files from the bin directory
if (Test-Path -Path "./bin") {
    Remove-Item -Recurse -Force -Path "./bin"
}

# Create the bin directory if it doesn't exist
New-Item -ItemType Directory -Force -Path ./bin | Out-Null

# Copy the assets directory to the bin directory
if (Test-Path -Path "./assets") {
    Copy-Item -Recurse -Force ./assets ./bin/assets
}

# Generate the CLASSPATH by iterating over JAR files in the lib directory and its subdirectories
$lib_dir = (Resolve-Path "lib").Path
$jar_files = Get-ChildItem -Path $lib_dir -Filter "*.jar" -Recurse | ForEach-Object { ".\\lib\\" + $_.FullName.Replace($lib_dir + '\', '') }

# Enclose paths with quotes if they contain spaces
$CLASSPATH = ($jar_files | ForEach-Object { 
    if($_ -match '\s') {
        "`"" + $_ + "`""
    } else {
        $_
    } 
}) -join ';'

# Print the CLASSPATH for debugging
Write-Output $CLASSPATH

# Compile the Java source files and place the .class files in the bin directory
javac -d ./bin/ ./src/*.java -cp $CLASSPATH

# Create the Project.jar file with the specified manifest file and the contents of the bin directory
$jarExePath = Get-ChildItem -Path C:\ -Recurse -Filter "jar.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
& $jarExePath cfm ./Project.jar ./Manifest.txt -C bin .

# Remove any .class files from the bin directory
Remove-Item -Recurse -Force ./bin

# Get out of the development directory
Set-Location ..

# Move the Project.jar file to the release directory
if (Test-Path -Path "./$folderRelease") {
    Remove-Item -Recurse -Force ./$folderRelease
}
New-Item -ItemType Directory -Force -Path ./$folderRelease | Out-Null
Move-Item ./$folderDevelopment/Project.jar ./$folderRelease/Project.jar
Copy-Item -Recurse -Force "./$folderDevelopment/lib" "./$folderRelease/lib"

# Create the 'run.ps1' file
@"
java -cp Project.jar;$CLASSPATH Main
"@ | Set-Content -Path ./$folderRelease/run.ps1 -Encoding UTF8

# Create the 'run.sh' file
@"
#!/bin/bash
java -cp Project.jar;$CLASSPATH Main
"@ | Set-Content -Path ./$folderRelease/run.sh -Encoding UTF8
<#
# Run the Project.jar file
Set-Location ./$folderRelease
./run.ps1
Set-Location ..
#>