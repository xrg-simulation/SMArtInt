
rem Windows build
cmake -S ./CSource -B ./_cmake/ -DCMAKE_BUILD_TYPE=Release
cd ./_cmake
cmake --build . --config Release
cd ../

REM Windows gcc build
REM cmake -S ./CSource -B ./_cmake_gcc/ -DCMAKE_BUILD_TYPE=Release -G "MinGW Makefiles"
REM cd ./_cmake_gcc
REM cmake --build . --config Release
REM cd ../

rem Linux build
wsl cmake -S ./CSource -B ./_cmake_wsl/ -DCMAKE_BUILD_TYPE=Release
cd ./_cmake_wsl
wsl cmake --build . --config Release
cd ../
