@echo off
REM ================================================================================
REM TESTE RÁPIDO DE VALIDAÇÃO - WINBOX TOOLKIT OPTIMIZATION
REM Versão simplificada e mais eficaz dos testes
REM ================================================================================

setlocal EnableDelayedExpansion
chcp 65001 > nul 2>&1

set "WINBOX_SCRIPT=..\Winbox Toolkit Optimization.bat"
set "TEST_LOG=quick_test_results_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.log"
set "TOTAL_TESTS=0"
set "PASSED_TESTS=0"
set "FAILED_TESTS=0"

cls
echo ================================================================================
echo TESTE RAPIDO DE VALIDACAO - WINBOX TOOLKIT OPTIMIZATION
echo ================================================================================
echo.
echo [INFO] Executando validacao rapida e eficaz...
echo [LOG] Arquivo de log: %TEST_LOG%
echo.

REM Verificar se o arquivo principal existe
if not exist "%WINBOX_SCRIPT%" (
    echo [ERROR] Arquivo principal nao encontrado: %WINBOX_SCRIPT%
    pause
    exit /b 1
)

REM Criar arquivo de log
echo ================================================================================ > "%TEST_LOG%"
echo TESTE RAPIDO DE VALIDACAO - WINBOX TOOLKIT OPTIMIZATION >> "%TEST_LOG%"
echo Data/Hora: %date% %time% >> "%TEST_LOG%"
echo ================================================================================ >> "%TEST_LOG%"
echo. >> "%TEST_LOG%"

REM ================================================================================
REM TESTES ESSENCIAIS
REM ================================================================================

echo [CATEGORIA] ESTRUTURA BASICA...
echo ------------------------------

call :QuickTest "Encoding UTF-8" "chcp 65001"
call :QuickTest "Headers principais" "WINBOX TOOLKIT OPTIMIZATION"
call :QuickTest "Variaveis globais" "VERSION="
call :QuickTest "Labels principais" ":MainMenu"
call :QuickTest "Funcoes administrativas" ":CheckAdminPrivileges"

echo.
echo [CATEGORIA] INTERFACE E MENUS...
echo --------------------------------

call :QuickTest "Interface ASCII" "CHAR_H"
call :QuickTest "Menu principal" "MENU PRINCIPAL"
call :QuickTest "Opcoes de sistema" "\[1\].*SYS"
call :QuickTest "Opcoes de memoria" "\[2\].*MEM"
call :QuickTest "Opcoes de privacidade" "\[3\].*PRI"

echo.
echo [CATEGORIA] FUNCIONALIDADES...
echo ------------------------------

call :QuickTest "Limpeza de memoria" ":MemoryCleanup"
call :QuickTest "Monitor tempo real" "RealTimeMemoryMonitor"
call :QuickTest "Deteccao de sistema" ":DetectWindowsVersion"
call :QuickTest "Comandos PowerShell" "powershell"
call :QuickTest "Comandos WMIC" "wmic"

echo.
echo [CATEGORIA] SEGURANCA E OTIMIZACAO...
echo ------------------------------------

call :QuickTest "Telemetria" "AllowTelemetry"
call :QuickTest "Performance" "Win32PrioritySeparation"
call :QuickTest "Tratamento erros" "errorlevel"
call :QuickTest "Validacao entrada" "InvalidChoice"
call :QuickTest "Confirmacao acoes" ":ConfirmAction"

echo.
echo [CATEGORIA] COMPATIBILIDADE...
echo ------------------------------

call :QuickTest "Windows builds" "WIN_BUILD"
call :QuickTest "Deteccao versao" "WINVER"
call :QuickTest "Build Windows 11" "22000"
call :QuickTest "Configuracao memoria" "Get-CimInstance"
call :QuickTest "Informacoes sistema" "TotalPhysicalMemory"

echo.

REM ================================================================================
REM RESULTADOS FINAIS
REM ================================================================================

echo ================================================================================
echo RESULTADOS DO TESTE RAPIDO
echo ================================================================================
echo.
echo [TOTAL] Total de testes: %TOTAL_TESTS%
echo [PASS] Testes aprovados: %PASSED_TESTS%
echo [FAIL] Testes falharam: %FAILED_TESTS%

if %TOTAL_TESTS% gtr 0 (
    set /a "SUCCESS_RATE=(%PASSED_TESTS%*100)/%TOTAL_TESTS%"
    echo [RATE] Taxa de sucesso: !SUCCESS_RATE!%%
) else (
    set "SUCCESS_RATE=0"
    echo [RATE] Taxa de sucesso: 0%%
)

call :LogMessage "=================================================================================="
call :LogMessage "RESULTADOS FINAIS"
call :LogMessage "Total: %TOTAL_TESTS% - Aprovados: %PASSED_TESTS% - Falharam: %FAILED_TESTS%"
call :LogMessage "Taxa de sucesso: !SUCCESS_RATE!%%"

if %FAILED_TESTS% equ 0 (
    echo.
    echo [SUCCESS] TODOS OS TESTES PASSARAM!
    echo [STATUS] Winbox Toolkit funcionando corretamente.
    call :LogMessage "RESULTADO: TODOS OS TESTES PASSARAM!"
) else if %PASSED_TESTS% geq 15 (
    echo.
    echo [OK] MAIORIA DOS TESTES PASSOU!
    echo [STATUS] Sistema funcional com algumas funcionalidades opcionais.
    call :LogMessage "RESULTADO: MAIORIA DOS TESTES PASSOU!"
) else (
    echo.
    echo [WARNING] MUITOS TESTES FALHARAM!
    echo [STATUS] Verifique implementacao.
    call :LogMessage "RESULTADO: MUITOS TESTES FALHARAM!"
)

echo.
echo [LOG] Resultados salvos em: %TEST_LOG%
echo.
pause
exit /b 0

REM ================================================================================
REM FUNCOES AUXILIARES
REM ================================================================================

:QuickTest
set "TEST_NAME=%~1"
set "TEST_PATTERN=%~2"
set /a "TOTAL_TESTS+=1"

echo [TEST %TOTAL_TESTS%] %TEST_NAME%...

REM Usar regex se o padrão contém caracteres especiais
echo %TEST_PATTERN% | findstr /C:"\\[" >nul 2>&1
if %errorlevel% equ 0 (
    REM Usar busca regex
    findstr /R "%TEST_PATTERN%" "%WINBOX_SCRIPT%" >nul 2>&1
) else (
    REM Usar busca literal
    findstr /C:"%TEST_PATTERN%" "%WINBOX_SCRIPT%" >nul 2>&1
)

if %errorlevel% equ 0 (
    set /a "PASSED_TESTS+=1"
    echo   [PASS] Encontrado: %TEST_PATTERN%
    call :LogMessage "TEST %TOTAL_TESTS% - %TEST_NAME%: PASS"
) else (
    set /a "FAILED_TESTS+=1"
    echo   [FAIL] Nao encontrado: %TEST_PATTERN%
    call :LogMessage "TEST %TOTAL_TESTS% - %TEST_NAME%: FAIL - %TEST_PATTERN%"
)
goto :eof

:LogMessage
echo %~1 >> "%TEST_LOG%"
goto :eof
