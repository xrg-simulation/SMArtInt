#!\bin\bash

version=$(git describe --tags --abbrev=0)
# get rid of the leading v
version=${version:1}
# store the build hash
build=$(git rev-parse --short HEAD)
# store the date
date=$(git show -s --format=%ci)

rm -r _deploy/
mkdir _deploy/

# in case we run on a windows machine we do not have rsync - therefore use find in combination with mkdir and cp to copy the required files
find ./SMArtInt/* -type d ! \( -path "*venv*" -or -path "*idea*" -or -path *_log* -or -name data_*.pckl \)  -exec mkdir -p ./_deploy/{} \;
find ./SMArtInt/* -type f ! \( -path "*venv*" -or -path "*idea*" -or -path *_log* -or -name data_*.pckl \)  -exec cp {} ./_deploy/{} \;

sed -i -e "s/%build%/$build/g" ./_deploy/SMArtInt/package.mo
sed -i -e "s/%version%/$version/g" ./_deploy/SMArtInt/package.mo
sed -i -e "s/%date%/$date/g" ./_deploy/SMArtInt/package.mo

sed -i -e "s/%build%/$build/g" ./_deploy/SMArtInt/libraryinfo.mos
sed -i -e "s/%version%/$version/g" ./_deploy/SMArtInt/libraryinfo.mos
sed -i -e "s/%date%/$date/g" ./_deploy/SMArtInt/libraryinfo.mos

#clean up
rm ./_deploy/SMArtInt/Resources/Library/win64/*
rm ./_deploy/SMArtInt/Resources/Library/linux64/*

# Windows build vsc
cmake -S ./CSource -B ./_deploy/_cmake/ -DCMAKE_BUILD_TYPE=Release
cd ./_deploy/_cmake
cmake --build . --config Release
cd ../../

# Windows build mingw
# cmake -S ./CSource -B ./_deploy/_cmake_gcc/ -DCMAKE_BUILD_TYPE=Release -G "MinGW Makefiles"
# cd ./_deploy/_cmake_gcc
# cd ../../

# Linux build
wsl cmake -S ./CSource -B ./_deploy/_cmake_wsl/ -DCMAKE_BUILD_TYPE=Release
cd ./_deploy/_cmake_wsl
wsl cmake --build . --config Release
cd ../../

# copy additional required libs
cp ./SMArtInt/Resources/Library/win64/tensorflowlite_c.dll ./_deploy/SMArtInt/Resources/Library/win64/
cp ./SMArtInt/Resources/Library/win64/onnxruntime_c.dll ./_deploy/SMArtInt/Resources/Library/win64/
cp ./SMArtInt/Resources/Library/linux64/libtensorflowlite_c.so ./_deploy/SMArtInt/Resources/Library/linux64/
cp ./SMArtInt/Resources/Library/linux64/libonnxruntime_c.so ./_deploy/SMArtInt/Resources/Library/linux64/

# pack everything
cp ./README.md ./_deploy/
cp LICENSE ./_deploy/
cd _deploy/
# clean the zip file first
zip -d ../SMArtInt_$version"_"$build.zip
zip -r ../SMArtInt_$version"_"$build.zip ./SMArtInt README.md LICENSE

echo "Press any key to continue..."
# -s: Do not echo input coming from a terminal
# -n 1: Read one character
read -s -n 1