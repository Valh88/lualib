@echo off
REM Build mymodule.dll (Lua 5.4 C module) with Free Pascal.
REM Requires: FPC in PATH (e.g. C:\fpcupdeluxe\fpc\bin\x86_64-win64) and lua54.dll.

set SCRIPT_DIR=%~dp0
set SRC_DIR=%SCRIPT_DIR%src
set EXAMPLE_DIR=%SCRIPT_DIR%example

REM Prefer FPC from FPCUPDELUXE or C:\fpcupdeluxe
set FPC_EXE=fpc
if not defined FPCUPDELUXE set "FPCUPDELUXE=C:\fpcupdeluxe"
if exist "%FPCUPDELUXE%\fpc\bin\x86_64-win64\fpc.exe" set "FPC_EXE=%FPCUPDELUXE%\fpc\bin\x86_64-win64\fpc.exe"

echo Building mymodule (Lua 5.4 module)...
"%FPC_EXE%" -MObjFPC -Scghi -O2 -Twin64 -Px86_64 -Fu"%SRC_DIR%" -Fi"%SRC_DIR%" "%EXAMPLE_DIR%\mymodule.lpr"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

echo.
echo Output: %EXAMPLE_DIR%\mymodule.dll
echo Place mymodule.dll where Lua can find it (see package.cpath) and ensure lua54.dll is nearby or in PATH.
echo Test: lua54 -e "local m = require('mymodule'); print(m.hello())"
exit /b 0
