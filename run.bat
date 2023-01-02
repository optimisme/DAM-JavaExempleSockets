rem run with: .\run.bat

cls
rm -r -force .\bin
rm -r -force .\src\.*
rm -r -force .\lib\javafx-windows\lib\.*
mkdir bin
xcopy .\assets .\bin\assets /E /I /Y

javac -cp ".;.\\bin;.\\lib\\Java-WebSocket-1.5.3.jar;.\\lib\\slf4j-api-2.0.3.jar;.\\lib\\slf4j-simple-2.0.3.jar" -d .\bin\ .\src\*.java
java -cp ".;.\\bin;.\\lib\\Java-WebSocket-1.5.3.jar;.\\lib\\slf4j-api-2.0.3.jar;.\\lib\\slf4j-simple-2.0.3.jar" Main