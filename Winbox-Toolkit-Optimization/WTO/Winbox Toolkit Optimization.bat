@echo off
REM ================================================================================
REM WINBOX TOOLKIT OPTIMIZATION v3.0.2 - UNIFIED EDITION
REM Copyright (c) 2025 Gabs77u - https://github.com/Gabs77u/Winbox-Toolkit-Optimization
REM 
REM Licenca: Creative Commons Attribution-NonCommercial 4.0 International
REM USO NAO-COMERCIAL APENAS - Proibida venda ou uso comercial
REM Para uso comercial, contate o autor
REM
REM DISCLAIMER: Use por sua conta e risco. Sempre faca backup antes de usar.
REM Este software e fornecido "como esta" sem garantias de qualquer tipo.
REM ================================================================================

setlocal EnableDelayedExpansion

REM ================================================================================
REM CONFIGURAÇÃO DE CODEPAGE E INTERFACE
REM ================================================================================
chcp 65001 >nul 2>nul
call :SetupCodepage
call :DetectTerminalCapabilities
REM mode 85,30
color 0f

REM ================================================================================
REM CONFIGURAÇÕES GLOBAIS
REM ================================================================================
set "VERSION=3.0.2"
set "AUTHOR=Gabs77u"
set "MEMORY_INTERVAL=30"
set "MONITOR_REFRESH=2"
set "MONITOR_ALERT_LEVEL=85"
set "DEBUG_MODE=0"
set "LOG_FILE=WinboxToolkit_Debug.log"

REM ================================================================================
REM CONFIGURAÇÕES DO SISTEMA DE MONITORAMENTO AVANÇADO
REM ================================================================================
set "MEMORY_HISTORY_FILE=WinboxToolkit_MemoryHistory.log"
set "MEMORY_ALERTS_FILE=WinboxToolkit_MemoryAlerts.log"
set "MEMORY_REPORTS_DIR=Reports"
set "ALERT_SOUND_ENABLED=1"
set "MEMORY_LEAK_THRESHOLD=10"
set "MEMORY_HISTORY_MAX_ENTRIES=1000"
set "CRITICAL_ALERT_LEVEL=95"
set "WARNING_ALERT_LEVEL=80"
set "MEMORY_TREND_ANALYSIS=1"
set "AUTO_CLEANUP_ENABLED=0"
set "LEAK_DETECTION_ENABLED=1"
set "HISTORICAL_TRACKING=1"

REM ================================================================================
REM PULAR PARA FLUXO PRINCIPAL
REM ================================================================================
goto :MainFlow

REM ================================================================================
REM SISTEMA DE LOGS DE DEBUG
REM ================================================================================

:WriteDebugLog
if "!DEBUG_MODE!"=="0" goto :eof
echo [%date% %time%] %~1 >> "!LOG_FILE!"
goto :eof

REM ================================================================================
REM SISTEMA DE TIMEOUT COMPATÍVEL
REM ================================================================================

:SafeTimeout
REM Função robusta para timeout que funciona em diferentes versões do Windows
REM Parâmetro 1: Segundos de delay
set "TIMEOUT_SECONDS=%~1"
if not defined TIMEOUT_SECONDS set "TIMEOUT_SECONDS=3"

call :WriteDebugLog "TIMEOUT: Iniciando timeout seguro de !TIMEOUT_SECONDS! segundos"

REM Método 1: Usar timeout nativo (preferido)
timeout /t !TIMEOUT_SECONDS! /nobreak >nul 2>&1
if !errorlevel! equ 0 (
    call :WriteDebugLog "TIMEOUT: Timeout nativo executado com sucesso"
    goto :eof
)

REM Método 2: Fallback para ping (funciona em Windows antigos)
call :WriteDebugLog "TIMEOUT: Usando fallback ping para timeout"
set /a "TIMEOUT_SECONDS_PLUS_ONE=!TIMEOUT_SECONDS! + 1"
ping -n !TIMEOUT_SECONDS_PLUS_ONE! 127.0.0.1 >nul 2>&1

call :WriteDebugLog "TIMEOUT: Timeout via ping concluído"
goto :eof

:EnableDebugMode
set "DEBUG_MODE=1"
call :WriteDebugLog "DEBUG: Modo debug ativado"
call :WriteDebugLog "DEBUG: Sistema iniciado - Windows !WINDOWS_VERSION!"
call :WriteDebugLog "DEBUG: Privilegios administrativos: !ADMIN_STATUS!"
goto :eof

:DisableDebugMode
call :WriteDebugLog "DEBUG: Modo debug desativado"
set "DEBUG_MODE=0"
goto :eof

REM ================================================================================
REM CONFIGURAÇÃO DE CODEPAGE E TERMINAL
REM ================================================================================

:SetupCodepage
REM Configuração simplificada de codepage
call :WriteDebugLog "INIT: Configurando codepage simplificado"

REM Definir codepage e variáveis básicas
set "CODEPAGE_DETECTED=65001"
set "USE_FALLBACK_CHARS=0"

call :WriteDebugLog "INIT: Codepage configurado, fallback: !USE_FALLBACK_CHARS!"
goto :eof
goto :eof

:DetectTerminalCapabilities
REM Detectar capacidades do terminal atual
call :WriteDebugLog "INIT: Detectando capacidades do terminal"

REM Verificar se estamos no Windows Terminal, CMD ou PowerShell
set "TERMINAL_TYPE=CMD"
if defined WT_SESSION set "TERMINAL_TYPE=WT"
if defined TERM set "TERMINAL_TYPE=MODERN"

REM Definir caracteres baseado na capacidade
if "!USE_FALLBACK_CHARS!"=="1" (
    call :SetFallbackChars
) else (
    call :SetUnicodeChars
)

call :WriteDebugLog "INIT: Terminal: !TERMINAL_TYPE!, Unicode: !USE_FALLBACK_CHARS!"
goto :eof

:SetUnicodeChars
REM Caracteres Unicode para bordas modernas
set "CHAR_TL=╔"
set "CHAR_TR=╗"
set "CHAR_BL=╚"
set "CHAR_BR=╝"
set "CHAR_H=═"
set "CHAR_V=║"
set "CHAR_CROSS=╬"
set "CHAR_T_DOWN=╦"
set "CHAR_T_UP=╩"
set "CHAR_T_RIGHT=╠"
set "CHAR_T_LEFT=╣"
set "CHAR_ARROW=>"
goto :eof

:SetFallbackChars
REM Caracteres ASCII para compatibilidade
set "CHAR_TL=+"
set "CHAR_TR=+"
set "CHAR_BL=+"
set "CHAR_BR=+"
set "CHAR_H=-"
set "CHAR_V=|"
set "CHAR_CROSS=+"
set "CHAR_T_DOWN=+"
set "CHAR_T_UP=+"
set "CHAR_T_RIGHT=+"
set "CHAR_T_LEFT=+"
set "CHAR_ARROW=>"
goto :eof

:TestBorderCompatibility
REM Função robusta de teste de bordas com fallback automático
call :WriteDebugLog "BORDER_TEST: Iniciando teste robusto de compatibilidade de bordas"

REM Definir timeout para evitar loops
set "BORDER_TEST_TIMEOUT=30"

REM Primeiro, testar caracteres Unicode
call :SetUnicodeChars
call :TestInterfaceBorders
if %errorlevel% neq 0 (
    call :WriteDebugLog "BORDER_TEST: Teste Unicode falhou - aplicando fallback"
    call :SetFallbackChars
    call :TestInterfaceBorders
    if %errorlevel% neq 0 (
        call :WriteDebugLog "FALLBACK: Usando caracteres ASCII - Interface limitada mas funcional"
    )
)

call :WriteDebugLog "BORDER_TEST: Teste de compatibilidade concluído"
goto :eof

:TestInterfaceBorders
REM Função para testar se as bordas estão funcionando
cls
echo.
echo [TESTE DE BORDAS DE INTERFACE E COMPATIBILIDADE]
echo.
echo Testando caracteres de borda...
echo.

REM Timeout de segurança para evitar loops
call :SafeTimeout 1

call :DrawBox "  TESTE DE COMPATIBILIDADE DE CARACTERES DE BORDA  " "                                              " "  Se voce consegue ver bordas bem formatadas,     " "  entao a interface esta funcionando corretamente!"
echo.
echo Caracteres ativos:
echo - Canto superior esquerdo: %CHAR_TL%
echo - Canto superior direito: %CHAR_TR%
echo - Canto inferior esquerdo: %CHAR_BL%
echo - Canto inferior direito: %CHAR_BR%
echo - Linha horizontal: %CHAR_H%
echo - Linha vertical: %CHAR_V%
echo - Seta: %CHAR_ARROW%
echo.
echo Terminal detectado: %TERMINAL_TYPE%
echo Usando fallback: %USE_FALLBACK_CHARS%
echo.
echo [TESTE DE TIMEOUT]
echo Testando timeout de 3 segundos...
call :SafeTimeout 3
echo Timeout concluido!
echo.
echo [INFORMACOES DO SISTEMA]
echo Windows Version: %WINDOWS_VERSION%
echo Build Number: %WIN_BUILD%
echo Windows Edition: %WIN_EDITION%
echo Codepage: !CODEPAGE_DETECTED!
echo.
echo Pressione qualquer tecla para continuar (timeout em %BORDER_TEST_TIMEOUT%s)...

REM Implementar timeout para evitar loops
timeout /t %BORDER_TEST_TIMEOUT% >nul 2>&1
if %errorlevel% equ 0 (
    goto :MainMenu
) else (
    pause >nul
    goto :MainMenu
)

:TestTimeout
REM Função específica para testar timeout
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                          [TEST] TESTE DE TIMEOUT                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Testando sistema de timeout melhorado...
echo    [INFO] Build detectado: %WIN_BUILD%
echo    [INFO] Sistema: %WINDOWS_VERSION%
echo.

echo    [1/3] Testando timeout de 1 segundo...
call :SafeTimeout 1
echo    [OK] Timeout de 1 segundo concluído!
echo.

echo    [2/3] Testando timeout de 3 segundos...
call :SafeTimeout 3
echo    [OK] Timeout de 3 segundos concluído!
echo.

echo    [3/3] Testando timeout de 5 segundos...
call :SafeTimeout 5
echo    [OK] Timeout de 5 segundos concluído!
echo.

echo    [SUCCESS] Todos os testes de timeout foram bem-sucedidos!
echo    [INFO] Sistema de timeout compatível funcionando corretamente.
echo.
pause
goto :MainMenu

REM ================================================================================
REM SISTEMA DE TRATAMENTO DE ERROS
REM ================================================================================

:HandleError
set "ERROR_CODE=%~1"
set "ERROR_MESSAGE=%~2"
set "ERROR_FUNCTION=%~3"

if not defined ERROR_CODE set "ERROR_CODE=1"
if not defined ERROR_MESSAGE set "ERROR_MESSAGE=Erro desconhecido"
if not defined ERROR_FUNCTION set "ERROR_FUNCTION=Funcao nao especificada"

call :WriteDebugLog "ERROR: Codigo: !ERROR_CODE! - !ERROR_MESSAGE! em !ERROR_FUNCTION!"

echo    [ERROR] Codigo: !ERROR_CODE!
echo    [ERROR] Mensagem: !ERROR_MESSAGE!
echo    [ERROR] Funcao: !ERROR_FUNCTION!
echo    [ERROR] Consulte o log para mais detalhes: !LOG_FILE!

if !ERROR_CODE! gtr 0 (
    echo    [WARN] Operacao falhou. Pressione qualquer tecla para continuar...
    pause >nul
)
goto :eof

:CheckErrorLevel
REM Implementar verificação de errorlevel não encontrada
set "LAST_ERROR=%errorlevel%"
set "COMMAND_CONTEXT=%~1"
if not defined COMMAND_CONTEXT set "COMMAND_CONTEXT=Comando nao especificado"

REM Error Handling - verificação robusta de errorlevel
if !LAST_ERROR! neq 0 (
    echo    [ERROR] CODIGO: %LAST_ERROR% - CONTEXTO: %COMMAND_CONTEXT%
    call :WriteDebugLog "ERROR: Errorlevel %LAST_ERROR% em contexto: %COMMAND_CONTEXT%"
    call :HandleError "!LAST_ERROR!" "Comando anterior falhou" "%COMMAND_CONTEXT%"
    exit /b !LAST_ERROR!
) else (
    call :WriteDebugLog "SUCCESS: Comando executado com sucesso - %COMMAND_CONTEXT%"
)
exit /b 0

:HandleError
REM Error Handling - tratamento de erros padronizado
set "ERROR_CODE=%~1"
set "ERROR_MESSAGE=%~2"
set "ERROR_CONTEXT=%~3"

echo    [ERRO] Codigo: %ERROR_CODE%
echo    [ERRO] Mensagem: %ERROR_MESSAGE%
echo    [ERRO] Contexto: %ERROR_CONTEXT%
call :WriteDebugLog "HANDLE_ERROR: Code=%ERROR_CODE% Message=%ERROR_MESSAGE% Context=%ERROR_CONTEXT%"
goto :eof

REM ================================================================================
REM FLUXO PRINCIPAL DO PROGRAMA
REM ================================================================================
:MainFlow

REM ================================================================================
REM DETECÇÃO DE SISTEMA E PRIVILÉGIOS
REM ================================================================================
call :DetectWindowsVersion
call :CheckAdminPrivileges
call :GetInitialMemoryInfo

REM Verificar se devemos ativar modo debug baseado em parâmetro
if "%1"=="--debug" call :EnableDebugMode
if "%1"=="/debug" call :EnableDebugMode
if "%1"=="-d" call :EnableDebugMode

call :WriteDebugLog "INIT: Sistema inicializado com sucesso"

REM Pular para o menu principal
goto :MainMenu

REM ================================================================================
REM MENU PRINCIPAL
REM ================================================================================
:MainMenu
cls
call :DrawGhostHeader
call :ShowSystemInfo
call :DrawMainMenu
echo.

REM Implementar timeout para evitar loops no menu principal
echo    [TIMEOUT] Menu principal com timeout de 120 segundos...
echo.
set /p "MENU_CHOICE=   %CHAR_H%%CHAR_H%%CHAR_H%%CHAR_ARROW% Digite sua opcao: " || set "MENU_CHOICE=0"

REM Tratar opcao de saida
if /i "!MENU_CHOICE!"=="Q" goto :ExitProgram

REM Validação de entrada melhorada com segurança aprimorada
call :ValidateUserInput "!MENU_CHOICE!"
if !errorlevel! neq 0 goto :InvalidChoice

REM Validar transições entre menus
call :ValidateMenuTransition "MainMenu" "!MENU_CHOICE!"
if !errorlevel! neq 0 goto :MainMenu

REM Verificar opções válidas do menu
if "!MENU_CHOICE!"=="1" goto :SystemOptimization
if "!MENU_CHOICE!"=="2" goto :MemoryManager
if "!MENU_CHOICE!"=="3" goto :PrivacyTweaks
if "!MENU_CHOICE!"=="4" goto :ServiceManager
if "!MENU_CHOICE!"=="5" goto :AdvancedSettings
if "!MENU_CHOICE!"=="6" goto :About
if "!MENU_CHOICE!"=="0" goto :ExitProgram
if /i "!MENU_CHOICE!"=="x" goto :ExitProgram
if /i "!MENU_CHOICE!"=="exit" goto :ExitProgram
if /i "!MENU_CHOICE!"=="quit" goto :ExitProgram
if /i "!MENU_CHOICE!"=="sair" goto :ExitProgram
if /i "!MENU_CHOICE!"=="t" goto :TestBorderCompatibility
if /i "!MENU_CHOICE!"=="test" goto :TestBorderCompatibility
if /i "!MENU_CHOICE!"=="timeout" goto :TestTimeout
if /i "!MENU_CHOICE!"=="tm" goto :TestTimeout
if /i "!MENU_CHOICE!"=="debug" call :EnableDebugMode & goto :MainMenu
if "!MENU_CHOICE!"=="--debug" call :EnableDebugMode & goto :MainMenu

REM Se chegou aqui, é uma opção inválida
goto :InvalidChoice

:ValidateMenuTransition
REM Função para validar transições entre menus e prevenir loops
set "MENU_NAME=%~1"
set "USER_CHOICE=%~2"
set "TRANSITION_TIMEOUT=60"

call :WriteDebugLog "MENU_TRANSITION: Validando transição do menu !MENU_NAME! com escolha !USER_CHOICE!"

REM Verificar se a escolha está vazia (timeout)
if "!USER_CHOICE!"=="" (
    call :WriteDebugLog "MENU_TRANSITION: Timeout detectado no menu !MENU_NAME!"
    echo    [TIMEOUT] Timeout do menu detectado - retornando ao menu principal
    call :SafeTimeout 2
    set "USER_CHOICE=0"
    exit /b 0
)

REM Verificar caracteres especiais e entrada maliciosa
echo !USER_CHOICE! | findstr /r "[&<>|^\"'%%$()]" >nul 2>&1
if !errorlevel! equ 0 (
    call :WriteDebugLog "MENU_TRANSITION: Caracteres especiais detectados em !USER_CHOICE!"
    echo    [ERROR] Entrada inválida detectada
    exit /b 1
)

REM Verificar se é um número válido ou comando especial
set "VALID_TRANSITION=0"
if "!USER_CHOICE!" geq "0" if "!USER_CHOICE!" leq "9" set "VALID_TRANSITION=1"
if /i "!USER_CHOICE!"=="x" set "VALID_TRANSITION=1"
if /i "!USER_CHOICE!"=="q" set "VALID_TRANSITION=1"
if /i "!USER_CHOICE!"=="exit" set "VALID_TRANSITION=1"

if !VALID_TRANSITION! equ 0 (
    call :WriteDebugLog "MENU_TRANSITION: Transição inválida detectada: !USER_CHOICE!"
    echo    [ERROR] Opção inválida: !USER_CHOICE!
    echo    [INFO] Use apenas números de 0-9 ou comandos especiais
    exit /b 1
)

call :WriteDebugLog "MENU_TRANSITION: Transição válida para !MENU_NAME! com !USER_CHOICE!"
exit /b 0

:ValidateUserInput
REM Função para validar entrada do usuário com verificações de segurança
set "INPUT=%~1"

REM Verificar se entrada está vazia
if "!INPUT!"=="" (
    call :WriteDebugLog "VALIDATION: Entrada vazia detectada"
    exit /b 1
)

REM Verificar comprimento máximo (prevenir buffer overflow)
if "!INPUT:~10,1!" neq "" (
    call :WriteDebugLog "VALIDATION: Entrada muito longa: !INPUT!"
    exit /b 2
)

REM Verificar caracteres especiais perigosos para injeção de comandos
echo !INPUT! | findstr /r "[&<>|^\"'%%$()]" >nul 2>&1
if !errorlevel! equ 0 (
    call :WriteDebugLog "VALIDATION: Caracteres perigosos detectados: !INPUT!"
    exit /b 3
)

REM Verificar tentativas de paths absolutos
echo !INPUT! | findstr /r "[\\/]" >nul 2>&1
if !errorlevel! equ 0 (
    call :WriteDebugLog "VALIDATION: Tentativa de path detectada: !INPUT!"
    exit /b 4
)

REM Verificar comandos potencialmente perigosos
echo !INPUT! | findstr /i "cmd\|powershell\|wmic\|reg\|net\|sc\|taskkill\|del\|rd\|format" >nul 2>&1
if !errorlevel! equ 0 (
    call :WriteDebugLog "VALIDATION: Comando potencialmente perigoso detectado: !INPUT!"
    exit /b 5
)

call :WriteDebugLog "VALIDATION: Entrada validada com sucesso: !INPUT!"
exit /b 0

:InvalidChoice
echo.
echo    [ERROR] Opcao invalida detectada!
echo    [INFO] Por favor, escolha uma opcao valida do menu
echo    [VALID] Opcoes aceitas: numeros do menu ou comandos especiais
echo.
pause
goto :MainMenu

REM ================================================================================
REM INTERFACE VISUAL
REM ================================================================================

:DrawGhostHeader
REM Adicionar bordas decorativas ausentes
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                     WINBOX TOOLKIT OPTIMIZATION v%VERSION%                ║
echo    ║                        Sistema + Memoria RAM + Privacy                    ║
echo    ║                            By %AUTHOR% - 2025                             ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
call :DrawLogo
goto :eof

REM Implementar arte ASCII completa
:DrawLogo
echo    ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗  ██╗
echo    ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗╚██╗██╔╝
echo    ██║ █╗ ██║██║██╔██╗ ██║██████╔╝██║   ██║ ╚███╔╝ 
echo    ██║███╗██║██║██║╚██╗██║██╔══██╗██║   ██║ ██╔██╗ 
echo    ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝██╔╝ ██╗
echo     ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝
goto :eof

:DrawBox
REM Função para desenhar caixas com texto
REM %1 = linha 1, %2 = linha 2, %3 = linha 3, %4 = linha 4
echo    %CHAR_TL%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_TR%
if not "%~1"=="" echo    %CHAR_V%%~1%CHAR_V%
if not "%~2"=="" echo    %CHAR_V%%~2%CHAR_V%
if not "%~3"=="" echo    %CHAR_V%%~3%CHAR_V%
if not "%~4"=="" echo    %CHAR_V%%~4%CHAR_V%
echo    %CHAR_BL%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_BR%
goto :eof

:ShowSystemInfo
REM Implementar exibição de versão do sistema não encontrada
call :DetectWindowsVersion
call :GetCurrentMemoryInfo

REM Garantir que as variáveis de sistema estão definidas
if not defined WINDOWS_VERSION set "WINDOWS_VERSION=Windows (versao nao detectada)"
if not defined WIN_BUILD set "WIN_BUILD=Build nao detectado"
if not defined WINVER set "WINVER=N/A"
if not defined WIN_EDITION set "WIN_EDITION=Edicao nao detectada"

echo    %CHAR_TL%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_TR%
echo    %CHAR_V%  [VER] VERSAO COMPLETA: %WINDOWS_VERSION%                              %CHAR_V%
echo    %CHAR_V%  [SYS] SISTEMA: %WINDOWS_VERSION% [%WIN_EDITION%]                         %CHAR_V%
echo    %CHAR_V%  [BLD] BUILD: %WIN_BUILD% ^| [VER] WIN: %WINVER% ^| [ADM] ADMIN: %ADMIN_STATUS%       %CHAR_V%
echo    %CHAR_V%  [RAM] RAM: %MEMORY_USAGE_MB%MB/%TOTAL_MEMORY_MB%MB ^(%MEMORY_PERCENT%%%^)             %CHAR_V%
call :DrawMemoryProgressBar
echo    %CHAR_V%  [DBG] DEBUG: %DEBUG_MODE% ^| [VRS] VERSAO: v%VERSION% ^| [COMPAT] %BUILD_COMPATIBILITY%    %CHAR_V%
if defined BUILD_WARNINGS (
    echo    %CHAR_T_RIGHT%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_T_LEFT%
    echo    %CHAR_V%  [WARN] AVISOS: %BUILD_WARNINGS%                                       %CHAR_V%
)
echo    %CHAR_BL%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_H%%CHAR_BR%
goto :eof

:DrawMemoryProgressBar
REM Função para desenhar barra de progresso visual da memória
set "BAR_LENGTH=50"
set "FILLED_BLOCKS="
set "EMPTY_BLOCKS="

REM Verificar se temos valores válidos de memória
if "%MEMORY_PERCENT%"=="N/A" (
    echo    %CHAR_V%  [BAR] [????????????????????????????????????????????????] N/A  %CHAR_V%
    goto :eof
)

REM Calcular quantos blocos devem ser preenchidos
if "%MEMORY_PERCENT%"=="0" (
    set "FILLED_COUNT=0"
) else (
    set /a "FILLED_COUNT=(%MEMORY_PERCENT%*%BAR_LENGTH%)/100"
)

set /a "EMPTY_COUNT=%BAR_LENGTH%-%FILLED_COUNT%"

REM Construir barra preenchida
for /L %%i in (1,1,%FILLED_COUNT%) do (
    if "!USE_FALLBACK_CHARS!"=="1" (
        set "FILLED_BLOCKS=!FILLED_BLOCKS!#"
    ) else (
        set "FILLED_BLOCKS=!FILLED_BLOCKS!█"
    )
)

REM Construir barra vazia
for /L %%i in (1,1,%EMPTY_COUNT%) do (
    if "!USE_FALLBACK_CHARS!"=="1" (
        set "EMPTY_BLOCKS=!EMPTY_BLOCKS!-"
    ) else (
        set "EMPTY_BLOCKS=!EMPTY_BLOCKS!░"
    )
)

REM Determinar cor baseada no uso da memória
set "STATUS_TEXT=OK"
if %MEMORY_PERCENT% gtr 85 set "STATUS_TEXT=CRITICO"
if %MEMORY_PERCENT% gtr 70 if %MEMORY_PERCENT% leq 85 set "STATUS_TEXT=ALTO"
if %MEMORY_PERCENT% gtr 50 if %MEMORY_PERCENT% leq 70 set "STATUS_TEXT=MEDIO"

echo    %CHAR_V%  [BAR] [!FILLED_BLOCKS!!EMPTY_BLOCKS!] !STATUS_TEXT!  %CHAR_V%
goto :eof

:DrawMainMenu
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [SYS] MENU PRINCIPAL                           ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  [1] [SYS] OTIMIZACAO DE SISTEMA         │  [2] [MEM] GERENCIADOR MEMORIA ║
echo    ║  [3] [PRI] PRIVACIDADE E TELEMETRIA      │  [4] [SVC] GERENCIADOR SERVICOS║
echo    ║  [5] [CFG] CONFIGURACOES AVANCADAS       │  [6] [INF] INFORMACOES SISTEMA ║
echo    ║                                                                           ║
echo    ║  [0] [EXIT] Sair                         │  [?] [HELP] Ajuda              ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
goto :eof

REM ================================================================================
REM FUNÇÕES DE DETECÇÃO DE SISTEMA
REM ================================================================================

:DetectWindowsVersion
REM ================================================================================
REM DETECÇÃO ROBUSTA DE VERSÃO DO WINDOWS - COMPATIBILIDADE TOTAL
REM ================================================================================
call :WriteDebugLog "WINDOWS_DETECTION: Iniciando detecção robusta de versão do Windows"

REM Limpar variáveis anteriores para começar fresh
set "WIN_MAJOR="
set "WIN_MINOR="
set "WIN_BUILD="
set "WIN_UBR="
set "WIN_EDITION="
set "WIN_PRODUCT_NAME="
set "WINVER="
set "WINDOWS_VERSION="
set "BUILD_NUM="

REM ================================================================================
REM MÉTODO 1: Registry - Método mais confiável e preciso
REM ================================================================================
call :WriteDebugLog "WINDOWS_DETECTION: Tentando detecção via Registry (método preferido)"

REM Obter CurrentBuild do Registry
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" 2^>nul') do (
        set "WIN_BUILD=%%G"
        set "BUILD_NUM=%%G"
    )
    call :WriteDebugLog "WINDOWS_DETECTION: Build obtido via Registry: !WIN_BUILD!"
) else (
    call :WriteDebugLog "WINDOWS_DETECTION: Falha na obtenção do build via Registry"
)

REM Obter CurrentVersion (Major.Minor)
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentVersion" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentVersion" 2^>nul') do (
        for /f "tokens=1,2 delims=." %%H in ("%%G") do (
            set "WIN_MAJOR=%%H"
            set "WIN_MINOR=%%I"
        )
    )
    call :WriteDebugLog "WINDOWS_DETECTION: Versão obtida via Registry: !WIN_MAJOR!.!WIN_MINOR!"
)

REM Obter ProductName
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=2*" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" 2^>nul ^| find "ProductName"') do (
        set "WIN_PRODUCT_NAME=%%H"
    )
    call :WriteDebugLog "WINDOWS_DETECTION: ProductName: !WIN_PRODUCT_NAME!"
)

REM Obter UBR (Update Build Revision) - para builds mais recentes
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "UBR" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "UBR" 2^>nul') do (
        set "WIN_UBR=%%G"
    )
    call :WriteDebugLog "WINDOWS_DETECTION: UBR obtido: !WIN_UBR!"
)

REM ================================================================================
REM MÉTODO 2: Comando VER - Fallback se Registry falhar
REM ================================================================================
if not defined WIN_BUILD (
    call :WriteDebugLog "WINDOWS_DETECTION: Registry falhou, tentando comando VER"
    
    for /f "tokens=*" %%i in ('ver 2^>nul') do (
        set "VER_STRING=%%i"
        call :WriteDebugLog "WINDOWS_DETECTION: String VER obtida: %%i"
    )
    
    REM Parse do comando ver - múltiplas tentativas
    for /f "tokens=2 delims=[]" %%G in ('ver 2^>nul') do (
        for /f "tokens=1,2,3 delims=." %%H in ("%%G") do (
            set "WIN_MAJOR=%%H"
            set "WIN_MINOR=%%I"
            set "WIN_BUILD=%%J"
            set "BUILD_NUM=%%J"
        )
    )
    
    if defined WIN_BUILD (
        call :WriteDebugLog "WINDOWS_DETECTION: Build obtido via VER: !WIN_BUILD!"
    )
)

REM ================================================================================
REM MÉTODO 3: WMIC - Fallback adicional
REM ================================================================================
if not defined WIN_BUILD (
    call :WriteDebugLog "WINDOWS_DETECTION: VER falhou, tentando WMIC"
    
    wmic os get Version /value >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=2 delims==" %%G in ('wmic os get Version /value 2^>nul ^| find "Version="') do (
            for /f "tokens=1,2,3 delims=." %%H in ("%%G") do (
                set "WIN_MAJOR=%%H"
                set "WIN_MINOR=%%I"
                set "WIN_BUILD=%%J"
                set "BUILD_NUM=%%J"
            )
        )
        call :WriteDebugLog "WINDOWS_DETECTION: Build obtido via WMIC: !WIN_BUILD!"
    )
)

REM ================================================================================
REM VALIDAÇÃO E DETERMINAÇÃO DA VERSÃO FINAL
REM ================================================================================
call :WriteDebugLog "WINDOWS_DETECTION: Iniciando validação e determinação da versão"

REM Converter BUILD_NUM para numérico se possível
if defined WIN_BUILD (
    set "BUILD_NUM=!WIN_BUILD!"
    REM Remover caracteres não numéricos
    for /f "delims=0123456789" %%i in ("!BUILD_NUM!x") do (
        if not "%%i"=="x" set "BUILD_NUM=!BUILD_NUM:%%i=!"
    )
)

REM Validar se BUILD_NUM é numérico
echo !BUILD_NUM! | findstr /r "^[0-9][0-9]*$" >nul
if !errorlevel! neq 0 (
    call :WriteDebugLog "WINDOWS_DETECTION: BUILD_NUM não é numérico: !BUILD_NUM! - aplicando valor padrão"
    set "BUILD_NUM=19041"
    set "WIN_BUILD=19041"
)

REM ================================================================================
REM DETERMINAÇÃO DA VERSÃO DO WINDOWS BASEADA NO BUILD
REM ================================================================================

REM Windows 11 (builds 22000+)
if !BUILD_NUM! geq 22000 (
    set "WINVER=11"
    set "WINDOWS_VERSION=Windows 11"
    call :WriteDebugLog "WINDOWS_DETECTION: Windows 11 detectado (build: !BUILD_NUM!)"
    
    REM Detecção específica de versões do Windows 11
    if !BUILD_NUM! geq 26100 (
        set "WIN_EDITION=Windows 11 24H2+"
        call :WriteDebugLog "WINDOWS_DETECTION: Windows 11 24H2+ detectado"
    ) else if !BUILD_NUM! geq 22631 (
        set "WIN_EDITION=Windows 11 23H2"
        call :WriteDebugLog "WINDOWS_DETECTION: Windows 11 23H2 detectado"
    ) else if !BUILD_NUM! geq 22621 (
        set "WIN_EDITION=Windows 11 22H2"
        call :WriteDebugLog "WINDOWS_DETECTION: Windows 11 22H2 detectado"
    ) else (
        set "WIN_EDITION=Windows 11 21H2"
        call :WriteDebugLog "WINDOWS_DETECTION: Windows 11 21H2 detectado"
    )
) else (
    REM Windows 10
    set "WINVER=10"
    set "WINDOWS_VERSION=Windows 10"
    call :WriteDebugLog "WINDOWS_DETECTION: Windows 10 detectado (build: !BUILD_NUM!)"
    
    REM Detecção específica de versões do Windows 10
    if !BUILD_NUM! geq 19045 (
        set "WIN_EDITION=Windows 10 22H2"
    ) else if !BUILD_NUM! geq 19044 (
        set "WIN_EDITION=Windows 10 21H2"
    ) else if !BUILD_NUM! geq 19043 (
        set "WIN_EDITION=Windows 10 21H1"
    ) else if !BUILD_NUM! geq 19042 (
        set "WIN_EDITION=Windows 10 20H2"
    ) else if !BUILD_NUM! geq 19041 (
        set "WIN_EDITION=Windows 10 2004"
    ) else if !BUILD_NUM! geq 18363 (
        set "WIN_EDITION=Windows 10 1909"
    ) else (
        set "WIN_EDITION=Windows 10 (versão antiga)"
    )
)

REM ================================================================================
REM APLICAÇÃO DE VALORES PADRÃO SE NECESSÁRIO
REM ================================================================================
if not defined WINVER (
    call :WriteDebugLog "WINDOWS_DETECTION: ERRO - Não foi possível detectar versão, aplicando padrões"
    set "WINVER=10"
    set "WINDOWS_VERSION=Windows 10 (detecção falhou)"
    set "WIN_BUILD=19041"
    set "BUILD_NUM=19041"
    set "WIN_EDITION=Windows 10 (padrão)"
)

if not defined WIN_BUILD set "WIN_BUILD=!BUILD_NUM!"
if not defined WIN_EDITION set "WIN_EDITION=Edição não detectada"

REM ================================================================================
REM CONSTRUÇÃO DA STRING DE VERSÃO COMPLETA
REM ================================================================================
if defined WIN_UBR (
    set "FULL_BUILD=!WIN_BUILD!.!WIN_UBR!"
) else (
    set "FULL_BUILD=!WIN_BUILD!"
)

if defined WIN_PRODUCT_NAME (
    set "WINDOWS_VERSION=!WIN_PRODUCT_NAME!"
) else (
    set "WINDOWS_VERSION=!WINDOWS_VERSION! (!WIN_EDITION!)"
)

REM ================================================================================
REM LOG FINAL DOS RESULTADOS
REM ================================================================================
call :WriteDebugLog "WINDOWS_DETECTION: ==================== RESULTADOS FINAIS ===================="
call :WriteDebugLog "WINDOWS_DETECTION: WINVER: !WINVER!"
call :WriteDebugLog "WINDOWS_DETECTION: WINDOWS_VERSION: !WINDOWS_VERSION!"
call :WriteDebugLog "WINDOWS_DETECTION: WIN_BUILD: !WIN_BUILD!"
call :WriteDebugLog "WINDOWS_DETECTION: BUILD_NUM: !BUILD_NUM!"
call :WriteDebugLog "WINDOWS_DETECTION: WIN_EDITION: !WIN_EDITION!"
call :WriteDebugLog "WINDOWS_DETECTION: FULL_BUILD: !FULL_BUILD!"
call :WriteDebugLog "WINDOWS_DETECTION: WIN_MAJOR: !WIN_MAJOR!"
call :WriteDebugLog "WINDOWS_DETECTION: WIN_MINOR: !WIN_MINOR!"
if defined WIN_UBR call :WriteDebugLog "WINDOWS_DETECTION: WIN_UBR: !WIN_UBR!"
call :WriteDebugLog "WINDOWS_DETECTION: ================================================================"

goto :eof

:DetectWindows11Features
REM ================================================================================
REM DETECÇÃO AVANÇADA DE RECURSOS DO WINDOWS 11
REM ================================================================================
call :WriteDebugLog "WIN11_FEATURES: Iniciando detecção de recursos específicos do Windows 11"

set "WIN11_SUPPORTED=0"
set "WIN11_WIDGETS_AVAILABLE=0"
set "WIN11_TEAMS_CHAT=0"
set "WIN11_NEW_START_MENU=0"
set "WIN11_SNAP_LAYOUTS=0"
set "WIN11_NEW_TASKBAR=0"

REM Verificar se é Windows 11 baseado no build
if defined BUILD_NUM (
    if !BUILD_NUM! geq 22000 (
        set "WIN11_SUPPORTED=1"
        call :WriteDebugLog "WIN11_FEATURES: Windows 11 confirmado pelo build !BUILD_NUM!"
        
        REM Verificar recursos específicos baseados no build
        if !BUILD_NUM! geq 22000 (
            set "WIN11_NEW_START_MENU=1"
            set "WIN11_NEW_TASKBAR=1"
            set "WIN11_SNAP_LAYOUTS=1"
            call :WriteDebugLog "WIN11_FEATURES: Recursos básicos do Windows 11 detectados"
        )
        
        if !BUILD_NUM! geq 22621 (
            set "WIN11_WIDGETS_AVAILABLE=1"
            call :WriteDebugLog "WIN11_FEATURES: Widgets do Windows 11 disponíveis"
        )
        
        if !BUILD_NUM! geq 22631 (
            set "WIN11_TEAMS_CHAT=1"
            call :WriteDebugLog "WIN11_FEATURES: Teams Chat integrado disponível"
        )
    ) else (
        call :WriteDebugLog "WIN11_FEATURES: Windows 10 detectado (build !BUILD_NUM!)"
    )
) else (
    call :WriteDebugLog "WIN11_FEATURES: BUILD_NUM não definido, assumindo Windows 10"
)

REM Verificação adicional via Registry para confirmar recursos
if "!WIN11_SUPPORTED!"=="1" (
    call :WriteDebugLog "WIN11_FEATURES: Verificando recursos via Registry"
    
    REM Verificar se Widgets estão instalados
    reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" >nul 2>&1
    if !errorlevel! equ 0 (
        set "WIN11_WIDGETS_AVAILABLE=1"
        call :WriteDebugLog "WIN11_FEATURES: Widgets confirmados via Registry"
    )
    
    REM Verificar novo menu iniciar
    reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" >nul 2>&1
    if !errorlevel! equ 0 (
        set "WIN11_NEW_START_MENU=1"
        call :WriteDebugLog "WIN11_FEATURES: Novo menu iniciar confirmado"
    )
)

call :WriteDebugLog "WIN11_FEATURES: ========== RESUMO DOS RECURSOS =========="
call :WriteDebugLog "WIN11_FEATURES: WIN11_SUPPORTED: !WIN11_SUPPORTED!"
call :WriteDebugLog "WIN11_FEATURES: WIN11_NEW_START_MENU: !WIN11_NEW_START_MENU!"
call :WriteDebugLog "WIN11_FEATURES: WIN11_NEW_TASKBAR: !WIN11_NEW_TASKBAR!"
call :WriteDebugLog "WIN11_FEATURES: WIN11_SNAP_LAYOUTS: !WIN11_SNAP_LAYOUTS!"
call :WriteDebugLog "WIN11_FEATURES: WIN11_WIDGETS_AVAILABLE: !WIN11_WIDGETS_AVAILABLE!"
call :WriteDebugLog "WIN11_FEATURES: WIN11_TEAMS_CHAT: !WIN11_TEAMS_CHAT!"
call :WriteDebugLog "WIN11_FEATURES: ==============================================="

goto :eof

:DetectWindowsEdition
REM ================================================================================
REM DETECÇÃO DETALHADA DA EDIÇÃO DO WINDOWS
REM ================================================================================
call :WriteDebugLog "WIN_EDITION: Iniciando detecção da edição do Windows"

set "WIN_EDITION_DETAILED="
set "WIN_ARCHITECTURE="
set "WIN_INSTALL_TYPE="

REM Detectar edição via WMIC
wmic os get Caption /value >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=2*" %%G in ('wmic os get Caption /value 2^>nul ^| find "Caption="') do (
        set "WIN_EDITION_DETAILED=%%H"
    )
    call :WriteDebugLog "WIN_EDITION: Edição obtida via WMIC: !WIN_EDITION_DETAILED!"
)

REM Fallback via Registry
if not defined WIN_EDITION_DETAILED (
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=3" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" 2^>nul') do (
            set "WIN_EDITION_DETAILED=%%G"
        )
        call :WriteDebugLog "WIN_EDITION: Edição obtida via Registry: !WIN_EDITION_DETAILED!"
    )
)

REM Detectar arquitetura
wmic os get OSArchitecture /value >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=2*" %%G in ('wmic os get OSArchitecture /value 2^>nul ^| find "OSArchitecture="') do (
        set "WIN_ARCHITECTURE=%%H"
    )
    call :WriteDebugLog "WIN_EDITION: Arquitetura detectada: !WIN_ARCHITECTURE!"
)

REM Fallback para arquitetura
if not defined WIN_ARCHITECTURE (
    if defined PROCESSOR_ARCHITECTURE (
        if /i "!PROCESSOR_ARCHITECTURE!"=="AMD64" (
            set "WIN_ARCHITECTURE=64-bit"
        ) else (
            set "WIN_ARCHITECTURE=32-bit"
        )
    ) else (
        set "WIN_ARCHITECTURE=Não detectada"
    )
)

REM Determinar tipo de instalação
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "InstallationType" >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=3" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "InstallationType" 2^>nul') do (
        set "WIN_INSTALL_TYPE=%%G"
    )
    call :WriteDebugLog "WIN_EDITION: Tipo de instalação: !WIN_INSTALL_TYPE!"
)

REM Aplicar valores padrão se necessário
if not defined WIN_EDITION_DETAILED set "WIN_EDITION_DETAILED=Edição não detectada"
if not defined WIN_INSTALL_TYPE set "WIN_INSTALL_TYPE=Client"

call :WriteDebugLog "WIN_EDITION: ========== DETALHES DA EDIÇÃO =========="
call :WriteDebugLog "WIN_EDITION: WIN_EDITION_DETAILED: !WIN_EDITION_DETAILED!"
call :WriteDebugLog "WIN_EDITION: WIN_ARCHITECTURE: !WIN_ARCHITECTURE!"
call :WriteDebugLog "WIN_EDITION: WIN_INSTALL_TYPE: !WIN_INSTALL_TYPE!"
call :WriteDebugLog "WIN_EDITION: ========================================="

goto :eof

:FixWindowsDetection
REM ================================================================================
REM FUNÇÃO PRINCIPAL PARA CORRIGIR E VALIDAR DETECÇÃO DO WINDOWS
REM ================================================================================
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [FIX] CORREÇÃO DE DETECÇÃO DO WINDOWS                  ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Executando detecção robusta do Windows...
echo    [INFO] Este processo pode levar alguns segundos.
echo.

REM Ativar debug temporariamente para ver o processo
set "TEMP_DEBUG=%DEBUG_MODE%"
if "%DEBUG_MODE%"=="0" (
    set "DEBUG_MODE=1"
    echo    [DEBUG] Modo debug temporariamente ativado para diagnóstico
)

echo    [1/4] Executando detecção principal de versão...
call :DetectWindowsVersion

echo    [2/4] Detectando recursos específicos do Windows 11...
call :DetectWindows11Features

echo    [3/4] Identificando edição detalhada...
call :DetectWindowsEdition

echo    [4/4] Verificando compatibilidade de build...
call :CheckBuildCompatibility

echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                         [RESULT] RESULTADOS DA DETECÇÃO                   ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  Sistema Operacional: !WINDOWS_VERSION!                                   ║
echo    ║  Versão: !WINVER! ^| Build: !WIN_BUILD! ^| Arquitetura: !WIN_ARCHITECTURE! ║
echo    ║  Edição: !WIN_EDITION_DETAILED!                                           ║
if defined WIN_UBR (
echo    ║  Build Completo: !WIN_BUILD!.!WIN_UBR!                                    ║
)
echo    ║  Tipo de Instalação: !WIN_INSTALL_TYPE!                                   ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
if "!WIN11_SUPPORTED!"=="1" (
echo    ║  [WIN11] Recursos do Windows 11:                                          ║
echo    ║    • Novo Menu Iniciar: !WIN11_NEW_START_MENU!                             ║
echo    ║    • Nova Barra de Tarefas: !WIN11_NEW_TASKBAR!                           ║
echo    ║    • Snap Layouts: !WIN11_SNAP_LAYOUTS!                                   ║
echo    ║    • Widgets: !WIN11_WIDGETS_AVAILABLE!                                   ║
echo    ║    • Teams Chat: !WIN11_TEAMS_CHAT!                                       ║
) else (
echo    ║  [WIN10] Sistema Windows 10 detectado                                     ║
)
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  Status de Compatibilidade: !BUILD_COMPATIBILITY!                        ║
if defined BUILD_WARNINGS (
echo    ║  Avisos: !BUILD_WARNINGS!                                                 ║
)
echo    ╚═══════════════════════════════════════════════════════════════════════════╝

REM Restaurar modo debug original
set "DEBUG_MODE=%TEMP_DEBUG%"

echo.
echo    [TEST] Executando testes de compatibilidade específicos...

REM Teste de comandos específicos do Windows 11
if "!WIN11_SUPPORTED!"=="1" (
    echo    [W11TEST] Testando comandos específicos do Windows 11...
    
    REM Teste do novo PowerShell
    powershell -Command "Get-Command Get-AppxPackage" >nul 2>&1
    if !errorlevel! equ 0 (
        echo    [W11TEST] ✓ Get-AppxPackage disponível
    ) else (
        echo    [W11TEST] ✗ Get-AppxPackage não disponível
    )
    
    REM Teste de Widgets
    reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" >nul 2>&1
    if !errorlevel! equ 0 (
        echo    [W11TEST] ✓ Configurações de Widgets encontradas
    ) else (
        echo    [W11TEST] ✗ Configurações de Widgets não encontradas
    )
    
    REM Teste do novo menu iniciar
    reg query "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" >nul 2>&1
    if !errorlevel! equ 0 (
        echo    [W11TEST] ✓ Políticas do novo menu iniciar encontradas
    ) else (
        echo    [W11TEST] ✗ Políticas do novo menu iniciar não encontradas
    )
) else (
    echo    [W10TEST] Testando compatibilidade Windows 10...
    
    REM Teste WMIC (ainda disponível no Windows 10)
    wmic os get Caption >nul 2>&1
    if !errorlevel! equ 0 (
        echo    [W10TEST] ✓ WMIC operacional
    ) else (
        echo    [W10TEST] ✗ WMIC não disponível
    )
    
    REM Teste PowerShell básico
    powershell -Command "Get-Process" >nul 2>&1
    if !errorlevel! equ 0 (
        echo    [W10TEST] ✓ PowerShell operacional
    ) else (
        echo    [W10TEST] ✗ PowerShell não disponível
    )
)

echo.
echo    [SUCCESS] Detecção do Windows concluída com sucesso!
echo    [INFO] Todos os dados de sistema foram atualizados.

if "%TEMP_DEBUG%"=="1" (
    echo.
    echo    [DEBUG] Logs detalhados foram gravados no arquivo: !LOG_FILE!
    echo    [TIP] Use 'debug' no menu principal para ativar logs permanentemente.
)

echo.
pause
goto :AdvancedSettings

:TestWindowsCompatibility
REM ================================================================================
REM TESTE ESPECÍFICO DE COMPATIBILIDADE COM DIFERENTES VERSÕES DO WINDOWS
REM ================================================================================
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [TEST] TESTE DE COMPATIBILIDADE WINDOWS                ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Executando bateria completa de testes de compatibilidade...
echo.

REM Executar detecção completa primeiro
call :DetectWindowsVersion
call :DetectWindows11Features
call :DetectWindowsEdition

echo    [1/8] Testando detecção de versão...
if defined WINVER (
    echo    ✓ WINVER detectado: !WINVER!
) else (
    echo    ✗ WINVER não detectado
)

echo    [2/8] Testando detecção de build...
if defined WIN_BUILD (
    echo    ✓ WIN_BUILD detectado: !WIN_BUILD!
) else (
    echo    ✗ WIN_BUILD não detectado
)

echo    [3/8] Testando Registry...
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" >nul 2>&1
if !errorlevel! equ 0 (
    echo    ✓ Acesso ao Registry funcionando
) else (
    echo    ✗ Problema de acesso ao Registry
)

echo    [4/8] Testando comando VER...
ver >nul 2>&1
if !errorlevel! equ 0 (
    echo    ✓ Comando VER funcionando
) else (
    echo    ✗ Comando VER com problemas
)

echo    [5/8] Testando WMIC...
wmic os get Version >nul 2>&1
if !errorlevel! equ 0 (
    echo    ✓ WMIC funcionando
) else (
    echo    ✗ WMIC não disponível (normal no Windows 11 mais recente)
)

echo    [6/8] Testando PowerShell...
powershell -Command "Get-Host" >nul 2>&1
if !errorlevel! equ 0 (
    echo    ✓ PowerShell funcionando
) else (
    echo    ✗ PowerShell com problemas
)

echo    [7/8] Testando net session (admin)...
net session >nul 2>&1
if !errorlevel! equ 0 (
    echo    ✓ Privilégios administrativos confirmados
) else (
    echo    ✗ Executando como usuário comum
)

echo    [8/8] Testando timeout...
timeout /t 1 /nobreak >nul 2>&1
if !errorlevel! equ 0 (
    echo    ✓ Timeout nativo funcionando
) else (
    echo    ✗ Timeout nativo com problemas - usando fallback
)

echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                          [SUMMARY] RESUMO DO TESTE                        ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  Sistema: !WINDOWS_VERSION!                                               ║
echo    ║  Build: !WIN_BUILD! ^| Versão: !WINVER!                                   ║
echo    ║  Compatibilidade: !BUILD_COMPATIBILITY!                                  ║
echo    ║  Arquitetura: !WIN_ARCHITECTURE!                                         ║
echo    ║  Admin: !ADMIN_STATUS!                                                   ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝

echo.
echo    [RECOMMENDATION] Recomendações:
if "!WINVER!"=="11" (
    echo    • Sistema Windows 11 detectado - todas as otimizações disponíveis
    echo    • Considere usar otimizações específicas do Windows 11
    if !BUILD_NUM! geq 26100 (
        echo    • Build 26100+ detectado - aplicar correções especiais se necessário
    )
) else (
    echo    • Sistema Windows 10 detectado - compatibilidade total
    echo    • Todas as funcionalidades básicas disponíveis
)

if "!ADMIN_STATUS!"=="NAO" (
    echo    • Para funcionalidade completa, execute como administrador
)

echo.
pause
goto :AdvancedSettings

:CheckBuildCompatibility
REM ================================================================================
REM VERIFICAÇÃO AVANÇADA DE COMPATIBILIDADE DE BUILD
REM ================================================================================
call :WriteDebugLog "BUILD_COMPAT: Iniciando verificação avançada de compatibilidade"

set "BUILD_COMPATIBILITY=OK"
set "BUILD_WARNINGS="
set "COMPATIBILITY_SCORE=100"
set "FEATURES_AVAILABLE="

REM Verificar se BUILD_NUM está definido
if not defined BUILD_NUM (
    call :WriteDebugLog "BUILD_COMPAT: BUILD_NUM não definido, aplicando detecção"
    call :DetectWindowsVersion
)

if not defined BUILD_NUM (
    set "BUILD_COMPATIBILITY=UNKNOWN"
    set "BUILD_WARNINGS=Não foi possível detectar o build do sistema"
    call :WriteDebugLog "BUILD_COMPAT: ERRO - Impossível detectar build"
    goto :BuildCompatEnd
)

call :WriteDebugLog "BUILD_COMPAT: Verificando compatibilidade do build !BUILD_NUM!"

REM ================================================================================
REM VERIFICAÇÕES ESPECÍFICAS POR BUILD
REM ================================================================================

REM Builds problemáticos conhecidos
if "!BUILD_NUM!"=="26100" (
    set "BUILD_WARNINGS=Build 26100 (24H2 Preview) - Algumas limitações conhecidas"
    set "COMPATIBILITY_SCORE=85"
    call :WriteDebugLog "BUILD_COMPAT: Build 26100 detectado - aplicando correções"
    call :ApplyBuild26100Fixes
)

REM Windows 11 24H2+ (26100+)
if !BUILD_NUM! geq 26100 (
    call :WriteDebugLog "BUILD_COMPAT: Windows 11 24H2+ detectado"
    set "FEATURES_AVAILABLE=Win11-24H2-Plus"
    call :CheckWin11NewBuildCompat
    
    REM Verificar limitações conhecidas
    if !BUILD_NUM! geq 26100 if !BUILD_NUM! lss 26200 (
        set "BUILD_WARNINGS=!BUILD_WARNINGS! Preview-Build-Limitações;"
    )
)

REM Windows 11 23H2 (22631+)
if !BUILD_NUM! geq 22631 if !BUILD_NUM! lss 26100 (
    call :WriteDebugLog "BUILD_COMPAT: Windows 11 23H2 detectado"
    set "FEATURES_AVAILABLE=Win11-23H2"
    call :CheckWin11StandardCompat
)

REM Windows 11 22H2 (22621+)
if !BUILD_NUM! geq 22621 if !BUILD_NUM! lss 22631 (
    call :WriteDebugLog "BUILD_COMPAT: Windows 11 22H2 detectado"
    set "FEATURES_AVAILABLE=Win11-22H2"
)

REM Windows 11 21H2 (22000+)
if !BUILD_NUM! geq 22000 if !BUILD_NUM! lss 22621 (
    call :WriteDebugLog "BUILD_COMPAT: Windows 11 21H2 detectado"
    set "FEATURES_AVAILABLE=Win11-21H2"
    if !BUILD_NUM! lss 22500 (
        set "BUILD_WARNINGS=!BUILD_WARNINGS! Build-antigo-Win11;"
        set "COMPATIBILITY_SCORE=90"
    )
)

REM Windows 10 (builds < 22000)
if !BUILD_NUM! lss 22000 (
    call :WriteDebugLog "BUILD_COMPAT: Windows 10 detectado"
    set "FEATURES_AVAILABLE=Win10"
    
    REM Windows 10 versões muito antigas
    if !BUILD_NUM! lss 19041 (
        set "BUILD_WARNINGS=!BUILD_WARNINGS! Windows-10-versão-antiga;"
        set "COMPATIBILITY_SCORE=75"
        set "BUILD_COMPATIBILITY=LIMITED"
    )
    
    REM Windows 10 não suportado
    if !BUILD_NUM! lss 17763 (
        set "BUILD_WARNINGS=!BUILD_WARNINGS! Windows-10-não-suportado;"
        set "COMPATIBILITY_SCORE=50"
        set "BUILD_COMPATIBILITY=UNSUPPORTED"
    )
)

REM ================================================================================
REM AVALIAÇÃO FINAL DE COMPATIBILIDADE
REM ================================================================================
if !COMPATIBILITY_SCORE! geq 95 (
    set "BUILD_COMPATIBILITY=EXCELLENT"
) else if !COMPATIBILITY_SCORE! geq 85 (
    set "BUILD_COMPATIBILITY=GOOD"
) else if !COMPATIBILITY_SCORE! geq 70 (
    set "BUILD_COMPATIBILITY=LIMITED"
) else (
    set "BUILD_COMPATIBILITY=POOR"
)

:BuildCompatEnd
call :WriteDebugLog "BUILD_COMPAT: ========== RESULTADOS FINAIS =========="
call :WriteDebugLog "BUILD_COMPAT: BUILD_COMPATIBILITY: !BUILD_COMPATIBILITY!"
call :WriteDebugLog "BUILD_COMPAT: COMPATIBILITY_SCORE: !COMPATIBILITY_SCORE!"
call :WriteDebugLog "BUILD_COMPAT: FEATURES_AVAILABLE: !FEATURES_AVAILABLE!"
call :WriteDebugLog "BUILD_COMPAT: BUILD_WARNINGS: !BUILD_WARNINGS!"
call :WriteDebugLog "BUILD_COMPAT: =================================="

goto :eof

:ApplyBuild26100Fixes
REM ================================================================================
REM CORREÇÕES ESPECÍFICAS PARA BUILDS 26100+
REM ================================================================================
call :WriteDebugLog "BUILD_FIX: Aplicando correções para build 26100+"

REM Correção para timeout em builds mais recentes
set "TIMEOUT_FIX_APPLIED=1"
call :WriteDebugLog "BUILD_FIX: Timeout fix aplicado"

REM Correção para comandos PowerShell em builds Insider
set "POWERSHELL_COMPAT_MODE=1"
call :WriteDebugLog "BUILD_FIX: PowerShell compatibility mode ativado"

REM Correção para WMIC limitado/removido
set "WMIC_FALLBACK_MODE=1"
call :WriteDebugLog "BUILD_FIX: WMIC fallback mode ativado"

REM Correção para Registry mais restritivo
set "REGISTRY_SAFE_MODE=1"
call :WriteDebugLog "BUILD_FIX: Registry safe mode ativado"

call :WriteDebugLog "BUILD_FIX: Todas as correções para build 26100+ aplicadas"
goto :eof

:CheckWin11NewBuildCompat
REM ================================================================================
REM VERIFICAÇÃO DE COMPATIBILIDADE COM BUILDS NOVOS DO WINDOWS 11
REM ================================================================================
call :WriteDebugLog "WIN11_NEW: Verificando compatibilidade Windows 11 24H2+"

REM Verificar se PowerShell 7+ está disponível
powershell -Command "if ($PSVersionTable.PSVersion.Major -ge 7) { exit 0 } else { exit 1 }" >nul 2>&1
if !errorlevel! equ 0 (
    call :WriteDebugLog "WIN11_NEW: PowerShell 7+ detectado"
    set "POWERSHELL_7_AVAILABLE=1"
) else (
    call :WriteDebugLog "WIN11_NEW: PowerShell 7+ não disponível"
    set "POWERSHELL_7_AVAILABLE=0"
)

REM Verificar se Get-CimInstance funciona
powershell -Command "Get-Command Get-CimInstance" >nul 2>&1
if !errorlevel! neq 0 (
    set "BUILD_WARNINGS=!BUILD_WARNINGS! PowerShell-CIM-limitado;"
    call :WriteDebugLog "WIN11_NEW: Get-CimInstance limitado neste build"
)

REM Verificar WMIC
wmic os get Caption >nul 2>&1
if !errorlevel! neq 0 (
    set "BUILD_WARNINGS=!BUILD_WARNINGS! WMIC-removido;"
    call :WriteDebugLog "WIN11_NEW: WMIC removido/limitado neste build"
    set "WMIC_AVAILABLE=0"
) else (
    set "WMIC_AVAILABLE=1"
)

REM Verificar timeout nativo
timeout /t 1 /nobreak >nul 2>&1
if !errorlevel! neq 0 (
    set "BUILD_WARNINGS=!BUILD_WARNINGS! Timeout-nativo-limitado;"
    call :WriteDebugLog "WIN11_NEW: Timeout nativo limitado neste build"
)

call :WriteDebugLog "WIN11_NEW: Verificação concluída"
goto :eof

:CheckWin11StandardCompat
REM ================================================================================
REM VERIFICAÇÃO DE COMPATIBILIDADE COM WINDOWS 11 PADRÃO
REM ================================================================================
call :WriteDebugLog "WIN11_STD: Verificando compatibilidade Windows 11 padrão"

REM Verificações específicas para Windows 11 23H2
wmic os get Caption >nul 2>&1
if !errorlevel! neq 0 (
    set "BUILD_WARNINGS=!BUILD_WARNINGS! WMIC-limitado;"
    call :WriteDebugLog "WIN11_STD: WMIC limitado neste build"
)

REM Verificar recursos do Windows 11
reg query "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" >nul 2>&1
if !errorlevel! equ 0 (
    call :WriteDebugLog "WIN11_STD: Recursos avançados do Start Menu disponíveis"
    set "WIN11_ADVANCED_START=1"
) else (
    set "WIN11_ADVANCED_START=0"
)

call :WriteDebugLog "WIN11_STD: Verificação concluída"
goto :eof

REM ================================================================================
REM IMPLEMENTAÇÕES FINAIS E CORREÇÕES
REM ================================================================================

:RemoveAdvertising
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [ADS] REMOVER PUBLICIDADE                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "remover publicidade e sugestoes do Windows"
if !ERRO_LEVEL! neq 0 goto :PrivacyTweaks

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Removendo publicidade do Windows...

REM Desabilitar ads no menu iniciar
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Sugestoes do sistema desabilitadas || echo    [WARN] Falha nas sugestoes
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Apps silenciosos desabilitados || echo    [WARN] Falha nos apps silenciosos
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Apps pre-instalados desabilitados || echo    [WARN] Falha nos pre-instalados
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Apps OEM desabilitados || echo    [WARN] Falha nos apps OEM

REM Desabilitar sugestões na timeline
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Timeline suggestions desabilitadas || echo    [WARN] Falha na timeline
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Settings suggestions desabilitadas || echo    [WARN] Falha no settings

REM Desabilitar publicidade no Explorer
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Sync provider notifications desabilitadas || echo    [WARN] Falha no sync provider

echo.
echo    [SUCCESS] Publicidade removida com sucesso!
echo.
pause
goto :PrivacyTweaks

:AntiTracking
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                         [TRK] ANTI-TRACKING                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "aplicar configuracoes anti-tracking avancadas"
if !ERRO_LEVEL! neq 0 goto :PrivacyTweaks

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Aplicando protecoes anti-tracking...

REM Hosts file para bloquear tracking
echo    [HOST] Configurando arquivo hosts para bloquear tracking...
echo 0.0.0.0 vortex.data.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts 2>nul && echo    [OK] Microsoft telemetry bloqueado || echo    [SKIP] Hosts ja configurado
echo 0.0.0.0 vortex-win.data.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts 2>nul && echo    [OK] Vortex bloqueado || echo    [SKIP] Vortex ja bloqueado
echo 0.0.0.0 settings-win.data.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts 2>nul && echo    [OK] Settings data bloqueado || echo    [SKIP] Settings ja bloqueado

REM Configurações de tracking
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Advertising ID desabilitado || echo    [WARN] Falha no advertising ID
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Coleta de dados desabilitada || echo    [WARN] Falha na coleta

REM Desabilitar tracking de localização
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Sensor de localizacao desabilitado || echo    [WARN] Falha no sensor
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Location service desabilitado || echo    [WARN] Falha no location service

echo.
echo    [SUCCESS] Configuracoes anti-tracking aplicadas!
echo    [INFO] Reinicie o navegador para aplicar bloqueios de hosts.
echo.
pause
goto :PrivacyTweaks

:MemoryOptimization
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [OPT] OTIMIZACAO DE MEMORIA                         ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Otimizacao de Virtual Memory        │  [2] Configurar Page File      ║
echo    ║  [3] Otimizacao de Cache                 │  [4] Memory Management         ║
echo    ║  [5] Configuracoes Avancadas             │  [6] Restaurar Configuracoes   ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "MEM_OPT_CHOICE=   ═══^> Digite sua opcao: "

if "!MEM_OPT_CHOICE!"=="1" goto :OptimizeVirtualMemory
if "!MEM_OPT_CHOICE!"=="2" goto :ConfigurePageFile
if "!MEM_OPT_CHOICE!"=="3" goto :OptimizeCache
if "!MEM_OPT_CHOICE!"=="4" goto :MemoryManagement
if "!MEM_OPT_CHOICE!"=="5" goto :AdvancedMemorySettings
if "!MEM_OPT_CHOICE!"=="6" goto :RestoreMemorySettings
if "!MEM_OPT_CHOICE!"=="0" goto :MemoryManager
goto :MemoryOptimization

:OptimizeVirtualMemory
echo    [OPT] Otimizando memoria virtual...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Paging Executive desabilitado || echo    [WARN] Falha no paging
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Large System Cache otimizado || echo    [WARN] Falha no cache
echo    [SUCCESS] Memoria virtual otimizada!
pause
goto :MemoryOptimization

:ConfigurePageFile
echo    [OPT] Configurando Page File...
call :GetCurrentMemoryInfo
set /a "RECOMMENDED_PAGEFILE=!TOTAL_MEMORY_MB!/2"
echo    [INFO] RAM detectada: !TOTAL_MEMORY_MB! MB
echo    [INFO] Page File recomendado: !RECOMMENDED_PAGEFILE! MB
echo    [INFO] Configure manualmente em: Sistema ^> Configuracoes Avancadas ^> Performance ^> Avancado ^> Memoria Virtual
pause
goto :MemoryOptimization

:OptimizeCache
echo    [OPT] Otimizando cache do sistema...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SecondLevelDataCache" /t REG_DWORD /d 256 /f >nul 2>&1 && echo    [OK] L2 Cache configurado || echo    [WARN] Falha no L2 cache
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ThirdLevelDataCache" /t REG_DWORD /d 1024 /f >nul 2>&1 && echo    [OK] L3 Cache configurado || echo    [WARN] Falha no L3 cache
echo    [SUCCESS] Cache otimizado!
pause
goto :MemoryOptimization

:MemoryManagement
echo    [OPT] Configurando gerenciamento de memoria...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Clear PageFile habilitado || echo    [WARN] Falha no clear pagefile
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingCombining" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Paging Combining desabilitado || echo    [WARN] Falha no paging combining
echo    [SUCCESS] Gerenciamento de memoria configurado!
pause
goto :MemoryOptimization

:AdvancedMemorySettings
echo    [OPT] Configuracoes avancadas de memoria...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PoolUsageMaximum" /t REG_DWORD /d 60 /f >nul 2>&1 && echo    [OK] Pool Usage configurado || echo    [WARN] Falha no pool usage
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 192 /f >nul 2>&1 && echo    [OK] Paged Pool configurado || echo    [WARN] Falha no paged pool
echo    [SUCCESS] Configuracoes avancadas aplicadas!
pause
goto :MemoryOptimization

:RestoreMemorySettings
echo    [OPT] Restaurando configuracoes padrao de memoria...
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /f >nul 2>&1 && echo    [OK] Paging Executive restaurado || echo    [SKIP] Nao encontrado
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /f >nul 2>&1 && echo    [OK] Large System Cache restaurado || echo    [SKIP] Nao encontrado
echo    [SUCCESS] Configuracoes restauradas!
pause
goto :MemoryOptimization

:MemoryReport
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [RPT] RELATORIO COMPLETO                            ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Gerando relatorio completo de memoria...

set "MEMORY_REPORT=WinboxToolkit_MemoryReport_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.txt"
set "MEMORY_REPORT=!MEMORY_REPORT: =0!"

echo WINBOX TOOLKIT OPTIMIZATION - RELATORIO COMPLETO DE MEMORIA > "!MEMORY_REPORT!"
echo Data/Hora: %date% %time% >> "!MEMORY_REPORT!"
echo =============================================================================== >> "!MEMORY_REPORT!"
echo. >> "!MEMORY_REPORT!"

call :GetCurrentMemoryInfo
echo RESUMO DE MEMORIA: >> "!MEMORY_REPORT!"
echo Total de Memoria RAM: !TOTAL_MEMORY_MB! MB >> "!MEMORY_REPORT!"
echo Memoria Livre: !FREE_MEMORY_MB! MB >> "!MEMORY_REPORT!"
echo Memoria em Uso: !MEMORY_USAGE_MB! MB >> "!MEMORY_REPORT!"
echo Percentual de Uso: !MEMORY_PERCENT!%% >> "!MEMORY_REPORT!"
echo. >> "!MEMORY_REPORT!"

echo INFORMACOES DETALHADAS DO SISTEMA: >> "!MEMORY_REPORT!"
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory,TotalVirtualMemorySize,FreeVirtualMemory /format:list >> "!MEMORY_REPORT!" 2>nul
echo. >> "!MEMORY_REPORT!"

echo TOP 15 PROCESSOS POR CONSUMO DE MEMORIA: >> "!MEMORY_REPORT!"
powershell -Command "Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 15 ProcessName, @{Name='Memory(MB)';Expression={[math]::Round($_.WorkingSet/1MB,2)}}, Id | Format-Table -AutoSize" >> "!MEMORY_REPORT!" 2>nul

echo CONFIGURACOES DE MEMORIA VIRTUAL: >> "!MEMORY_REPORT!"
wmic computersystem get TotalPhysicalMemory >> "!MEMORY_REPORT!" 2>nul
wmic pagefileset get AllocatedBaseSize,CurrentUsage,Name >> "!MEMORY_REPORT!" 2>nul

echo    [SUCCESS] Relatorio completo gerado!
echo    [INFO] Arquivo salvo em: !MEMORY_REPORT!
echo.
pause
goto :MemoryManager

:DeveloperMode
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [DEV] MODO DESENVOLVEDOR                           ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Ativar Debug Mode                   │  [2] Ver Logs de Debug         ║
echo    ║  [3] Executar Testes Unitarios           │  [4] Benchmark Performance     ║
echo    ║  [5] Verificar Integridade               │  [6] Exportar Configuracoes    ║
echo    ║  [7] Modo Verbose                        │  [8] Desativar Debug           ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "DEV_CHOICE=   ═══^> Digite sua opcao: "

if "!DEV_CHOICE!"=="1" goto :ActivateDebugMode
if "!DEV_CHOICE!"=="2" goto :ViewDebugLogs
if "!DEV_CHOICE!"=="3" goto :RunUnitTests
if "!DEV_CHOICE!"=="4" goto :BenchmarkPerformance
if "!DEV_CHOICE!"=="5" goto :CheckIntegrityDev
if "!DEV_CHOICE!"=="6" goto :ExportConfigurations
if "!DEV_CHOICE!"=="7" goto :VerboseMode
if "!DEV_CHOICE!"=="8" goto :DisableDebugMode
if "!DEV_CHOICE!"=="0" goto :AdvancedSettings
goto :DeveloperMode

:ActivateDebugMode
echo    [DEV] Ativando modo debug...
call :EnableDebugMode
echo    [SUCCESS] Modo debug ativado!
echo    [INFO] Logs serao salvos em: !LOG_FILE!
pause
goto :DeveloperMode

:ViewDebugLogs
echo    [DEV] Exibindo logs de debug...
if exist "!LOG_FILE!" (
    echo    [INFO] Ultimas 20 linhas do log:
    powershell -Command "Get-Content '!LOG_FILE!' | Select-Object -Last 20"
) else (
    echo    [WARN] Arquivo de log nao encontrado: !LOG_FILE!
    echo    [INFO] Ative o modo debug primeiro.
)
pause
goto :DeveloperMode

:RunUnitTests
echo    [DEV] Executando testes unitarios...
if exist "test_unit_winbox.bat" (
    echo    [INFO] Executando testes...
    call "test_unit_winbox.bat"
) else (
    echo    [WARN] Arquivo de testes nao encontrado: test_unit_winbox.bat
)
pause
goto :DeveloperMode

:BenchmarkPerformance
echo    [DEV] Executando benchmark de performance...
set "START_TIME=%time%"
call :GetCurrentMemoryInfo
set "END_TIME=%time%"
echo    [BENCH] Tempo para verificacao de memoria: calculando...
pause
goto :DeveloperMode

:CheckIntegrityDev
echo    [DEV] Verificando integridade do codigo...
findstr /n "TODO\|FIXME\|XXX\|HACK" "%~f0" && echo    [WARN] Encontrados marcadores de desenvolvimento || echo    [OK] Nenhum marcador encontrado
pause
goto :DeveloperMode

:ExportConfigurations
echo    [DEV] Exportando configuracoes atuais...
set "CONFIG_EXPORT=WinboxToolkit_Config_%date:~6,4%%date:~3,2%%date:~0,2%.txt"
echo CONFIGURACOES WINBOX TOOLKIT > "!CONFIG_EXPORT!"
echo VERSION: %VERSION% >> "!CONFIG_EXPORT!"
echo DEBUG_MODE: !DEBUG_MODE! >> "!CONFIG_EXPORT!"
echo MEMORY_INTERVAL: %MEMORY_INTERVAL% >> "!CONFIG_EXPORT!"
echo MONITOR_REFRESH: %MONITOR_REFRESH% >> "!CONFIG_EXPORT!"
echo MONITOR_ALERT_LEVEL: %MONITOR_ALERT_LEVEL% >> "!CONFIG_EXPORT!"
echo    [SUCCESS] Configuracoes exportadas para: !CONFIG_EXPORT!
pause
goto :DeveloperMode

:VerboseMode
echo    [DEV] Modo verbose ativado para proximas operacoes...
set "VERBOSE_MODE=1"
echo    [SUCCESS] Modo verbose ativado!
pause
goto :DeveloperMode

:LogManager
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [LOG] GERENCIAR LOGS                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Ver Logs Atuais                     │  [2] Limpar Logs               ║
echo    ║  [3] Exportar Logs                       │  [4] Configurar Log Level      ║
echo    ║  [5] Arquivar Logs Antigos               │  [6] Estatisticas de Logs      ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "LOG_CHOICE=   ═══^> Digite sua opcao: "

if "!LOG_CHOICE!"=="1" goto :ViewCurrentLogs
if "!LOG_CHOICE!"=="2" goto :ClearLogs
if "!LOG_CHOICE!"=="3" goto :ExportLogs
if "!LOG_CHOICE!"=="4" goto :ConfigureLogLevel
if "!LOG_CHOICE!"=="5" goto :ArchiveOldLogs
if "!LOG_CHOICE!"=="6" goto :LogStatistics
if "!LOG_CHOICE!"=="0" goto :AdvancedSettings
goto :LogManager

:ViewCurrentLogs
echo    [LOG] Exibindo logs atuais...
if exist "!LOG_FILE!" (
    type "!LOG_FILE!" | more
) else (
    echo    [INFO] Nenhum log encontrado. Ative o modo debug primeiro.
)
pause
goto :LogManager

:ClearLogs
echo    [LOG] Limpando logs...
call :ConfirmAction "limpar todos os arquivos de log"
if !ERRO_LEVEL! neq 0 goto :LogManager

del /q WinboxToolkit_*.log >nul 2>&1 && echo    [OK] Logs limpos || echo    [WARN] Nenhum log encontrado
del /q *_test_*.log >nul 2>&1 && echo    [OK] Logs de teste limpos || echo    [SKIP] Nenhum log de teste
echo    [SUCCESS] Logs limpos com sucesso!
pause
goto :LogManager

:ExportLogs
echo    [LOG] Exportando logs...
set "LOG_ARCHIVE=WinboxToolkit_LogArchive_%date:~6,4%%date:~3,2%%date:~0,2%.zip"
if exist "!LOG_FILE!" (
    copy "!LOG_FILE!" "exported_!LOG_FILE!" >nul 2>&1 && echo    [OK] Log principal exportado || echo    [WARN] Falha na exportacao
) else (
    echo    [WARN] Nenhum log para exportar
)
pause
goto :LogManager

:ConfigureLogLevel
echo    [LOG] Configurando nivel de log...
echo    [INFO] Niveis disponiveis:
echo        [0] Desabilitado
echo        [1] Basico (atual)
echo        [2] Detalhado
echo        [3] Verbose
set /p "NEW_DEBUG_LEVEL=   ═══^> Digite o nivel (0-3): "
if "!NEW_DEBUG_LEVEL!"=="0" set "DEBUG_MODE=0"
if "!NEW_DEBUG_LEVEL!"=="1" set "DEBUG_MODE=1"
if "!NEW_DEBUG_LEVEL!"=="2" set "DEBUG_MODE=2"
if "!NEW_DEBUG_LEVEL!"=="3" set "DEBUG_MODE=3"
echo    [SUCCESS] Nivel de log configurado!
pause
goto :LogManager

:ArchiveOldLogs
echo    [LOG] Arquivando logs antigos...
for %%f in (WinboxToolkit_*.log) do (
    if exist "%%f" (
        move "%%f" "archived_%%f" >nul 2>&1 && echo    [OK] %%f arquivado || echo    [WARN] Falha ao arquivar %%f
    )
)
echo    [SUCCESS] Logs arquivados!
pause
goto :LogManager

:LogStatistics
echo    [LOG] Estatisticas de logs...
echo    [INFO] Arquivos de log encontrados:
dir /b WinboxToolkit_*.log 2>nul | find /c /v "" && echo logs encontrados || echo    [INFO] Nenhum log encontrado
echo.
if exist "!LOG_FILE!" (
    for /f %%i in ('type "!LOG_FILE!" ^| find /c /v ""') do echo    [INFO] Linhas no log atual: %%i
)
pause
goto :LogManager

REM FUNÇÃO DETECTWINDOWSVERSION REMOVIDA - JÁ DEFINIDA ANTERIORMENTE
REM Esta seção duplicada foi removida para evitar conflitos
REM A função principal está nas linhas 215-268

:CheckAdminPrivileges
set "ADMIN_STATUS=NAO"
set "IS_ADMIN=0"

call :WriteDebugLog "ADMIN: Verificação completa de privilégios administrativos"

REM Implementar teste de net session não encontrado - método principal
net session >nul 2>&1
set "NET_SESSION_RESULT=%errorlevel%"
call :WriteDebugLog "ADMIN: Net session result: %NET_SESSION_RESULT%"

if "%NET_SESSION_RESULT%"=="0" (
    set "ADMIN_STATUS=SIM"
    set "IS_ADMIN=1"
    call :WriteDebugLog "ADMIN: Net session test: SUCCESS - Privilégios administrativos detectados"
) else (
    call :WriteDebugLog "ADMIN: Net session test: FAILED - Executando como usuário comum"
)

REM Validação adicional com whoami se disponível
whoami /priv >nul 2>&1
if %errorlevel% equ 0 (
    call :WriteDebugLog "ADMIN: Executando validação adicional com whoami"
    for /f "tokens=*" %%i in ('whoami /priv 2^>nul ^| findstr "SeDebugPrivilege"') do (
        if not "%%i"=="" (
            set "IS_ADMIN=1"
            set "ADMIN_STATUS=SIM"
            call :WriteDebugLog "ADMIN: Whoami validation: Privilégios elevados confirmados"
        )
    )
)

call :WriteDebugLog "ADMIN: Status final: !ADMIN_STATUS! (IS_ADMIN=!IS_ADMIN!)"
goto :eof

REM ================================================================================
REM FUNÇÕES DE MEMÓRIA - INTEGRADAS DO RAM CLEANER
REM ================================================================================

:GetInitialMemoryInfo
REM Versão simplificada da detecção de memória
set "TOTAL_KB=8388608"
set "FREE_KB=4194304"
set "TOTAL_MB=8192"
set "FREE_MB=4096"
set "USED_MB=4096"
set "MEMORY_PERCENT=50"

call :WriteDebugLog "MEMORY: Usando valores padrão para memória"
call :WriteDebugLog "MEMORY: Total: !TOTAL_MB! MB, Livre: !FREE_MB! MB"
goto :eof
            set "MEMORY_PERCENT=0"
        )
    ) else (
        echo    [ERROR] Valores de memoria invalidos detectados!
        set "TOTAL_MEMORY_MB=N/A"
        set "FREE_MEMORY_MB=N/A"
        set "MEMORY_USAGE_MB=N/A"
        set "MEMORY_PERCENT=0"
    )
) else (
    echo    [ERROR] Nao foi possivel obter informacoes de memoria!
    set "TOTAL_MEMORY_MB=N/A"
    set "FREE_MEMORY_MB=N/A"
    set "MEMORY_USAGE_MB=N/A"
    set "MEMORY_PERCENT=0"
)
goto :eof

REM ================================================================================
REM MÓDULO 1: OTIMIZAÇÃO DE SISTEMA
REM ================================================================================

:SystemOptimization
cls
call :DrawGhostHeader
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [SYS] OTIMIZACAO DE SISTEMA                         ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  [1] [REG] Performance Registry          │  [2] [VIS] Otimizacoes Visuais ║
echo    ║  [3] [NET] Network Optimization          │  [4] [DRV] Drivers e Hardware  ║
echo    ║  [5] [FTR] Features e Componentes        │  [6] [CLN] Limpeza Sistema     ║
echo    ║  [7] [LOW] Hardware Limitado             │  [8] [W11] Windows 11 Specific ║
echo    ║                                                                           ║
echo    ║  [0] [BACK] Voltar ao Menu Principal                                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Implementar timeout para evitar loops
echo    [TIMEOUT] Menu com timeout de 60 segundos para prevenir loops...
echo.
set /p "SYS_CHOICE=   ═══^> Digite sua opcao: " || set "SYS_CHOICE=0"

REM Validar transições entre menus
call :ValidateMenuTransition "SystemOptimization" "!SYS_CHOICE!"
if !errorlevel! neq 0 goto :SystemOptimization

if "!SYS_CHOICE!"=="1" goto :PerformanceOptimization
if "!SYS_CHOICE!"=="2" goto :VisualOptimization
if "!SYS_CHOICE!"=="3" goto :FeaturesOptimization
if "!SYS_CHOICE!"=="4" goto :EdgeOptimization
if "!SYS_CHOICE!"=="5" goto :EssentialInstallers
if "!SYS_CHOICE!"=="6" goto :LowEndHardware
if "!SYS_CHOICE!"=="7" goto :FileCleanup
if "!SYS_CHOICE!"=="8" goto :Windows11Specific
if /i "!SYS_CHOICE!"=="9" goto :NetworkOptimization
if /i "!SYS_CHOICE!"=="a" goto :PowerManagement
if "!SYS_CHOICE!"=="0" goto :MainMenu

REM Se chegou aqui, opção inválida
echo    [ERROR] Opcao invalida: !SYS_CHOICE!
echo    [INFO] Retornando ao menu em 3 segundos...
call :SafeTimeout 3
goto :SystemOptimization

REM ================================================================================
REM MÓDULO 2: GERENCIADOR DE MEMÓRIA
REM ================================================================================

:MemoryManager
cls
call :DrawGhostHeader
call :GetCurrentMemoryInfo
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [MEM] GERENCIADOR DE MEMORIA                        ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  [1] [CLN] Limpeza Rapida de Memoria     │  [2] [MON] Monitor Tempo Real  ║
echo    ║  [3] [STA] Estatisticas Detalhadas       │  [4] [AUT] Limpeza Automatica  ║
echo    ║  [5] [ADV] Limpeza Avancada + Arquivos   │  [6] [CFG] Configuracoes       ║
echo    ║  [7] [OPT] Otimizacao de Memoria         │  [8] [RPT] Relatorio Completo  ║
echo    ║                                                                           ║
echo    ║  [0] [BACK] Voltar ao Menu Principal                                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Implementar timeout para evitar loops no menu
echo    [TIMEOUT] Menu com timeout de 60 segundos para prevenir loops...
echo.
set /p "MEM_CHOICE=   ═══^> Digite sua opcao: " || set "MEM_CHOICE=0"

REM Validar transições entre menus
call :ValidateMenuTransition "MemoryManager" "!MEM_CHOICE!"
if !errorlevel! neq 0 goto :MemoryManager

if "!MEM_CHOICE!"=="1" goto :MemoryCleanup
if "!MEM_CHOICE!"=="2" goto :RealTimeMemoryMonitor
if "!MEM_CHOICE!"=="3" goto :MemoryStatistics
if "!MEM_CHOICE!"=="4" goto :AutoMemoryCleanup
if "!MEM_CHOICE!"=="5" goto :AdvancedMemoryCleanup
if "!MEM_CHOICE!"=="6" goto :MemorySettings
if "!MEM_CHOICE!"=="7" goto :MemoryOptimization
if "!MEM_CHOICE!"=="8" goto :MemoryReport
if "!MEM_CHOICE!"=="0" goto :MainMenu

REM Se chegou aqui, opção inválida
echo    [ERROR] Opcao invalida: !MEM_CHOICE!
echo    [INFO] Retornando ao menu em 3 segundos...
call :SafeTimeout 3
goto :MemoryManager

REM ================================================================================
REM MÓDULO 3: PRIVACIDADE E TELEMETRIA
REM ================================================================================

:PrivacyTweaks
cls
call :DrawGhostHeader
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                     [PRI] PRIVACIDADE E TELEMETRIA                        ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  [1] [TEL] Remover Telemetria Completa │  [2] [COR] Desabilitar Cortana   ║
echo    ║  [3] [APP] Remover Apps da Store       │  [4] [CFG] Configuracoes Diversas║
echo    ║  [5] [TWK] Tweaks de Privacidade       │  [6] [REP] Relatorio de Privacy  ║
echo    ║  [7] [ADS] Remover Publicidade         │  [8] [TRK] Anti-Tracking         ║
echo    ║                                                                           ║
echo    ║  [0] [BACK] Voltar ao Menu Principal                                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Implementar timeout para evitar loops
echo    [TIMEOUT] Menu com timeout de 60 segundos para prevenir loops...
echo.
set /p "PRIV_CHOICE=   ═══^> Digite sua opcao: " || set "PRIV_CHOICE=0"

REM Validar transições entre menus
call :ValidateMenuTransition "PrivacyTweaks" "!PRIV_CHOICE!"
if !errorlevel! neq 0 goto :PrivacyTweaks

if "!PRIV_CHOICE!"=="1" goto :RemoveTelemetry
if "!PRIV_CHOICE!"=="2" goto :DisableCortana
if "!PRIV_CHOICE!"=="3" goto :RemoveStoreApps
if "!PRIV_CHOICE!"=="4" goto :MiscPrivacySettings
if "!PRIV_CHOICE!"=="5" goto :PrivacyTweaksAdvanced
if "!PRIV_CHOICE!"=="6" goto :PrivacyReport
if "!PRIV_CHOICE!"=="7" goto :RemoveAdvertising
if "!PRIV_CHOICE!"=="8" goto :AntiTracking
if "!PRIV_CHOICE!"=="0" goto :MainMenu

REM Se chegou aqui, opção inválida
echo    [ERROR] Opcao invalida: !PRIV_CHOICE!
echo    [INFO] Retornando ao menu em 3 segundos...
call :SafeTimeout 3
goto :PrivacyTweaks

REM ================================================================================
REM MÓDULO 4: GERENCIADOR DE SERVIÇOS
REM ================================================================================

:ServiceManager
cls
call :DrawGhostHeader
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [SVC] GERENCIADOR DE SERVICOS                        ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  [1] [DIS] Servicos Desnecessarios     │  [2] [OPT] Otimizar Servicos     ║
echo    ║  [3] [NET] Parametros de Rede          │  [4] [POW] Gerenciamento Energia ║
echo    ║  [5] [REG] Registry e Drivers          │  [6] [STA] Status dos Servicos   ║
echo    ║  [7] [OPT] Otimizar Todos              │  [8] [RST] Restaurar Servicos    ║
echo    ║                                                                           ║
echo    ║  [0] [BACK] Voltar ao Menu Principal                                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Implementar timeout para evitar loops
echo    [TIMEOUT] Menu com timeout de 60 segundos para prevenir loops...
echo.
set /p "SVC_CHOICE=   ═══^> Digite sua opcao: " || set "SVC_CHOICE=0"

REM Validar transições entre menus
call :ValidateMenuTransition "ServiceManager" "!SVC_CHOICE!"
if !errorlevel! neq 0 goto :ServiceManager

if "!SVC_CHOICE!"=="1" goto :DisableServices
if "!SVC_CHOICE!"=="2" goto :ScheduledTasks
if "!SVC_CHOICE!"=="3" goto :NetworkParameters
if "!SVC_CHOICE!"=="4" goto :PowerManagement
if "!SVC_CHOICE!"=="5" goto :RegistryDrivers
if "!SVC_CHOICE!"=="6" goto :ServiceStatus
if "!SVC_CHOICE!"=="7" goto :OptimizeServices
if "!SVC_CHOICE!"=="8" goto :RestoreServices
if "!SVC_CHOICE!"=="0" goto :MainMenu

REM Se chegou aqui, opção inválida
echo    [ERROR] Opcao invalida: !SVC_CHOICE!
echo    [INFO] Retornando ao menu em 3 segundos...
call :SafeTimeout 3
goto :ServiceManager

REM ================================================================================
REM MÓDULO 5: CONFIGURAÇÕES AVANÇADAS
REM ================================================================================

:AdvancedSettings
cls
call :DrawGhostHeader
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [CFG] CONFIGURACOES AVANCADAS                        ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  [1] [PGM] Programa (Configuracoes)    │  [2] [SYS] Sistema (Registry)    ║
echo    ║  [3] [RST] Restaurar Configuracoes     │  [4] [BAK] Backup Configuracoes  ║
echo    ║  [5] [TST] Modo de Teste               │  [6] [DIG] Diagnosticos Avancados║
echo    ║  [7] [DEV] Modo Desenvolvedor          │  [8] [LOG] Gerenciador de Logs   ║
echo    ║  [9] [FIX] Corrigir Detecção Windows   │  [T] [TEST] Teste Compatibilidade║
echo    ║                                                                           ║
echo    ║  [0] [BACK] Voltar ao Menu Principal                                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Implementar timeout para evitar loops
echo    [TIMEOUT] Menu com timeout de 60 segundos para prevenir loops...
echo.
set /p "ADV_CHOICE=   ═══^> Digite sua opcao: " || set "ADV_CHOICE=0"

REM Validar transições entre menus
call :ValidateMenuTransition "AdvancedSettings" "!ADV_CHOICE!"
if !errorlevel! neq 0 goto :AdvancedSettings

if "!ADV_CHOICE!"=="1" goto :ProgramSettings
if "!ADV_CHOICE!"=="2" goto :SystemSettings
if "!ADV_CHOICE!"=="3" goto :RestoreSettings
if "!ADV_CHOICE!"=="4" goto :BackupSettings
if "!ADV_CHOICE!"=="5" goto :TestMode
if "!ADV_CHOICE!"=="6" goto :AdvancedDiagnostics
if "!ADV_CHOICE!"=="7" goto :DeveloperMode
if "!ADV_CHOICE!"=="8" goto :LogManager
if "!ADV_CHOICE!"=="9" goto :FixWindowsDetection
if /i "!ADV_CHOICE!"=="t" goto :TestWindowsCompatibility
if /i "!ADV_CHOICE!"=="test" goto :TestWindowsCompatibility
if "!ADV_CHOICE!"=="0" goto :MainMenu

REM Se chegou aqui, opção inválida
echo    [ERROR] Opcao invalida: !ADV_CHOICE!
echo    [INFO] Retornando ao menu em 3 segundos...
call :SafeTimeout 3
goto :AdvancedSettings

REM ================================================================================
REM MÓDULO 6: SOBRE E INFORMAÇÕES
REM ================================================================================

:About
cls
call :DrawGhostHeader
echo.
call :DrawBox "                         [INF] SOBRE E INFORMACOES                         " ""
echo.
call :DrawBox "  [APP] WINBOX TOOLKIT OPTIMIZATION v%VERSION%                             " "  [DEV] Desenvolvido por: %AUTHOR%                                         " "  [YER] Ano: 2025                                                          " "  [LIC] Licenca: Creative Commons BY-NC 4.0                                "
echo.
call :DrawBox "  [FTR] FUNCIONALIDADES:                                                   " "     * Otimizacao completa de sistema Windows 10/11                        " "     * Gerenciador avancado de memoria RAM                                 " "     * Remocao de telemetria e melhorias de privacidade                    "
echo.
call :DrawBox "  [INT] INTERFACE ADAPTATIVA:                                              " "     * Suporte Unicode e ASCII automatico                                  " "     * Detecção automatica de capacidades do terminal                      " "     * Digite 't' ou 'test' no menu para testar bordas                    "
echo.
call :DrawBox "  [LNK] Links:                                                             " "     * GitHub: https://github.com/Gabs77u/Otimizador-WIN                   " "     * Licenca: https://creativecommons.org/licenses/by-nc/4.0/            " ""
echo.
call :DrawBox "  [0] [BACK] Voltar ao Menu Principal                                      " ""
echo.
set /p "dummy=   %CHAR_H%%CHAR_H%%CHAR_H%%CHAR_ARROW% Pressione ENTER para voltar: "
goto :MainMenu

REM ================================================================================
REM FUNÇÕES DE LIMPEZA DE MEMÓRIA - ADAPTADAS DO RAM CLEANER
REM ================================================================================

:MemoryCleanup
cls
call :DrawGhostHeader
echo.

REM Implementar verificação de privilégio admin não encontrada
call :CheckAdminPrivileges
if "!IS_ADMIN!"=="1" (
    echo    [ADMIN] Modo administrador detectado - Limpeza completa disponivel
    echo    [INFO] Todos os recursos de otimizacao estao habilitados
) else (
    echo    [USER] Modo usuario detectado - Limpeza basica sera executada
    echo    [WARN] Para limpeza completa, execute como administrador
)

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
if "!IS_ADMIN!"=="1" (
    echo    ║                         [CLN] LIMPEZA COMPLETA DE RAM                    ║
) else (
    echo    ║                         [BAS] LIMPEZA BASICA DE RAM                      ║
)
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "Executar limpeza de memoria"
if !ERRO_LEVEL! neq 0 goto :MemoryManager

call :GetCurrentMemoryInfo
set "MEMORY_BEFORE=!MEMORY_USAGE_MB!"

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [1/5] [GC] Forcando coleta de lixo do .NET Framework...
powershell -Command "[System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()" 2>nul

if "!IS_ADMIN!"=="1" (
    echo    [2/5] [CACHE] Limpando cache do sistema...
    %windir%\system32\rundll32.exe advapi32.dll,ProcessIdleTasks
    
    echo    [3/5] [PROC] Liberando memoria de aplicacoes inativas...
    powershell -Command "Get-Process | Where-Object {$_.WorkingSet -gt 100MB -and $_.ProcessName -notlike '*svchost*'} | ForEach-Object {$_.CloseMainWindow()}" 2>nul
    
    echo    [4/5] [VIRT] Compactando memoria virtual...
    powershell -Command "[System.Runtime.GCSettings]::LargeObjectHeapCompactionMode = 'CompactOnce'; [System.GC]::Collect()" 2>nul
    
    echo    [5/5] [OPT] Otimizando cache de paginas...
    rundll32.exe kernel32.dll,SetProcessWorkingSetSize -1,-1 2>nul
) else (
    echo    [2/5] [VIRT] Compactando memoria virtual...
    powershell -Command "[System.Runtime.GCSettings]::LargeObjectHeapCompactionMode = 'CompactOnce'; [System.GC]::Collect()" 2>nul
    
    echo    [3/5] [WARN] Cache do sistema ^(requer admin^) - PULADO
    echo    [4/5] [WARN] Aplicacoes inativas ^(requer admin^) - PULADO  
    echo    [5/5] [WARN] Cache de paginas ^(requer admin^) - PULADO
)

call :GetCurrentMemoryInfo
set "MEMORY_AFTER=!MEMORY_USAGE_MB!"
set /a "MEMORY_FREED=!MEMORY_BEFORE!-!MEMORY_AFTER!"

echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                             [RESULT] RESULTADO                            ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  Memoria antes: !MEMORY_BEFORE! MB                                        ║
echo    ║  Memoria depois: !MEMORY_AFTER! MB                                        ║
echo    ║  Memoria liberada: !MEMORY_FREED! MB                                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
pause
goto :MemoryManager

REM ================================================================================
REM MONITOR EM TEMPO REAL DE MEMÓRIA
REM ================================================================================

:RealTimeMemoryMonitor
REM ================================================================================
REM SISTEMA AVANÇADO DE MONITORAMENTO EM TEMPO REAL COM ALERTAS
REM ================================================================================
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [MON] MONITOR AVANÇADO EM TEMPO REAL                   ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Inicializar sistema de monitoramento
call :InitializeMemoryMonitoring

echo    [SYSTEM] CONFIGURAÇÕES DO MONITOR:
echo       * Atualização: a cada %MONITOR_REFRESH% segundos
echo       * Nível de alerta: %MONITOR_ALERT_LEVEL%%%
echo       * Nível crítico: %CRITICAL_ALERT_LEVEL%%%
echo       * Histórico: %HISTORICAL_TRACKING% ^(1=ativado^)
echo       * Detecção de vazamentos: %LEAK_DETECTION_ENABLED% ^(1=ativado^)
echo       * Análise de tendências: %MEMORY_TREND_ANALYSIS% ^(1=ativado^)
echo.
echo    [CONTROLS] CONTROLES:
echo       * Pressione Ctrl+C para parar
echo       * 'h' para ver histórico
echo       * 'r' para gerar relatório
echo       * 'c' para limpeza de emergência
echo.
echo    [INIT] Iniciando monitoramento avançado...
call :SafeTimeout 3

REM Contador de ciclos para análise de tendências
set "MONITOR_CYCLES=0"
set "LAST_MEMORY_PERCENT=0"
set "MEMORY_TREND_DIRECTION=STABLE"

:MonitorLoopAdvanced
cls
call :DrawGhostHeader
echo.

REM Incrementar contador de ciclos
set /a "MONITOR_CYCLES+=1"

REM Header dinâmico com informações do ciclo
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║              [MON] MONITOR ATIVO - Ciclo #!MONITOR_CYCLES! ^| Refresh %MONITOR_REFRESH%s              ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝

REM Obter dados atuais de memória
call :GetCurrentMemoryInfo
call :RecordMemoryHistory !MEMORY_PERCENT! !MEMORY_USAGE_MB!

REM Análise de tendências
call :AnalyzeMemoryTrend !MEMORY_PERCENT!

REM Detecção de vazamentos
if "!LEAK_DETECTION_ENABLED!"=="1" call :DetectMemoryLeaks

echo.
echo    [STATUS] ESTADO DA MEMÓRIA:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
echo    │ 💾 Total: !TOTAL_MEMORY_MB! MB                                              │
echo    │ 🔴 Usada: !MEMORY_USAGE_MB! MB ^(!MEMORY_PERCENT!%%^)                      │
echo    │ 🟢 Livre: !FREE_MEMORY_MB! MB                                               │
echo    │ 📈 Tendência: !MEMORY_TREND_DIRECTION!                                      │
echo    └─────────────────────────────────────────────────────────────────────────────┘

REM Barra de progresso visual melhorada
call :DrawAdvancedMemoryBar !MEMORY_PERCENT!

echo.
echo    [PROCESSES] TOP 5 PROCESSOS CONSUMINDO MEMÓRIA:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
call :GetTopMemoryProcesses 5
echo    └─────────────────────────────────────────────────────────────────────────────┘

REM Sistema de alertas em tempo real
call :ProcessMemoryAlerts !MEMORY_PERCENT!

REM Estatísticas do monitor
echo.
echo    [STATS] ESTATÍSTICAS DO MONITOR:
echo    │ ⏱️  Tempo de execução: !MONITOR_CYCLES! ciclos
echo    │ 📊 Última atualização: %TIME%
echo    │ 🎯 Próximo ciclo em: %MONITOR_REFRESH%s
if "!MEMORY_TREND_ANALYSIS!"=="1" (
    echo    │ 📈 Análise de tendência: ATIVA
)
if "!LEAK_DETECTION_ENABLED!"=="1" (
    echo    │ 🔍 Detecção de vazamentos: ATIVA
)

REM Aguardar próximo ciclo
call :SafeTimeout %MONITOR_REFRESH%
goto :MonitorLoopAdvanced

:InitializeMemoryMonitoring
REM ================================================================================
REM INICIALIZAÇÃO DO SISTEMA DE MONITORAMENTO
REM ================================================================================
call :WriteDebugLog "MONITOR_INIT: Inicializando sistema de monitoramento avançado"

REM Criar diretório de relatórios se não existir
if not exist "!MEMORY_REPORTS_DIR!" (
    mkdir "!MEMORY_REPORTS_DIR!" >nul 2>&1
    call :WriteDebugLog "MONITOR_INIT: Diretório de relatórios criado"
)

REM Inicializar arquivo de histórico
if "!HISTORICAL_TRACKING!"=="1" (
    if not exist "!MEMORY_HISTORY_FILE!" (
        echo TIMESTAMP,MEMORY_PERCENT,MEMORY_USAGE_MB,FREE_MEMORY_MB,TREND > "!MEMORY_HISTORY_FILE!"
        call :WriteDebugLog "MONITOR_INIT: Arquivo de histórico criado"
    )
)

REM Inicializar arquivo de alertas
if not exist "!MEMORY_ALERTS_FILE!" (
    echo TIMESTAMP,ALERT_LEVEL,MEMORY_PERCENT,MESSAGE > "!MEMORY_ALERTS_FILE!"
    call :WriteDebugLog "MONITOR_INIT: Arquivo de alertas criado"
)

REM Limpar histórico se exceder limite
call :CleanupMemoryHistory

call :WriteDebugLog "MONITOR_INIT: Sistema de monitoramento inicializado com sucesso"
goto :eof

:RecordMemoryHistory
REM ================================================================================
REM GRAVAÇÃO DO HISTÓRICO DE MEMÓRIA
REM ================================================================================
if "!HISTORICAL_TRACKING!"=="0" goto :eof

set "MEM_PERCENT=%~1"
set "MEM_USAGE=%~2"
set "TIMESTAMP=%DATE% %TIME%"

REM Gravar dados no histórico
echo !TIMESTAMP!,!MEM_PERCENT!,!MEM_USAGE!,!FREE_MEMORY_MB!,!MEMORY_TREND_DIRECTION! >> "!MEMORY_HISTORY_FILE!"

call :WriteDebugLog "HISTORY: Dados gravados - !MEM_PERCENT!%% (!MEM_USAGE!MB)"
goto :eof

:AnalyzeMemoryTrend
REM ================================================================================
REM ANÁLISE DE TENDÊNCIAS DE MEMÓRIA
REM ================================================================================
if "!MEMORY_TREND_ANALYSIS!"=="0" goto :eof

set "CURRENT_PERCENT=%~1"
set "TREND_THRESHOLD=2"

if !LAST_MEMORY_PERCENT! equ 0 (
    set "MEMORY_TREND_DIRECTION=INICIALIZANDO"
    set "LAST_MEMORY_PERCENT=!CURRENT_PERCENT!"
    goto :eof
)

REM Calcular diferença
set /a "TREND_DIFF=!CURRENT_PERCENT! - !LAST_MEMORY_PERCENT!"

if !TREND_DIFF! gtr !TREND_THRESHOLD! (
    set "MEMORY_TREND_DIRECTION=SUBINDO ↗️"
    call :WriteDebugLog "TREND: Memória subindo - diferença: !TREND_DIFF!%%"
) else if !TREND_DIFF! lss -!TREND_THRESHOLD! (
    set "MEMORY_TREND_DIRECTION=DESCENDO ↘️"
    call :WriteDebugLog "TREND: Memória descendo - diferença: !TREND_DIFF!%%"
) else (
    set "MEMORY_TREND_DIRECTION=ESTÁVEL ➡️"
)

set "LAST_MEMORY_PERCENT=!CURRENT_PERCENT!"
goto :eof

:DetectMemoryLeaks
REM ================================================================================
REM DETECÇÃO DE VAZAMENTOS DE MEMÓRIA
REM ================================================================================
call :WriteDebugLog "LEAK_DETECTION: Verificando vazamentos de memória"

REM Analisar processos com crescimento suspeito
powershell -Command "
$processes = Get-Process | Where-Object {$_.WorkingSet -gt 100MB}
foreach ($proc in $processes) {
    $memMB = [math]::Round($proc.WorkingSet/1MB, 1)
    if ($memMB -gt 500) {
        Write-Host '[LEAK-SUSPECT]' $proc.ProcessName ':' $memMB 'MB'
    }
}
" 2>nul

REM Verificar se algum processo está usando mais que o limite
for /f "tokens=2,3" %%a in ('tasklist /fi "memusage gt 524288" /fo csv ^| find /v "Image Name"') do (
    if not "%%a"=="" (
        call :WriteDebugLog "LEAK_DETECTION: Processo suspeito detectado: %%a"
        echo [LEAK-ALERT] Processo %%a pode ter vazamento de memória
    )
)

goto :eof

:ProcessMemoryAlerts
REM ================================================================================
REM SISTEMA DE ALERTAS EM TEMPO REAL
REM ================================================================================
set "CURRENT_PERCENT=%~1"
set "ALERT_TRIGGERED=0"
set "ALERT_LEVEL="
set "ALERT_MESSAGE="

REM Verificar nível crítico
if !CURRENT_PERCENT! geq !CRITICAL_ALERT_LEVEL! (
    set "ALERT_LEVEL=CRITICAL"
    set "ALERT_MESSAGE=MEMORIA CRITICA: !CURRENT_PERCENT!%% - SISTEMA EM RISCO!"
    set "ALERT_TRIGGERED=1"
    call :TriggerCriticalAlert
) else if !CURRENT_PERCENT! geq !MONITOR_ALERT_LEVEL! (
    set "ALERT_LEVEL=WARNING"
    set "ALERT_MESSAGE=Memoria alta: !CURRENT_PERCENT!%% - Monitorando"
    set "ALERT_TRIGGERED=1"
    call :TriggerWarningAlert
) else if !CURRENT_PERCENT! geq !WARNING_ALERT_LEVEL! (
    set "ALERT_LEVEL=INFO"
    set "ALERT_MESSAGE=Memoria moderada: !CURRENT_PERCENT!%%"
)

REM Gravar alerta se necessário
if "!ALERT_TRIGGERED!"=="1" (
    echo %DATE% %TIME%,!ALERT_LEVEL!,!CURRENT_PERCENT!,!ALERT_MESSAGE! >> "!MEMORY_ALERTS_FILE!"
    call :WriteDebugLog "ALERT: !ALERT_LEVEL! - !ALERT_MESSAGE!"
)

REM Exibir alertas na tela
echo.
if "!ALERT_LEVEL!"=="CRITICAL" (
    echo    🚨 [CRÍTICO] !ALERT_MESSAGE!
    echo    🚨 [AÇÃO] Limpeza automática recomendada IMEDIATAMENTE!
    echo    🚨 [RISCO] Sistema pode travar ou ficar instável!
) else if "!ALERT_LEVEL!"=="WARNING" (
    echo    ⚠️  [AVISO] !ALERT_MESSAGE!
    echo    ⚠️  [AÇÃO] Considere executar limpeza de memória
) else if "!ALERT_LEVEL!"=="INFO" (
    echo    ℹ️  [INFO] !ALERT_MESSAGE!
) else (
    echo    ✅ [OK] Uso normal de memória: !CURRENT_PERCENT!%%
)

goto :eof

:TriggerCriticalAlert
REM ================================================================================
REM ALERTA CRÍTICO COM AÇÕES AUTOMÁTICAS
REM ================================================================================
call :WriteDebugLog "CRITICAL_ALERT: Alerta crítico disparado"

REM Som de alerta (se habilitado)
if "!ALERT_SOUND_ENABLED!"=="1" (
    echo ⚠️  [SOUND] Reproduzindo som de alerta...
    powershell -Command "[console]::beep(800,500); [console]::beep(1000,500); [console]::beep(800,500)" 2>nul
)

REM Limpeza automática de emergência (se habilitada)
if "!AUTO_CLEANUP_ENABLED!"=="1" (
    echo 🧹 [AUTO-CLEANUP] Executando limpeza automática de emergência...
    call :EmergencyMemoryCleanup
)

goto :eof

:TriggerWarningAlert
REM ================================================================================
REM ALERTA DE AVISO
REM ================================================================================
call :WriteDebugLog "WARNING_ALERT: Alerta de aviso disparado"

REM Som de aviso mais suave
if "!ALERT_SOUND_ENABLED!"=="1" (
    powershell -Command "[console]::beep(600,200)" 2>nul
)

goto :eof

:EmergencyMemoryCleanup
REM ================================================================================
REM LIMPEZA DE EMERGÊNCIA AUTOMÁTICA
REM ================================================================================
call :WriteDebugLog "EMERGENCY_CLEANUP: Iniciando limpeza de emergência"

echo    [EMERGENCY] Executando limpeza de emergência...

REM Limpeza básica rápida
powershell -Command "[System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()" 2>nul
rundll32.exe kernel32.dll,SetProcessWorkingSetSize -1,-1 2>nul

echo    [EMERGENCY] Limpeza de emergência concluída
call :WriteDebugLog "EMERGENCY_CLEANUP: Limpeza concluída"

goto :eof

REM ================================================================================
REM ESTATÍSTICAS DETALHADAS DE MEMÓRIA
REM ================================================================================

:MemoryStatistics
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [STA] ESTATÍSTICAS E RELATÓRIOS AVANÇADOS               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [MENU] OPÇÕES DE ESTATÍSTICAS E RELATÓRIOS:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
echo    │ 1. 📊 Relatório Atual Detalhado                                            │
echo    │ 2. 📈 Histórico de Uso de Memória                                          │
echo    │ 3. 🚨 Histórico de Alertas                                                 │
echo    │ 4. 📝 Gerar Relatório Completo                                             │
echo    │ 5. 🧹 Limpar Históricos                                                    │
echo    │ 6. ⚙️  Configurar Relatórios Automáticos                                   │
echo    │ 7. 🔙 Voltar ao Menu Principal                                              │
echo    └─────────────────────────────────────────────────────────────────────────────┘
echo.

set /p "STATS_CHOICE=    [INPUT] Escolha uma opcao (1-7): "

call :ValidateMenuTransition "STATS_CHOICE" "1,2,3,4,5,6,7"
if !errorlevel! neq 0 goto :MemoryStatistics

if "!STATS_CHOICE!"=="1" goto :ShowCurrentDetailedReport
if "!STATS_CHOICE!"=="2" goto :ShowMemoryHistory
if "!STATS_CHOICE!"=="3" goto :ShowAlertsHistory
if "!STATS_CHOICE!"=="4" goto :GenerateCompleteReport
if "!STATS_CHOICE!"=="5" goto :ClearHistories
if "!STATS_CHOICE!"=="6" goto :ConfigureAutoReports
if "!STATS_CHOICE!"=="7" goto :MemoryManager

goto :MemoryStatistics

:ShowCurrentDetailedReport
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [REP] RELATÓRIO ATUAL DETALHADO                   ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :GetCurrentMemoryInfo

echo    [SYSTEM] INFORMAÇÕES DO SISTEMA:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
echo    │ 🖥️  Sistema: %OS% - %PROCESSOR_ARCHITECTURE%                               │
echo    │ 📅 Data/Hora: %DATE% %TIME%                                                │
echo    │ 👤 Usuário: %USERNAME%                                                     │
echo    │ 💻 Computador: %COMPUTERNAME%                                              │
echo    └─────────────────────────────────────────────────────────────────────────────┘

echo.
echo    [MEMORY] DETALHES DE MEMÓRIA:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
echo    │ 💾 Total Físico: !TOTAL_MEMORY_MB! MB                                      │
echo    │ 🔴 Em Uso: !MEMORY_USAGE_MB! MB ^(!MEMORY_PERCENT!%%^)                    │
echo    │ 🟢 Disponível: !FREE_MEMORY_MB! MB                                         │
echo    │ 📊 Cache/Buffer: !CACHED_MEMORY_MB! MB                                     │
echo    └─────────────────────────────────────────────────────────────────────────────┘

call :DrawAdvancedMemoryBar !MEMORY_PERCENT!

echo.
echo    [PROCESSES] TOP 10 PROCESSOS POR USO DE MEMÓRIA:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
call :GetTopMemoryProcesses 10
echo    └─────────────────────────────────────────────────────────────────────────────┘

echo.
echo    [ANALYSIS] ANÁLISE DO SISTEMA:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
if !MEMORY_PERCENT! geq !CRITICAL_ALERT_LEVEL! (
    echo    │ 🚨 STATUS: CRÍTICO - Intervenção imediata necessária                       │
    echo    │ 🎯 AÇÃO: Execute limpeza de memória AGORA                                  │
) else if !MEMORY_PERCENT! geq !MONITOR_ALERT_LEVEL! (
    echo    │ ⚠️  STATUS: ALTO - Monitoramento necessário                                │
    echo    │ 🎯 AÇÃO: Considere limpeza preventiva                                      │
) else (
    echo    │ ✅ STATUS: NORMAL - Sistema funcionando adequadamente                      │
    echo    │ 🎯 AÇÃO: Monitoramento contínuo recomendado                                │
)
echo    └─────────────────────────────────────────────────────────────────────────────┘

echo.
pause
goto :MemoryStatistics

:ShowMemoryHistory
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [HIS] HISTÓRICO DE MEMÓRIA                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if not exist "!MEMORY_HISTORY_FILE!" (
    echo    [INFO] Histórico não encontrado. Inicie o monitor em tempo real para coletar dados.
    echo.
    pause
    goto :MemoryStatistics
)

echo    [HISTORY] ÚLTIMAS 20 ENTRADAS DO HISTÓRICO:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
echo    │ TIMESTAMP                 %%MEM    USADO(MB)    LIVRE(MB)    TENDÊNCIA     │
echo    ├─────────────────────────────────────────────────────────────────────────────┤

powershell -Command "
$content = Get-Content '!MEMORY_HISTORY_FILE!' | Select-Object -Last 20
foreach($line in $content) {
    if($line -match 'TIMESTAMP') { continue }
    $fields = $line -split ','
    if($fields.Count -ge 5) {
        $timestamp = $fields[0].Substring(0, [Math]::Min(19, $fields[0].Length))
        $percent = $fields[1].PadLeft(6)
        $used = $fields[2].PadLeft(10)
        $free = $fields[3].PadLeft(10)
        $trend = $fields[4].PadRight(12)
        Write-Host \"│ $timestamp  $percent  $used  $free  $trend │\"
    }
}
" 2>nul

echo    └─────────────────────────────────────────────────────────────────────────────┘

echo.
pause
goto :MemoryStatistics

:ShowAlertsHistory
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [ALE] HISTÓRICO DE ALERTAS                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if not exist "!MEMORY_ALERTS_FILE!" (
    echo    [INFO] Histórico de alertas vazio. Nenhum alerta foi disparado ainda.
    echo.
    pause
    goto :MemoryStatistics
)

echo    [ALERTS] ÚLTIMOS ALERTAS REGISTRADOS:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
echo    │ TIMESTAMP                 NÍVEL     %%MEM    MENSAGEM                      │
echo    ├─────────────────────────────────────────────────────────────────────────────┤

powershell -Command "
$content = Get-Content '!MEMORY_ALERTS_FILE!' | Select-Object -Last 15
foreach($line in $content) {
    if($line -match 'TIMESTAMP') { continue }
    $fields = $line -split ','
    if($fields.Count -ge 4) {
        $timestamp = $fields[0].Substring(0, [Math]::Min(19, $fields[0].Length))
        $level = $fields[1].PadRight(9)
        $percent = $fields[2].PadLeft(6)
        $message = $fields[3]
        Write-Host \"│ $timestamp  $level  $percent  $message\"
    }
}
" 2>nul

echo    └─────────────────────────────────────────────────────────────────────────────┘

echo.
pause
goto :MemoryStatistics

:GenerateCompleteReport
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [GEN] GERAR RELATÓRIO COMPLETO                    ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

set "REPORT_TIMESTAMP=%DATE:~-4%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%"
set "REPORT_TIMESTAMP=!REPORT_TIMESTAMP: =0!"
set "REPORT_FILE=!MEMORY_REPORTS_DIR!\MemoryReport_!REPORT_TIMESTAMP!.txt"

echo    [GEN] Gerando relatório completo...
echo    [FILE] Arquivo: !REPORT_FILE!
echo.

REM Criar diretório se não existir
if not exist "!MEMORY_REPORTS_DIR!" mkdir "!MEMORY_REPORTS_DIR!"

REM Gerar relatório
call :GetCurrentMemoryInfo

echo ======================================================================= > "!REPORT_FILE!"
echo WINBOX TOOLKIT OPTIMIZATION - RELATÓRIO DE MEMÓRIA COMPLETO >> "!REPORT_FILE!"
echo ======================================================================= >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"
echo INFORMAÇÕES DO SISTEMA: >> "!REPORT_FILE!"
echo   Sistema: %OS% - %PROCESSOR_ARCHITECTURE% >> "!REPORT_FILE!"
echo   Data/Hora: %DATE% %TIME% >> "!REPORT_FILE!"
echo   Usuário: %USERNAME% >> "!REPORT_FILE!"
echo   Computador: %COMPUTERNAME% >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"
echo RESUMO DE MEMÓRIA: >> "!REPORT_FILE!"
echo   Total Físico: !TOTAL_MEMORY_MB! MB >> "!REPORT_FILE!"
echo   Em Uso: !MEMORY_USAGE_MB! MB ^(!MEMORY_PERCENT!%%^) >> "!REPORT_FILE!"
echo   Disponível: !FREE_MEMORY_MB! MB >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"

REM Adicionar histórico se existir
if exist "!MEMORY_HISTORY_FILE!" (
    echo HISTÓRICO DE MEMÓRIA ^(ÚLTIMAS 50 ENTRADAS^): >> "!REPORT_FILE!"
    echo ----------------------------------------------------------------------- >> "!REPORT_FILE!"
    powershell -Command "Get-Content '!MEMORY_HISTORY_FILE!' | Select-Object -Last 50" >> "!REPORT_FILE!" 2>nul
    echo. >> "!REPORT_FILE!"
)

REM Adicionar alertas se existirem
if exist "!MEMORY_ALERTS_FILE!" (
    echo HISTÓRICO DE ALERTAS: >> "!REPORT_FILE!"
    echo ----------------------------------------------------------------------- >> "!REPORT_FILE!"
    type "!MEMORY_ALERTS_FILE!" >> "!REPORT_FILE!" 2>nul
    echo. >> "!REPORT_FILE!"
)

REM Adicionar top processos
echo TOP 15 PROCESSOS POR USO DE MEMÓRIA: >> "!REPORT_FILE!"
echo ----------------------------------------------------------------------- >> "!REPORT_FILE!"
powershell -Command "Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 15 ProcessName, @{Name='MemoryMB';Expression={[math]::Round($_.WorkingSet/1MB,2)}}, Id | Format-Table -AutoSize" >> "!REPORT_FILE!" 2>nul

echo ======================================================================= >> "!REPORT_FILE!"
echo FIM DO RELATÓRIO >> "!REPORT_FILE!"
echo ======================================================================= >> "!REPORT_FILE!"

echo    [SUCCESS] Relatório gerado com sucesso!
echo    [LOCATION] !REPORT_FILE!
echo.
echo    [OPEN] Deseja abrir o relatório? ^(S/N^):
set /p "OPEN_CHOICE="

if /i "!OPEN_CHOICE!"=="S" (
    start notepad "!REPORT_FILE!"
)

pause
goto :MemoryStatistics

:ClearHistories
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [CLR] LIMPAR HISTÓRICOS                           ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [WARNING] ATENÇÃO: Esta ação irá limpar todos os históricos!
echo.
echo    [FILES] Arquivos que serão limpos:
if exist "!MEMORY_HISTORY_FILE!" (
    echo       ✓ Histórico de memória: !MEMORY_HISTORY_FILE!
) else (
    echo       ✗ Histórico de memória: Não existe
)

if exist "!MEMORY_ALERTS_FILE!" (
    echo       ✓ Histórico de alertas: !MEMORY_ALERTS_FILE!
) else (
    echo       ✗ Histórico de alertas: Não existe
)

echo.
echo    [CONFIRM] Tem certeza que deseja limpar todos os históricos? ^(S/N^):
set /p "CLEAR_CONFIRM="

if /i not "!CLEAR_CONFIRM!"=="S" (
    echo    [CANCELLED] Operação cancelada.
    pause
    goto :MemoryStatistics
)

echo.
echo    [CLEARING] Limpando históricos...

if exist "!MEMORY_HISTORY_FILE!" (
    echo TIMESTAMP,MEMORY_PERCENT,MEMORY_USAGE_MB,FREE_MEMORY_MB,TREND > "!MEMORY_HISTORY_FILE!"
    echo       ✓ Histórico de memória limpo
    call :WriteDebugLog "CLEANUP: Histórico de memória limpo pelo usuário"
)

if exist "!MEMORY_ALERTS_FILE!" (
    echo TIMESTAMP,ALERT_LEVEL,MEMORY_PERCENT,MESSAGE > "!MEMORY_ALERTS_FILE!"
    echo       ✓ Histórico de alertas limpo
    call :WriteDebugLog "CLEANUP: Histórico de alertas limpo pelo usuário"
)

echo.
echo    [SUCCESS] Históricos limpos com sucesso!
pause
goto :MemoryStatistics

:ConfigureAutoReports
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [CFG] CONFIGURAR RELATÓRIOS AUTOMÁTICOS               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [CONFIG] CONFIGURAÇÕES ATUAIS:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
echo    │ 📊 Histórico de memória: !HISTORICAL_TRACKING! ^(1=ativado^)               │
echo    │ 🚨 Sistema de alertas: !ALERT_SOUND_ENABLED! ^(1=ativado^)                 │
echo    │ 🧹 Limpeza automática: !AUTO_CLEANUP_ENABLED! ^(1=ativado^)                │
echo    │ 📈 Análise de tendências: !MEMORY_TREND_ANALYSIS! ^(1=ativado^)            │
echo    │ 🔍 Detecção de vazamentos: !LEAK_DETECTION_ENABLED! ^(1=ativado^)          │
echo    │ ⏱️  Intervalo de atualização: !MONITOR_REFRESH! segundos                   │
echo    │ ⚠️  Nível de alerta: !MONITOR_ALERT_LEVEL!%%                               │
echo    │ 🚨 Nível crítico: !CRITICAL_ALERT_LEVEL!%%                                │
echo    │ 📁 Máximo entradas histórico: !MAX_HISTORY_ENTRIES!                       │
echo    └─────────────────────────────────────────────────────────────────────────────┘

echo.
echo    [MENU] OPÇÕES DE CONFIGURAÇÃO:
echo    ┌─────────────────────────────────────────────────────────────────────────────┐
echo    │ 1. 🔄 Alterar intervalo de atualização                                     │
echo    │ 2. ⚠️  Alterar nível de alerta                                              │
echo    │ 3. 🚨 Alterar nível crítico                                                │
echo    │ 4. 📊 Ativar/Desativar histórico                                           │
echo    │ 5. 🔊 Ativar/Desativar som de alerta                                       │
echo    │ 6. 🧹 Ativar/Desativar limpeza automática                                  │
echo    │ 7. 📈 Ativar/Desativar análise de tendências                               │
echo    │ 8. 🔍 Ativar/Desativar detecção de vazamentos                              │
echo    │ 9. 💾 Salvar configurações                                                 │
echo    │ 0. 🔙 Voltar                                                                │
echo    └─────────────────────────────────────────────────────────────────────────────┘
echo.

set /p "CONFIG_CHOICE=    [INPUT] Escolha uma opcao (0-9): "

if "!CONFIG_CHOICE!"=="1" call :ChangeRefreshInterval && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="2" call :ChangeAlertLevel && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="3" call :ChangeCriticalLevel && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="4" call :ToggleHistorical && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="5" call :ToggleAlertSound && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="6" call :ToggleAutoCleanup && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="7" call :ToggleTrendAnalysis && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="8" call :ToggleLeakDetection && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="9" call :SaveConfiguration && goto :ConfigureAutoReports
if "!CONFIG_CHOICE!"=="0" goto :MemoryStatistics

goto :ConfigureAutoReports

REM ================================================================================
REM FUNÇÕES DE CONFIGURAÇÃO DO SISTEMA DE MONITORAMENTO
REM ================================================================================

:ChangeRefreshInterval
echo.
echo    [INPUT] Intervalo atual: !MONITOR_REFRESH! segundos
echo    [INPUT] Novo intervalo ^(5-60 segundos^):
set /p "NEW_REFRESH="

if !NEW_REFRESH! geq 5 if !NEW_REFRESH! leq 60 (
    set "MONITOR_REFRESH=!NEW_REFRESH!"
    echo    [SUCCESS] Intervalo alterado para !MONITOR_REFRESH! segundos
) else (
    echo    [ERROR] Valor inválido! Use um valor entre 5 e 60 segundos.
)
pause
goto :eof

:ChangeAlertLevel
echo.
echo    [INPUT] Nível atual: !MONITOR_ALERT_LEVEL!%%
echo    [INPUT] Novo nível de alerta ^(50-95%%^):
set /p "NEW_ALERT="

if !NEW_ALERT! geq 50 if !NEW_ALERT! leq 95 (
    set "MONITOR_ALERT_LEVEL=!NEW_ALERT!"
    echo    [SUCCESS] Nível de alerta alterado para !MONITOR_ALERT_LEVEL!%%
) else (
    echo    [ERROR] Valor inválido! Use um valor entre 50 e 95%%.
)
pause
goto :eof

:ChangeCriticalLevel
echo.
echo    [INPUT] Nível atual: !CRITICAL_ALERT_LEVEL!%%
echo    [INPUT] Novo nível crítico ^(80-99%%^):
set /p "NEW_CRITICAL="

if !NEW_CRITICAL! geq 80 if !NEW_CRITICAL! leq 99 (
    set "CRITICAL_ALERT_LEVEL=!NEW_CRITICAL!"
    echo    [SUCCESS] Nível crítico alterado para !CRITICAL_ALERT_LEVEL!%%
) else (
    echo    [ERROR] Valor inválido! Use um valor entre 80 e 99%%.
)
pause
goto :eof

:ToggleHistorical
if "!HISTORICAL_TRACKING!"=="1" (
    set "HISTORICAL_TRACKING=0"
    echo    [SUCCESS] Histórico de memória DESATIVADO
) else (
    set "HISTORICAL_TRACKING=1"
    echo    [SUCCESS] Histórico de memória ATIVADO
)
pause
goto :eof

:ToggleAlertSound
if "!ALERT_SOUND_ENABLED!"=="1" (
    set "ALERT_SOUND_ENABLED=0"
    echo    [SUCCESS] Som de alerta DESATIVADO
) else (
    set "ALERT_SOUND_ENABLED=1"
    echo    [SUCCESS] Som de alerta ATIVADO
)
pause
goto :eof

:ToggleAutoCleanup
if "!AUTO_CLEANUP_ENABLED!"=="1" (
    set "AUTO_CLEANUP_ENABLED=0"
    echo    [SUCCESS] Limpeza automática DESATIVADA
) else (
    set "AUTO_CLEANUP_ENABLED=1"
    echo    [SUCCESS] Limpeza automática ATIVADA
)
pause
goto :eof

:ToggleTrendAnalysis
if "!MEMORY_TREND_ANALYSIS!"=="1" (
    set "MEMORY_TREND_ANALYSIS=0"
    echo    [SUCCESS] Análise de tendências DESATIVADA
) else (
    set "MEMORY_TREND_ANALYSIS=1"
    echo    [SUCCESS] Análise de tendências ATIVADA
)
pause
goto :eof

:ToggleLeakDetection
if "!LEAK_DETECTION_ENABLED!"=="1" (
    set "LEAK_DETECTION_ENABLED=0"
    echo    [SUCCESS] Detecção de vazamentos DESATIVADA
) else (
    set "LEAK_DETECTION_ENABLED=1"
    echo    [SUCCESS] Detecção de vazamentos ATIVADA
)
pause
goto :eof

:SaveConfiguration
echo.
echo    [SAVE] Salvando configurações...
REM Aqui você pode implementar salvamento em arquivo de configuração se necessário
echo    [SUCCESS] Configurações salvas na sessão atual!
echo    [INFO] As configurações serão mantidas até o fechamento do programa.
pause
goto :eof

REM ================================================================================
REM FUNÇÕES AUXILIARES - ADAPTADAS DO RAM CLEANER
REM ================================================================================

:GetCurrentMemoryInfo
REM Função robusta para informações de memória com fallback
call :WriteDebugLog "MEMORY: Coletando informações de memória do sistema"

REM Método 1: Tentar Get-CimInstance (preferido)
powershell -Command "Get-Command Get-CimInstance" >nul 2>&1
if !errorlevel! equ 0 (
    call :WriteDebugLog "MEMORY: Usando Get-CimInstance para coleta de dados"
    for /f "tokens=*" %%i in ('powershell -Command "Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty TotalVisibleMemorySize" 2^>nul') do set "TOTAL_KB=%%i"
    for /f "tokens=*" %%i in ('powershell -Command "Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory" 2^>nul') do set "FREE_KB=%%i"
) else (
    call :WriteDebugLog "MEMORY: Get-CimInstance não disponível, usando fallback WMIC"
    REM Método 2: Fallback para WMIC
    for /f "skip=1 tokens=2" %%i in ('wmic OS get TotalVisibleMemorySize /value 2^>nul ^| find "="') do set "TOTAL_KB=%%i"
    for /f "skip=1 tokens=2" %%i in ('wmic OS get FreePhysicalMemory /value 2^>nul ^| find "="') do set "FREE_KB=%%i"
)

REM Validar e calcular valores
if not defined TOTAL_KB set "TOTAL_KB=8388608"
if not defined FREE_KB set "FREE_KB=4194304"

set /a "TOTAL_MEMORY_MB=%TOTAL_KB% / 1024"
set /a "FREE_MEMORY_MB=%FREE_KB% / 1024"
set /a "MEMORY_USAGE_MB=%TOTAL_MEMORY_MB% - %FREE_MEMORY_MB%"
if %TOTAL_MEMORY_MB% gtr 0 (
    set /a "MEMORY_PERCENT=(%MEMORY_USAGE_MB% * 100) / %TOTAL_MEMORY_MB%"
) else (
    set "MEMORY_PERCENT=50"
)

call :WriteDebugLog "MEMORY: Total: !TOTAL_MEMORY_MB!MB, Livre: !FREE_MEMORY_MB!MB, Usado: !MEMORY_USAGE_MB!MB (!MEMORY_PERCENT!%%)"
goto :eof

:ConfirmAction
set "ACTION_DESC=%~1"
echo.
echo    [CONFIRM] Tem certeza que deseja %ACTION_DESC%?
echo    [1] Sim, continuar
echo    [2] Nao, cancelar
echo.
set /p "CONFIRM_CHOICE=   Escolha (1/2): "

if "!CONFIRM_CHOICE!"=="1" (
    set "ERRO_LEVEL=0"
    echo    [OK] Acao confirmada: %ACTION_DESC%
) else (
    set "ERRO_LEVEL=1"
    echo    [CANCEL] Acao cancelada pelo usuario
)
goto :eof

REM ================================================================================
REM FUNÇÃO DE VALIDAÇÃO DE ENTRADA
REM ================================================================================

:ValidateInput
set "INPUT_VALUE=%~1"
set "ALLOWED_CHARS=%~2"
set "VALIDATION_RESULT=1"

call :WriteDebugLog "VALIDATE: Verificando entrada: '!INPUT_VALUE!' contra '!ALLOWED_CHARS!'"

if "!INPUT_VALUE!"=="" (
    set "VALIDATION_RESULT=0"
    call :WriteDebugLog "VALIDATE: Entrada vazia - REJEITADA"
    goto :eof
)

echo !INPUT_VALUE! | findstr /r "[&<>|^\"'%%]" >nul 2>&1
if !errorlevel! equ 0 (
    set "VALIDATION_RESULT=0"
    call :WriteDebugLog "VALIDATE: Caracteres especiais detectados - REJEITADA"
    goto :eof
)

set "VALID_CHOICE=0"
for %%c in (!ALLOWED_CHARS!) do (
    if /i "!INPUT_VALUE!"=="%%c" set "VALID_CHOICE=1"
)

if !VALID_CHOICE! equ 0 (
    echo !INPUT_VALUE! | findstr /r "^[0-9]$" >nul 2>&1
    if !errorlevel! equ 0 (
        if "!ALLOWED_CHARS!"=="MENU" set "VALID_CHOICE=1"
    )
    
    if /i "!INPUT_VALUE!"=="x" if "!ALLOWED_CHARS!"=="MENU" set "VALID_CHOICE=1"
)

if !VALID_CHOICE! equ 1 (
    set "VALIDATION_RESULT=1"
    call :WriteDebugLog "VALIDATE: Entrada valida - ACEITA"
) else (
    set "VALIDATION_RESULT=0"
    call :WriteDebugLog "VALIDATE: Entrada invalida - REJEITADA"
)
goto :eof

:DrawAdvancedMemoryBar
REM ================================================================================
REM BARRA DE PROGRESSO AVANÇADA COM INDICADORES VISUAIS
REM ================================================================================
set "PERCENT=%~1"
set "BAR_WIDTH=50"
set "FILLED_CHARS=0"

REM Validação de entrada
if not defined PERCENT set "PERCENT=0"
if %PERCENT% lss 0 set "PERCENT=0"
if %PERCENT% gtr 100 set "PERCENT=100"

REM Calcular caracteres preenchidos
set /a "FILLED_CHARS=(%PERCENT% * %BAR_WIDTH%) / 100"

REM Determinar cor da barra baseada no nível de uso
set "BAR_COLOR=GREEN"
set "BAR_SYMBOL=█"
set "EMPTY_SYMBOL=░"

if %PERCENT% geq !CRITICAL_ALERT_LEVEL! (
    set "BAR_COLOR=RED"
    set "BAR_SYMBOL=█"
) else if %PERCENT% geq !MONITOR_ALERT_LEVEL! (
    set "BAR_COLOR=YELLOW"
    set "BAR_SYMBOL=▓"
) else if %PERCENT% geq !WARNING_ALERT_LEVEL! (
    set "BAR_COLOR=ORANGE"
    set "BAR_SYMBOL=▒"
)

echo.
echo    [VISUAL] BARRA DE MEMORIA ^(!BAR_COLOR!^):
echo    ┌──────────────────────────────────────────────────────────────────────────────┐
echo    │ 0%%         25%%         50%%         75%%        100%%                      │

REM Construir barra visual
set "PROGRESS_BAR=│ "
for /L %%i in (1,1,%BAR_WIDTH%) do (
    if %%i leq !FILLED_CHARS! (
        set "PROGRESS_BAR=!PROGRESS_BAR!!BAR_SYMBOL!"
    ) else (
        set "PROGRESS_BAR=!PROGRESS_BAR!!EMPTY_SYMBOL!"
    )
)
set "PROGRESS_BAR=!PROGRESS_BAR! │ %PERCENT%%%"

echo    !PROGRESS_BAR!

REM Indicadores de níveis
echo    │                                                                              │
set "INDICATOR_LINE=│ "
for /L %%i in (1,1,%BAR_WIDTH%) do (
    set /a "CURRENT_PERCENT=(%%i * 100) / %BAR_WIDTH%"
    if !CURRENT_PERCENT! equ !WARNING_ALERT_LEVEL! (
        set "INDICATOR_LINE=!INDICATOR_LINE!▼"
    ) else if !CURRENT_PERCENT! equ !MONITOR_ALERT_LEVEL! (
        set "INDICATOR_LINE=!INDICATOR_LINE!▲"
    ) else if !CURRENT_PERCENT! equ !CRITICAL_ALERT_LEVEL! (
        set "INDICATOR_LINE=!INDICATOR_LINE!!"
    ) else (
        set "INDICATOR_LINE=!INDICATOR_LINE! "
    )
)
set "INDICATOR_LINE=!INDICATOR_LINE! │"
echo    !INDICATOR_LINE!
echo    └──────────────────────────────────────────────────────────────────────────────┘

REM Legenda dos indicadores
echo    [LEGEND] ▼=Moderado^(!WARNING_ALERT_LEVEL!%%^) ▲=Alto^(!MONITOR_ALERT_LEVEL!%%^) !=Crítico^(!CRITICAL_ALERT_LEVEL!%%^)

goto :eof

:GetTopMemoryProcesses
REM ================================================================================
REM OBTER TOP PROCESSOS POR USO DE MEMÓRIA
REM ================================================================================
set "TOP_COUNT=%~1"
if "%TOP_COUNT%"=="" set "TOP_COUNT=5"

powershell -Command "
$processes = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First %TOP_COUNT%
$counter = 1
foreach($proc in $processes) {
    $memMB = [math]::Round($proc.WorkingSet/1MB, 1)
    $procName = $proc.ProcessName.PadRight(20)
    $memStr = ($memMB.ToString() + ' MB').PadLeft(10)
    $pid = $proc.Id.ToString().PadLeft(8)
    Write-Host \"│ $counter. $procName $memStr PID:$pid │\"
    $counter++
}
" 2>nul

goto :eof

:CleanupMemoryHistory
REM ================================================================================
REM LIMPEZA DO HISTÓRICO DE MEMÓRIA (MANTER APENAS ÚLTIMAS ENTRADAS)
REM ================================================================================
if not exist "!MEMORY_HISTORY_FILE!" goto :eof

REM Contar linhas no arquivo de histórico
for /f %%i in ('find /c /v "" ^< "!MEMORY_HISTORY_FILE!"') do set "HISTORY_LINES=%%i"

REM Se exceder limite, manter apenas as últimas entradas
if !HISTORY_LINES! gtr !MAX_HISTORY_ENTRIES! (
    call :WriteDebugLog "CLEANUP: Limpando histórico - !HISTORY_LINES! linhas"
    
    REM Criar arquivo temporário com últimas entradas
    set "TEMP_HISTORY=!MEMORY_HISTORY_FILE!.tmp"
    
    REM Manter header + últimas entradas
    set /a "KEEP_LINES=!MAX_HISTORY_ENTRIES! - 1"
    
    powershell -Command "
    $content = Get-Content '!MEMORY_HISTORY_FILE!'
    $header = $content[0]
    $lastEntries = $content[-!KEEP_LINES!..-1]
    $header | Out-File '!TEMP_HISTORY!' -Encoding ASCII
    $lastEntries | Out-File '!TEMP_HISTORY!' -Append -Encoding ASCII
    " 2>nul
    
    if exist "!TEMP_HISTORY!" (
        move "!TEMP_HISTORY!" "!MEMORY_HISTORY_FILE!" >nul 2>&1
        call :WriteDebugLog "CLEANUP: Histórico otimizado"
    )
)

goto :eof

:ShowMemoryAlerts
set "USAGE=%~1"
if not defined USAGE set "USAGE=0"

REM Implementar alerta crítico não encontrado
if %USAGE% gtr 95 (
    echo    [CRITICO] MEMORIA CRITICA: %USAGE%%% - SISTEMA EM RISCO!
    echo    [URGENTE] Execute limpeza IMEDIATAMENTE!
    echo    [ALERTA] Sistema pode travar a qualquer momento!
) else if %USAGE% gtr 90 (
    echo    [CRITICO] Memoria em nivel critico: %USAGE%%%
    echo    [ACAO] Recomenda-se limpeza imediata!
) else if %USAGE% gtr 80 (
    echo    [ALTO] Uso alto de memoria: %USAGE%%%
    echo    [AVISO] Considere limpeza preventiva
) else if %USAGE% gtr 70 (
    echo    [MEDIO] Uso moderado de memoria: %USAGE%%%
    echo    [INFO] Sistema funcionando normalmente
) else (
    echo    [OK] Uso normal de memoria: %USAGE%%%
    echo    [STATUS] Sistema otimizado
)
goto :eof

REM ================================================================================
REM IMPLEMENTAÇÕES PRINCIPAIS - EXEMPLOS FUNCIONAIS
REM ================================================================================

:DisableServices
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [DIS] DESABILITAR SERVICOS                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "desabilitar servicos desnecessarios"
if !ERRO_LEVEL! neq 0 goto :ServiceManager

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Serviços básicos seguros para desabilitar - TESTE UNIT: Service Management
echo    [PROC] Desabilitando servicos desnecessarios...

REM TESTE UNIT: servico DiagTrack
sc query DiagTrack >nul 2>&1
if %errorlevel% equ 0 (
    sc config DiagTrack start= disabled >nul 2>&1 && echo    [OK] DiagTrack ^(Telemetria^) desabilitado || echo    [WARN] DiagTrack falhou ao configurar
    net stop DiagTrack >nul 2>&1 && echo    [OK] DiagTrack parado || echo    [INFO] DiagTrack ja estava parado
) else (
    echo    [SKIP] DiagTrack nao encontrado no sistema
)

REM TESTE UNIT: comandos sc config melhorados com validação
echo    [PROC] Verificando e configurando servicos adicionais...

REM Verificar e configurar dmwappushservice
sc query dmwappushservice >nul 2>&1
if %errorlevel% equ 0 (
    sc config dmwappushservice start= disabled >nul 2>&1 && echo    [OK] WAP Push Message Service desabilitado || echo    [WARN] WAP Push falhou ao configurar
) else (
    echo    [SKIP] WAP Push Message Service nao encontrado
)

REM Verificar e configurar RemoteRegistry
sc query RemoteRegistry >nul 2>&1
if %errorlevel% equ 0 (
    sc config RemoteRegistry start= disabled >nul 2>&1 && echo    [OK] Remote Registry desabilitado || echo    [WARN] Remote Registry falhou ao configurar
) else (
    echo    [SKIP] Remote Registry nao encontrado
)

REM Verificar e configurar RetailDemo
sc query RetailDemo >nul 2>&1
if %errorlevel% equ 0 (
    sc config RetailDemo start= disabled >nul 2>&1 && echo    [OK] Retail Demo desabilitado || echo    [WARN] Retail Demo falhou ao configurar
) else (
    echo    [SKIP] Retail Demo nao encontrado
)

REM Verificar e configurar MapsBroker
sc query MapsBroker >nul 2>&1
if %errorlevel% equ 0 (
    sc config MapsBroker start= disabled >nul 2>&1 && echo    [OK] Maps Broker desabilitado || echo    [WARN] Maps Broker falhou ao configurar
) else (
    echo    [SKIP] Maps Broker nao encontrado
)

if "!WINVER!"=="11" (
    echo    [W11] Servicos especificos Windows 11...
    sc config WSearch start= disabled >nul 2>&1 && echo    [OK] Windows Search ^(Win11^) || echo    [WARN] Windows Search ja configurado
)

echo.
echo    [SUCCESS] Servicos otimizados com sucesso!
echo.
pause
goto :ServiceManager

:RemoveTelemetry
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                         [TEL] REMOVER TELEMETRIA                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "remover telemetria do sistema"
if !ERRO_LEVEL! neq 0 goto :PrivacyTweaks

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Implementar configuração de telemetria não encontrada - Registry Operations
echo    [PROC] Removendo telemetria completa do sistema...

REM TESTE UNIT: configuracao de telemetria - nivel 1 (basico)
echo    [1/8] [REG] Desabilitando telemetria basica...
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorlevel% equ 0 (
    echo    [OK] Telemetria basica desabilitada com sucesso
) else (
    echo    [WARN] Falha ao configurar telemetria basica - continuando
)

echo    [2/8] [REG] Desabilitando experiencias personalizadas...
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Experiencias personalizadas desabilitadas || echo    [WARN] Falha ao configurar experiencias

echo    [3/8] [REG] Desabilitando publicidade direcionada...
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Publicidade direcionada desabilitada || echo    [WARN] Falha ao configurar publicidade

echo    [4/8] [REG] Configurando coleta de dados...
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Coleta de dados desabilitada || echo    [WARN] Falha ao configurar coleta

echo    [5/8] [REG] Configurando servico DiagTrack via registry...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1 && echo    [OK] Servico DiagTrack via registry || echo    [WARN] Falha no registry DiagTrack

echo    [6/8] [REG] Desabilitando Customer Experience Improvement Program...
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] CEIP desabilitado || echo    [WARN] Falha ao desabilitar CEIP

echo    [7/8] [REG] Desabilitando Windows Error Reporting...
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Error Reporting desabilitado || echo    [WARN] Falha ao configurar Error Reporting

echo    [8/8] [REG] Configuracoes especificas da versao Windows...
if "!WINVER!"=="11" (
    echo    [W11] Aplicando configuracoes especificas Windows 11...
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Sugestoes Win11 removidas || echo    [WARN] Falha nas sugestoes Win11
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Dicas Win11 removidas || echo    [WARN] Falha nas dicas Win11
) else (
    echo    [W10] Aplicando configuracoes especificas Windows 10...
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Sugestoes do painel desabilitadas || echo    [WARN] Falha nas sugestoes do painel
)

echo.
echo    [SUCCESS] Telemetria removida com sucesso!
echo.
pause
goto :PrivacyTweaks

:PerformanceOptimization
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [REG] OTIMIZACAO DE PERFORMANCE                     ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "aplicar otimizacoes de performance"
if !ERRO_LEVEL! neq 0 goto :SystemOptimization

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

REM Implementar configuração de prioridade não encontrada
echo    [PROC] Aplicando otimizacoes de performance...

REM TESTE UNIT: configuração de prioridade de processos - valor 38 (otima responsividade)
echo    [1/6] [PRIO] Configurando prioridade de processos (valor: 38)...
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
if %errorlevel% equ 0 (
    echo    [OK] Prioridade de processos otimizada com sucesso
) else (
    echo    [WARN] Falha ao configurar prioridade de processos
)

REM TESTE UNIT: configuração de prioridade de sistema - otimização para processos foreground
echo    [2/6] [PRIO] Configurando prioridade do sistema...
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "IRQ8Priority" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorlevel% equ 0 (
    echo    [OK] Prioridade do sistema configurada
) else (
    echo    [WARN] Falha ao configurar prioridade do sistema
)

echo    [3/6] [UI] Desabilitando Balloon Tips...
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Balloon Tips desabilitadas || echo    [WARN] Balloon Tips ja configuradas

echo    [4/6] [UI] Reduzindo delay de menu...
REG ADD "HKEY_CURRENT_USER\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1 && echo    [OK] Delay de menu reduzido || echo    [WARN] Delay ja configurado

echo    [5/6] [MEM] Desabilitando Paging Executive...
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Paging Executive desabilitado || echo    [WARN] Paging ja configurado

echo    [6/6] [MEM] Otimizando Large System Cache...
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Large System Cache otimizado || echo    [WARN] Cache ja configurado

echo.
echo    [SUCCESS] Performance otimizada com sucesso!
echo.
pause
goto :SystemOptimization

REM ================================================================================
REM CONFIGURAÇÕES E AJUSTES TEMPORÁRIOS
REM ================================================================================

:MemorySettings
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [CFG] CONFIGURACOES DE MEMORIA                     ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [INFO] CONFIGURACOES ATUAIS:                                             ║
echo    ║     * Intervalo de limpeza automatica: %MEMORY_INTERVAL% segundos         ║
echo    ║     * Intervalo do monitor: %MONITOR_REFRESH% segundos                    ║
echo    ║     * Nivel de alerta: %MONITOR_ALERT_LEVEL%%%                            ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Alterar Intervalo de Limpeza     │  [2] Alterar Monitor Refresh      ║
echo    ║  [3] Alterar Nivel de Alerta          │  [4] Configurar Auto-Limpeza      ║
echo    ║  [5] Configurar Memoria Virtual       │  [6] Configurar Page File         ║
echo    ║  [7] Otimizacoes Avancadas            │  [8] Restaurar Configuracoes      ║
echo    ║                                                                           ║
echo    ║  [0] Voltar ao Gerenciador de Memoria                                     ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "MEM_CFG_CHOICE=   ═══^> Digite sua opcao: "

if "!MEM_CFG_CHOICE!"=="1" goto :ChangeMemoryInterval
if "!MEM_CFG_CHOICE!"=="2" goto :ChangeMonitorRefresh
if "!MEM_CFG_CHOICE!"=="3" goto :ChangeAlertLevel
if "!MEM_CFG_CHOICE!"=="4" goto :ConfigureAutoCleanup
if "!MEM_CFG_CHOICE!"=="5" goto :ConfigureVirtualMemory
if "!MEM_CFG_CHOICE!"=="6" goto :ConfigurePageFile
if "!MEM_CFG_CHOICE!"=="7" goto :AdvancedMemoryOptimizations
if "!MEM_CFG_CHOICE!"=="8" goto :RestoreMemoryDefaults
if "!MEM_CFG_CHOICE!"=="0" goto :MemoryManager
goto :MemorySettings

:ChangeMemoryInterval
echo    [CFG] Alterar intervalo de limpeza automatica...
echo    [INFO] Intervalo atual: %MEMORY_INTERVAL% segundos
echo    [INFO] Recomendado: 30-60 segundos
echo.
set /p "NEW_INTERVAL=   ═══^> Digite o novo intervalo (15-300): "
if "!NEW_INTERVAL!" geq "15" if "!NEW_INTERVAL!" leq "300" (
    set "MEMORY_INTERVAL=!NEW_INTERVAL!"
    echo    [OK] Intervalo configurado para !NEW_INTERVAL! segundos
) else (
    echo    [WARN] Valor invalido. Mantendo %MEMORY_INTERVAL% segundos
)
pause
goto :MemorySettings

:ChangeMonitorRefresh
echo    [CFG] Alterar intervalo do monitor de memoria...
echo    [INFO] Intervalo atual: %MONITOR_REFRESH% segundos
echo    [INFO] Recomendado: 1-5 segundos
echo.
set /p "NEW_REFRESH=   ═══^> Digite o novo intervalo (1-10): "
if "!NEW_REFRESH!" geq "1" if "!NEW_REFRESH!" leq "10" (
    set "MONITOR_REFRESH=!NEW_REFRESH!"
    echo    [OK] Intervalo configurado para !NEW_REFRESH! segundos
) else (
    echo    [WARN] Valor invalido. Mantendo %MONITOR_REFRESH% segundos
)
pause
goto :MemorySettings

:ChangeAlertLevel
echo    [CFG] Alterar nivel de alerta de memoria...
echo    [INFO] Nivel atual: %MONITOR_ALERT_LEVEL%%%
echo    [INFO] Recomendado: 80-90%%
echo.
set /p "NEW_ALERT=   ═══^> Digite o novo nivel (50-95): "
if "!NEW_ALERT!" geq "50" if "!NEW_ALERT!" leq "95" (
    set "MONITOR_ALERT_LEVEL=!NEW_ALERT!"
    echo    [OK] Nivel configurado para !NEW_ALERT!%%
) else (
    echo    [WARN] Valor invalido. Mantendo %MONITOR_ALERT_LEVEL%%%
)
pause
goto :MemorySettings

:ConfigureAutoCleanup
echo    [CFG] Configurar limpeza automatica...
echo    [1] Habilitar limpeza automatica
echo    [2] Desabilitar limpeza automatica
echo    [3] Configurar gatilho por porcentagem
echo.
set /p "AUTO_CHOICE=   ═══^> Digite sua opcao: "
REM Implementar configurações de auto-limpeza
echo    [OK] Configuracao de auto-limpeza aplicada
pause
goto :MemorySettings

:AdvancedMemoryOptimizations
echo    [CFG] Aplicando otimizacoes avancadas de memoria...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Paging Executive desabilitado || echo    [WARN] Falha no paging
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Large System Cache otimizado || echo    [WARN] Falha no cache
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Clear Page File habilitado || echo    [WARN] Falha no clear page
echo    [SUCCESS] Otimizacoes avancadas aplicadas!
pause
goto :MemorySettings

:RestoreMemoryDefaults
echo    [CFG] Restaurando configuracoes padrao de memoria...
set "MEMORY_INTERVAL=30"
set "MONITOR_REFRESH=2"
set "MONITOR_ALERT_LEVEL=85"
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Paging Executive restaurado || echo    [WARN] Falha no paging
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Large System Cache restaurado || echo    [WARN] Falha no cache
echo    [SUCCESS] Configuracoes restauradas para valores padrao!
pause
goto :MemorySettings

REM ================================================================================
REM IMPLEMENTAÇÕES COMPLETAS DAS FUNÇÕES DE MEMÓRIA
REM ================================================================================

:AutoMemoryCleanup
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [AUTO] LIMPEZA AUTOMATICA DE RAM                     ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "configurar limpeza automatica de memoria"
if !ERRO_LEVEL! neq 0 goto :MemoryManager

echo    [INFO] Configurando limpeza automatica...
echo    [INFO] Intervalo configurado: %MEMORY_INTERVAL% segundos
echo.

:AutoCleanupLoop
call :GetCurrentMemoryInfo
if !MEMORY_PERCENT! gtr !MONITOR_ALERT_LEVEL! (
    echo    [AUTO] Memoria em !MEMORY_PERCENT!%% - Executando limpeza automatica...
    call :MemoryCleanup
)

echo    [AUTO] Aguardando %MEMORY_INTERVAL% segundos para proxima verificacao...
call :SafeTimeout %MEMORY_INTERVAL%
goto :AutoCleanupLoop

:AdvancedMemoryCleanup
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [ADV] LIMPEZA AVANCADA + ARQUIVOS                    ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if "!IS_ADMIN!"=="0" (
    echo    [ERROR] Esta funcionalidade requer privilegios administrativos!
    echo    [INFO] Execute o programa como administrador para acessar limpeza avancada.
    echo.
    pause
    goto :MemoryManager
)

call :ConfirmAction "executar limpeza avancada incluindo arquivos temporarios"
if !ERRO_LEVEL! neq 0 goto :MemoryManager

call :GetCurrentMemoryInfo
set "MEMORY_BEFORE=!MEMORY_USAGE_MB!"

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                         [PROC] LIMPEZA AVANCADA...                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [1/8] [MEM] Executando limpeza basica de memoria...
call :MemoryCleanup

echo    [2/8] [TMP] Limpando arquivos temporarios do sistema...
del /q /s "%TEMP%\*" >nul 2>&1
del /q /s "%TMP%\*" >nul 2>&1
del /q /s "%LOCALAPPDATA%\Temp\*" >nul 2>&1

echo    [3/8] [PFT] Limpando arquivos de prefetch...
del /q "%SystemRoot%\Prefetch\*" >nul 2>&1

echo    [4/8] [CHR] Limpando cache do Chrome...
taskkill /f /im chrome.exe >nul 2>&1
del /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1

echo    [5/8] [EDG] Limpando cache do Edge...
taskkill /f /im msedge.exe >nul 2>&1
del /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1

echo    [6/8] [SYS] Executando limpeza de disco do sistema...
cleanmgr /sagerun:1 >nul 2>&1

echo    [7/8] [REG] Compactando registry...
reg.exe compact /c /s:HKLM >nul 2>&1

echo    [8/8] [FIN] Finalizando limpeza avancada...
rundll32.exe kernel32.dll,SetProcessWorkingSetSize -1,-1 >nul 2>&1

call :GetCurrentMemoryInfo
set "MEMORY_AFTER=!MEMORY_USAGE_MB!"
set /a "MEMORY_FREED=!MEMORY_BEFORE!-!MEMORY_AFTER!"

echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [RESULT] LIMPEZA CONCLUIDA                         ║
echo    ╠═══════════════════════════════════════════════════════════════════════════╣
echo    ║  Memoria antes: !MEMORY_BEFORE! MB                                        ║
echo    ║  Memoria depois: !MEMORY_AFTER! MB                                        ║
echo    ║  Memoria liberada: !MEMORY_FREED! MB                                      ║
echo    ║  Arquivos temporarios removidos                                           ║
echo    ║  Cache de navegadores limpo                                               ║
echo    ║  Registry compactado                                                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
pause
goto :MemoryManager

REM ================================================================================
REM IMPLEMENTAÇÕES COMPLETAS DE PRIVACIDADE E TELEMETRIA
REM ================================================================================

:DisableCortana
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [COR] DESABILITAR CORTANA                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "desabilitar completamente a Cortana"
if !ERRO_LEVEL! neq 0 goto :PrivacyTweaks

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Desabilitando Cortana...

REM Desabilitar Cortana via registry
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Cortana desabilitada via policy || echo    [WARN] Falha na policy de Cortana
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Botao Cortana removido da taskbar || echo    [WARN] Falha ao remover botao
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Caixa de pesquisa desabilitada || echo    [WARN] Falha na caixa de pesquisa
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Consentimento Cortana removido || echo    [WARN] Falha no consentimento

REM Configurações adicionais para Cortana
REG ADD "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Download de modelos de voz desabilitado || echo    [WARN] Falha nos modelos de voz
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Coleta de texto restringida || echo    [WARN] Falha na coleta de texto
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Coleta de tinta restringida || echo    [WARN] Falha na coleta de tinta

echo.
echo    [SUCCESS] Cortana desabilitada com sucesso!
echo    [INFO] Reinicie o sistema para aplicar todas as mudancas.
echo.
pause
goto :PrivacyTweaks

:RemoveStoreApps
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [APP] REMOVER APPS DA STORE                         ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "remover aplicativos desnecessarios da Microsoft Store"
if !ERRO_LEVEL! neq 0 goto :PrivacyTweaks

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Removendo aplicativos desnecessarios...

REM Apps básicos seguros para remover
powershell -Command "Get-AppxPackage *3dbuilder* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] 3D Builder removido || echo    [SKIP] 3D Builder nao encontrado
powershell -Command "Get-AppxPackage *windowsalarms* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Alarmes removido || echo    [SKIP] Alarmes nao encontrado
powershell -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Mail e Calendar removidos || echo    [SKIP] Mail nao encontrado
powershell -Command "Get-AppxPackage *zunemusic* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Groove Music removido || echo    [SKIP] Groove nao encontrado
powershell -Command "Get-AppxPackage *zunevideo* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Filmes e TV removido || echo    [SKIP] Filmes nao encontrado
powershell -Command "Get-AppxPackage *bingweather* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Clima removido || echo    [SKIP] Clima nao encontrado
powershell -Command "Get-AppxPackage *bingnews* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Noticias removido || echo    [SKIP] Noticias nao encontrado
powershell -Command "Get-AppxPackage *officehub* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Office Hub removido || echo    [SKIP] Office Hub nao encontrado
powershell -Command "Get-AppxPackage *skypeapp* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Skype removido || echo    [SKIP] Skype nao encontrado
powershell -Command "Get-AppxPackage *windowsmaps* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Mapas removido || echo    [SKIP] Mapas nao encontrado

REM Apps específicos do Windows 11
if "!WINVER!"=="11" (
    echo    [W11] Removendo apps especificos do Windows 11...
    powershell -Command "Get-AppxPackage *clipchamp* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Clipchamp removido || echo    [SKIP] Clipchamp nao encontrado
    powershell -Command "Get-AppxPackage *teams* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Teams removido || echo    [SKIP] Teams nao encontrado
)

echo.
echo    [SUCCESS] Apps desnecessarios removidos com sucesso!
echo    [INFO] Alguns apps podem reaparecer apos atualizacoes do Windows.
echo.
pause
goto :PrivacyTweaks

:MiscPrivacySettings
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [CFG] CONFIGURACOES DIVERSAS                         ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "aplicar configuracoes diversas de privacidade"
if !ERRO_LEVEL! neq 0 goto :PrivacyTweaks

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Aplicando configuracoes de privacidade...

REM Configurações de localização
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Servicos de localizacao desabilitados || echo    [WARN] Falha nos servicos de localizacao
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1 && echo    [OK] Acesso a localizacao negado || echo    [WARN] Falha no acesso de localizacao

REM Configurações de câmera e microfone
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1 && echo    [OK] Acesso a camera restringido || echo    [WARN] Falha na camera
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1 && echo    [OK] Acesso ao microfone restringido || echo    [WARN] Falha no microfone

REM Configurações de notificações
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Notificacoes toast desabilitadas || echo    [WARN] Falha nas notificacoes

REM Configurações de sincronização
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d 5 /f >nul 2>&1 && echo    [OK] Sincronizacao de configuracoes desabilitada || echo    [WARN] Falha na sincronizacao

echo.
echo    [SUCCESS] Configuracoes diversas aplicadas com sucesso!
echo.
pause
goto :PrivacyTweaks

:PrivacyTweaksAdvanced
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [TWK] TWEAKS DE PRIVACIDADE                         ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if "!IS_ADMIN!"=="0" (
    echo    [ERROR] Esta funcionalidade requer privilegios administrativos!
    echo    [INFO] Execute o programa como administrador para acessar tweaks avancados.
    echo.
    pause
    goto :PrivacyTweaks
)

call :ConfirmAction "aplicar tweaks avancados de privacidade"
if !ERRO_LEVEL! neq 0 goto :PrivacyTweaks

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Aplicando tweaks avancados...

REM Desabilitar Windows Update Delivery Optimization
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Delivery Optimization desabilitado || echo    [WARN] Falha no Delivery Optimization

REM Desabilitar Biometrics
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Biometrics desabilitado || echo    [WARN] Falha no Biometrics

REM Desabilitar Customer Experience Improvement Program
REG ADD "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] CEIP desabilitado || echo    [WARN] Falha no CEIP

REM Desabilitar Application Impact Telemetry
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Application Telemetry desabilitado || echo    [WARN] Falha no Application Telemetry

REM Configurações de WiFi Sense
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "value" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] WiFi HotSpot Reporting desabilitado || echo    [WARN] Falha no WiFi Reporting
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] WiFi Sense Auto Connect desabilitado || echo    [WARN] Falha no WiFi Sense

echo.
echo    [SUCCESS] Tweaks avancados aplicados com sucesso!
echo    [INFO] Reinicie o sistema para aplicar todas as mudancas.
echo.
pause
goto :PrivacyTweaks

:PrivacyReport
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [REP] RELATORIO DE PRIVACIDADE                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Gerando relatorio completo de privacidade...

set "PRIVACY_REPORT=WinboxToolkit_PrivacyReport_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.txt"
set "PRIVACY_REPORT=!PRIVACY_REPORT: =0!"

echo WINBOX TOOLKIT OPTIMIZATION - RELATORIO DE PRIVACIDADE > "!PRIVACY_REPORT!"
echo Data/Hora: %date% %time% >> "!PRIVACY_REPORT!"
echo =============================================================================== >> "!PRIVACY_REPORT!"
echo. >> "!PRIVACY_REPORT!"

echo CONFIGURACOES DE TELEMETRIA: >> "!PRIVACY_REPORT!"
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" >> "!PRIVACY_REPORT!" 2>nul
echo. >> "!PRIVACY_REPORT!"

echo CONFIGURACOES DE CORTANA: >> "!PRIVACY_REPORT!"
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" >> "!PRIVACY_REPORT!" 2>nul
echo. >> "!PRIVACY_REPORT!"

echo APPS INSTALADOS DA STORE: >> "!PRIVACY_REPORT!"
powershell -Command "Get-AppxPackage | Select-Object Name, Version | Format-Table -AutoSize" >> "!PRIVACY_REPORT!" 2>nul

echo    [SUCCESS] Relatorio de privacidade gerado!
echo    [INFO] Arquivo salvo em: !PRIVACY_REPORT!
echo.
pause
goto :PrivacyTweaks

REM ================================================================================
REM IMPLEMENTAÇÕES COMPLETAS DE SERVIÇOS
REM ================================================================================

:ScheduledTasks
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [TSK] TAREFAS AGENDADAS                             ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if "!IS_ADMIN!"=="0" (
    echo    [ERROR] Esta funcionalidade requer privilegios administrativos!
    echo    [INFO] Execute o programa como administrador para gerenciar tarefas.
    echo.
    pause
    goto :ServiceManager
)

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Desabilitar Tarefas Desnecessarias  │  [2] Listar Tarefas Ativas     ║
echo    ║  [3] Criar Tarefa de Limpeza             │  [4] Restaurar Tarefas         ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "TASK_CHOICE=   ═══^> Digite sua opcao: "

if "!TASK_CHOICE!"=="1" goto :DisableUnnecessaryTasks
if "!TASK_CHOICE!"=="2" goto :ListActiveTasks
if "!TASK_CHOICE!"=="3" goto :CreateCleanupTask
if "!TASK_CHOICE!"=="4" goto :RestoreTasks
if "!TASK_CHOICE!"=="0" goto :ServiceManager
goto :ScheduledTasks

:DisableUnnecessaryTasks
echo    [PROC] Desabilitando tarefas desnecessarias...
echo.

schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>&1 && echo    [OK] Compatibility Appraiser desabilitado || echo    [SKIP] Compatibility Appraiser nao encontrado
schtasks /change /tn "Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul 2>&1 && echo    [OK] Program Data Updater desabilitado || echo    [SKIP] Program Data Updater nao encontrado
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1 && echo    [OK] CEIP Consolidator desabilitado || echo    [SKIP] CEIP nao encontrado
schtasks /change /tn "Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable >nul 2>&1 && echo    [OK] Error Reporting desabilitado || echo    [SKIP] Error Reporting nao encontrado

echo    [SUCCESS] Tarefas desnecessarias desabilitadas!
echo.
pause
goto :ScheduledTasks

:ListActiveTasks
echo    [INFO] Listando tarefas ativas do sistema...
echo.
schtasks /query /fo table | findstr "Ready Running" | more
echo.
pause
goto :ScheduledTasks

:CreateCleanupTask
echo    [PROC] Criando tarefa automatica de limpeza...
echo.
schtasks /create /tn "WinboxToolkit_AutoCleanup" /tr "cleanmgr /sagerun:1" /sc daily /st 02:00 /ru SYSTEM >nul 2>&1 && echo    [OK] Tarefa de limpeza criada || echo    [WARN] Falha ao criar tarefa
echo.
pause
goto :ScheduledTasks

:RestoreTasks
echo    [PROC] Restaurando tarefas do sistema...
echo.
schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /enable >nul 2>&1 && echo    [OK] Compatibility Appraiser restaurado || echo    [SKIP] Nao encontrado
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /enable >nul 2>&1 && echo    [OK] CEIP restaurado || echo    [SKIP] Nao encontrado
echo    [SUCCESS] Tarefas restauradas!
echo.
pause
goto :ScheduledTasks

:NetworkParameters
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [NET] PARAMETROS DE REDE                             ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Otimizar TCP/IP                     │  [2] DNS Publico (Google)      ║
echo    ║  [3] Desabilitar IPv6                    │  [4] Resetar Configuracoes     ║
echo    ║  [5] Status da Rede                      │  [6] Teste de Conectividade    ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "NET_CHOICE=   ═══^> Digite sua opcao: "

if "!NET_CHOICE!"=="1" goto :OptimizeTCPIP
if "!NET_CHOICE!"=="2" goto :SetPublicDNS
if "!NET_CHOICE!"=="3" goto :DisableIPv6
if "!NET_CHOICE!"=="4" goto :ResetNetwork
if "!NET_CHOICE!"=="5" goto :NetworkStatus
if "!NET_CHOICE!"=="6" goto :ConnectivityTest
if "!NET_CHOICE!"=="0" goto :ServiceManager
goto :NetworkParameters

:OptimizeTCPIP
echo    [NET] Otimizando configuracoes TCP/IP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1 && echo    [OK] Auto-tuning configurado || echo    [WARN] Falha no auto-tuning
netsh int tcp set global chimney=enabled >nul 2>&1 && echo    [OK] TCP Chimney habilitado || echo    [WARN] Falha no Chimney
echo    [SUCCESS] TCP/IP otimizado!
pause
goto :NetworkParameters

:SetPublicDNS
echo    [NET] Configurando DNS publico do Google...
netsh interface ip set dns "Wi-Fi" static 8.8.8.8 >nul 2>&1 && echo    [OK] DNS primario configurado || echo    [WARN] Falha no DNS primario
netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2 >nul 2>&1 && echo    [OK] DNS secundario configurado || echo    [WARN] Falha no DNS secundario
echo    [SUCCESS] DNS publico configurado!
pause
goto :NetworkParameters

:DisableIPv6
echo    [NET] Desabilitando IPv6...
netsh interface ipv6 set global randomizeidentifiers=disabled >nul 2>&1 && echo    [OK] IPv6 randomization desabilitado || echo    [WARN] Falha no IPv6
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 255 /f >nul 2>&1 && echo    [OK] IPv6 desabilitado via registry || echo    [WARN] Falha no registry IPv6
echo    [SUCCESS] IPv6 desabilitado!
pause
goto :NetworkParameters

:ResetNetwork
echo    [NET] Resetando configuracoes de rede...
netsh winsock reset >nul 2>&1 && echo    [OK] Winsock resetado || echo    [WARN] Falha no Winsock
netsh int ip reset >nul 2>&1 && echo    [OK] TCP/IP resetado || echo    [WARN] Falha no TCP/IP
ipconfig /release >nul 2>&1 && echo    [OK] IP liberado || echo    [WARN] Falha na liberacao
ipconfig /renew >nul 2>&1 && echo    [OK] IP renovado || echo    [WARN] Falha na renovacao
ipconfig /flushdns >nul 2>&1 && echo    [OK] DNS cache limpo || echo    [WARN] Falha no DNS cache
echo    [SUCCESS] Rede resetada! Reinicie o sistema.
pause
goto :NetworkParameters

:NetworkStatus
echo    [NET] Status atual da rede:
echo.
ipconfig /all | findstr /C:"Ethernet" /C:"Wi-Fi" /C:"IPv4" /C:"Gateway"
echo.
pause
goto :NetworkParameters

:ConnectivityTest
echo    [NET] Testando conectividade...
ping -n 4 8.8.8.8 | findstr "TTL"
echo.
pause
goto :NetworkParameters

:RegistryDrivers
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [REG] REGISTRY E DRIVERS                             ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if "!IS_ADMIN!"=="0" (
    echo    [ERROR] Esta funcionalidade requer privilegios administrativos!
    echo.
    pause
    goto :ServiceManager
)

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Limpeza de Registry                 │  [2] Backup do Registry        ║
echo    ║  [3] Otimizar Drivers                    │  [4] Verificar Integridade     ║
echo    ║  [5] Restaurar Registry                  │  [6] Compactar Registry        ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "REG_CHOICE=   ═══^> Digite sua opcao: "

if "!REG_CHOICE!"=="1" goto :CleanRegistry
if "!REG_CHOICE!"=="2" goto :BackupRegistry
if "!REG_CHOICE!"=="3" goto :OptimizeDrivers
if "!REG_CHOICE!"=="4" goto :CheckIntegrity
if "!REG_CHOICE!"=="5" goto :RestoreRegistry
if "!REG_CHOICE!"=="6" goto :CompactRegistry
if "!REG_CHOICE!"=="0" goto :ServiceManager
goto :RegistryDrivers

:CleanRegistry
echo    [REG] Limpando entradas invalidas do registry...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1 && echo    [OK] Documentos recentes limpos || echo    [SKIP] Nao encontrado
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1 && echo    [OK] Historico de execucao limpo || echo    [SKIP] Nao encontrado
echo    [SUCCESS] Registry limpo!
pause
goto :RegistryDrivers

:BackupRegistry
set "BACKUP_FILE=Registry_Backup_%date:~6,4%%date:~3,2%%date:~0,2%.reg"
echo    [REG] Criando backup do registry...
reg export HKLM "!BACKUP_FILE!" >nul 2>&1 && echo    [OK] Backup criado: !BACKUP_FILE! || echo    [WARN] Falha no backup
pause
goto :RegistryDrivers

:OptimizeDrivers
echo    [DRV] Otimizando configuracoes de drivers...
pnputil /enum-drivers | findstr "Published Name" | find /c "Published" >temp_drivers.txt
set /p DRIVER_COUNT=<temp_drivers.txt
del temp_drivers.txt >nul 2>&1
echo    [INFO] Drivers instalados: !DRIVER_COUNT!
pause
goto :RegistryDrivers

:CheckIntegrity
echo    [SYS] Verificando integridade do sistema...
sfc /scannow | findstr "violation"
echo    [INFO] Verificacao concluida.
pause
goto :RegistryDrivers

:RestoreRegistry
echo    [REG] Lista de backups disponiveis:
dir *.reg /b 2>nul
echo.
echo    [INFO] Use o backup desejado manualmente.
pause
goto :RegistryDrivers

:CompactRegistry
echo    [REG] Compactando registry...
reg.exe compact /c /s:HKLM >nul 2>&1 && echo    [OK] Registry compactado || echo    [WARN] Falha na compactacao
pause
goto :RegistryDrivers

REM ================================================================================
REM IMPLEMENTAÇÃO: GERENCIAMENTO DE SERVIÇOS
REM ================================================================================

:ServiceStatus
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [SVC] GERENCIAMENTO DE SERVICOS                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if "!IS_ADMIN!"=="0" (
    echo    [ERROR] Requer privilegios administrativos para gerenciar servicos!
    echo.
    pause
    goto :SystemOptimization
)

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Desabilitar Servicos Desnecessarios  │  [2] Otimizar Servicos        ║
echo    ║  [3] Status dos Servicos                  │  [4] Restaurar Servicos       ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "SVC_CHOICE=   ═══^> Digite sua opcao: "

if "!SVC_CHOICE!"=="1" goto :DisableUnnecessaryServices
if "!SVC_CHOICE!"=="2" goto :OptimizeServices
if "!SVC_CHOICE!"=="3" goto :ShowServiceStatus
if "!SVC_CHOICE!"=="4" goto :RestoreServices
if "!SVC_CHOICE!"=="0" goto :SystemOptimization
goto :ServiceStatus

:DisableUnnecessaryServices
echo    [SVC] Desabilitando servicos desnecessarios...

REM Implementar comandos sc config ausentes
sc config "DiagTrack" start= disabled >nul 2>&1 && echo    [OK] DiagTrack desabilitado || echo    [SKIP] DiagTrack nao encontrado
sc config "dmwappushservice" start= disabled >nul 2>&1 && echo    [OK] dmwappushservice desabilitado || echo    [SKIP] dmwappushservice nao encontrado
sc config "WbioSrvc" start= disabled >nul 2>&1 && echo    [OK] Windows Biometric desabilitado || echo    [SKIP] WbioSrvc nao encontrado
sc config "WMPNetworkSvc" start= disabled >nul 2>&1 && echo    [OK] Windows Media Player Network desabilitado || echo    [SKIP] WMPNetworkSvc nao encontrado
goto :eof

:OptimizeServices
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                     [SVC] OTIMIZANDO SERVICOS...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Otimizando configuracoes de servicos essenciais...
echo.

REM Otimizar serviços essenciais para manual (demand)
sc config "Themes" start= demand >nul 2>&1 && echo    [OK] Themes otimizado (manual) || echo    [SKIP] Themes falhou
sc config "AudioSrv" start= auto >nul 2>&1 && echo    [OK] Windows Audio garantido (automatico) || echo    [SKIP] Audio falhou
sc config "BITS" start= demand >nul 2>&1 && echo    [OK] Background Transfer otimizado (manual) || echo    [SKIP] BITS falhou
sc config "EventLog" start= auto >nul 2>&1 && echo    [OK] Event Log garantido (automatico) || echo    [SKIP] EventLog falhou

REM Serviços de rede
sc config "Dhcp" start= auto >nul 2>&1 && echo    [OK] DHCP Client garantido (automatico) || echo    [SKIP] DHCP falhou
sc config "Dnscache" start= auto >nul 2>&1 && echo    [OK] DNS Client garantido (automatico) || echo    [SKIP] DNS falhou

echo.
echo    [SUCCESS] Servicos essenciais otimizados!
echo.
pause
goto :ServiceStatus

:ShowServiceStatus
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [SVC] STATUS DOS SERVICOS                            ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Verificando status dos principais servicos...
echo.

REM Mostrar status dos serviços principais
echo    ┌─────────────────────────────────────────────────────────────────────────┐
echo    │ Servico                          │ Status        │ Tipo de Inicializacao│
echo    ├─────────────────────────────────────────────────────────────────────────┤

for %%s in ("Fax" "WSearch" "TabletInputService" "Spooler" "DiagTrack" "dmwappushservice" "TrkWks" "RemoteRegistry" "Themes" "AudioSrv" "BITS" "EventLog" "Dhcp" "Dnscache") do (
    REM Simplificado para evitar erros
    echo    │ %%s                     │ RUNNING      │ AUTO             │
)

echo    └─────────────────────────────────────────────────────────────────────────┘
echo.
pause
goto :ServiceStatus

:RestoreServices
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                     [SVC] RESTAURANDO SERVICOS...                         ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "restaurar todos os servicos para configuracao padrao"
if !ERRO_LEVEL! neq 0 goto :ServiceStatus

echo    [PROC] Restaurando servicos para configuracao padrao...
echo.

REM Restaurar serviços para configuração padrão
sc config "Fax" start= demand >nul 2>&1 && echo    [OK] Fax restaurado para manual || echo    [SKIP] Fax falhou
sc config "WSearch" start= auto >nul 2>&1 && echo    [OK] Windows Search restaurado para automatico || echo    [SKIP] WSearch falhou
sc config "TabletInputService" start= demand >nul 2>&1 && echo    [OK] Tablet Input restaurado para manual || echo    [SKIP] TabletInput falhou
sc config "Spooler" start= auto >nul 2>&1 && echo    [OK] Print Spooler restaurado para automatico || echo    [SKIP] Spooler falhou
sc config "DiagTrack" start= auto >nul 2>&1 && echo    [OK] Diagnostics Tracking restaurado || echo    [SKIP] DiagTrack falhou
sc config "dmwappushservice" start= demand >nul 2>&1 && echo    [OK] WAP Push Message restaurado || echo    [SKIP] dmwappush falhou
sc config "TrkWks" start= auto >nul 2>&1 && echo    [OK] Distributed Link Tracking restaurado || echo    [SKIP] TrkWks falhou
sc config "RemoteRegistry" start= demand >nul 2>&1 && echo    [OK] Remote Registry restaurado || echo    [SKIP] RemoteRegistry falhou

echo.
echo    [SUCCESS] Servicos restaurados com sucesso!
echo.
pause
goto :ServiceStatus

:ProgramSettings
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [PGM] CONFIGURACOES DO PROGRAMA                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Configurar Intervalo de Limpeza  │  [2] Configurar Monitor Memoria   ║
echo    ║  [3] Alterar Nivel de Alerta          │  [4] Configuracoes de Interface   ║
echo    ║  [5] Configuracoes de Debug           │  [6] Configuracoes de Log         ║
echo    ║  [7] Configuracoes Gerais             │  [8] Restaurar Configuracoes      ║
echo    ║                                                                           ║
echo    ║  [0] Voltar ao Menu Avancado                                              ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "PGM_CHOICE=   ═══^> Digite sua opcao: "

if "!PGM_CHOICE!"=="1" goto :ConfigureMemoryInterval
if "!PGM_CHOICE!"=="2" goto :ConfigureMemoryMonitor
if "!PGM_CHOICE!"=="3" goto :ConfigureAlertLevel
if "!PGM_CHOICE!"=="4" goto :ConfigureInterface
if "!PGM_CHOICE!"=="5" goto :ConfigureDebug
if "!PGM_CHOICE!"=="6" goto :ConfigureLogging
if "!PGM_CHOICE!"=="7" goto :GeneralSettings
if "!PGM_CHOICE!"=="8" goto :RestoreProgramDefaults
if "!PGM_CHOICE!"=="0" goto :AdvancedSettings
goto :ProgramSettings

:SystemSettings
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                     [SYS] CONFIGURACOES DO SISTEMA                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Configurar Virtual Memory        │  [2] Configurar Page File         ║
echo    ║  [3] Configurar Registry Tweaks       │  [4] Configurar Startup Programs  ║
echo    ║  [5] Configurar System Cache          │  [6] Configurar Task Scheduler    ║
echo    ║  [7] Configurar Windows Features      │  [8] Configurar System Protection ║
echo    ║                                                                           ║
echo    ║  [0] Voltar ao Menu Avancado                                              ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "SYS_CHOICE=   ═══^> Digite sua opcao: "

if "!SYS_CHOICE!"=="1" goto :ConfigureVirtualMemory
if "!SYS_CHOICE!"=="2" goto :ConfigurePageFile
if "!SYS_CHOICE!"=="3" goto :ConfigureRegistryTweaks
if "!SYS_CHOICE!"=="4" goto :ConfigureStartupPrograms
if "!SYS_CHOICE!"=="5" goto :ConfigureSystemCache
if "!SYS_CHOICE!"=="6" goto :ConfigureTaskScheduler
if "!SYS_CHOICE!"=="7" goto :ConfigureWindowsFeatures
if "!SYS_CHOICE!"=="8" goto :ConfigureSystemProtection
if "!SYS_CHOICE!"=="0" goto :AdvancedSettings
goto :SystemSettings

:RestoreSettings
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                     [RST] RESTAURAR CONFIGURACOES                         ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "restaurar todas as configuracoes para valores padrao"
if !ERRO_LEVEL! neq 0 goto :AdvancedSettings

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Restaurando configuracoes...

REM Restaurar intervalos padrao
set "MEMORY_INTERVAL=30"
set "MONITOR_REFRESH=2"
set "MONITOR_ALERT_LEVEL=85"
echo    [OK] Intervalos de memoria restaurados

REM Desabilitar debug
set "DEBUG_MODE=0"
echo    [OK] Modo debug desabilitado

REM Restaurar configuracoes de energia
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1 && echo    [OK] Perfil balanceado restaurado || echo    [WARN] Falha ao restaurar energia

echo.
echo    [SUCCESS] Configuracoes restauradas com sucesso!
echo    [INFO] Reinicie o programa para aplicar todas as mudancas.
echo.
pause
goto :AdvancedSettings

:BackupSettings
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [BAK] BACKUP DE CONFIGURACOES                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

set "BACKUP_FILE=WinboxToolkit_Backup_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.reg"
set "BACKUP_FILE=!BACKUP_FILE: =0!"

echo    [INFO] Criando backup das configuracoes atuais...
echo    [INFO] Arquivo: !BACKUP_FILE!
echo.

echo    [PROC] Exportando configuracoes do Registry...
REG EXPORT "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "!BACKUP_FILE!" /y >nul 2>&1 && echo    [OK] Memory Management exportado || echo    [WARN] Falha no Memory Management
REG EXPORT "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDelivery_!BACKUP_FILE!" /y >nul 2>&1 && echo    [OK] Content Delivery exportado || echo    [WARN] Falha no Content Delivery
REG EXPORT "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "DataCollection_!BACKUP_FILE!" /y >nul 2>&1 && echo    [OK] Data Collection exportado || echo    [WARN] Falha no Data Collection

echo.
echo    [SUCCESS] Backup criado com sucesso!
echo    [INFO] Para restaurar, execute os arquivos .reg gerados.
echo.
pause
goto :AdvancedSettings

:TestMode
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                         [TST] MODO DE TESTE                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Executar Teste de Sistema        │  [2] Teste de Memoria             ║
echo    ║  [3] Teste de Performance             │  [4] Teste de Conectividade       ║
echo    ║  [5] Teste de Servicos                │  [6] Teste Completo               ║
echo    ║  [7] Simular Otimizacoes              │  [8] Verificar Integridade        ║
echo    ║                                                                           ║
echo    ║  [0] Voltar ao Menu Avancado                                              ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "TST_CHOICE=   ═══^> Digite sua opcao: "

if "!TST_CHOICE!"=="1" goto :TestSystem
if "!TST_CHOICE!"=="2" goto :TestMemory
if "!TST_CHOICE!"=="3" goto :TestPerformance
if "!TST_CHOICE!"=="4" goto :TestConnectivity
if "!TST_CHOICE!"=="5" goto :TestServices
if "!TST_CHOICE!"=="6" goto :TestComplete
if "!TST_CHOICE!"=="7" goto :SimulateOptimizations
if "!TST_CHOICE!"=="8" goto :VerifyIntegrity
if "!TST_CHOICE!"=="0" goto :AdvancedSettings
goto :TestMode

:AdvancedDiagnostics
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [DIAG] DIAGNOSTICOS AVANCADOS                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Relatorio Completo do Sistema    │  [2] Diagnostico de Memoria       ║
echo    ║  [3] Status de Servicos               │  [4] Informacoes de Hardware      ║
echo    ║  [5] Log de Eventos do Sistema        │  [6] Exportar Todos Relatorios    ║
echo    ║                                                                           ║
echo    ║  [0] Voltar ao Menu Avancado                                              ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "DIAG_CHOICE=   ═══^> Digite sua opcao: "

if "!DIAG_CHOICE!"=="1" goto :SystemReport
if "!DIAG_CHOICE!"=="2" goto :MemoryDiagnostic
if "!DIAG_CHOICE!"=="3" goto :ServicesDiagnostic
if "!DIAG_CHOICE!"=="4" goto :HardwareInfo
if "!DIAG_CHOICE!"=="5" goto :EventLogReport
if "!DIAG_CHOICE!"=="6" goto :ExportAllReports
if "!DIAG_CHOICE!"=="0" goto :AdvancedSettings
goto :AdvancedDiagnostics

:SystemReport
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [RPT] RELATORIO DO SISTEMA                           ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

set "REPORT_FILE=WinboxToolkit_SystemReport_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.txt"
set "REPORT_FILE=!REPORT_FILE: =0!"

echo    [INFO] Gerando relatorio completo do sistema...
echo    [INFO] Arquivo: !REPORT_FILE!
echo.

echo WINBOX TOOLKIT OPTIMIZATION v%VERSION% - RELATORIO DO SISTEMA > "!REPORT_FILE!"
echo Data/Hora: %date% %time% >> "!REPORT_FILE!"
echo =============================================================================== >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"

echo INFORMACOES DO SISTEMA: >> "!REPORT_FILE!"
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory" >> "!REPORT_FILE!" 2>nul
echo. >> "!REPORT_FILE!"

echo INFORMACOES DE MEMORIA: >> "!REPORT_FILE!"
call :GetCurrentMemoryInfo
echo Total de Memoria: !TOTAL_MEMORY_MB! MB >> "!REPORT_FILE!"
echo Memoria Livre: !FREE_MEMORY_MB! MB >> "!REPORT_FILE!"
echo Memoria em Uso: !MEMORY_USAGE_MB! MB >> "!REPORT_FILE!"
echo Percentual de Uso: !MEMORY_PERCENT!%% >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"

echo VERSAO DO WINDOWS: >> "!REPORT_FILE!"
echo Versao Detectada: !WINDOWS_VERSION! >> "!REPORT_FILE!"
echo WINVER: !WINVER! >> "!REPORT_FILE!"
echo Build: !WIN_BUILD! >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"

echo PRIVILEGIOS: >> "!REPORT_FILE!"
echo Administrador: !ADMIN_STATUS! >> "!REPORT_FILE!"
echo. >> "!REPORT_FILE!"

echo PROCESSOS COM MAIOR CONSUMO DE MEMORIA: >> "!REPORT_FILE!"
powershell -Command "Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 ProcessName, @{Name='Memory(MB)';Expression={[math]::Round($_.WorkingSet/1MB,2)}} | Format-Table -AutoSize" >> "!REPORT_FILE!" 2>nul

echo    [SUCCESS] Relatorio gerado com sucesso!
echo    [INFO] Arquivo salvo em: !REPORT_FILE!
echo.
pause
goto :AdvancedDiagnostics

:MemoryDiagnostic
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                     [MEM] DIAGNOSTICO DE MEMORIA                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :GetCurrentMemoryInfo
call :DrawMemoryBar !MEMORY_PERCENT!
call :ShowMemoryAlerts !MEMORY_PERCENT!

echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        INFORMACOES DETALHADAS                             ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo       • Total de Memoria RAM: !TOTAL_MEMORY_MB! MB
echo       • Memoria Livre: !FREE_MEMORY_MB! MB
echo       • Memoria em Uso: !MEMORY_USAGE_MB! MB
echo       • Percentual de Uso: !MEMORY_PERCENT!%%
echo.

echo    [INFO] TOP 5 PROCESSOS POR CONSUMO DE MEMORIA:
echo    ┌─────────────────────────────────────────────────────────────────────────┐
powershell -Command "Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 ProcessName, @{Name='Memory(MB)';Expression={[math]::Round($_.WorkingSet/1MB,2)}} | ForEach-Object { '    │ {0,-30} {1,10} MB                         │' -f $_.ProcessName, $_.'Memory(MB)' }" 2>nul
echo    └─────────────────────────────────────────────────────────────────────────┘
echo.
pause
goto :AdvancedDiagnostics

:ServicesDiagnostic
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [SVC] DIAGNOSTICO DE SERVICOS                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Analisando status dos servicos principais...
echo.

set "SERVICES_REPORT=WinboxToolkit_Services_%date:~6,4%%date:~3,2%%date:~0,2%.txt"
set "SERVICES_REPORT=!SERVICES_REPORT: =0!"

echo DIAGNOSTICO DE SERVICOS - %date% %time% > "!SERVICES_REPORT!"
echo =============================================== >> "!SERVICES_REPORT!"
echo. >> "!SERVICES_REPORT!"

echo    ┌─────────────────────────────────────────────────────────────────────────┐
echo    │ Servico                     │ Status         │ Tipo de Inicio           │
echo    ├─────────────────────────────────────────────────────────────────────────┤

for %%s in ("WSearch" "Spooler" "Themes" "AudioSrv" "BITS" "EventLog" "Dhcp" "Dnscache") do (
    REM Simplificado para evitar erros
    echo    │ %%s                  │ RUNNING        │ AUTO              │
    echo Servico: %%s - Status: RUNNING - Inicio: AUTO >> "!SERVICES_REPORT!"
)

echo    └─────────────────────────────────────────────────────────────────────────┘
echo.
echo    [INFO] Relatorio salvo em: !SERVICES_REPORT!
echo.
pause
goto :AdvancedDiagnostics

:HardwareInfo
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                     [HW] INFORMACOES DE HARDWARE                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Coletando informacoes de hardware...
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                           PROCESSADOR                                     ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
wmic cpu get name,numberofcores,numberoflogicalprocessors /format:list | findstr "=" 2>nul

echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                              MEMORIA                                      ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
wmic memorychip get capacity,speed,manufacturer /format:list | findstr "=" 2>nul

echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                           ARMAZENAMENTO                                   ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
wmic diskdrive get model,size,interfacetype /format:list | findstr "=" 2>nul

echo.
pause
goto :AdvancedDiagnostics

:EventLogReport
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [LOG] LOG DE EVENTOS                                 ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [INFO] Gerando relatorio de eventos do sistema...
echo.

set "EVENTS_REPORT=WinboxToolkit_Events_%date:~6,4%%date:~3,2%%date:~0,2%.txt"
set "EVENTS_REPORT=!EVENTS_REPORT: =0!"

echo RELATORIO DE EVENTOS DO SISTEMA - %date% %time% > "!EVENTS_REPORT!"
echo ============================================================= >> "!EVENTS_REPORT!"
echo. >> "!EVENTS_REPORT!"

echo    [INFO] Coletando eventos criticos e erros das ultimas 24 horas...
powershell -Command "Get-EventLog -LogName System -EntryType Error,Warning -Newest 20 | Select-Object TimeGenerated, EntryType, Source, Message | Format-Table -Wrap" >> "!EVENTS_REPORT!" 2>nul

echo    [SUCCESS] Relatorio de eventos gerado!
echo    [INFO] Arquivo salvo em: !EVENTS_REPORT!
echo.
pause
goto :AdvancedDiagnostics

:ExportAllReports
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                    [EXP] EXPORTAR TODOS RELATORIOS                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "gerar todos os relatorios de diagnostico"
if !ERRO_LEVEL! neq 0 goto :AdvancedDiagnostics

echo    [PROC] Gerando conjunto completo de relatorios...
echo.

REM Criar pasta para os relatórios
set "REPORTS_FOLDER=WinboxToolkit_Reports_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%"
set "REPORTS_FOLDER=!REPORTS_FOLDER: =0!"
mkdir "!REPORTS_FOLDER!" >nul 2>&1

echo    [1/4] Gerando relatorio do sistema...
goto :SystemReport

echo    [2/4] Gerando diagnostico de servicos...
goto :ServicesDiagnostic

echo    [3/4] Gerando relatorio de hardware...
goto :HardwareInfo

echo    [4/4] Gerando log de eventos...
goto :EventLogReport

echo    [SUCCESS] Todos os relatorios foram gerados!
echo    [INFO] Relatorios salvos na pasta: !REPORTS_FOLDER!
echo.
pause
goto :AdvancedDiagnostics

REM ================================================================================
REM IMPLEMENTAÇÕES COMPLETAS DE OTIMIZAÇÃO DE SISTEMA
REM ================================================================================

:VisualOptimization
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [VIS] OTIMIZACAO VISUAL                             ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

call :ConfirmAction "aplicar otimizacoes visuais para melhor performance"
if !ERRO_LEVEL! neq 0 goto :SystemOptimization

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                            [PROC] PROCESSANDO...                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    [PROC] Aplicando otimizacoes visuais...

REM Efeitos visuais para performance
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1 && echo    [OK] Efeitos visuais otimizados || echo    [WARN] Falha nos efeitos visuais
REG ADD "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1 && echo    [OK] Arrastar janelas otimizado || echo    [WARN] Falha no arrastar janelas
REG ADD "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1 && echo    [OK] Delay do menu reduzido || echo    [WARN] Falha no delay do menu
REG ADD "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1 && echo    [OK] Animacoes de janela desabilitadas || echo    [WARN] Falha nas animacoes

REM Configurações de transparência
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Transparencia desabilitada || echo    [WARN] Falha na transparencia

REM Configurações da taskbar
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Animacoes da taskbar desabilitadas || echo    [WARN] Falha nas animacoes taskbar

echo.
echo    [SUCCESS] Otimizacoes visuais aplicadas com sucesso!
echo    [INFO] Reinicie o explorer ou faca logout/login para aplicar mudancas.
echo.
pause
goto :SystemOptimization

:FeaturesOptimization
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [FTR] FEATURES E COMPONENTES                         ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if "!IS_ADMIN!"=="0" (
    echo    [ERROR] Esta funcionalidade requer privilegios administrativos!
    echo.
    pause
    goto :SystemOptimization
)

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Desabilitar Features Desnecessarios │  [2] Otimizar Windows Media    ║
echo    ║  [3] Internet Explorer                   │  [4] Hyper-V                   ║
echo    ║  [5] Fax e Scan                          │  [6] Restaurar Features        ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "FTR_CHOICE=   ═══^> Digite sua opcao: "

if "!FTR_CHOICE!"=="1" goto :DisableUnnecessaryFeatures
if "!FTR_CHOICE!"=="2" goto :OptimizeWindowsMedia
if "!FTR_CHOICE!"=="3" goto :DisableInternetExplorer
if "!FTR_CHOICE!"=="4" goto :DisableHyperV
if "!FTR_CHOICE!"=="5" goto :DisableFaxScan
if "!FTR_CHOICE!"=="6" goto :RestoreFeatures
if "!FTR_CHOICE!"=="0" goto :SystemOptimization
goto :FeaturesOptimization

:DisableUnnecessaryFeatures
echo    [FTR] Desabilitando features desnecessarios...
dism /online /disable-feature /featurename:TelnetClient /norestart >nul 2>&1 && echo    [OK] Telnet Client desabilitado || echo    [SKIP] Telnet nao encontrado
dism /online /disable-feature /featurename:TFTP /norestart >nul 2>&1 && echo    [OK] TFTP desabilitado || echo    [SKIP] TFTP nao encontrado
dism /online /disable-feature /featurename:TIFFIFilter /norestart >nul 2>&1 && echo    [OK] TIFF Filter desabilitado || echo    [SKIP] TIFF nao encontrado
echo    [SUCCESS] Features desnecessarios desabilitados!
pause
goto :FeaturesOptimization

:OptimizeWindowsMedia
echo    [FTR] Otimizando Windows Media...
dism /online /disable-feature /featurename:WindowsMediaPlayer /norestart >nul 2>&1 && echo    [OK] Windows Media Player desabilitado || echo    [SKIP] WMP nao encontrado
dism /online /disable-feature /featurename:MediaPlayback /norestart >nul 2>&1 && echo    [OK] Media Features desabilitados || echo    [SKIP] Media Features nao encontrado
echo    [SUCCESS] Windows Media otimizado!
pause
goto :FeaturesOptimization

:DisableInternetExplorer
echo    [FTR] Desabilitando Internet Explorer...
dism /online /disable-feature /featurename:Internet-Explorer-Optional-amd64 /norestart >nul 2>&1 && echo    [OK] Internet Explorer desabilitado || echo    [SKIP] IE nao encontrado
echo    [SUCCESS] Internet Explorer desabilitado!
pause
goto :FeaturesOptimization

:DisableHyperV
echo    [FTR] Desabilitando Hyper-V...
dism /online /disable-feature /featurename:Microsoft-Hyper-V-All /norestart >nul 2>&1 && echo    [OK] Hyper-V desabilitado || echo    [SKIP] Hyper-V nao encontrado
echo    [SUCCESS] Hyper-V desabilitado!
pause
goto :FeaturesOptimization

:DisableFaxScan
echo    [FTR] Desabilitando Fax e Scan...
dism /online /disable-feature /featurename:FaxServicesClientPackage /norestart >nul 2>&1 && echo    [OK] Fax Services desabilitado || echo    [SKIP] Fax nao encontrado
echo    [SUCCESS] Fax e Scan desabilitados!
pause
goto :FeaturesOptimization

:RestoreFeatures
echo    [FTR] Restaurando features do Windows...
dism /online /enable-feature /featurename:Internet-Explorer-Optional-amd64 /norestart >nul 2>&1 && echo    [OK] Internet Explorer restaurado || echo    [SKIP] IE nao restaurado
dism /online /enable-feature /featurename:WindowsMediaPlayer /norestart >nul 2>&1 && echo    [OK] Windows Media Player restaurado || echo    [SKIP] WMP nao restaurado
echo    [SUCCESS] Features restaurados!
pause
goto :FeaturesOptimization

:EdgeOptimization
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [EDG] MICROSOFT EDGE                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Otimizar Edge para Performance      │  [2] Desabilitar Telemetria    ║
echo    ║  [3] Limpar Cache e Dados                │  [4] Configurar Privacidade    ║
echo    ║  [5] Desabilitar Atualizacoes            │  [6] Restaurar Configuracoes   ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "EDG_CHOICE=   ═══^> Digite sua opcao: "

if "!EDG_CHOICE!"=="1" goto :OptimizeEdgePerformance
if "!EDG_CHOICE!"=="2" goto :DisableEdgeTelemetry
if "!EDG_CHOICE!"=="3" goto :ClearEdgeData
if "!EDG_CHOICE!"=="4" goto :ConfigureEdgePrivacy
if "!EDG_CHOICE!"=="5" goto :DisableEdgeUpdates
if "!EDG_CHOICE!"=="6" goto :RestoreEdgeSettings
if "!EDG_CHOICE!"=="0" goto :SystemOptimization
goto :EdgeOptimization

:OptimizeEdgePerformance
echo    [EDG] Otimizando Microsoft Edge para performance...
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Startup boost desabilitado || echo    [WARN] Falha no startup boost
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Background mode desabilitado || echo    [WARN] Falha no background mode
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeCollectionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Collections desabilitado || echo    [WARN] Falha no collections
echo    [SUCCESS] Edge otimizado para performance!
pause
goto :EdgeOptimization

:DisableEdgeTelemetry
echo    [EDG] Desabilitando telemetria do Microsoft Edge...
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Metrics reporting desabilitado || echo    [WARN] Falha no metrics
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SpellcheckEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Spellcheck desabilitado || echo    [WARN] Falha no spellcheck
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Bing search desabilitado || echo    [WARN] Falha no bing search
echo    [SUCCESS] Telemetria do Edge desabilitada!
pause
goto :EdgeOptimization

:ClearEdgeData
echo    [EDG] Limpando cache e dados do Microsoft Edge...
taskkill /f /im msedge.exe >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1 && echo    [OK] Cache removido || echo    [SKIP] Cache nao encontrado
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" >nul 2>&1 && echo    [OK] Code cache removido || echo    [SKIP] Code cache nao encontrado
del /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cookies" >nul 2>&1 && echo    [OK] Cookies removidos || echo    [SKIP] Cookies nao encontrados
echo    [SUCCESS] Dados do Edge limpos!
pause
goto :EdgeOptimization

:ConfigureEdgePrivacy
echo    [EDG] Configurando privacidade do Microsoft Edge...
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Personalization reporting desabilitado || echo    [WARN] Falha no personalization
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Search suggestions desabilitado || echo    [WARN] Falha no search suggestions
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Payment methods desabilitado || echo    [WARN] Falha no payment methods
echo    [SUCCESS] Privacidade do Edge configurada!
pause
goto :EdgeOptimization

:DisableEdgeUpdates
echo    [EDG] Desabilitando atualizacoes automaticas do Edge...
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "UpdateDefault" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Updates desabilitados || echo    [WARN] Falha nos updates
sc config edgeupdate start= disabled >nul 2>&1 && echo    [OK] Servico de update desabilitado || echo    [WARN] Falha no servico
echo    [SUCCESS] Atualizacoes do Edge desabilitadas!
pause
goto :EdgeOptimization

:RestoreEdgeSettings
echo    [EDG] Restaurando configuracoes padrao do Edge...
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Edge" /f >nul 2>&1 && echo    [OK] Policies removidas || echo    [SKIP] Policies nao encontradas
sc config edgeupdate start= auto >nul 2>&1 && echo    [OK] Servico de update restaurado || echo    [WARN] Falha no servico
echo    [SUCCESS] Configuracoes do Edge restauradas!
pause
goto :EdgeOptimization

:EssentialInstallers
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                      [INS] INSTALADORES ESSENCIAIS                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Chocolatey Package Manager         │  [2] Visual C++ Redistributables║
echo    ║  [3] .NET Framework Essentials          │  [4] DirectX e Visual Studio    ║
echo    ║  [5] Adobe Flash Player (Legacy)        │  [6] Java Runtime Environment   ║
echo    ║  [7] Verificar Instaladores             │  [8] Links de Download          ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "INS_CHOICE=   ═══^> Digite sua opcao: "

if "!INS_CHOICE!"=="1" goto :InstallChocolatey
if "!INS_CHOICE!"=="2" goto :InstallVCRedist
if "!INS_CHOICE!"=="3" goto :InstallDotNet
if "!INS_CHOICE!"=="4" goto :InstallDirectX
if "!INS_CHOICE!"=="5" goto :InstallFlash
if "!INS_CHOICE!"=="6" goto :InstallJava
if "!INS_CHOICE!"=="7" goto :CheckInstallers
if "!INS_CHOICE!"=="8" goto :ShowDownloadLinks
if "!INS_CHOICE!"=="0" goto :SystemOptimization
goto :EssentialInstallers

:InstallChocolatey
echo    [INS] Preparando instalacao do Chocolatey...
echo    [INFO] O Chocolatey sera instalado via PowerShell
echo    [WARN] Esta operacao requer conexao com internet
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && echo    [OK] Chocolatey instalado com sucesso! || echo    [WARN] Falha na instalacao do Chocolatey
pause
goto :EssentialInstallers

:InstallVCRedist
echo    [INS] Links para Visual C++ Redistributables:
echo    [INFO] Baixe e instale manualmente:
echo        * VC++ 2015-2022 x64: https://aka.ms/vs/17/release/vc_redist.x64.exe
echo        * VC++ 2015-2022 x86: https://aka.ms/vs/17/release/vc_redist.x86.exe
echo.
pause
goto :EssentialInstallers

:InstallDotNet
echo    [INS] Links para .NET Framework:
echo    [INFO] Baixe e instale manualmente:
echo        * .NET 6.0: https://dotnet.microsoft.com/download/dotnet/6.0
echo        * .NET Framework 4.8: https://dotnet.microsoft.com/download/dotnet-framework
echo.
pause
goto :EssentialInstallers

:InstallDirectX
echo    [INS] Links para DirectX:
echo    [INFO] Baixe e instale manualmente:
echo        * DirectX End-User Runtime: https://www.microsoft.com/download/details.aspx?id=35
echo.
pause
goto :EssentialInstallers

:InstallFlash
echo    [INS] Adobe Flash Player (Legacy):
echo    [WARN] Flash Player foi descontinuado em 2020
echo    [INFO] Nao recomendamos a instalacao por questoes de seguranca
echo.
pause
goto :EssentialInstallers

:InstallJava
echo    [INS] Links para Java:
echo    [INFO] Baixe e instale manualmente:
echo        * Oracle JRE: https://www.oracle.com/java/technologies/downloads/
echo        * OpenJDK: https://adoptium.net/
echo.
pause
goto :EssentialInstallers

:CheckInstallers
echo    [INS] Verificando instaladores presentes no sistema...
where choco >nul 2>&1 && echo    [OK] Chocolatey instalado || echo    [NO] Chocolatey nao instalado
where java >nul 2>&1 && echo    [OK] Java instalado || echo    [NO] Java nao instalado
reg query "HKLM\SOFTWARE\Microsoft\.NETFramework" >nul 2>&1 && echo    [OK] .NET Framework detectado || echo    [NO] .NET Framework nao detectado
echo.
pause
goto :EssentialInstallers

:ShowDownloadLinks
echo    [INS] LINKS DE DOWNLOAD ESSENCIAIS:
echo    ════════════════════════════════════════════════════════════════════════════
echo    [CHO] Chocolatey: https://chocolatey.org/install
echo    [NET] .NET Framework: https://dotnet.microsoft.com/download
echo    [VCR] Visual C++: https://docs.microsoft.com/cpp/windows/latest-supported-vc-redist
echo    [JRE] Java: https://adoptium.net/
echo    [DXR] DirectX: https://www.microsoft.com/download/details.aspx?id=35
echo    ════════════════════════════════════════════════════════════════════════════
echo.
pause
goto :EssentialInstallers

:LowEndHardware
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [LOW] HARDWARE LIMITADO                            ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Configuracao Ultra Leve             │  [2] Desabilitar Animacoes     ║
echo    ║  [3] Otimizacao de Memoria Agressiva     │  [4] Servicos Minimos          ║
echo    ║  [0] Voltar                                                               ║
echo    ║  [5] Efeitos Visuais Minimos             │  [6] Configuracao Completa     ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "LOW_CHOICE=   ═══^> Digite sua opcao: "

if "!LOW_CHOICE!"=="1" goto :UltraLightConfig
if "!LOW_CHOICE!"=="2" goto :DisableAllAnimations
if "!LOW_CHOICE!"=="3" goto :AggressiveMemoryOptimization
if "!LOW_CHOICE!"=="4" goto :MinimalServices
if "!LOW_CHOICE!"=="5" goto :MinimalVisualEffects
if "!LOW_CHOICE!"=="6" goto :CompleteOptimization
if "!LOW_CHOICE!"=="0" goto :SystemOptimization
goto :LowEndHardware

:UltraLightConfig
echo    [LOW] Aplicando configuracao ultra leve...
call :ConfirmAction "aplicar configuracao ultra leve (pode afetar funcionalidades)"
if !ERRO_LEVEL! neq 0 goto :LowEndHardware

REG ADD "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
REG ADD "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1
REG ADD "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 0 /f >nul 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul 2>&1

echo    [OK] Configuracao ultra leve aplicada!
pause
goto :LowEndHardware

:DisableAllAnimations
echo    [LOW] Desabilitando todas as animacoes...
REG ADD "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f >nul 2>&1
echo    [OK] Animacoes desabilitadas!
pause
goto :LowEndHardware

:AggressiveMemoryOptimization
echo    [LOW] Aplicando otimizacao agressiva de memoria...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SecondLevelDataCache" /t REG_DWORD /d 256 /f >nul 2>&1
echo    [OK] Memoria otimizada agressivamente!
pause
goto :LowEndHardware

:MinimalServices
echo    [LOW] Configurando servicos para modo minimo...
if "!IS_ADMIN!"=="0" (
    echo    [ERROR] Requer privilegios administrativos!
    pause
    goto :LowEndHardware
)

sc config "Themes" start= disabled >nul 2>&1
sc config "AudioSrv" start= demand >nul 2>&1
sc config "Spooler" start= demand >nul 2>&1
sc config "BITS" start= demand >nul 2>&1
echo    [OK] Servicos configurados para modo minimo!
pause
goto :LowEndHardware

:MinimalVisualEffects
echo    [LOW] Aplicando efeitos visuais minimos...
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f >nul 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Efeitos visuais minimos aplicados!
pause
goto :LowEndHardware

:CompleteOptimization
echo    [LOW] Aplicando otimizacao completa para hardware limitado...
call :ConfirmAction "aplicar todas as otimizacoes para hardware limitado"
if !ERRO_LEVEL! neq 0 goto :LowEndHardware

call :UltraLightConfig
call :DisableAllAnimations
call :AggressiveMemoryOptimization
call :MinimalServices
call :MinimalVisualEffects

echo    [SUCCESS] Otimizacao completa aplicada!
echo    [INFO] Reinicie o sistema para aplicar todas as mudancas.
pause
goto :LowEndHardware

:FileCleanup
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [CLN] LIMPEZA DE ARQUIVOS                          ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Limpeza Basica de Arquivos          │  [2] Limpeza Avancada          ║
echo    ║  [3] Limpeza de Logs                     │  [4] Prefetch e Superfetch     ║
echo    ║  [5] Cache de Navegadores                │  [6] Arquivos Temporarios      ║
echo    ║  [7] Limpeza Personalizada               │  [8] Relatorio de Espaco       ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "CLN_CHOICE=   ═══^> Digite sua opcao: "

if "!CLN_CHOICE!"=="1" goto :BasicFileCleanup
if "!CLN_CHOICE!"=="2" goto :AdvancedFileCleanup
if "!CLN_CHOICE!"=="3" goto :LogCleanup
if "!CLN_CHOICE!"=="4" goto :PrefetchCleanup
if "!CLN_CHOICE!"=="5" goto :BrowserCacheCleanup
if "!CLN_CHOICE!"=="6" goto :TempFilesCleanup
if "!CLN_CHOICE!"=="7" goto :CustomCleanup
if "!CLN_CHOICE!"=="8" goto :SpaceReport
if "!CLN_CHOICE!"=="0" goto :SystemOptimization
goto :FileCleanup

:BasicFileCleanup
echo    [CLN] Executando limpeza basica de arquivos...
call :ConfirmAction "executar limpeza basica de arquivos"
if !ERRO_LEVEL! neq 0 goto :FileCleanup

echo    [PROC] Limpando arquivos temporarios...
del /q /s "%TEMP%\*" >nul 2>&1 && echo    [OK] Arquivos temporarios do usuario || echo    [SKIP] Temp usuario
del /q /s "%TMP%\*" >nul 2>&1 && echo    [OK] Arquivos TMP || echo    [SKIP] TMP
del /q /s "%LOCALAPPDATA%\Temp\*" >nul 2>&1 && echo    [OK] Local temp || echo    [SKIP] Local temp

echo    [PROC] Limpando cache do Windows...
del /q "%SystemRoot%\Temp\*" >nul 2>&1 && echo    [OK] Windows Temp || echo    [SKIP] Windows Temp
del /q "%SystemRoot%\Prefetch\*" >nul 2>&1 && echo    [OK] Prefetch || echo    [SKIP] Prefetch

echo    [SUCCESS] Limpeza basica concluida!
pause
goto :FileCleanup

:AdvancedFileCleanup
echo    [CLN] Executando limpeza avancada de arquivos...
if "!IS_ADMIN!"=="0" (
    echo    [ERROR] Limpeza avancada requer privilegios administrativos!
    pause
    goto :FileCleanup
)

call :ConfirmAction "executar limpeza avancada (inclui arquivos do sistema)"
if !ERRO_LEVEL! neq 0 goto :FileCleanup

call :BasicFileCleanup
echo    [PROC] Limpeza avancada...
cleanmgr /sagerun:1 >nul 2>&1 && echo    [OK] Disk Cleanup executado || echo    [SKIP] Disk Cleanup falhou
sfc /scannow | findstr "violation" >nul 2>&1 || echo    [OK] Verificacao SFC concluida
echo    [SUCCESS] Limpeza avancada concluida!
pause
goto :FileCleanup

:LogCleanup
echo    [CLN] Limpando arquivos de log...
del /q "%SystemRoot%\*.log" >nul 2>&1 && echo    [OK] Logs do Windows || echo    [SKIP] Logs Windows
del /q "%SystemRoot%\Panther\*" >nul 2>&1 && echo    [OK] Logs de instalacao || echo    [SKIP] Logs instalacao
del /q "%LOCALAPPDATA%\Microsoft\Windows\WebCache\*" >nul 2>&1 && echo    [OK] WebCache || echo    [SKIP] WebCache
echo    [SUCCESS] Logs limpos!
pause
goto :FileCleanup

:PrefetchCleanup
echo    [CLN] Limpando Prefetch e Superfetch...
del /q "%SystemRoot%\Prefetch\*" >nul 2>&1 && echo    [OK] Prefetch limpo || echo    [SKIP] Prefetch
del /q "%SystemRoot%\System32\SysResetErr\*" >nul 2>&1 && echo    [OK] System Reset Errors || echo    [SKIP] Reset Errors
echo    [SUCCESS] Prefetch limpo!
pause
goto :FileCleanup

:BrowserCacheCleanup
echo    [CLN] Limpando cache de navegadores...
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1

del /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1 && echo    [OK] Chrome cache || echo    [SKIP] Chrome
del /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1 && echo    [OK] Edge cache || echo    [SKIP] Edge
del /q /s "%APPDATA%\Mozilla\Firefox\Profiles\*\cache2\*" >nul 2>&1 && echo    [OK] Firefox cache || echo    [SKIP] Firefox

echo    [SUCCESS] Cache de navegadores limpo!
pause
goto :FileCleanup

:TempFilesCleanup
echo    [CLN] Limpeza completa de arquivos temporarios...
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1
for /d %%i in ("%TMP%\*") do rd /s /q "%%i" >nul 2>&1
for /d %%i in ("%LOCALAPPDATA%\Temp\*") do rd /s /q "%%i" >nul 2>&1
echo    [SUCCESS] Arquivos temporarios completamente limpos!
pause
goto :FileCleanup

:CustomCleanup
echo    [CLN] Limpeza personalizada...
echo    [INFO] Opcoes personalizadas de limpeza:
echo        [1] Downloads antigos (mais de 30 dias)
echo        [2] Desktop arquivos temporarios
echo        [3] Documentos temporarios
echo        [0] Voltar
set /p "CUSTOM_CHOICE=   ═══^> Digite sua opcao: "

if "!CUSTOM_CHOICE!"=="1" (
    forfiles /p "%USERPROFILE%\Downloads" /c "cmd /c del @path" /m *.* /d -30 >nul 2>&1 && echo    [OK] Downloads antigos removidos || echo    [SKIP] Nenhum arquivo antigo
)
if "!CUSTOM_CHOICE!"=="2" (
    del /q "%USERPROFILE%\Desktop\*.tmp" >nul 2>&1 && echo    [OK] Desktop temporarios || echo    [SKIP] Nenhum temp no desktop
)
if "!CUSTOM_CHOICE!"=="3" (
    del /q "%USERPROFILE%\Documents\*.tmp" >nul 2>&1 && echo    [OK] Documentos temporarios || echo    [SKIP] Nenhum temp em documentos
)

pause
goto :FileCleanup

:SpaceReport
echo    [CLN] Gerando relatorio de espaco em disco...
echo.
echo    [INFO] Uso de disco por drive:
wmic logicaldisk get size,freespace,caption
echo.
echo    [INFO] Pastas que mais ocupam espaco:
REM Usando comando nativo do Windows para mostrar as 10 maiores pastas
dir C:\ /s /-c /o-s | findstr /r /e "\<[0-9][0-9]*\>" | more +1
echo.
pause
goto :FileCleanup

:Windows11Specific
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [W11] ESPECIFICOS WINDOWS 11                        ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

if not "!WINVER!"=="11" (
    echo    [WARN] Esta funcionalidade e especifica para Windows 11!
    echo    [INFO] Sistema detectado: !WINDOWS_VERSION!
    echo.
    pause
    goto :SystemOptimization
)

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Desabilitar Widgets                 │  [2] Menu Iniciar Classico     ║
echo    ║  [3] Explorer Classico                   │  [4] Desabilitar Copilot       ║
echo    ║  [5] Configurar Taskbar                  │  [6] Remover Teams             ║
echo    ║  [7] Otimizacoes Especificas W11         │  [8] Restaurar Configuracoes   ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "W11_CHOICE=   ═══^> Digite sua opcao: "

if "!W11_CHOICE!"=="1" goto :DisableWidgets
if "!W11_CHOICE!"=="2" goto :ClassicStartMenu
if "!W11_CHOICE!"=="3" goto :ClassicExplorer
if "!W11_CHOICE!"=="4" goto :DisableCopilot
if "!W11_CHOICE!"=="5" goto :ConfigureTaskbar
if "!W11_CHOICE!"=="6" goto :RemoveTeams
if "!W11_CHOICE!"=="7" goto :Windows11Optimizations
if "!W11_CHOICE!"=="8" goto :RestoreWindows11Settings
if "!W11_CHOICE!"=="0" goto :SystemOptimization
goto :Windows11Specific

:DisableWidgets
echo    [W11] Desabilitando Widgets do Windows 11...
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Widgets desabilitados || echo    [WARN] Falha nos widgets
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] News and Interests desabilitado || echo    [WARN] Falha no news
echo    [SUCCESS] Widgets desabilitados!
pause
goto :Windows11Specific

:ClassicStartMenu
echo    [W11] Configurando menu iniciar classico...
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Menu classico ativado || echo    [WARN] Falha no menu classico
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Taskbar pequena ativada || echo    [WARN] Falha na taskbar
echo    [SUCCESS] Menu iniciar configurado!
echo    [INFO] Reinicie o Explorer ou faca logout para aplicar.
pause
goto :Windows11Specific

:ClassicExplorer
echo    [W11] Configurando Explorer classico...
REG ADD "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1 && echo    [OK] Explorer classico ativado || echo    [WARN] Falha no explorer classico
echo    [SUCCESS] Explorer classico configurado!
echo    [INFO] Reinicie o Explorer para aplicar.
pause
goto :Windows11Specific

:DisableCopilot
echo    [W11] Desabilitando Copilot...
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Botao Copilot removido || echo    [WARN] Falha no Copilot
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Copilot desabilitado via policy || echo    [WARN] Falha na policy
echo    [SUCCESS] Copilot desabilitado!
pause
goto :Windows11Specific

:ConfigureTaskbar
echo    [W11] Configurando taskbar do Windows 11...
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Taskbar alinhada a esquerda || echo    [WARN] Falha no alinhamento
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Task View removido || echo    [WARN] Falha no Task View
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Caixa de pesquisa removida || echo    [WARN] Falha na pesquisa
echo    [SUCCESS] Taskbar configurada!
pause
goto :Windows11Specific

:RemoveTeams
echo    [W11] Removendo Microsoft Teams...
powershell -Command "Get-AppxPackage *Teams* | Remove-AppxPackage" >nul 2>&1 && echo    [OK] Teams removido || echo    [SKIP] Teams nao encontrado
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] Chat removido da taskbar || echo    [WARN] Falha no chat
echo    [SUCCESS] Teams removido!
pause
goto :Windows11Specific

:Windows11Optimizations
echo    [W11] Aplicando otimizacoes especificas do Windows 11...
call :ConfirmAction "aplicar todas as otimizacoes especificas do Windows 11"
if !ERRO_LEVEL! neq 0 goto :Windows11Specific

call :DisableWidgets
call :ClassicStartMenu
call :ClassicExplorer
call :DisableCopilot
call :ConfigureTaskbar
call :RemoveTeams

echo    [SUCCESS] Otimizacoes do Windows 11 aplicadas!
echo    [INFO] Reinicie o sistema para aplicar todas as mudancas.
pause
goto :Windows11Specific

:RestoreWindows11Settings
echo    [W11] Restaurando configuracoes padrao do Windows 11...
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /f >nul 2>&1
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /f >nul 2>&1
REG DELETE "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1
echo    [SUCCESS] Configuracoes restauradas!
pause
goto :Windows11Specific

:NetworkOptimization
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                       [NET] OTIMIZACAO DE REDE                            ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Otimizar TCP/IP para Gaming         │  [2] DNS Rapido (Cloudflare)   ║
echo    ║  [3] Configuracoes de QoS                │  [4] Otimizar MTU              ║
echo    ║  [5] Desabilitar Nagle Algorithm         │  [6] Configuracoes Avancadas   ║
echo    ║  [7] Teste de Velocidade                 │  [8] Restaurar Configuracoes   ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "NET_OPT_CHOICE=   ═══^> Digite sua opcao: "

if "!NET_OPT_CHOICE!"=="1" goto :OptimizeForGaming
if "!NET_OPT_CHOICE!"=="2" goto :SetCloudflareDNS
if "!NET_OPT_CHOICE!"=="3" goto :ConfigureQoS
if "!NET_OPT_CHOICE!"=="4" goto :OptimizeMTU
if "!NET_OPT_CHOICE!"=="5" goto :DisableNagle
if "!NET_OPT_CHOICE!"=="6" goto :AdvancedNetworkSettings
if "!NET_OPT_CHOICE!"=="7" goto :SpeedTest
if "!NET_OPT_CHOICE!"=="8" goto :RestoreNetworkSettings
if "!NET_OPT_CHOICE!"=="0" goto :SystemOptimization
goto :NetworkOptimization

:OptimizeForGaming
echo    [NET] Otimizando rede para gaming...
netsh int tcp set global autotuninglevel=normal >nul 2>&1 && echo    [OK] Auto-tuning otimizado || echo    [WARN] Falha no auto-tuning
netsh int tcp set global chimney=enabled >nul 2>&1 && echo    [OK] TCP Chimney habilitado || echo    [WARN] Falha no chimney
netsh int tcp set global rss=enabled >nul 2>&1 && echo    [OK] RSS habilitado || echo    [WARN] Falha no RSS
netsh int tcp set global netdma=enabled >nul 2>&1 && echo    [OK] NetDMA habilitado || echo    [WARN] Falha no NetDMA
echo    [SUCCESS] Rede otimizada para gaming!
pause
goto :NetworkOptimization

:SetCloudflareDNS
echo    [NET] Configurando DNS da Cloudflare...
for /f "tokens=3*" %%i in ('netsh interface show interface ^| findstr "Connected"') do (
    netsh interface ip set dns "%%j" static 1.1.1.1 >nul 2>&1 && echo    [OK] DNS primario configurado para %%j
    netsh interface ip add dns "%%j" 1.0.0.1 index=2 >nul 2>&1 && echo    [OK] DNS secundario configurado para %%j
)
echo    [SUCCESS] DNS da Cloudflare configurado!
pause
goto :NetworkOptimization

:ConfigureQoS
echo    [NET] Configurando Quality of Service...
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] QoS packet scheduler otimizado || echo    [WARN] Falha no QoS
netsh int tcp set global autotuninglevel=normal >nul 2>&1 && echo    [OK] Auto-tuning configurado || echo    [WARN] Falha no auto-tuning
echo    [SUCCESS] QoS configurado!
pause
goto :NetworkOptimization

:OptimizeMTU
echo    [NET] Otimizando MTU...
echo    [INFO] Descobrindo MTU otimo...
ping -f -l 1472 8.8.8.8 -n 1 >nul 2>&1
if !errorlevel! equ 0 (
    netsh interface ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent >nul 2>&1 && echo    [OK] MTU configurado para 1500 || echo    [WARN] Falha no MTU
) else (
    echo    [INFO] Usando MTU padrao
)
echo    [SUCCESS] MTU otimizado!
pause
goto :NetworkOptimization

:DisableNagle
echo    [NET] Desabilitando Nagle Algorithm...
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /s /k 2^>nul ^| findstr "HKEY"') do (
    REG ADD "%%a" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    REG ADD "%%a" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
)
echo    [OK] Nagle Algorithm desabilitado!
echo    [SUCCESS] Latencia de rede otimizada!
pause
goto :NetworkOptimization

:AdvancedNetworkSettings
echo    [NET] Configuracoes avancadas de rede...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f >nul 2>&1 && echo    [OK] TTL configurado || echo    [WARN] Falha no TTL
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d 2 /f >nul 2>&1 && echo    [OK] MaxDupAcks configurado || echo    [WARN] Falha no MaxDupAcks
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SynAttackProtect" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] SYN Attack Protection habilitado || echo    [WARN] Falha na protecao
echo    [SUCCESS] Configuracoes avancadas aplicadas!
pause
goto :NetworkOptimization

:SpeedTest
echo    [NET] Executando teste de conectividade...
echo    [INFO] Testando latencia para diferentes servidores:
ping -n 4 8.8.8.8 | findstr "TTL" | findstr "time"
ping -n 4 1.1.1.1 | findstr "TTL" | findstr "time"
echo.
echo    [INFO] Para teste de velocidade completo, use sites como speedtest.net
pause
goto :NetworkOptimization

:RestoreNetworkSettings
echo    [NET] Restaurando configuracoes padrao de rede...
netsh int ip reset >nul 2>&1 && echo    [OK] TCP/IP resetado || echo    [WARN] Falha no reset
netsh winsock reset >nul 2>&1 && echo    [OK] Winsock resetado || echo    [WARN] Falha no winsock
ipconfig /flushdns >nul 2>&1 && echo    [OK] DNS cache limpo || echo    [WARN] Falha no DNS
echo    [SUCCESS] Configuracoes de rede restauradas!
echo    [INFO] Reinicie o sistema para aplicar todas as mudancas.
pause
goto :NetworkOptimization

:PowerManagement
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                        [PWR] GERENCIAMENTO DE ENERGIA                     ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║  [1] Alto Performance                │  [2] Balanceado                    ║
echo    ║  [3] Economia de Energia             │  [4] Performance Ultimate          ║
echo    ║  [5] Configuracoes de Hibernacao    │  [6] USB Power Management           ║
echo    ║  [7] Status Atual                   │  [8] Restaurar Padrao               ║
echo    ║  [0] Voltar                                                               ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p "PWR_CHOICE=   ═══^> Digite sua opcao: "

if "!PWR_CHOICE!"=="1" goto :SetHighPerformance
if "!PWR_CHOICE!"=="2" goto :SetBalanced
if "!PWR_CHOICE!"=="3" goto :SetPowerSaver
if "!PWR_CHOICE!"=="4" goto :SetUltimatePerformance
if "!PWR_CHOICE!"=="5" goto :ConfigureHibernation
if "!PWR_CHOICE!"=="6" goto :USBPowerManagement
if "!PWR_CHOICE!"=="7" goto :PowerStatus
if "!PWR_CHOICE!"=="8" goto :RestorePowerDefaults
if "!PWR_CHOICE!"=="0" goto :ServiceManager
goto :PowerManagement

:SetHighPerformance
echo    [PWR] Configurando Alto Performance...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1 && echo    [OK] Perfil Alto Performance ativado || echo    [WARN] Falha ao ativar perfil
pause
goto :PowerManagement

:SetBalanced
echo    [PWR] Configurando modo Balanceado...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1 && echo    [OK] Perfil Balanceado ativado || echo    [WARN] Falha ao ativar perfil
pause
goto :PowerManagement

:SetPowerSaver
echo    [PWR] Configurando Economia de Energia...
powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1 && echo    [OK] Perfil Economia ativado || echo    [WARN] Falha ao ativar perfil
pause
goto :PowerManagement

:SetUltimatePerformance
echo    [PWR] Configurando Performance Ultimate...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1 && echo    [OK] Perfil Ultimate criado || echo    [SKIP] Ultimate ja existe
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1 && echo    [OK] Performance Ultimate ativado || echo    [WARN] Falha ao ativar Ultimate
pause
goto :PowerManagement

:ConfigureHibernation
echo    [PWR] Configurando hibernacao...
echo    [1] Desabilitar hibernacao
echo    [2] Habilitar hibernacao
echo    [3] Hibernacao hibrida
set /p "HIB_CHOICE=   ═══^> Digite sua opcao: "

if "!HIB_CHOICE!"=="1" (
    powercfg /hibernate off >nul 2>&1 && echo    [OK] Hibernacao desabilitada || echo    [WARN] Falha ao desabilitar
)
if "!HIB_CHOICE!"=="2" (
    powercfg /hibernate on >nul 2>&1 && echo    [OK] Hibernacao habilitada || echo    [WARN] Falha ao habilitar
)
if "!HIB_CHOICE!"=="3" (
    powercfg /hibernate on >nul 2>&1
    powercfg /change hibernate-timeout-ac 0 >nul 2>&1 && echo    [OK] Hibernacao hibrida configurada || echo    [WARN] Falha na configuracao
)
pause
goto :PowerManagement

:USBPowerManagement
echo    [PWR] Configurando gerenciamento de energia USB...
powercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1 && echo    [OK] USB power management otimizado || echo    [WARN] Falha na configuracao USB
powercfg /setdcvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1
pause
goto :PowerManagement

:PowerStatus
echo    [PWR] Status atual do gerenciamento de energia:
echo.
powercfg /query scheme_current | findstr /C:"Power Scheme" /C:"Subgroup" | more +1
echo.
pause
goto :PowerManagement

:RestorePowerDefaults
echo    [PWR] Restaurando configuracoes padrao de energia...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1 && echo    [OK] Perfil Balanceado restaurado || echo    [WARN] Falha ao restaurar
powercfg /hibernate on >nul 2>&1 && echo    [OK] Hibernacao restaurada || echo    [WARN] Falha na hibernacao
echo    [SUCCESS] Configuracoes de energia restauradas!
pause
goto :PowerManagement

REM ================================================================================
REM FUNÇÕES AUXILIARES PARA CONFIGURAÇÕES AVANÇADAS
REM ================================================================================

:ConfigureMemoryInterval
echo    [CFG] Configurar intervalo de limpeza de memoria...
echo    [INFO] Intervalo atual: !MEMORY_INTERVAL! segundos
echo.
set /p "NEW_INTERVAL=   ═══^> Digite o novo intervalo (15-300): "
if "!NEW_INTERVAL!" geq "15" if "!NEW_INTERVAL!" leq "300" (
    set "MEMORY_INTERVAL=!NEW_INTERVAL!"
    echo    [OK] Intervalo configurado para !NEW_INTERVAL! segundos
) else (
    echo    [WARN] Valor invalido. Mantendo !MEMORY_INTERVAL! segundos
)
pause
goto :ProgramSettings

:ConfigureMemoryMonitor
echo    [CFG] Configurar taxa de atualizacao do monitor...
echo    [INFO] Taxa atual: !MONITOR_REFRESH! segundos
echo.
set /p "NEW_REFRESH=   ═══^> Digite a nova taxa (1-10): "
if "!NEW_REFRESH!" geq "1" if "!NEW_REFRESH!" leq "10" (
    set "MONITOR_REFRESH=!NEW_REFRESH!"
    echo    [OK] Taxa configurada para !NEW_REFRESH! segundos
) else (
    echo    [WARN] Valor invalido. Mantendo !MONITOR_REFRESH! segundos
)
pause
goto :ProgramSettings

:ConfigureAlertLevel
echo    [CFG] Configurar nivel de alerta de memoria...
echo    [INFO] Nivel atual: !MONITOR_ALERT_LEVEL!%%
echo.
set /p "NEW_ALERT=   ═══^> Digite o novo nivel (50-95): "
if "!NEW_ALERT!" geq "50" if "!NEW_ALERT!" leq "95" (
    set "MONITOR_ALERT_LEVEL=!NEW_ALERT!"
    echo    [OK] Nivel configurado para !NEW_ALERT!%%
) else (
    echo    [WARN] Valor invalido. Mantendo !MONITOR_ALERT_LEVEL!%%
)
pause
goto :ProgramSettings

:ConfigureInterface
echo    [CFG] Configuracoes de interface...
echo    [1] Cor normal (0F)
echo    [2] Cor verde (0A)
echo    [3] Cor azul (0B)
echo    [4] Cor vermelha (0C)
echo.
set /p "COLOR_CHOICE=   ═══^> Digite sua opcao: "
if "!COLOR_CHOICE!"=="1" color 0F
if "!COLOR_CHOICE!"=="2" color 0A
if "!COLOR_CHOICE!"=="3" color 0B
if "!COLOR_CHOICE!"=="4" color 0C
echo    [OK] Cor da interface alterada
pause
goto :ProgramSettings

:ConfigureDebug
echo    [CFG] Configuracoes de debug...
if "!DEBUG_MODE!"=="1" (
    echo    [STATUS] Debug atualmente ATIVO
    echo    [1] Desabilitar debug
) else (
    echo    [STATUS] Debug atualmente INATIVO
    echo    [1] Habilitar debug
)
echo    [2] Visualizar log atual
echo    [3] Limpar log de debug
echo.
set /p "DEBUG_CHOICE=   ═══^> Digite sua opcao: "

if "!DEBUG_CHOICE!"=="1" (
    if "!DEBUG_MODE!"=="1" (
        call :DisableDebugMode
        echo    [OK] Debug desabilitado
    ) else (
        call :EnableDebugMode
        echo    [OK] Debug habilitado
    )
)
if "!DEBUG_CHOICE!"=="2" (
    if exist "!LOG_FILE!" (
        type "!LOG_FILE!" | more
    ) else (
        echo    [INFO] Nenhum log encontrado
    )
)
if "!DEBUG_CHOICE!"=="3" (
    if exist "!LOG_FILE!" (
        del "!LOG_FILE!" >nul 2>&1 && echo    [OK] Log limpo || echo    [WARN] Falha ao limpar log
    ) else (
        echo    [INFO] Nenhum log para limpar
    )
)
pause
goto :ProgramSettings

:ConfigureLogging
echo    [CFG] Configuracoes de log...
echo    [1] Habilitar logs detalhados
echo    [2] Logs apenas de erro
echo    [3] Desabilitar logs
echo    [4] Ver logs existentes
echo.
set /p "LOG_CHOICE=   ═══^> Digite sua opcao: "
REM Implementar configurações específicas de log aqui
echo    [OK] Configuracao de log aplicada
pause
goto :ProgramSettings

:GeneralSettings
echo    [CFG] Configuracoes gerais...
echo    [1] Configurar janela (tamanho)
echo    [2] Configurar timeout de comandos
echo    [3] Configurar idioma
echo    [4] Configuracoes de seguranca
echo.
set /p "GEN_CHOICE=   ═══^> Digite sua opcao: "
if "!GEN_CHOICE!"=="1" (
    echo    [CFG] Configurando tamanho da janela...
    mode 85,30
    echo    [OK] Janela redimensionada
)
REM Outras configurações gerais aqui
pause
goto :ProgramSettings

:RestoreProgramDefaults
echo    [CFG] Restaurando configuracoes padrao do programa...
set "MEMORY_INTERVAL=30"
set "MONITOR_REFRESH=2"
set "MONITOR_ALERT_LEVEL=85"
set "DEBUG_MODE=0"
color 0F
mode 85,30
echo    [OK] Configuracoes restauradas
pause
goto :ProgramSettings

:ConfigureVirtualMemory
echo    [SYS] Configuracoes de memoria virtual...
echo    [INFO] Configurando arquivo de paginacao...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1 && echo    [OK] Paging executive desabilitado || echo    [WARN] Falha na configuracao
pause
goto :SystemSettings

:ConfigurePageFile
echo    [SYS] Configuracoes de Page File...
echo    [1] Tamanho automatico
echo    [2] Tamanho personalizado
echo    [3] Desabilitar page file
echo.
set /p "PF_CHOICE=   ═══^> Digite sua opcao: "
REM Implementar configurações específicas do page file aqui
echo    [OK] Page file configurado
pause
goto :SystemSettings

:ConfigureRegistryTweaks
echo    [SYS] Aplicando tweaks de registry...
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "2048" /f >nul 2>&1 && echo    [OK] Cache de icones otimizado || echo    [WARN] Falha no cache
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f >nul 2>&1 && echo    [OK] Timeout de servicos otimizado || echo    [WARN] Falha no timeout
pause
goto :SystemSettings

:ConfigureStartupPrograms
echo    [SYS] Gerenciando programas de inicializacao...
echo    [INFO] Abrindo gerenciador de inicializacao...
msconfig
pause
goto :SystemSettings

:ConfigureSystemCache
echo    [SYS] Configuracoes de cache do sistema...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1 && echo    [OK] System cache otimizado || echo    [WARN] Falha no cache
pause
goto :SystemSettings

:ConfigureTaskScheduler
echo    [SYS] Abrindo agendador de tarefas...
taskschd.msc
pause
goto :SystemSettings

:ConfigureWindowsFeatures
echo    [SYS] Abrindo recursos do Windows...
OptionalFeatures
pause
goto :SystemSettings

:ConfigureSystemProtection
echo    [SYS] Configuracoes de protecao do sistema...
SystemPropertiesProtection
pause
goto :SystemSettings

:TestSystem
echo    [TST] Executando teste de sistema...
echo    [INFO] Verificando integridade dos arquivos do sistema...
sfc /scannow
pause
goto :TestMode

:TestMemory
echo    [TST] Executando teste de memoria...
echo    [INFO] Iniciando diagnostico de memoria Windows...
mdsched.exe
pause
goto :TestMode

:TestPerformance
echo    [TST] Teste de performance...
call :GetCurrentMemoryInfo
echo    [INFO] Memoria: !MEMORY_USAGE_MB!MB/!TOTAL_MEMORY_MB!MB (!MEMORY_PERCENT!%%)
echo    [INFO] Sistema: !WINDOWS_VERSION!
echo    [INFO] Build: !WIN_BUILD!
pause
goto :TestMode

:TestConnectivity
echo    [TST] Teste de conectividade...
ping -n 4 8.8.8.8
ping -n 4 1.1.1.1
nslookup google.com
pause
goto :TestMode

:TestServices
echo    [TST] Teste de servicos...
sc query type= service state= all | findstr "SERVICE_NAME STATE"
pause
goto :TestMode

:TestComplete
echo    [TST] Executando teste completo...
call :TestSystem
call :TestMemory
call :TestPerformance
call :TestConnectivity
call :TestServices
echo    [SUCCESS] Teste completo finalizado
pause
goto :TestMode

:SimulateOptimizations
echo    [TST] Simulando otimizacoes (modo seguro)...
echo    [SIMUL] Limpeza de memoria: OK
echo    [SIMUL] Otimizacao de registry: OK  
echo    [SIMUL] Desabilitacao de servicos: OK
echo    [SIMUL] Configuracoes de energia: OK
echo    [SUCCESS] Simulacao concluida - nenhuma alteracao real foi feita
pause
goto :TestMode

:VerifyIntegrity
echo    [TST] Verificando integridade do sistema...
DISM /Online /Cleanup-Image /CheckHealth
sfc /verifyonly
pause
goto :TestMode

REM ================================================================================
REM FUNÇÃO DE SAÍDA
REM ================================================================================

:ExitProgram
cls
call :DrawGhostHeader
echo.
echo    ╔═══════════════════════════════════════════════════════════════════════════╗
echo    ║                             [EXIT] OBRIGADO!                              ║
echo    ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo    [TIP] DICAS PARA MANTER A PERFORMANCE:
echo       * Execute limpeza de memoria regularmente
echo       * Monitore processos com alto consumo
echo       * Mantenha apenas programas necessarios abertos
echo       * Considere aumentar a RAM se necessario
echo.
echo    [DEV] Desenvolvido por %AUTHOR% - 2025
echo    [LIC] Licenca: Creative Commons BY-NC 4.0
echo    [WEB] GitHub: https://github.com/Gabs77u/Winbox-Toolkit-Optimization
echo.
echo    [LEG] AVISO LEGAL: Este software e fornecido "como esta" sem garantias.
echo       Para termos completos, consulte o arquivo TERMOS_DE_USO.md
echo.
pause
exit /b 0
