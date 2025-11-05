@echo off
REM Windows 快速設置腳本
REM Windows Quick Setup Script

echo ============================================================
echo Full Client E2E Testing - Windows Setup
echo ============================================================

python scripts\setup.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ 設置失敗！
    pause
    exit /b 1
)

echo.
echo ✅ 設置完成！
echo.
echo 下一步:
echo   1. 啟動虛擬環境:
echo      .venv\Scripts\activate
echo.
echo   2. 執行測試:
echo      python scripts\run_tests.py --platform mac
echo.
pause

