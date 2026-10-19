@echo off
chcp 936 >nul
setlocal enabledelayedexpansion
title MeiYing ShenBu - 停止

rem ==================================================================
rem  魅影神捕  停止全部服务
rem  按「监听端口」精准杀进程，不会误伤其它 node / java 进程
rem ==================================================================

echo.
echo   ============================================================
echo     魅影神捕  停止服务
echo   ============================================================
echo.

call :killPort 8080
call :killPort 5173

rem 顺手关掉遗留的启动窗口（里面的服务已经被杀了，只剩一句"请按任意键"）
taskkill /FI "WINDOWTITLE eq MeiYing-Backend*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq MeiYing-Frontend*" /F >nul 2>&1

echo.
echo   ============================================================
echo     已停止。要重新启动请双击 start.bat
echo   ============================================================
echo.
pause
exit /b 0

rem ---------------- 子过程：杀掉占用指定端口的进程 ----------------
:killPort
set "HIT="
for /f "tokens=5" %%A in ('netstat -ano ^| findstr ":%~1 " ^| findstr "LISTENING"') do (
    taskkill /F /PID %%A >nul 2>&1
    if not errorlevel 1 set "HIT=1"
)
if defined HIT (echo     端口 %~1   已停止) else (echo     端口 %~1   未在运行)
exit /b 0
