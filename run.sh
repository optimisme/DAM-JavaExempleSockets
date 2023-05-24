#!/bin/bash

reset

# Remove any existing Project.jar file
rm Project.jar

# Remove any existing .class files from the bin directory
rm -f ./bin/*.* 

# Create the bin directory if it doesn't exist
mkdir -p ./bin

# Copy the assets directory to the bin directory
cp -r ./assets ./bin

# Generate the CLASSPATH by iterating over JAR files in the lib directory and its subdirectories
lib_dir="lib"
jar_files=()

# Find all JAR files in the lib directory and its subdirectories
while IFS= read -r -d '' jar_file; do
  jar_files+=("$jar_file")
done < <(find "$lib_dir" -name "*.jar" -type f -print0)

# Join the JAR files into the class_path
class_path=$(IFS=:; echo "${jar_files[*]}")

# Remove the leading ':' from the class_path
export CLASSPATH=${class_path#:}

# Compile the Java source files and place the .class files in the bin directory
javac -d ./bin/ ./src/*.java -cp $CLASSPATH

# Create the Project.jar file with the specified manifest file and the contents of the bin directory
jar cfm Project.jar ./src/Manifest.txt -C bin . 

# Remove any .class files from the bin directory
rm -f ./bin/*.* 
rmdir ./bin

# Run the Project.jar file
java -jar Project.jar -cp $CLASSPATH