#!/bin/bash
# macOS/Linux 快速設置腳本
# macOS/Linux Quick Setup Script

set -e

echo "============================================================"
echo "Full Client E2E Testing - macOS/Linux Setup"
echo "============================================================"

python3 scripts/setup.py

echo ""
echo "✅ 設置完成！"
echo ""
echo "下一步:"
echo "  1. 啟動虛擬環境:"
echo "     source .venv/bin/activate"
echo ""
echo "  2. 執行測試:"
echo "     python scripts/run_tests.py --platform mac"
echo ""

