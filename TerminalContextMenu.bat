@echo off
setlocal enabledelayedexpansion
title Terminal Context Menu Manager

:: Check for admin privileges and elevate if needed
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrator privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

:: Remove trailing backslash if present
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Create RegBackup directory if it doesn't exist
if not exist "%SCRIPT_DIR%\RegBackup" mkdir "%SCRIPT_DIR%\RegBackup"

:MAIN_MENU
cls
echo ====================================================
echo       Terminal Context Menu Manager
echo ====================================================
echo.
echo Current script directory: %SCRIPT_DIR%
echo.
echo 1. Show System Information
echo 2. Add Terminal Context Menu Options
echo 3. Remove Terminal Context Menu Options
echo 4. Exit
echo.
echo Please make your selection and press Enter...
set /p "choice=Enter your choice (1-4): "

if "%choice%"=="1" goto SHOW_INFO
if "%choice%"=="2" goto ADD_MENU
if "%choice%"=="3" goto REMOVE_MENU
if "%choice%"=="4" goto EXIT
echo.
echo Invalid choice. Please try again.
echo.
timeout /t 3 >nul
goto MAIN_MENU

:SHOW_INFO
cls
echo ====================================================
echo             System Information
echo ====================================================
echo.
echo Username: %USERNAME%
echo Computer Name: %COMPUTERNAME%
echo Current Directory: %CD%
echo Script Directory: %SCRIPT_DIR%
echo.
echo === Detecting Command Line Tools ===
echo.

:: Check CMD
set "CMD_FOUND=No"
where cmd.exe >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=*" %%i in ('where cmd.exe 2^>nul') do (
        echo CMD Path: %%i
        set "CMD_FOUND=Yes"
        goto cmd_check_done
    )
) 
:cmd_check_done
if "%CMD_FOUND%"=="No" echo CMD: Not found

:: Check PowerShell
set "PS_FOUND=No"
where powershell.exe >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=*" %%i in ('where powershell.exe 2^>nul') do (
        echo PowerShell Path: %%i
        set "PS_FOUND=Yes"
        goto ps_check_done
    )
)
:ps_check_done
if "%PS_FOUND%"=="No" echo PowerShell: Not found

:: Check Windows Terminal
set "WT_FOUND=No"
where wt.exe >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=*" %%i in ('where wt.exe 2^>nul') do (
        echo Windows Terminal Path: %%i
        set "WT_FOUND=Yes"
        goto wt_check_done
    )
)
:wt_check_done
if "%WT_FOUND%"=="No" echo Windows Terminal: Not found

echo.
echo === Icon Files Status ===
if exist "%SCRIPT_DIR%\cmd.ico" (echo CMD Icon: Found) else (echo CMD Icon: Missing)
if exist "%SCRIPT_DIR%\powershell.ico" (echo PowerShell Icon: Found) else (echo PowerShell Icon: Missing)
if exist "%SCRIPT_DIR%\terminal.ico" (echo Terminal Icon: Found) else (echo Terminal Icon: Missing)

echo.
echo === VBS Files Status ===
if exist "%SCRIPT_DIR%\OpenCmdAdmin.vbs" (echo CMD Admin VBS: Found) else (echo CMD Admin VBS: Missing)
if exist "%SCRIPT_DIR%\OpenPowerShellAdmin.vbs" (echo PowerShell Admin VBS: Found) else (echo PowerShell Admin VBS: Missing)
if exist "%SCRIPT_DIR%\OpenTerminalAdmin.vbs" (echo Terminal Admin VBS: Found) else (echo Terminal Admin VBS: Missing)

echo.
echo Press any key to return to main menu...
pause >nul
goto MAIN_MENU

:ADD_MENU
cls
echo ====================================================
echo          Add Terminal Context Menu Options
echo ====================================================
echo.
echo This will backup your current registry and add context menu options.
echo.
echo 1. Add CMD (Regular + Admin)
echo 2. Add PowerShell (Regular + Admin)
echo 3. Add Windows Terminal (Regular + Admin)
echo 4. Add All (CMD + PowerShell + Terminal)
echo 5. Back to Main Menu
echo.
echo Please make your selection and press Enter...
set /p "add_choice=Enter your choice (1-5): "

if "%add_choice%"=="1" goto ADD_CMD
if "%add_choice%"=="2" goto ADD_POWERSHELL
if "%add_choice%"=="3" goto ADD_TERMINAL
if "%add_choice%"=="4" goto ADD_ALL
if "%add_choice%"=="5" goto MAIN_MENU
echo.
echo Invalid choice. Please try again.
echo.
timeout /t 3 >nul
goto ADD_MENU

:ADD_CMD
echo.
echo Backing up registry...
call :BACKUP_REGISTRY
echo Adding CMD context menu entries...
call :CREATE_CMD_REGISTRY
echo CMD context menu added successfully!
echo.
echo Press any key to continue...
pause >nul
goto MAIN_MENU

:ADD_POWERSHELL
echo.
echo Backing up registry...
call :BACKUP_REGISTRY
echo Adding PowerShell context menu entries...
call :CREATE_POWERSHELL_REGISTRY
echo PowerShell context menu added successfully!
echo.
echo Press any key to continue...
pause >nul
goto MAIN_MENU

:ADD_TERMINAL
echo.
echo Backing up registry...
call :BACKUP_REGISTRY
echo Adding Windows Terminal context menu entries...
call :CREATE_TERMINAL_REGISTRY
echo Windows Terminal context menu added successfully!
echo.
echo Press any key to continue...
pause >nul
goto MAIN_MENU

:ADD_ALL
echo.
echo Backing up registry...
call :BACKUP_REGISTRY
echo Adding all context menu entries...
call :CREATE_CMD_REGISTRY
call :CREATE_POWERSHELL_REGISTRY
call :CREATE_TERMINAL_REGISTRY
echo All context menu entries added successfully!
echo.
echo Press any key to continue...
pause >nul
goto MAIN_MENU

:REMOVE_MENU
cls
echo ====================================================
echo        Remove Terminal Context Menu Options
echo ====================================================
echo.
echo This will remove all terminal context menu options.
echo.
echo 1. Remove CMD entries
echo 2. Remove PowerShell entries
echo 3. Remove Windows Terminal entries
echo 4. Remove All entries
echo 5. Back to Main Menu
echo.
echo Please make your selection and press Enter...
set /p "remove_choice=Enter your choice (1-5): "

if "%remove_choice%"=="1" goto REMOVE_CMD
if "%remove_choice%"=="2" goto REMOVE_POWERSHELL
if "%remove_choice%"=="3" goto REMOVE_TERMINAL
if "%remove_choice%"=="4" goto REMOVE_ALL
if "%remove_choice%"=="5" goto MAIN_MENU
echo.
echo Invalid choice. Please try again.
echo.
timeout /t 3 >nul
goto REMOVE_MENU

:REMOVE_CMD
echo.
echo Removing CMD context menu entries...
call :REMOVE_CMD_REGISTRY
echo CMD context menu entries removed successfully!
echo.
echo Press any key to continue...
pause >nul
goto MAIN_MENU

:REMOVE_POWERSHELL
echo.
echo Removing PowerShell context menu entries...
call :REMOVE_POWERSHELL_REGISTRY
echo PowerShell context menu entries removed successfully!
echo.
echo Press any key to continue...
pause >nul
goto MAIN_MENU

:REMOVE_TERMINAL
echo.
echo Removing Windows Terminal context menu entries...
call :REMOVE_TERMINAL_REGISTRY
echo Windows Terminal context menu entries removed successfully!
echo.
echo Press any key to continue...
pause >nul
goto MAIN_MENU

:REMOVE_ALL
echo.
echo Removing all context menu entries...
call :REMOVE_CMD_REGISTRY
call :REMOVE_POWERSHELL_REGISTRY
call :REMOVE_TERMINAL_REGISTRY
echo All context menu entries removed successfully!
echo.
echo Press any key to continue...
pause >nul
goto MAIN_MENU

:EXIT
echo.
echo Thank you for using Terminal Context Menu Manager!
echo.
echo Press any key to exit...
pause >nul
exit /b 0

:: ============= Registry Functions =============

:BACKUP_REGISTRY
:: Create timestamp for backup filename
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "backup_timestamp=%dt:~0,4%%dt:~4,2%%dt:~6,2%_%dt:~8,2%%dt:~10,2%%dt:~12,2%"

echo Creating full registry backup with timestamp: %backup_timestamp%

:: Full registry backup using regedit
regedit /e "%SCRIPT_DIR%\RegBackup\FullRegistry_%backup_timestamp%.reg" >nul 2>&1
if !errorlevel! equ 0 (
    echo Registry backup completed successfully.
) else (
    echo Warning: Registry backup failed, but continuing with operation.
)
goto :eof

:CREATE_CMD_REGISTRY
:: Get CMD path
for /f "tokens=*" %%i in ('where cmd.exe 2^>nul') do set "CMD_PATH=%%i"
if "!CMD_PATH!"=="" set "CMD_PATH=cmd.exe"

:: Add CMD for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenCmd" /ve /d "Open Command Prompt" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenCmd" /v "Icon" /d "%SCRIPT_DIR%\cmd.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenCmd\command" /ve /d "\"!CMD_PATH!\" /k cd /d \"%%V\"" /f >nul 2>&1

:: Add CMD for folder backgrounds
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmd" /ve /d "Open Command Prompt" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmd" /v "Icon" /d "%SCRIPT_DIR%\cmd.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmd\command" /ve /d "\"!CMD_PATH!\" /k cd /d \"%%V\"" /f >nul 2>&1

:: Add CMD for drives
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenCmd" /ve /d "Open Command Prompt" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenCmd" /v "Icon" /d "%SCRIPT_DIR%\cmd.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenCmd\command" /ve /d "\"!CMD_PATH!\" /k cd /d \"%%V\"" /f >nul 2>&1

:: Add CMD Admin for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenCmdAdmin" /ve /d "Open Command Prompt (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenCmdAdmin" /v "Icon" /d "%SCRIPT_DIR%\cmd.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenCmdAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenCmdAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenCmdAdmin.vbs\" \"%%V\"" /f >nul 2>&1

:: Add CMD Admin for folder backgrounds
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmdAdmin" /ve /d "Open Command Prompt (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmdAdmin" /v "Icon" /d "%SCRIPT_DIR%\cmd.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmdAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmdAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenCmdAdmin.vbs\" \"%%V\"" /f >nul 2>&1

:: Add CMD Admin for drives
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenCmdAdmin" /ve /d "Open Command Prompt (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenCmdAdmin" /v "Icon" /d "%SCRIPT_DIR%\cmd.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenCmdAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenCmdAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenCmdAdmin.vbs\" \"%%V\"" /f >nul 2>&1
goto :eof

:CREATE_POWERSHELL_REGISTRY
:: Get PowerShell path
for /f "tokens=*" %%i in ('where powershell.exe 2^>nul') do set "PS_PATH=%%i"
if "!PS_PATH!"=="" set "PS_PATH=powershell.exe"

:: Add PowerShell for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell" /ve /d "Open PowerShell" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell" /v "Icon" /d "%SCRIPT_DIR%\powershell.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell\command" /ve /d "\"!PS_PATH!\" -NoExit -Command Set-Location -Path '%%V'" /f >nul 2>&1

:: Add PowerShell for folder backgrounds
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell" /ve /d "Open PowerShell" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell" /v "Icon" /d "%SCRIPT_DIR%\powershell.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell\command" /ve /d "\"!PS_PATH!\" -NoExit -Command Set-Location -Path '%%V'" /f >nul 2>&1

:: Add PowerShell for drives
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell" /ve /d "Open PowerShell" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell" /v "Icon" /d "%SCRIPT_DIR%\powershell.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell\command" /ve /d "\"!PS_PATH!\" -NoExit -Command Set-Location -Path '%%V'" /f >nul 2>&1

:: Add PowerShell Admin for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShellAdmin" /ve /d "Open PowerShell (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShellAdmin" /v "Icon" /d "%SCRIPT_DIR%\powershell.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShellAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShellAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenPowerShellAdmin.vbs\" \"%%V\"" /f >nul 2>&1

:: Add PowerShell Admin for folder backgrounds
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShellAdmin" /ve /d "Open PowerShell (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShellAdmin" /v "Icon" /d "%SCRIPT_DIR%\powershell.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShellAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShellAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenPowerShellAdmin.vbs\" \"%%V\"" /f >nul 2>&1

:: Add PowerShell Admin for drives
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShellAdmin" /ve /d "Open PowerShell (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShellAdmin" /v "Icon" /d "%SCRIPT_DIR%\powershell.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShellAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShellAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenPowerShellAdmin.vbs\" \"%%V\"" /f >nul 2>&1
goto :eof

:CREATE_TERMINAL_REGISTRY
:: Remove old Windows Terminal entries first
reg delete "HKEY_CLASSES_ROOT\Directory\shell\wt" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\wt" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\wt" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\shell\wt_admin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\wt_admin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\wt_admin" /f >nul 2>&1

:: Get Windows Terminal path
for /f "tokens=*" %%i in ('where wt.exe 2^>nul') do set "WT_PATH=%%i"
if "!WT_PATH!"=="" (
    :: Try default Windows Apps location
    set "WT_PATH=C:\Users\%USERNAME%\AppData\Local\Microsoft\WindowsApps\wt.exe"
    if not exist "!WT_PATH!" (
        set "WT_PATH=wt.exe"
    )
)

:: Add "Open Terminal" for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminal" /ve /d "Open Terminal" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminal" /v "Icon" /d "%SCRIPT_DIR%\terminal.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminal\command" /ve /d "\"!WT_PATH!\" -d \"%%V\"" /f >nul 2>&1

:: Add "Open Terminal" for folder backgrounds
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminal" /ve /d "Open Terminal" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminal" /v "Icon" /d "%SCRIPT_DIR%\terminal.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminal\command" /ve /d "\"!WT_PATH!\" -d \"%%V\"" /f >nul 2>&1

:: Add "Open Terminal" for drives
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminal" /ve /d "Open Terminal" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminal" /v "Icon" /d "%SCRIPT_DIR%\terminal.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminal\command" /ve /d "\"!WT_PATH!\" -d \"%%V\"" /f >nul 2>&1

:: Add "Open Terminal (Admin)" for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminalAdmin" /ve /d "Open Terminal (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminalAdmin" /v "Icon" /d "%SCRIPT_DIR%\terminal.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminalAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminalAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenTerminalAdmin.vbs\" \"%%V\"" /f >nul 2>&1

:: Add "Open Terminal (Admin)" for folder backgrounds
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminalAdmin" /ve /d "Open Terminal (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminalAdmin" /v "Icon" /d "%SCRIPT_DIR%\terminal.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminalAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminalAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenTerminalAdmin.vbs\" \"%%V\"" /f >nul 2>&1

:: Add "Open Terminal (Admin)" for drives
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminalAdmin" /ve /d "Open Terminal (Admin)" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminalAdmin" /v "Icon" /d "%SCRIPT_DIR%\terminal.ico" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminalAdmin" /v "HasLUAShield" /d "" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminalAdmin\command" /ve /d "wscript.exe \"%SCRIPT_DIR%\OpenTerminalAdmin.vbs\" \"%%V\"" /f >nul 2>&1
goto :eof

:REMOVE_CMD_REGISTRY
reg delete "HKEY_CLASSES_ROOT\Directory\shell\OpenCmd" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmd" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\OpenCmd" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\shell\OpenCmdAdmin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmdAdmin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\OpenCmdAdmin" /f >nul 2>&1
goto :eof

:REMOVE_POWERSHELL_REGISTRY
reg delete "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShellAdmin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShellAdmin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShellAdmin" /f >nul 2>&1
goto :eof

:REMOVE_TERMINAL_REGISTRY
:: Remove old entries
reg delete "HKEY_CLASSES_ROOT\Directory\shell\wt" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\wt" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\wt" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\shell\wt_admin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\wt_admin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\wt_admin" /f >nul 2>&1
:: Remove current entries
reg delete "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminal" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminal" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminal" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\shell\OpenTerminalAdmin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\OpenTerminalAdmin" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Drive\shell\OpenTerminalAdmin" /f >nul 2>&1
goto :eof