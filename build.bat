@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ================================================================
rem OpcodeFinder command-line build script
rem Builds the existing Visual Studio 2010 / Qt4 project from cmd.exe.
rem
rem Usage:
rem   build.bat [Debug|Release] [Win32]
rem
rem Required environment:
rem   QTDIR      Path to Qt4 built for the same MSVC toolset, e.g.
rem              C:\Qt\4.8.7-msvc2010
rem   BOOST_ROOT Path to Boost root, e.g. C:\boost_1_49_0
rem
rem Optional environment:
rem   VS100COMNTOOLS  Usually created by Visual Studio 2010 installer.
rem   MSBUILD         Full path to MSBuild.exe if auto-detection fails.
rem ================================================================

set "CONFIG=%~1"
if "%CONFIG%"=="" set "CONFIG=Release"
set "PLATFORM=%~2"
if "%PLATFORM%"=="" set "PLATFORM=Win32"

if /I not "%CONFIG%"=="Debug" if /I not "%CONFIG%"=="Release" (
  echo [ERROR] Invalid configuration: %CONFIG%
  echo Usage: build.bat [Debug^|Release] [Win32]
  exit /b 1
)

if /I not "%PLATFORM%"=="Win32" (
  echo [ERROR] This project only defines Win32 builds.
  exit /b 1
)

pushd "%~dp0" || exit /b 1

if not defined QTDIR (
  echo [ERROR] QTDIR is not set.
  echo Example: set QTDIR=C:\Qt\4.8.7-msvc2010
  popd
  exit /b 1
)

if not exist "%QTDIR%\bin\moc.exe" (
  echo [ERROR] Qt tools were not found at "%QTDIR%\bin".
  echo Check QTDIR. It must point to a Qt4 build for Visual Studio/MSVC.
  popd
  exit /b 1
)

if not defined BOOST_ROOT (
  if exist "C:\boost_1_49_0" set "BOOST_ROOT=C:\boost_1_49_0"
)

if not defined BOOST_ROOT (
  echo [ERROR] BOOST_ROOT is not set and C:\boost_1_49_0 was not found.
  echo Example: set BOOST_ROOT=C:\boost_1_49_0
  popd
  exit /b 1
)

if not exist "%BOOST_ROOT%\boost\regex.hpp" (
  echo [ERROR] Boost headers were not found under "%BOOST_ROOT%".
  popd
  exit /b 1
)

rem The .vcxproj has hard-coded C:\boost_1_49_0 entries. Override through
rem INCLUDE/LIB as well so alternate BOOST_ROOT values still work for cl/link.
set "INCLUDE=%BOOST_ROOT%;%INCLUDE%"
if exist "%BOOST_ROOT%\stage\lib" set "LIB=%BOOST_ROOT%\stage\lib;%LIB%"
if exist "%BOOST_ROOT%\lib32-msvc-10.0" set "LIB=%BOOST_ROOT%\lib32-msvc-10.0;%LIB%"

rem Load Visual Studio 2010 compiler environment when available.
if defined VS100COMNTOOLS (
  if exist "%VS100COMNTOOLS%\..\..\VC\vcvarsall.bat" (
    call "%VS100COMNTOOLS%\..\..\VC\vcvarsall.bat" x86
  )
)

where cl.exe >nul 2>nul
if errorlevel 1 (
  echo [WARN] cl.exe was not found in PATH. Continuing with MSBuild auto-detection.
)

if not defined MSBUILD (
  if exist "%WINDIR%\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" set "MSBUILD=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
)
if not defined MSBUILD (
  for /f "delims=" %%M in ('where MSBuild.exe 2^>nul') do if not defined MSBUILD set "MSBUILD=%%M"
)

if not defined MSBUILD (
  echo [ERROR] MSBuild.exe was not found. Install Visual Studio 2010 or set MSBUILD manually.
  popd
  exit /b 1
)

echo [INFO] Configuration: %CONFIG%
echo [INFO] Platform:      %PLATFORM%
echo [INFO] QTDIR:         %QTDIR%
echo [INFO] BOOST_ROOT:    %BOOST_ROOT%
echo [INFO] MSBUILD:       %MSBUILD%

"%MSBUILD%" "OpcodeFinder.sln" /m /p:Configuration=%CONFIG% /p:Platform=%PLATFORM% /v:m
if errorlevel 1 (
  echo [ERROR] Build failed.
  popd
  exit /b 1
)

if not exist "%CONFIG%\OpcodeFinder.exe" (
  echo [ERROR] Build reported success, but "%CONFIG%\OpcodeFinder.exe" was not found.
  popd
  exit /b 1
)

echo [OK] Built: "%CD%\%CONFIG%\OpcodeFinder.exe"
echo [INFO] Run package.bat %CONFIG% to copy Qt DLLs into a dist folder.
popd
exit /b 0
