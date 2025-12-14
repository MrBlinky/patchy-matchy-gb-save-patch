@echo off
pushd "%~dp0"

call :patch "patchymatchy.gb", -DV10
call :patch "patchymatchy-v1.0.gb", -DV10
call :patch "patchymatchy-v1.1.gb", -DV11

popd
exit /B

:patch
set out="%~n1 save patch.gb"
if exist "%~f1" (
..\..\rgbds\rgbasm.exe patchymatchy-patch.asm -o patch.o %2
..\..\rgbds\rgblink.exe -t -o %out% -O %1 patch.o
..\..\rgbds\rgbfix.exe -v %out%
del /Q patch.o
echo Saved patched rom to %out%
)
exit /B
