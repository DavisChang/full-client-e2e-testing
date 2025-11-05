#!/bin/bash
# 跨平台啟動 Selenium Grid 腳本
# 自動檢測系統架構並使用對應的 Docker 鏡像

set -e

# 顏色輸出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 啟動 Selenium Grid...${NC}"

# 檢測系統架構
ARCH=$(uname -m)
OS=$(uname -s)

echo -e "${YELLOW}系統資訊:${NC}"
echo "  作業系統: $OS"
echo "  架構: $ARCH"

# 設置 Docker Compose 文件
COMPOSE_FILES="docker-compose.yaml"

if [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
    echo -e "${YELLOW}✓ 檢測到 ARM64 架構 (Apple Silicon)${NC}"
    COMPOSE_FILES="docker-compose.yaml:docker-compose.arm64.yaml"
else
    echo -e "${YELLOW}✓ 檢測到 x86_64 架構${NC}"
fi

export COMPOSE_FILE=$COMPOSE_FILES

# 檢查 Docker 是否運行
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker 未運行，請先啟動 Docker Desktop${NC}"
    exit 1
fi

# 解析參數
MODE=${1:-standalone}
BROWSER=${2:-chrome}

case $MODE in
    standalone)
        echo -e "${GREEN}📦 啟動 Standalone 模式 - $BROWSER${NC}"
        if [[ "$BROWSER" == "firefox" ]]; then
            docker-compose --profile firefox up -d selenium-chrome selenium-firefox
        else
            docker-compose up -d selenium-chrome
        fi
        ;;
    grid)
        echo -e "${GREEN}🌐 啟動 Grid 模式${NC}"
        docker-compose --profile grid up -d
        ;;
    all)
        echo -e "${GREEN}🎯 啟動所有服務${NC}"
        docker-compose --profile firefox --profile grid up -d
        ;;
    *)
        echo -e "${RED}❌ 未知模式: $MODE${NC}"
        echo "用法: $0 [standalone|grid|all] [chrome|firefox]"
        exit 1
        ;;
esac

# 等待服務就緒
echo -e "${YELLOW}⏳ 等待服務啟動...${NC}"
sleep 5

# 檢查服務狀態
echo -e "${GREEN}✅ 服務狀態:${NC}"
docker-compose ps

# 顯示訪問地址
echo ""
echo -e "${GREEN}🎉 Selenium Grid 已啟動！${NC}"
echo ""
echo -e "${YELLOW}📍 訪問地址:${NC}"

if docker ps --format '{{.Names}}' | grep -q "selenium-chrome"; then
    echo "  Chrome WebDriver:  http://localhost:4444"
    echo "  Chrome VNC:        http://localhost:7900"
fi

if docker ps --format '{{.Names}}' | grep -q "selenium-firefox"; then
    echo "  Firefox WebDriver: http://localhost:4445"
    echo "  Firefox VNC:       http://localhost:7901"
fi

if docker ps --format '{{.Names}}' | grep -q "selenium-hub"; then
    echo "  Grid Console:      http://localhost:4446"
fi

echo ""
echo -e "${YELLOW}💡 提示:${NC}"
echo "  - 查看日誌: docker-compose logs -f"
echo "  - 停止服務: docker-compose down"
echo "  - 查看狀態: curl http://localhost:4444/wd/hub/status"

