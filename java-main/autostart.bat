@echo off
setlocal enabledelayedexpansion
rem ================================================================
rem  MeiYing ShenBu silent auto-start
rem  - Runs hidden (launched by the .vbs in the Startup folder)
rem  - Safe to run multiple times: skips anything already listening
rem  - Backend: javaw (no console window, cannot be killed by
rem    accidentally closing a cmd window). Logs: springBootTest\log
rem  - Frontend: vite dev server, output to vite-dev.log
rem ================================================================

set "ROOT=%~dp0"
set "BACKEND=%ROOT%springBootTest"
set "FRONTEND=%ROOT%meiying-shenbu-vue"

rem Clear env vars that can override server.port via relaxed binding
set "SERVER__PORT="
set "SERVER__HOST="
set "SERVER_PORT="
set "SERVER_HOST="

rem ---------------- backend on 8080 ----------------
netstat -ano | findstr ":8080 " | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    set "JARFILE="
    for /f "delims=" %%J in ('dir /b /o-d "%BACKEND%\target\*.jar" 2^>nul') do (
        if not defined JARFILE set "JARFILE=%%~nxJ"
    )
    if defined JARFILE (
        pushd "%BACKEND%"
        start "" /b javaw -Dfile.encoding=UTF-8 -jar "%BACKEND%\target\!JARFILE!" --server.port=8080
        popd
    )
)

rem ---------------- frontend on 5173 ----------------
netstat -ano | findstr ":5173 " | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    if exist "%FRONTEND%\node_modules\vite\package.json" (
        pushd "%FRONTEND%"
        start "" /b cmd /c "call npm run dev > vite-dev.log 2>&1"
        popd
    )
)

exit /b 0
