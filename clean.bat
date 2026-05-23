@echo off
setlocal
pushd "%~dp0" || exit /b 1
if exist Debug rmdir /S /Q Debug
if exist Release rmdir /S /Q Release
if exist dist rmdir /S /Q dist
if exist OpcodeFinder\GeneratedFiles rmdir /S /Q OpcodeFinder\GeneratedFiles
echo [OK] Cleaned build outputs.
popd
exit /b 0
