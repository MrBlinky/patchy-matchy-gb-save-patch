@echo off
pushd "%~dp0"

call :patch "patchymatchy.gb"

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
