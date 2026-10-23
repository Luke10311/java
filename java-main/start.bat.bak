@echo off
chcp 936 >nul
setlocal enabledelayedexpansion
title MeiYing ShenBu - 一键启动

rem ==================================================================
rem  魅影神捕  一键启动（后端 Spring Boot + 前端 Vue）
rem
rem  · 全篇用相对路径（%~dp0 = 本脚本所在目录），整个文件夹挪走也能跑
rem  · java / npm / mvn 优先用 PATH 里的，找不到才去常见位置兜底
rem  · node_modules 和 target 每次开机都会被删，所以会自动重建
rem ==================================================================

rem ---------- ① 定位后端目录 ----------
rem 按顺序找，第一个含 pom.xml 的胜出：
rem   1) 本文件夹下的 springBootTest         —— 最新版后端（10-10）
rem                                             产物 springBootTest-0.0.1-SNAPSHOT.jar
rem   2) 本文件夹下的 meiying-shenbu-backend —— 另一份等价实现（10-09）
rem                                             产物 shenbu-backend-1.0.0.jar
rem   3) 本文件夹下的 backend               —— 兼容旧命名
rem   4) D:\workSpace\springBootTest        —— 绝对路径兜底
rem      注意：D 盘那份是「还没接入 MyBatis-Plus」的旧状态，没有 /api/user 接口，
rem      只在前面全部落空时才会用到（用到时会给出警告）
set "BACKEND="
for %%D in ("%~dp0springBootTest" "%~dp0meiying-shenbu-backend" "%~dp0backend" "D:\workSpace\springBootTest") do (
    if not defined BACKEND if exist "%%~fD\pom.xml" set "BACKEND=%%~fD"
)
set "FRONTEND=%~dp0meiying-shenbu-vue"

rem ---------- ② 清掉会顶掉配置文件的环境变量 ----------
rem Spring Boot 松散绑定会把 SERVER__PORT 当成 server.port，害得端口乱跑
rem （本机确实存在 SERVER__PORT，日志里见过 Tomcat 起在 53125 这种随机端口）
set "SERVER__PORT="
set "SERVER__HOST="
set "SERVER_PORT="
set "SERVER_HOST="

echo.
echo   ============================================================
echo     魅影神捕  一键启动
echo   ============================================================
if defined BACKEND (echo     后端 : %BACKEND%) else (echo     后端 : 未找到，将只启动前端)
if exist "%FRONTEND%\package.json" (echo     前端 : %FRONTEND%) else (echo     前端 : 未找到 ^(%FRONTEND%^))
echo   ============================================================

rem 选中兜底后端时明确警告：它不是可用的接口后端
if /i "%BACKEND%"=="D:\workSpace\springBootTest" (
    echo     [警告] 用的是兜底后端，它没有 /api/user 接口。
    echo            前端登录会报"未找到"。请把 springBootTest 或
    echo            meiying-shenbu-backend 整个文件夹放到 start.bat 旁边再启动。
    echo.
)

rem 前端目录缺失时给出可操作的提示（这才是"前端 : 未找到"的真正原因）
if not exist "%FRONTEND%\package.json" (
    echo     [提示] 前端目录缺失：%FRONTEND%
    echo            请确认 meiying-shenbu-vue 与 start.bat 在同一个文件夹里。
    echo.
)

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

rem 后端 jar 名跟着 pom.xml 的 artifactId 走，所以不能写死项目名：
rem 用 *.jar 通配，并用 %%~nxJ 只取文件名（免得 dir 回完整路径后拼接出错）
set "JARFILE="
for /f "delims=" %%J in ('dir /b /o-d "%BACKEND%\target\*.jar" 2^>nul') do (
    if not defined JARFILE set "JARFILE=%%~nxJ"
)

if defined JARFILE (
    echo         已有 %JARFILE%，跳过构建。
) else (
    rem ---------- 找一个能用的 mvn ----------
    rem 顺序：PATH → MAVEN_HOME / M2_HOME → IntelliJ IDEA 内置 → 项目自带 mvnw.cmd
    rem （mvnw.cmd 放最后：本机 .m2/wrapper 是空的，走它需要联网下载 Maven）
    set "MVNCMD="
    where mvn >nul 2>&1
    if not errorlevel 1 set "MVNCMD=mvn"

    if not defined MVNCMD if defined MAVEN_HOME if exist "%MAVEN_HOME%\bin\mvn.cmd" set "MVNCMD=%MAVEN_HOME%\bin\mvn.cmd"
    if not defined MVNCMD if defined M2_HOME if exist "%M2_HOME%\bin\mvn.cmd" set "MVNCMD=%M2_HOME%\bin\mvn.cmd"
    if not defined MVNCMD (
        for /d %%I in ("D:\IntelliJ IDEA*" "C:\Program Files\JetBrains\*" "%LOCALAPPDATA%\Programs\IntelliJ IDEA*") do (
            if not defined MVNCMD if exist "%%~fI\plugins\maven\lib\maven3\bin\mvn.cmd" (
                set "MVNCMD=%%~fI\plugins\maven\lib\maven3\bin\mvn.cmd"
            )
        )
    )
    if not defined MVNCMD if exist "%BACKEND%\mvnw.cmd" set "MVNCMD=%BACKEND%\mvnw.cmd"
    if not defined MVNCMD (
        echo   [致命] 找不到 Maven：PATH 里没有 mvn，也没找到 IDEA 内置的 mvn.cmd。
        echo          请安装 Maven 并加入 PATH，或用 IntelliJ IDEA 打开后端
        echo          %BACKEND%  自行执行 package。
        goto end
    )

    echo         target 已丢失，用 !MVNCMD! 构建（首次要下依赖，请等 1-3 分钟）...
    echo.
    pushd "%BACKEND%"
    call "!MVNCMD!" -B package -DskipTests
    set "MVNRC=!ERRORLEVEL!"
    popd
    echo.
    if not "!MVNRC!"=="0" (
        echo   [失败] Maven 构建失败，请看上面的报错。
        goto end
    )
    for /f "delims=" %%J in ('dir /b /o-d "%BACKEND%\target\*.jar" 2^>nul') do (
        if not defined JARFILE set "JARFILE=%%~nxJ"
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
rem 显式 --server.port=8080 能压过环境变量里的 SERVER__PORT
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

rem ---------- 探活：确认后端上真有 /api/user 接口 ----------
rem 启动的不是接口后端时，这里能把"前端登录报未找到"提前讲清楚
where curl >nul 2>&1
if errorlevel 1 goto probeDone
set "HTTPCODE="
for /f %%C in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/user/me') do set "HTTPCODE=%%C"
if "!HTTPCODE!"=="404" (
    echo         [警告] 8080 上的服务没有 /api/user 接口 ^(HTTP 404^)。
    echo                当前后端不是可用的接口后端，前端调接口会"未找到"。
    echo                请检查 %BACKEND%
) else if "!HTTPCODE!"=="000" (
    echo         [警告] 8080 端口连不上，后端可能启动失败。
) else (
    echo         接口探活：/api/user/me 返回 !HTTPCODE!，正常。
)
:probeDone
echo.

:skipBackend

rem ===================== ④ 安装依赖 + 启动前端 =====================
if not exist "%FRONTEND%\package.json" (
    echo   [跳过] 没找到前端目录 %FRONTEND%
    goto end
)

rem 注意：npm 在 Windows 上是 npm.cmd，属于批处理文件，
rem 这里必须写 call npm，否则控制权交给 npm.cmd 后不再返回，
rem 脚本会在这一行静默结束，前端永远不会启动。
echo   [3/3] 准备前端 ...
call npm -v >nul 2>&1
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
