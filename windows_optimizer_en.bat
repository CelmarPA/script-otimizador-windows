@echo off

:: Checks administrative privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
echo This script requires administrative privileges. Please run as administrator.
pause
exit /b
)

title System Optimizer
color 0a

:menu
cls
echo ===================================================
echo                System Optimizer
echo ===================================================
echo [1] - Disable SysMain
echo [2] - Disable WinSAT
echo [3] - Set Power Plan to High Performance
echo [4] - Clean Temporary Files
echo [5] - Full Optimization
echo [6] - PC Performance Test
echo [7] - Enable / Disable Background Apps
echo [8] - Update All Outdated Software
echo [9] - Windows / Office Activator / Repair
echo [0] - Exit
echo ===================================================

set /p option="Choose an option: "

if "%option%"=="1" goto deactivate_sysmain
if "%option%"=="2" goto deactivate_winsat
if "%option%"=="3" goto max_energy
if "%option%"=="4" goto clean_temps
if "%option%"=="5" goto full_optimization
if "%option%"=="6" goto test_performance
if "%option%"=="7" goto background_apps
if "%option%"=="8" goto update_all_softwares
if "%option%"=="9" goto run_massgrave
if "%option%"=="0" goto exit

goto menu

:deactivate_sysmain
echo Disabling SysMain...
sc stop "SysMain"
sc config "SysMain" start=disabled
echo SysMain has been disabled!
pause

goto menu

:deactivate_winsat
echo Disabling WinSAT...
taskkill /f /im winsat.exe >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable
echo WinSAT has been disabled!
pause

goto menu

:max_energy
echo Setting Power Plan to High Performance...

for /f "tokens=2 delims=:(" %%a in ('powercfg /list ^| findstr /i "High performance Alto desempenho"') do set GUID=%%a
set GUID=%GUID: =%

if "%GUID%"=="" (
echo Power Plan "High Performance" not found.
pause
goto menu
)

echo Power Plan found: %GUID%
powercfg -setactive %GUID%

echo Power Plan has been set to High Performance!
pause

goto menu

:clean_temps
echo Cleaning Temporary Files...
rd /s /q %temp% >nul 2>&1
mkdir %temp% >nul 2>&1
for /d %%p in ("%systemroot%\temp*.*") do rd /s /q "%%p" >nul 2>&1
del /f /q "%systemroot%\temp*.*" >nul 2>&1
echo Temporary files cleaned!
pause

goto menu

:full_optimization
echo Performing Full Optimization...
call :deactivate_sysmain_silent
call :deactivate_winsat_silent
call :max_energy_silent
call :clean_temps_silent
call :deactivate_background_app
echo Full optimization completed!
pause

goto menu

:deactivate_sysmain_silent
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start=disabled >nul 2>&1
goto :eof

:deactivate_winsat_silent
taskkill /f /im winsat.exe >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>&1
goto :eof

:max_energy_silent
for /f "tokens=2 delims=:(" %%a in ('powercfg /list ^| findstr /i "High performance Alto desempenho"') do set GUID=%%a
set GUID=%GUID: =%
if not "%GUID%"=="" powercfg -setactive %GUID%
goto :eof

:clean_temps_silent
rd /s /q %temp% >nul 2>&1
mkdir %temp% >nul 2>&1
for /d %%p in ("%systemroot%\temp*.*") do rd /s /q "%%p" >nul 2>&1
del /f /q "%systemroot%\temp*.*" >nul 2>&1
goto :eof

:test_performance
echo Running Performance Test
powershell get-ciminstance win32_winsat
pause

goto menu

:background_apps
:menu
cls
echo =============================================
echo             Background Apps Management
echo =============================================
echo [1] - Disable Background Apps
echo [2] - Enable Background Apps
echo [3] - Return to Previous Menu
echo =============================================
set /p option="Choose an option: "

if "%option%"=="1" goto deactivate_background_app
if "%option%"=="2" goto activate_background_app
if "%option%"=="3" goto menu

goto menu

:deactivate_background_app
echo Disabling Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
pause

goto menu

:activate_background_app
echo Enabling Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f
pause

goto menu

:update_all_softwares
cls
echo Updating All Software...

where winget >nul 2>&1
if errorlevel 1 (
echo Winget not found. Attempting installation via Microsoft Store...
powershell -Command "Get-AppxPackage -Name *AppInstaller* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register `$($_.InstallLocation)\AppxManifest.xml`}"
timeout /t 5 >nul
)

where winget >nul 2>&1
if errorlevel 1 (
echo ERROR: Winget still not found.
echo Please update Windows or install the "App Installer" manually from Microsoft Store.
echo Direct link: [https://apps.microsoft.com/detail/9nblggh4nns1](https://apps.microsoft.com/detail/9nblggh4nns1)
pause
goto menu
)

echo Updating Winget (App Installer)...
powershell -NoLogo -NoProfile -Command "winget upgrade Microsoft.DesktopAppInstaller --accept-source-agreements --accept-package-agreements" >nul 2>&1

echo Updating all software via Winget...
echo This may take a few minutes...

powershell -NoLogo -NoProfile -Command "winget upgrade --all --accept-source-agreements --accept-package-agreements"

echo All software has been updated successfully!

set "LOG=%~dp0update_log.txt"
echo Saving update log to "%LOG%"...
winget list > "%LOG%"
echo Log saved successfully!
pause

goto menu

:run_massgrave
echo Running online script...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm [https://get.activated.win](https://get.activated.win) | iex"
pause

goto menu

:exit
echo Exiting...
pause
exit
