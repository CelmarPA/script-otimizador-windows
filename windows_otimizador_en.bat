@echo off

:: Checks administrative privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo This script requires administrative privileges. Please run as administrator.
    pause
    exit /b
)

title Otimizador do Sistema
color 0a

:menu
cls
echo ===================================================
echo                Otimizador do Sistema
echo ===================================================
echo [1] - Desativar SysMain
echo [2] - Desativar WinSAT
echo [3] - Ativar (Energia) Alto Desempenho
echo [4] - Limpar Arquivos Temporarios
echo [5] - Otimizacao Completa
echo [6] - Teste de Desempenho PC
echo [7] - Desabilitar / Habilitar Apps Seg Plano
echo [8] - Atualizar Todos os Softwares Desatualizados
echo [9] - Ativador do Windows / Office / Reparo 
echo [0] - Sair
echo ===================================================

set /p option="Escolha uma opcao: "

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
echo Deactivating SysMain...
sc stop "SysMain"
sc config "SysMain" start=disabled
echo SysMain has been deactivated!
pause 

goto menu

:deactivate_winsat
echo Deactivating WinSAT...
taskkill /f /im winsat.exe >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable
echo WinSAT has been deactivated!
pause 

goto menu

:max_energy
echo Setting Power Plan to High Performance...

:: Captured only the GUID, ignoring text in parentheses
for /f "tokens=2 delims=:(" %%a in ('powercfg /list ^| findstr /i "Alto desempenho High performance"') do set GUID=%%a

:: Remove extra spaces
set GUID=%GUID: =%

:: Checks if GUID is empty
if "%GUID%"=="" (
    echo Power Plan "High performance" not found.
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

:: Clean user's %temp%
echo Cleaning user temp files...
rd /s /q %temp% >nul 2>&1
mkdir %temp% >nul 2>&1

:: Clean system's temp
echo Cleaning system temp files...
for /d %%p in ("%systemroot%\temp\*.*") do rd /s /q "%%p" >nul 2>&1
del /f /q "%systemroot%\temp\*.*" >nul 2>&1

echo Temporary files have been cleaned!
pause

goto menu

:full_optimization
echo Performing Full Optimization...
call :deactivate_sysmain_silent
call :deactivate_winsat_silent
call :max_energy_silent
call :clean_temps_silent
echo Full optimization completed!
pause 

goto menu

:: Silent versions of functions for full optimization
:deactivate_sysmain_silent
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start=disabled >nul 2>&1
goto :eof

:deactivate_winsat_silent
taskkill /f /im winsat.exe >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>&1
goto :eof

:max_energy_silent
for /f "tokens=2 delims=:(" %%a in ('powercfg /list ^| findstr /i "Alto desempenho High performance"') do set GUID=%%a
set GUID=%GUID: =%
if not "%GUID%"=="" powercfg -setactive %GUID%
goto :eof

:clean_temps_silent
rd /s /q %temp% >nul 2>&1
mkdir %temp% >nul 2>&1
for /d %%p in ("%systemroot%\temp\*.*") do rd /s /q "%%p" >nul 2>&1
del /f /q "%systemroot%\temp\*.*" >nul 2>&1
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
echo             Aplicativos Segundo Plano
echo =============================================
echo [1] - Desativar Apps Segundo Plano
echo [2] - Ativar Apps Segundo Plano
echo [3] - Retornar ao Menu Anterior
echo =============================================
set /p option="Escolha uma opcao: "

if "%option%"=="1" goto deactivate_background_app
if "%option%"=="2" goto activate_background_app
if "%option%"=="3" goto menu

goto menu

:deactivate_background_app
echo Deactivating Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
pause

goto menu

:activate_background_app
echo Activating Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f
pause

goto menu

:update_all_softwares
:: ===================================================
:: Atualizar todos os programas via Winget
:: ===================================================
cls
echo Atualizando Todos os Softwares...
echo.

:: Testa se o Winget está instalado
where winget >nul 2>&1
if errorlevel 1 (
    echo Winget nao encontrado. Tentando instalar via Microsoft Store...
    powershell -Command "Get-AppxPackage -Name *AppInstaller* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register `$($_.InstallLocation)\AppxManifest.xml`}"
    timeout /t 5 >nul
)

:: Testa novamente após tentativa de instalação
where winget >nul 2>&1
if errorlevel 1 (
    echo ERRO: O Winget ainda nao foi encontrado.
    echo Atualize o Windows ou instale manualmente o aplicativo "App Installer" pela Microsoft Store.
    echo Link direto: https://apps.microsoft.com/detail/9nblggh4nns1
    pause
    goto menu
)

:: Atualiza o próprio Winget (App Installer)
echo Verificando atualizacoes do Winget...
powershell -NoLogo -NoProfile -Command "winget upgrade Microsoft.DesktopAppInstaller --accept-source-agreements --accept-package-agreements" >nul 2>&1

:: Atualiza todos os softwares
echo.
echo Atualizando todos os programas via Winget...
echo Isso pode levar alguns minutos...
echo.

:: Executa dentro da mesma janela (sem abrir nova e sem fechar)
powershell -NoLogo -NoProfile -Command "winget upgrade --all --accept-source-agreements --accept-package-agreements"

echo.
echo Todos os programas foram atualizados com sucesso!
echo.

:: Salva log no mesmo diretório do script
set "LOG=%~dp0update_log.txt"
echo Salvando log de atualizacoes em "%LOG%"...
winget list > "%LOG%"
echo Log salvo com sucesso!
pause

goto menu

:run_massgrave
echo Running online script...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://get.activated.win | iex"
pause

goto menu

:exit
echo Exiting...
pause
exit
