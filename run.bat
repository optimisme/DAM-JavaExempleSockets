rem run with: .\run.bat

cls

REM Remove any existing Project.jar file
del Project.jar

REM Remove any existing .class files from the bin directory
del /Q bin\*.*

REM Create the bin directory if it doesn't exist
mkdir bin

REM Copy the assets directory to the bin directory
xcopy /E /I assets bin\assets

REM Generate the CLASSPATH by iterating over JAR files in the lib directory and its subdirectories
set "lib_dir=lib"
setlocal enabledelayedexpansion
set "class_path="

REM Find all JAR files in the lib directory and its subdirectories
for /R "%lib_dir%" %%F in (*.jar) do (
  set "class_path=!class_path!;%%F"
)

REM Remove the leading ';' from the class_path
set "class_path=!class_path:~1!"

REM Compile the Java source files and place the .class files in the bin directory
javac -d bin/ src/*.java -cp "%class_path%"

REM Create the Project.jar file with the specified manifest file and the contents of the bin directory
jar cfm Project.jar src/Manifest.txt -C bin .

REM Remove any .class files from the bin directory
del /Q bin\*.*
rd bin

REM Run the Project.jar file
java -jar Project.jar -cp "%class_path%"

endlocal
