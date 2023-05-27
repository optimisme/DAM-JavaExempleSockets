#!/bin/bash

reset

export folderDevelopment="Project"
export folderRelease="Release"

# Get into the development directory
cd $folderDevelopment

# Remove any existing .class files from the bin directory
rm -rf ./bin

# Create the bin directory if it doesn't exist
mkdir -p ./bin

# Copy the assets directory to the bin directory
if [ -d ./assets ]; then
    cp -r ./assets ./bin
fi

# Generate the CLASSPATH by iterating over JAR files in the lib directory and its subdirectories
lib_dir="lib"
jar_files=()

# Trobar tots els fitxers JAR al directori lib i els seus subdirectoris
while IFS= read -r -d '' jar_file; do
  jar_files+=("$jar_file")
done < <(find "$lib_dir" -name "*.jar" -type f -print0)

# Unir els fitxers JAR en el class_path
class_path=$(IFS=:; echo "${jar_files[*]}")

# Eliminar el ':' inicial del class_path
export CLASSPATH=${class_path#:}

# Generar el class_path compatible amb Windows
class_path_win=$(IFS=";"; printf "%s" "${jar_files[*]//\//\\\\}")
class_path_win=${class_path_win%;}
export CLASSPATHWIN=${class_path_win}

# Compile the Java source files and place the .class files in the bin directory
javac -d ./bin/ ./src/*.java -cp $CLASSPATH

# Create the Project.jar file with the specified manifest file and the contents of the bin directory
jar cfm ./Project.jar ./Manifest.txt -C bin .

# Remove any .class files from the bin directory
rm -rf ./bin

# Get out of the development directory
cd ..

# Move the Project.jar file to the release directory
rm -rf ./$folderRelease
mkdir -p ./$folderRelease
mv ./$folderDevelopment/Project.jar ./$folderRelease/Project.jar
cp -r ./$folderDevelopment/lib ./$folderRelease/lib

# Create the 'run.sh' file
cat > run.sh << EOF
#!/bin/bash
java -cp "Project.jar:$CLASSPATH" Main
EOF

# Create the 'run.ps1' file
cat > run.ps1 << EOF
java -cp "Project.jar;$CLASSPATHWIN" Main
EOF

# Fem l'arxiu executable
chmod +x run.sh
mv run.sh ./$folderRelease/run.sh
mv run.ps1 ./$folderRelease/run.ps1

# Run the Project.jar file
cd ./$folderRelease
./run.sh
cd ..