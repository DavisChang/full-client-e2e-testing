@echo off
REM 跨平台啟動 Selenium Grid 腳本 (Windows)
REM 自動檢測系統架構並使用對應的 Docker 鏡像

setlocal enabledelayedexpansion

echo ========================================
echo    啟動 Selenium Grid (Windows)
echo ========================================
echo.

REM 檢測系統架構
set ARCH=%PROCESSOR_ARCHITECTURE%
echo 系統架構: %ARCH%
echo.

REM Windows 通常是 AMD64 (x86_64)
set COMPOSE_FILES=docker-compose.yaml
echo 使用配置: %COMPOSE_FILES%

REM 檢查 Docker 是否運行
docker info >nul 2>&1
if errorlevel 1 (
    echo [錯誤] Docker 未運行，請先啟動 Docker Desktop
    exit /b 1
)

REM 解析參數
set MODE=%1
set BROWSER=%2

if "%MODE%"=="" set MODE=standalone
if "%BROWSER%"=="" set BROWSER=chrome

echo 啟動模式: %MODE%
echo 瀏覽器: %BROWSER%
echo.

REM 根據模式啟動服務
if "%MODE%"=="standalone" (
    echo [啟動] Standalone 模式 - %BROWSER%
    if "%BROWSER%"=="firefox" (
        docker-compose --profile firefox up -d selenium-chrome selenium-firefox
    ) else (
        docker-compose up -d selenium-chrome
    )
) else if "%MODE%"=="grid" (
    echo [啟動] Grid 模式
    docker-compose --profile grid up -d
) else if "%MODE%"=="all" (
    echo [啟動] 所有服務
    docker-compose --profile firefox --profile grid --profile edge up -d
) else (
    echo [錯誤] 未知模式: %MODE%
    echo 用法: %~nx0 [standalone^|grid^|all] [chrome^|firefox]
    exit /b 1
)

REM 等待服務就緒
echo.
echo 等待服務啟動...
timeout /t 5 /nobreak >nul

REM 檢查服務狀態
echo.
echo ========================================
echo    服務狀態
echo ========================================
docker-compose ps

REM 顯示訪問地址
echo.
echo ========================================
echo    Selenium Grid 已啟動！
echo ========================================
echo.
echo 訪問地址:

docker ps --format "{{.Names}}" | findstr /C:"selenium-chrome" >nul
if not errorlevel 1 (
    echo   Chrome WebDriver:  http://localhost:4444
    echo   Chrome VNC:        http://localhost:7900
)

docker ps --format "{{.Names}}" | findstr /C:"selenium-firefox" >nul
if not errorlevel 1 (
    echo   Firefox WebDriver: http://localhost:4445
    echo   Firefox VNC:       http://localhost:7901
)

docker ps --format "{{.Names}}" | findstr /C:"selenium-hub" >nul
if not errorlevel 1 (
    echo   Grid Console:      http://localhost:4446
)

echo.
echo 提示:
echo   - 查看日誌: docker-compose logs -f
echo   - 停止服務: docker-compose down
echo   - 查看狀態: curl http://localhost:4444/wd/hub/status
echo.

endlocal

