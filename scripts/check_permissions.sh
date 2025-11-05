#!/bin/bash
# 檢查 macOS Accessibility 權限

echo "========================================"
echo "檢查 macOS Accessibility 權限"
echo "========================================"
echo ""

# 檢查 Terminal 權限
echo "1. 檢查 Terminal Accessibility 權限..."
if osascript -e 'tell application "System Events" to get name of first process' &>/dev/null; then
    echo "   ✅ Terminal 有 Accessibility 權限"
else
    echo "   ❌ Terminal 沒有 Accessibility 權限"
    echo "   請執行: open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'"
fi

echo ""
echo "2. 檢查 Python 執行檔..."
PYTHON_PATH=$(which python)
echo "   Python 路徑: $PYTHON_PATH"

echo ""
echo "3. 檢查 Appium 狀態..."
if curl -s http://localhost:4723/status &>/dev/null; then
    echo "   ✅ Appium 服務器正在運行"
    curl -s http://localhost:4723/status | python3 -m json.tool 2>/dev/null || echo "   (無法解析響應)"
else
    echo "   ❌ Appium 服務器未運行"
    echo "   請在另一個終端執行: appium"
fi

echo ""
echo "4. 檢查 Calculator 是否在運行..."
if pgrep -x "Calculator" > /dev/null; then
    echo "   ✅ Calculator 正在運行"
else
    echo "   ℹ️  Calculator 未運行（測試時會自動啟動）"
fi

echo ""
echo "========================================"
echo "完成檢查"
echo "========================================"

