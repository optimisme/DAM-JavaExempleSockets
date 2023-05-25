@echo off
SETLOCAL

set folderDevelopment=Project
set folderRelease=Release

:: Get into the development directory
cd %folderDevelopment%

:: Remove any existing .class files from the bin directory
if exist bin rmdir /s /q bin

:: Create the bin directory if it doesn't exist
if not exist bin mkdir bin

:: Copy the assets directory to the bin directory
xcopy /E /I assets bin\assets

:: Generate the CLASSPATH by iterating over JAR files in the lib directory and its subdirectories
for /R lib %%f in (*.jar) do (
    set "class_path=!class_path!;%%f"
)

:: Compile the Java source files and place the .class files in the bin directory
javac -d bin src\*.java -cp %class_path%

:: Create the Project.jar file with the specified manifest file and the contents of the bin directory
jar cfm Project.jar Manifest.txt -C bin .

:: Remove any .class files from the bin directory
if exist bin rmdir /s /q bin

:: Get out of the development directory
cd ..

:: Remove any existing folderRelease
if exist %folderRelease% rmdir /s /q %folderRelease%

:: Create the release directory if it doesn't exist
if not exist %folderRelease% mkdir %folderRelease%

:: Move the Project.jar file to the release directory
move %folderDevelopment%\Project.jar %folderRelease%\Project.jar
xcopy /E /I %folderDevelopment%\lib %folderRelease%\lib

:: Create the 'run.bat' file
echo java -jar Project.jar > run.bat
move run.bat %folderRelease%\run.bat

:: Run the Project.jar file
cd %folderRelease%
java -cp Project.jar;%class_path% Main

ENDLOCAL