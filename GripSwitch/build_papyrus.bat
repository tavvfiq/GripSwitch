@echo off
setlocal enabledelayedexpansion

:: Configuration
set "BASE_DIR=%~dp0"
cd /d "%BASE_DIR%"

set "COMPILER_PATH=D:\Modding\papyrus-compiler\Original Compiler"
set "COMPILER=%COMPILER_PATH%\PapyrusCompiler.exe"
set "FLAGS=%COMPILER_PATH%\TESV_Papyrus_Flags.flg"
set "IMPORTS=D:\Modding\PapyrusImport"

:: Folder Definitions
:: %~dp0 ends with a backslash. We use :~0,-1 to remove it.
set "PROJECT_DIR=%BASE_DIR:~0,-1%"
set "SCRIPTS_DIR=%BASE_DIR%Scripts\Source"
set "OUTPUT_DIR=%BASE_DIR%Scripts"

set "IMPORTS=D:\Modding\PapyrusImport;%SCRIPTS_DIR%"

:: 1. Sync Project Files to ./scripts
echo === Syncing Project Source Files ===
if not exist "%PROJECT_DIR%" (
    echo [X] Error: Project directory "%PROJECT_DIR%" not found.
    pause
    exit /b 1
)

:: 2. Check if compiler exists
if not exist "%COMPILER%" (
    echo [X] Papyrus Compiler not found at: "%COMPILER%"
    pause
    exit /b 1
)

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: 3. Compile each script
echo === Compiling Papyrus Scripts ===
echo.

for %%f in ("%SCRIPTS_DIR%\*.psc") do (
    set "filename=%%~nxf"
    echo Compiling !filename!...
    
    "%COMPILER%" "%%f" ^
        -import="%IMPORTS%" ^
        -output="%OUTPUT_DIR%" ^
        -flags="%FLAGS%" ^
        -quiet
    
    if !errorlevel! equ 0 (
        echo [OK] !filename! compiled successfully
    ) else (
        echo [X] Failed to compile !filename!
    )
    echo.
)

echo === Process Complete ===
pause