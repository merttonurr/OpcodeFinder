@echo off
setlocal EnableExtensions

rem Copies the compiled exe plus the Qt runtime DLLs into dist\.
rem Usage: package.bat [Debug|Release]

set "CONFIG=%~1"
if "%CONFIG%"=="" set "CONFIG=Release"

pushd "%~dp0" || exit /b 1

if not exist "%CONFIG%\OpcodeFinder.exe" (
  echo [ERROR] "%CONFIG%\OpcodeFinder.exe" was not found. Run build.bat %CONFIG% first.
  popd
  exit /b 1
)

if not defined QTDIR (
  echo [ERROR] QTDIR is not set.
  popd
  exit /b 1
)

if not exist "dist" mkdir "dist"
copy /Y "%CONFIG%\OpcodeFinder.exe" "dist\" >nul

if /I "%CONFIG%"=="Debug" (
  copy /Y "%QTDIR%\bin\QtCored4.dll" "dist\" >nul
  copy /Y "%QTDIR%\bin\QtGuid4.dll" "dist\" >nul
) else (
  copy /Y "%QTDIR%\bin\QtCore4.dll" "dist\" >nul
  copy /Y "%QTDIR%\bin\QtGui4.dll" "dist\" >nul
)

echo [OK] Package folder: "%CD%\dist"
popd
exit /b 0
