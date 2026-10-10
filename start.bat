@echo off
chcp 936 >nul
setlocal enabledelayedexpansion
title MeiYing ShenBu - 一键启动

rem ==================================================================
rem  魅影神捕  一键启动（后端 Spring Boot + 前端 Vue）
rem
rem  · 全篇用相对路径（%~dp0 = 本脚本所在目录），整个文件夹挪走也能跑
rem  · 工具直接用 PATH 里的 java / npm，不用配绝对路径
rem  · node_modules 和 target 每次开机都会被删，所以会自动重建
rem ==================================================================

rem ---------- ① 定位后端目录 ----------
rem 按顺序找，第一个含 pom.xml 的胜出：
rem   前两个是相对路径（把后端挪进本文件夹就能用）
rem   第三个是绝对路径兜底 —— 你现在的后端就在 D:\workSpace\springBootTest
rem   最后一个是你早先那个参考后端，只当保底
rem 以后想换后端位置，改这一行的第三个路径即可。
set "BACKEND="
for %%D in ("%~dp0springBootTest" "%~dp0backend" "D:\workSpace\springBootTest" "%~dp0meiying-shenbu-backend") do (
    if not defined BACKEND if exist "%%~fD\pom.xml" set "BACKEND=%%~fD"
)
set "FRONTEND=%~dp0meiying-shenbu-vue"

rem ---------- ② 清掉会顶掉配置文件的环境变量 ----------
rem Spring Boot 松散绑定会把 SERVER__PORT 当成 server.port，害得端口乱跑
set "SERVER__PORT="
set "SERVER__HOST="
set "SERVER_PORT="
set "SERVER_HOST="

echo.
echo   ============================================================
echo     魅影神捕  一键启动
echo   ============================================================
if defined BACKEND (echo     后端 : %BACKEND%) else (echo     后端 : 未找到，将只启动前端)
if exist "%FRONTEND%\package.json" (echo     前端 : %FRONTEND%) else (echo     前端 : 未找到)
echo   ============================================================

rem ---------- 0) 环境自检：把「看不懂的报错」提前变成「看得懂的提示」 ----------
rem MySQL 没监听 3306 的话，后端会连不上库，这里先提醒一句
netstat -ano | findstr ":3306 " | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo     [提示] 3306 端口没有监听 —— MySQL 可能没启动。
    echo            后端会连不上数据库。请启动 MySQL 服务后重试。
)
echo.

if not defined BACKEND goto skipBackend

rem ===================== ③ 构建 + 启动后端 =====================
java -version >nul 2>&1
if errorlevel 1 (
    echo   [致命] PATH 里找不到可用的 java，无法构建/启动后端。
    echo          请检查 JDK 是否装好、JAVA_HOME 和 PATH 是否配置正确。
    goto skipBackend
)

echo   [1/3] 检查后端构建产物 ...

set "JARFILE="
for /f "delims=" %%J in ('dir /b /o-d "%BACKEND%\target\springBootTest-*.jar" 2^>nul') do (
    if not defined JARFILE set "JARFILE=%%J"
)

if defined JARFILE (
    echo         已有 %JARFILE%，跳过构建。
) else (
    echo         target 已丢失，开始 Maven 构建（首次要下依赖，请等 1-3 分钟）...
    echo.
    pushd "%BACKEND%"
    if exist "mvnw.cmd" (
        call mvnw.cmd -B package -DskipTests
    ) else (
        call mvn -B package -DskipTests
    )
    set "MVNRC=!ERRORLEVEL!"
    popd
    echo.
    if not "!MVNRC!"=="0" (
        echo   [失败] Maven 构建失败，请看上面的报错。
        goto end
    )
    for /f "delims=" %%J in ('dir /b /o-d "%BACKEND%\target\springBootTest-*.jar" 2^>nul') do (
        if not defined JARFILE set "JARFILE=%%J"
    )
    if not defined JARFILE (
        echo   [失败] 构建完成但没找到 jar 包，请检查 pom.xml。
        goto end
    )
    echo         构建完成：!JARFILE!
)

echo   [2/3] 启动后端（新窗口，端口 8080）...
rem /d 负责设置工作目录（让 log/xx.log 落在后端自己目录下）；
rem jar 用完整路径，否则相对路径找不到（jar 在 target 子目录里）；
rem /k 后面不要给整串命令再加引号，嵌套引号会把参数弄乱
set "JARPATH=%BACKEND%\target\%JARFILE%"
start "MeiYing-Backend" /d "%BACKEND%" cmd /k java -Dfile.encoding=UTF-8 -jar "%JARPATH%" --server.port=8080

echo         等后端就绪 ...
set /a T=0
:waitBackend
netstat -ano | findstr ":8080 " | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 goto backendReady
set /a T+=1
if !T! GEQ 45 (
    echo         [警告] 45 秒了 8080 还没起来，先接着启动前端，回头看看后端窗口的报错。
    goto skipBackend
)
rem 用 ping 当 sleep：timeout 在 stdin 被重定向时会直接报错
ping -n 2 127.0.0.1 >nul
goto waitBackend
:backendReady
echo         后端已就绪 ^(8080^)
echo.

:skipBackend

rem ===================== ④ 安装依赖 + 启动前端 =====================
if not exist "%FRONTEND%\package.json" (
    echo   [跳过] 没找到前端目录 %FRONTEND%
    goto end
)

echo   [3/3] 准备前端 ...
npm -v >nul 2>&1
if errorlevel 1 (
    echo   [致命] PATH 里找不到 npm，无法启动前端。
    echo          请检查 Node.js 是否装好、PATH 是否配置正确。
    goto end
)
if not exist "%FRONTEND%\node_modules" (
    echo         node_modules 已丢失，执行 npm install（首次 1-2 分钟）...
    echo.
    pushd "%FRONTEND%"
    call npm install
    set "NPMRC=!ERRORLEVEL!"
    popd
    echo.
    if not "!NPMRC!"=="0" (
        echo   [失败] npm install 失败，请看上面的报错。
        goto end
    )
) else (
    echo         node_modules 已存在，跳过安装。
)

rem 前端必须用 /d 指定工作目录，且 /k 后面不要整体加引号
start "MeiYing-Frontend" /d "%FRONTEND%" cmd /k npm run dev

echo.
echo   ============================================================
echo     启动完成
echo   ------------------------------------------------------------
echo     后端  http://localhost:8080
echo     前端  http://localhost:5173
echo     账号  shenbu_test  /  123456
echo   ------------------------------------------------------------
echo     要停止请双击  stop.bat
echo   ============================================================

:end
echo.
pause
