@echo off
setlocal
chcp 65001 > nul
color 0B
title https://github.com/OtaconEvil

REM Comprobar si se tienen privilegios de administrador
fltmc >nul 2>&1 || (
    echo Privilegios de administrador requeridos.
    PowerShell Start -Verb RunAs "%0" 2>nul || (
        echo Haz clic derecho en el script y selecciona "Ejecutar como administrador".
        pause
        goto :eof
    )
    exit 0
)

:menu
cls
echo.
echo -----------------------------------------------
echo           Configuraciones gpedit.msc 
echo -----------------------------------------------
echo 1. Ejecutar Editor de directivas de grupo local
echo 2. Instalar Editor de directivas de grupo local
echo 3. Desinstalar Editor de directivas de grupo local
echo 4. Salir
echo -----------------------------------------------
echo.
set /p opcion=Seleccione una opción: 

if "%opcion%"=="1" (

    REM Verificar la versión de Windows
    ver | findstr /i "10\." >nul 2>&1
    if %errorlevel% equ 0 (
        REM Versión de Windows: 10
        goto check_gpedit
    )
    ver | findstr /i "11\." >nul 2>&1
    if %errorlevel% equ 0 (
        REM Versión de Windows: 11
        goto check_gpedit
    )
    echo No se pudo determinar la versión de Windows.
    goto menu

    :check_gpedit
    REM Verificar si el Editor de directivas de grupo local está instalado
    if %errorlevel% equ 0 (
        echo Ejecutando Editor de directivas de grupo local...
        start gpedit.msc
        goto menu
    ) else (
        echo El Editor de directivas de grupo local no está instalado en este sistema.
        goto menu
    )
) else if "%opcion%"=="2" (

    REM Verificar la versión de Windows
    ver | findstr /i "10\." >nul 2>&1
    if %errorlevel% equ 0 (
        REM Versión de Windows: 10
        goto check_gpedit
    )
    ver | findstr /i "11\." >nul 2>&1
    if %errorlevel% equ 0 (
        REM Versión de Windows: 11
        goto check_gpedit
    )
    echo No se pudo determinar la versión de Windows.
    goto menu

    :check_gpedit
    REM Verificar si el Editor de directivas de grupo local está instalado
    if %errorlevel% equ 0 (
        echo El Editor de directivas de grupo local está instalado en este sistema.
        goto menu
    ) else (
        echo Instalando Editor de directivas de grupo local...
        pushd "%~dp0" 
        dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt 
        dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt 
        for /f %%i in ('findstr /i . List.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i" 
        del List.txt
        echo.
        echo Instalación del Editor de directivas de grupo local completada.
        goto menu
    )
) else if "%opcion%"=="3" (

    REM Verificar la versión de Windows
    ver | findstr /i "10\." >nul 2>&1
    if %errorlevel% equ 0 (
        REM Versión de Windows: 10
        goto check_gpedit
    )
    ver | findstr /i "11\." >nul 2>&1
    if %errorlevel% equ 0 (
        REM Versión de Windows: 11
        goto check_gpedit
    )
    echo No se pudo determinar la versión de Windows.
    goto menu

    :check_gpedit
    REM Verificar si el Editor de directivas de grupo local está instalado
    if %errorlevel% equ 0 (
        echo Desinstalando el Editor de directivas de grupo local...
        REM Desinstalar el Editor de directivas de grupo local
        for /f %%i in ('dism /online /get-packages ^| findstr "GroupPolicy" ^| findstr /v "Removal" ^| findstr /r /c:".*GroupPolicy.*"') do (
            dism /online /norestart /remove-package:"%%i"
        )
        echo.
        echo Desinstalacion del Editor de directivas de grupo local completada.
        goto menu
    ) else (
        echo El Editor de directivas de grupo local no está instalado en este sistema.
        goto menu
    )
) else if "%opcion%"=="4" (
    exit
) else (
    echo Opción inválida. Por favor, seleccione una opción válida.
    pause
    goto menu
)

:end
endlocal