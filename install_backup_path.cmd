@echo off
setlocal

set "TOOL=%~dp0backup.vbs"
if not exist "%TOOL%" (
    echo Error: backup.vbs was not found.
    echo Expected:
    echo %TOOL%
    pause
    exit /b 1
)

REM Add CURRENT to the user Path
set "CURRENT=%~dp0"
if "%CURRENT:~-1%"=="\" set "CURRENT=%CURRENT:~0,-1%"
for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USER_PATH=%%B"

echo ;%USER_PATH%; | find /i ";%CURRENT%;" >nul
if errorlevel 1 (
    if defined USER_PATH (
        reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "%USER_PATH%;%CURRENT%" /f
    ) else (
        reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "%CURRENT%" /f
    )
)

REM Edit the Windows Registry
reg add "HKCU\Software\Classes\*\shell\Backup" /ve /d "Backup" /f

reg add "HKCU\Software\Classes\*\shell\Backup" /v Icon /d "%SystemRoot%\System32\shell32.dll,258" /f

reg add "HKCU\Software\Classes\*\shell\Backup\command" ^
    /ve ^
    /d "wscript.exe \"%TOOL%\" \"%%1\"" ^
    /f

echo.
echo Installed Backup context menu.
echo TOOL=%TOOL%
reg query "HKCU\Software\Classes\*\shell\Backup\command"
pause
