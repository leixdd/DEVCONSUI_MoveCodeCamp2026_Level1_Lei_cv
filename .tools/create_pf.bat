@echo off
REM Create a new portfolio contract - launcher for PowerShell
REM Usage: create_pf.bat <NETWORK> <NAME> <COURSE> <SCHOOL> <ABOUT> <LINKEDIN_URL> <GITHUB_URL> <SKILLS>
REM Example: create_pf.bat testnet "John Doe" "Move" "Sui Academy" "About me" "https://linkedin.com/in/john" "https://github.com/john" "Move,Rust"

set "SCRIPT_DIR=%~dp0"
set "PS1=%SCRIPT_DIR%create_pf.ps1"

if not exist "%PS1%" (
    echo Error: create_pf.ps1 not found at %PS1%
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" "%~1" "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8"
exit /b %ERRORLEVEL%
