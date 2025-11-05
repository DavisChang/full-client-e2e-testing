# 🐳 Docker Selenium Grid Usage Guide

This guide explains how to use Docker to run Selenium Grid on **cross-platform** environments (Windows, macOS, Linux).

---

## 📋 Table of Contents

- [System Requirements](#system-requirements)
- [Architecture Overview](#architecture-overview)
- [Quick Start](#quick-start)
- [Using Scripts](#using-scripts)
- [Manual Start](#manual-start)
- [Usage Examples](#usage-examples)
- [VNC Viewer](#vnc-viewer)
- [Troubleshooting](#troubleshooting)

---

## 🖥️ System Requirements

- **Docker Desktop**: >= 4.0
- **Docker Compose**: >= 2.0 (included in Docker Desktop)
- **Systems**: 
  - ✅ Windows 10/11 (x86_64)
  - ✅ macOS (Apple Silicon/ARM64)
  - ✅ macOS (Intel/x86_64)
  - ✅ Linux (x86_64/ARM64)
- **Memory**: At least 4GB available memory

---

## 🏗️ Architecture Overview

This project supports two architectures with automatic adaptation:

### x86_64 Architecture (Windows / Intel Mac / Linux)

Uses official Selenium Docker images:
- `selenium/standalone-chrome`
- `selenium/standalone-firefox`
- `selenium/hub` + `selenium/node-chrome/firefox/edge`

### ARM64 Architecture (Apple Silicon Mac)

Uses community-maintained ARM64 images:
- `seleniarm/standalone-chromium`
- `seleniarm/standalone-firefox`
- `seleniarm/hub` + `seleniarm/node-chromium/firefox`

**Configuration File Structure:**
```
docker-compose.yaml          # Main configuration (x86_64)
docker-compose.arm64.yaml    # ARM64 override configuration
scripts/start-selenium.sh    # macOS/Linux startup script (auto-detect)
scripts/start-selenium.bat   # Windows startup script
```

---

## 🚀 Quick Start

### Method 1: Using Automated Scripts (Recommended)

#### macOS / Linux

```bash
# Grant execute permission (one time only)
chmod +x scripts/start-selenium.sh

# Start Chrome Standalone
./scripts/start-selenium.sh standalone chrome

# Start Chrome + Firefox
./scripts/start-selenium.sh standalone firefox

# Start Grid mode (Hub + Nodes)
./scripts/start-selenium.sh grid

# Start all services
./scripts/start-selenium.sh all
```

#### Windows

```batch
REM Start Chrome Standalone
scripts\start-selenium.bat standalone chrome

REM Start Chrome + Firefox
scripts\start-selenium.bat standalone firefox

REM Start Grid mode (Hub + Nodes)
scripts\start-selenium.bat grid

REM Start all services (including Edge)
scripts\start-selenium.bat all
```

### Method 2: Manual Start

See [Manual Start](#manual-start) section.

---

## 📜 Using Scripts

### Script Features

✅ Auto-detect system architecture (x86_64 / ARM64)  
✅ Auto-select corresponding Docker images  
✅ Health check to confirm service readiness  
✅ Display access addresses and usage tips  

### Script Parameters

```bash
# Syntax
./scripts/start-selenium.sh [mode] [browser]
scripts\start-selenium.bat [mode] [browser]

# Mode options
standalone    # Standalone mode (single container, suitable for simple tests)
grid          # Grid mode (Hub + Nodes, suitable for parallel tests)
all           # Start all services

# Browser options (standalone mode only)
chrome        # Chrome only (default)
firefox       # Chrome + Firefox
```

### Examples

```bash
# macOS/Linux
./scripts/start-selenium.sh                          # Chrome standalone
./scripts/start-selenium.sh standalone firefox       # Chrome + Firefox
./scripts/start-selenium.sh grid                     # Grid mode

# Windows
scripts\start-selenium.bat                           # Chrome standalone
scripts\start-selenium.bat standalone firefox        # Chrome + Firefox
scripts\start-selenium.bat grid                      # Grid mode
```

---

## 🔧 Manual Start

### Windows / Intel Mac / Linux (x86_64)

```bash
# Start Chrome Standalone
docker-compose up -d selenium-chrome

# Start Chrome + Firefox
docker-compose --profile firefox up -d selenium-chrome selenium-firefox

# Start Grid mode
docker-compose --profile grid up -d

# Start Grid + Edge (Windows)
docker-compose --profile grid --profile edge up -d
```

### Apple Silicon Mac (ARM64)

```bash
# Method 1: Using environment variable
export COMPOSE_FILE=docker-compose.yaml:docker-compose.arm64.yaml
docker-compose up -d selenium-chrome

# Method 2: Using -f parameter
docker-compose -f docker-compose.yaml -f docker-compose.arm64.yaml up -d

# Start Firefox
docker-compose -f docker-compose.yaml -f docker-compose.arm64.yaml \
  --profile firefox up -d

# Start Grid mode
docker-compose -f docker-compose.yaml -f docker-compose.arm64.yaml \
  --profile grid up -d
```

### Stop Services

```bash
# Stop all containers
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Stop specific service
docker-compose stop selenium-chrome
```

---

## ⚙️ Service Port Mapping

| Service | Port | Purpose | Platform |
|---------|------|---------|----------|
| **selenium-chrome** | 4444 | WebDriver API | All |
| **selenium-chrome** | 7900 | VNC Viewer | All |
| **selenium-firefox** | 4445 | WebDriver API | All |
| **selenium-firefox** | 7901 | VNC Viewer | All |
| **selenium-hub** | 4446 | Grid UI & WebDriver | All |
| **selenium-hub** | 4442/4443 | Event Bus | All |

---

## 💻 Usage Examples

### Python + Selenium

```python
from selenium import webdriver
from selenium.webdriver.common.by import By

# Method 1: Standalone mode
options = webdriver.ChromeOptions()
driver = webdriver.Remote(
    command_executor='http://localhost:4444',  # Chrome
    options=options
)

# Method 2: Grid mode
driver = webdriver.Remote(
    command_executor='http://localhost:4446',  # Grid Hub
    options=options
)

try:
    driver.get("https://www.google.com")
    print(f"Page title: {driver.title}")
    
    # Find element
    search_box = driver.find_element(By.NAME, "q")
    search_box.send_keys("Selenium Grid")
    search_box.submit()
    
finally:
    driver.quit()
```

### Robot Framework

#### Configuration File Update

Update `resources/keywords/web.robot`:

```robot
*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser With Grid
    [Arguments]    ${url}    ${browser}=chrome
    # Standalone mode
    Open Browser    ${url}    ${browser}    
    ...    remote_url=http://localhost:4444
    
    # Grid mode
    # Open Browser    ${url}    ${browser}    
    # ...    remote_url=http://localhost:4446
    
    Maximize Browser Window
    Set Selenium Implicit Wait    10s
```

#### Test Usage

```robot
*** Settings ***
Resource    ../../resources/keywords/web.robot

*** Test Cases ***
Test Google Search
    Open Browser With Grid    https://www.google.com    chrome
    Title Should Be    Google
    Close Browser
```

### pytest + Selenium

```python
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By

@pytest.fixture
def driver():
    """Selenium Grid WebDriver fixture"""
    options = webdriver.ChromeOptions()
    
    # Connect to Docker Selenium Grid
    driver = webdriver.Remote(
        command_executor='http://localhost:4444',
        options=options
    )
    
    driver.implicitly_wait(10)
    driver.maximize_window()
    
    yield driver
    driver.quit()

def test_google_homepage(driver):
    """Test Google homepage"""
    driver.get("https://www.google.com")
    assert "Google" in driver.title
    
def test_google_search(driver):
    """Test Google search"""
    driver.get("https://www.google.com")
    
    search_box = driver.find_element(By.NAME, "q")
    search_box.send_keys("Selenium Grid")
    search_box.submit()
    
    # Wait for results to load
    driver.implicitly_wait(5)
    assert "Selenium Grid" in driver.title
```

---

## 🖼️ VNC Viewer

Use VNC to view browser test execution in real-time.

### Method 1: Using Browser (Recommended)

Open directly in browser (supports Windows, macOS, Linux):

- **Chrome Standalone**: http://localhost:7900
- **Firefox Standalone**: http://localhost:7901

Default password: `secret` (configured for no password)

### Method 2: Using VNC Client

#### macOS

```bash
# Use built-in VNC client
open vnc://localhost:7900  # Chrome
open vnc://localhost:7901  # Firefox
```

#### Windows

1. Download [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)
2. Connect to `localhost:7900` or `localhost:7901`

#### Linux

```bash
# Use Remmina
sudo apt install remmina
remmina -c vnc://localhost:7900
```

---

## 🔧 Troubleshooting

### 1. Container Cannot Start

```bash
# View detailed logs
docker-compose logs selenium-chrome

# Check if port is occupied (macOS/Linux)
lsof -i:4444

# Check if port is occupied (Windows)
netstat -ano | findstr :4444

# Clean up and restart
docker-compose down
docker-compose up -d
```

### 2. ARM64 Image Pull Failed (Apple Silicon)

Ensure using correct script or configuration:

```bash
# ✅ Correct: Use automated script
./scripts/start-selenium.sh

# ✅ Correct: Manually specify ARM64 configuration
docker-compose -f docker-compose.yaml -f docker-compose.arm64.yaml up -d

# ❌ Wrong: Use main configuration only (will try to pull x86_64 images)
docker-compose up -d  # Will fail on ARM64 Mac
```

### 3. Edge Node Cannot Start on Windows

Ensure using Grid mode and enable Edge profile:

```batch
docker-compose --profile grid --profile edge up -d
```

### 4. Memory Insufficient

Adjust Docker Desktop memory settings:

**Docker Desktop > Settings > Resources > Memory**

Recommended minimum allocation:
- Standalone mode: 4GB
- Grid mode: 8GB

### 5. Network Connection Issues

```bash
# View networks
docker network ls

# Check container IP
docker inspect selenium-chrome | grep IPAddress

# Test connection
curl http://localhost:4444/wd/hub/status

# Windows use
curl.exe http://localhost:4444/wd/hub/status
```

### 6. Slow Test Execution

#### Increase Concurrent Sessions

Edit `docker-compose.yaml`:

```yaml
environment:
  SE_NODE_MAX_SESSIONS: 8  # Increase to 8
```

#### Use Grid Mode

Grid mode allows parallel test execution:

```bash
./scripts/start-selenium.sh grid
```

---

## 📊 Health Check

All services are configured with health checks:

```bash
# View health status
docker-compose ps

# Example output:
# NAME               STATUS              PORTS
# selenium-chrome    Up (healthy)        0.0.0.0:4444->4444/tcp

# Manual status check
curl http://localhost:4444/wd/hub/status | jq .value.ready
# Output: true
```

---

## 🎯 Best Practices

### 1. Use Specific Version Tags

Production environments should use specific versions instead of `latest`:

```yaml
# x86_64
image: selenium/standalone-chrome:130.0

# ARM64
image: seleniarm/standalone-chromium:130.0
```

### 2. Choose Appropriate Mode

| Mode | Use Case | Advantages | Disadvantages |
|------|----------|------------|---------------|
| **Standalone** | Local development, quick tests | Fast startup, fewer resources | No parallelization |
| **Grid** | CI/CD, large-scale testing | Parallel execution, scalable | Higher resource consumption |

### 3. Configure Log Level

Use `FINE` for development, `INFO` for production:

```yaml
SE_OPTS: "--log-level INFO"
```

### 4. Regular Cleanup

```bash
# Stop and remove containers
docker-compose down

# Clean unused images
docker image prune -a

# Clean all unused resources
docker system prune -a
```

---

## 🌍 Cross-Platform Considerations

### Windows Specific Configuration

1. **Path Format**: Use backslash `\` or forward slash `/`
2. **Edge Support**: Windows can use Edge nodes
3. **PowerShell vs CMD**: Scripts support both

### macOS Specific Configuration

1. **Apple Silicon**: Auto-use ARM64 images
2. **Built-in VNC Support**: Can use `open vnc://` command
3. **Shared Memory**: Auto-configured

### Linux Specific Configuration

1. **Docker Permissions**: May require `sudo`
2. **Firewall**: Ensure ports aren't blocked

---

## 📚 Reference Resources

- [Selenium Docker Official Documentation](https://github.com/SeleniumHQ/docker-selenium)
- [Seleniarm (ARM64 Support)](https://github.com/seleniumhq-community/docker-seleniarm)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Selenium WebDriver Documentation](https://www.selenium.dev/documentation/webdriver/)

---

## 💡 Quick Command Reference

```bash
# ============ macOS / Linux ============

# Start (auto-detect architecture)
./scripts/start-selenium.sh standalone chrome
./scripts/start-selenium.sh grid

# View status
docker-compose ps
docker-compose logs -f selenium-chrome

# Stop
docker-compose down

# ============ Windows ============

# Start
scripts\start-selenium.bat standalone chrome
scripts\start-selenium.bat grid

# View status
docker-compose ps
docker-compose logs -f selenium-chrome

# Stop
docker-compose down

# ============ Common Commands ============

# Health check
curl http://localhost:4444/wd/hub/status

# VNC viewer
open http://localhost:7900        # macOS/Linux
start http://localhost:7900       # Windows

# Clean resources
docker system prune -a
```

---

**Update Date**: 2025-11-04  
**Applicable Version**: Docker Compose >= 2.0  
**Supported Platforms**: Windows, macOS (ARM64/Intel), Linux
