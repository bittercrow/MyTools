@echo off

set "CURRENT=%~dp0"
if "%CURRENT:~-1%"=="\" set "CURRENT=%CURRENT:~0,-1%"

for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USER_PATH=%%B"

if defined USER_PATH (
    setlocal EnableDelayedExpansion
    set "NEW_PATH=;!USER_PATH!;"
    set "NEW_PATH=!NEW_PATH:;%CURRENT%;=;!"
    if "!NEW_PATH:~0,1!"==";" set "NEW_PATH=!NEW_PATH:~1!"
    if "!NEW_PATH:~-1!"==";" set "NEW_PATH=!NEW_PATH:~0,-1!"
    reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "!NEW_PATH!" /f
    endlocal
)

reg delete "HKCU\Software\Classes\*\shell\Backup" /f

echo Removed Backup context menu.
pause
