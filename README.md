# Full Client E2E Testing Framework

<div align="center">

**Comprehensive Cross-Platform End-to-End Automation Testing Framework**  
Built with Robot Framework + Appium + Selenium, supporting Web, Windows, macOS, and Android platforms

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-6.1+-orange.svg)](https://robotframework.org/)
[![Appium](https://img.shields.io/badge/Appium-3.x-purple.svg)](https://appium.io/)
[![Node](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen.svg)](https://nodejs.org/)

[Features](#-features) • [Quick Start](#-quick-start) • [Documentation](#-project-structure) • [Contributing](./CONTRIBUTING.md)

</div>

---

## ✨ Features

- ✅ **Multi-Platform Support** - Web, Android, Windows, macOS - one framework for all
- ✅ **Dual Testing Frameworks** - Robot Framework + Python pytest coexist
- ✅ **AI-Assisted Development** - Complete guide for accelerating test development with AI
- ✅ **Environment Parameterization** - Easily switch between dev/test/production environments
- ✅ **Docker Support** - One-click Selenium Grid and Appium setup
- ✅ **CI/CD Integration** - GitHub Actions example configurations
- ✅ **Battle-Tested** - Includes complete macOS Calculator test cases with cross-version support

---

## 🚀 Quick Start

> **🤖 AI-Assisted Testing:** New to test automation or want to accelerate development with AI?  
> See our comprehensive guide: [AI_ASSISTED_TESTING_GUIDE.md](./AI_ASSISTED_TESTING_GUIDE.md)

> **💡 Cross-Platform Support:** This project fully supports macOS and Windows!  
> For detailed cross-platform guide, see [CROSS_PLATFORM_GUIDE.md](./CROSS_PLATFORM_GUIDE.md)

> **🐳 Docker Selenium Grid:** Supports Windows, macOS (ARM64/Intel), Linux!  
> For detailed Docker guide, see [DOCKER_SELENIUM_GUIDE.md](./DOCKER_SELENIUM_GUIDE.md)

### 1. Environment Setup

#### 🍎 macOS / Linux

```bash
# Method 1: One-Click Setup (Recommended)
chmod +x setup.sh
./setup.sh

# Method 2: Using Python Script
python3 scripts/setup.py

# Method 3: Manual Installation
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
npm install
cp .env.example .env
```

#### 🪟 Windows

```batch
REM Method 1: One-Click Setup (Recommended)
setup.bat

REM Method 2: Using Python Script
python scripts\setup.py

REM Method 3: Manual Installation
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
npm install
copy .env.example .env
```

### 2. Start Testing Services

#### macOS/Windows Local Testing (Recommended)

##### 🍎 macOS

```bash
# 0. Check System Permissions (Recommended)
chmod +x scripts/check_permissions.sh
./scripts/check_permissions.sh

# 1. Install Appium 3.x and Mac2 driver
# Note: Appium 3.x requires Node.js v22.12.0+ or v20.19.0+
nvm install 22.13.1  # or use Node.js 20.19.0+
nvm use 22.13.1
nvm alias default 22.13.1

npm install -g appium@3.1.0
appium driver install mac2

# 2. Grant Accessibility Permissions
# Open System Settings > Privacy & Security > Accessibility
# Check Terminal.app or your terminal app
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

# 3. Start Appium Server (in a new terminal window)
appium

# 4. Run Tests (in another terminal)
# Using cross-platform script
python scripts/run_tests.py --platform mac --env dev

# Or use Robot Framework directly
robot --variable ENV:dev --variable PLATFORM:mac tests/mac/calculator_full_test.robot

# Or use Python pytest
python3 -m pytest tests/python/test_mac_calculator.py -v
```

**Important Note - macOS Appium 3.x Requirements**:
- Mac2 driver 3.x uses `@title` and `@label` attributes (**does NOT support** `@name`)
- Number buttons: `@title="1"`, `@title="2"`, etc.
- Operators: `@title="+"`, `@title="×"`, `@title="="`, etc.
- Display result: `@label="main display"` or `@label="主要顯示方式"` (varies by macOS version)

**🎯 Cross-Version & Language Compatibility**:
- ✅ Automatically supports multiple macOS versions (10.x ~ 15.x+)
- ✅ **Language independent** - works on English, Chinese, or any other language system
- ✅ Uses structural element location (not dependent on label text)
- ✅ No manual configuration needed - works on all macOS versions and languages

##### 🪟 Windows

```batch
REM 1. Install Appium and Windows driver (for Windows app testing)
npm install -g appium
appium driver install windows

REM 2. Start Appium Server
start /B appium

REM 3. Run Tests (using cross-platform script)
python scripts\run_tests.py --platform windows --env dev

REM Or use Robot Framework directly
robot --variable ENV:dev --variable PLATFORM:windows tests\windows\
```

#### Web Testing
```bash
# Start Selenium Grid using Docker
make compose-up

# Run Web tests
robot --variable ENV:dev --variable PLATFORM:web tests/web/login_web.robot
```

#### Android Testing
```bash
# Ensure Appium is started and device/emulator is connected
robot --variable ENV:dev --variable PLATFORM:android tests/android/login_android.robot
```

---

## 📁 Project Structure

```
full-client-e2e-testing/
├── config/                          # Configuration files
│   ├── drivers/                     # Platform-specific driver configs
│   │   ├── web.yaml                 # Selenium WebDriver config
│   │   ├── android.yaml             # Appium Android config
│   │   ├── mac.yaml                 # Appium Mac2 config
│   │   └── windows.yaml             # WinAppDriver config
│   └── environments/                # Environment configs
│       ├── dev.yaml                 # Development environment
│       └── staging.yaml             # Staging environment
│
├── resources/                       # Test resources
│   ├── keywords/                    # Robot Framework keywords
│   │   ├── environment.robot        # Environment loading
│   │   ├── web.robot                # Web test keywords
│   │   ├── android.robot            # Android test keywords
│   │   └── mac.robot                # Mac test keywords
│   ├── variables/                   # UI locators
│   │   ├── web_locators.robot
│   │   ├── android_locators.robot
│   │   └── mac_locators.robot
│   └── libs/                        # Python helper libraries
│       ├── env_loader.py            # Environment variable loader
│       └── appium_helper.py         # Appium helper functions
│
├── tests/                           # Test cases
│   ├── web/                         # Web tests
│   ├── android/                     # Android tests
│   ├── mac/                         # macOS tests
│   │   ├── sample_mac.robot         # Basic tests
│   │   └── calculator_full_test.robot  # Complete calculator tests
│   ├── python/                      # Python tests
│   │   ├── test_health.py           # Health check
│   │   └── test_mac_calculator.py   # Mac Calculator tests
│   └── journeys/                    # Cross-platform journey tests
│
├── tools/                           # Tool scripts
├── .github/workflows/               # CI/CD configurations
├── .env                             # Environment variables (not in version control)
├── .env.example                     # Environment variable template
├── docker-compose.yaml              # Docker configuration
├── Makefile                         # Make commands
├── requirements.txt                 # Python dependencies
├── package.json                     # Node.js dependencies
└── README.md                        # This file
```

---

## 🎯 macOS Testing Complete Guide

### Prerequisites

1. **macOS System** (test target)
2. **Appium 3.x + Mac2 Driver**
3. **Python 3.9+**
4. **Node.js 18+** (for Appium)

### Installation Steps

```bash
# 1. Install Appium
npm install -g appium

# 2. Install Mac2 Driver
appium driver install mac2

# 3. Verify Installation
appium driver list
```

### Accessibility Permission Setup (Important!)

macOS testing requires Accessibility permissions to control UI:

1. Open **System Settings** (or **System Preferences** on older macOS)
2. Go to **Privacy & Security** → **Accessibility**
3. Click **+** to add the following applications:
   - **Terminal.app** (if using Terminal)
   - **iTerm.app** (if using iTerm)
   - **Cursor** (if using Cursor IDE)
   - **Visual Studio Code** (if running tests from VS Code terminal)
4. Ensure toggles are enabled (blue)
5. **Important:** After granting permissions, **restart your terminal** for changes to take effect

**Quick Test Accessibility Permissions:**
```bash
# This command should return a process name without error
osascript -e 'tell application "System Events" to get name of first process'
```

### Running Tests

```bash
# Start Appium (in background)
appium &

# Robot Framework complete test suite
robot --variable ENV:dev --variable PLATFORM:mac tests/mac/calculator_full_test.robot

# Python pytest tests
python3 -m pytest tests/python/test_mac_calculator.py -v

# Run single test
python3 -m pytest tests/python/test_mac_calculator.py::TestMacCalculator::test_calculator_addition_1_plus_2 -v

# View test reports
open log.html       # Robot Framework detailed log
open report.html    # Robot Framework test report
```

### Test Coverage

✅ **Implemented Test Cases:**
- Calculator application launch test
- Addition operation tests (1+2, 5+5, 3+7)
- Multiplication operation test (4×5)

📝 **Expandable Tests:**
- Subtraction operations (−)
- Division operations (÷)
- Decimal point operations
- Clear function (AC)
- Continuous operations

### Cross-Version Compatibility

**🌟 Structural Element Location (Language & Version Independent):**

Our test framework uses **structural element location** that doesn't depend on text labels:

| macOS Version | System Language | Support Status |
|---------------|-----------------|----------------|
| macOS 10.x (Catalina) | Any (EN/ZH/JP/etc.) | ✅ Supported |
| macOS 11.x (Big Sur) | Any (EN/ZH/JP/etc.) | ✅ Supported |
| macOS 12.x (Monterey) | Any (EN/ZH/JP/etc.) | ✅ Supported |
| macOS 13.x (Ventura) | Any (EN/ZH/JP/etc.) | ✅ Supported |
| macOS 14.x (Sonoma) | Any (EN/ZH/JP/etc.) | ✅ Supported |
| macOS 15.x (Sequoia) | Any (EN/ZH/JP/etc.) | ✅ Supported |

**Implementation:** The `get_calculator_result()` method in `test_mac_calculator.py` uses structural XPath (e.g., `//Window//Group[1]//StaticText[1]`) instead of text-based labels, making it work universally across all languages and versions.

### Test Results

For latest test results, see: [MAC_CALCULATOR_TEST_RESULTS.md](./MAC_CALCULATOR_TEST_RESULTS.md)

```
✅ Python Tests: 5 passed in 20.55s
✅ Robot Tests: 5 passed, 0 failed
✅ Cross-Version: Tested on macOS 10.x ~ 15.x
```

---

## 🪟 Windows Testing

### Windows Local Testing (Calculator)

#### Test Status
- ✅ **Python Tests**: 4/4 passed (100%)
- ✅ **Robot Framework Tests**: 7/7 passed (100%)
- ✅ **Chinese Encoding Tests**: Successfully supported

#### Quick Start

```powershell
# 1. Start WinAppDriver (Administrator privileges required)
.\start-winappdriver-port4724.ps1

# 2. Run Tests
# English version (Recommended, stable)
python -m pytest tests\python\test_windows_simple.py -v

# Chinese version (Requires UTF-8 environment)
.\setup-utf8-env.ps1
python -m pytest tests\python\test_windows_chinese.py -v -s

# Robot Framework
robot tests\windows\calculator_full_test.robot

# 3. View Reports
start report.html
```

#### Technical Highlights

**1. Selenium 4 Compatibility** ✅
- Issue: Selenium 4 API incompatible with WinAppDriver
- Solution: Use HTTP direct communication to bypass API limitations
- Result: Full compatibility, no dependency downgrade needed

**2. Port Conflict Handling** ✅  
- Issue: Port 4723 occupied by system
- Solution: Automatically use alternative port 4724
- Configuration: `WIN_REMOTE_URL=http://127.0.0.1:4724`

**3. Chinese Encoding Support** ✅
- Issue: Windows PowerShell doesn't support UTF-8 by default
- Solution: Provide environment setup scripts and bilingual test versions
- Documentation: [CHINESE_ENCODING_GUIDE.md](./CHINESE_ENCODING_GUIDE.md)

#### Test Coverage

| Test Type | Test Cases | Status |
|-----------|------------|--------|
| Addition Tests | 1+2=3, 5+5=10 | ✅ |
| Subtraction Tests | 10-3=7 | ✅ |
| Multiplication Tests | 4×5=20 | ✅ |

#### Documentation Resources

- 💻 **Local Testing Guide**: [WINDOWS_LOCAL_TESTING.md](./WINDOWS_LOCAL_TESTING.md)
  - Complete setup steps
  - WinAppDriver startup guide
  - Port conflict handling
  
- 📊 **Test Results**: [WINDOWS_TEST_RESULTS.md](./WINDOWS_TEST_RESULTS.md)
  - Detailed test results
  - Performance metrics

- 🌏 **Chinese Encoding**: [CHINESE_ENCODING_GUIDE.md](./CHINESE_ENCODING_GUIDE.md)
  - UTF-8 environment setup
  - Multiple solutions

---

## 🪟 Windows Remote Testing (Calculator)

### Overview

This framework supports remotely controlling a Windows machine from a Mac development machine to execute automated tests. You can write and execute tests on Mac while the actual application (like Windows Calculator) runs on the remote Windows machine.

```
Mac (Development Machine)         Windows (Test Machine)
┌──────────────────┐              ┌────────────────────┐
│ Robot Framework  │──Network──>│  WinAppDriver      │
│ Python Pytest    │  HTTP/4723   │  Calculator App    │
└──────────────────┘              └────────────────────┘
```

### Quick Start

#### 1. Windows Setup (One-Time Configuration)

Two methods to set up Windows machine:

##### Method A: Direct Execution on Windows Machine (Recommended)

Execute the following steps on the remote Windows machine:

```powershell
# 1. Download and copy setup-windows-remote.ps1 script to Windows machine

# 2. Open PowerShell as Administrator

# 3. Allow script execution (first time)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 4. Run setup script
.\setup-windows-remote.ps1
```

##### Method B: Remote Setup via SSH from Mac

If you've enabled Windows SSH Server, you can remotely transfer and execute scripts from Mac:

**Step 1: Enable SSH Server on Windows**

Execute on Windows machine as Administrator:

```powershell
# Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start SSH service
Start-Service sshd

# Set to auto-start
Set-Service -Name sshd -StartupType 'Automatic'

# Configure firewall (usually auto-created)
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Verify service status
Get-Service sshd
```

**Step 2: Transfer Script from Mac**

```bash
# Transfer setup script to Windows (replace username and IP address)
scp scripts/setup-windows-remote.ps1 username@192.168.1.100:C:/Users/username/Desktop/

# SSH connect to Windows
ssh username@192.168.1.100

# Execute in Windows PowerShell (Administrator privileges required)
# Note: Recommended to right-click "Run as Administrator" in GUI
cd C:\Users\username\Desktop
.\setup-windows-remote.ps1
```

**Tip:** Since the script requires Administrator privileges, it's recommended to transfer via SSH and then right-click the script in Windows GUI to select "Run PowerShell as Administrator".

**The script will automatically:**
- ✅ Check system requirements (Windows 10/11)
- ✅ Enable Developer Mode
- ✅ Download and install WinAppDriver
- ✅ Configure firewall (open port 4723)
- ✅ Start WinAppDriver service
- ✅ Display configuration info (IP and App ID)

#### 2. Mac Configuration

Add Windows configuration in the `.env` file in project root:

```bash
# Windows Remote Testing Configuration
# Use actual values from Windows script output
WIN_REMOTE_URL=http://192.168.1.100:4723
WINDOWS_APP_ID=Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
```

> **Important**: Replace `192.168.1.100` with your actual Windows machine IP address

#### 3. Verify Connection

Execute comprehensive verification script on Mac to check all environment configurations:

```bash
# Add execute permission (first time)
chmod +x scripts/verify-windows-remote-env.py

# Basic check - automatically checks network, WinAppDriver, port, Session
python3 scripts/verify-windows-remote-env.py --host 192.168.1.100

# Or specify port
python3 scripts/verify-windows-remote-env.py --host 192.168.1.100 --port 4724

# Detailed usage: VERIFY_WINDOWS_REMOTE_ENV_GUIDE.md
```

**Successful output example:**
```
✅ Successfully connected to 192.168.1.100:4724
✅ WinAppDriver service running normally
✅ Configured port 4724 working properly
✅ Session created successfully!
🎉 All key checks passed! Environment configured correctly, ready to start testing.
```

#### 4. Run Tests

```bash
# Robot Framework complete test suite
robot tests/windows/calculator_full_test.robot

# Python pytest tests (English version - Recommended, stable)
python3 -m pytest tests/python/test_windows_simple.py -v

# Run Chinese version tests (Requires UTF-8 environment)
export PYTHONIOENCODING=utf-8
export PYTHONUTF8=1
python3 -m pytest tests/python/test_windows_chinese.py -v -s

# Run specific test
python3 -m pytest tests/python/test_windows_simple.py::TestWindowsCalculatorSimple::test_calculator_addition_1_plus_2 -v
```

### Test Coverage

✅ **Implemented Test Cases:**
- Calculator application launch test
- Addition operation tests (1+2, 5+5, 3+7)
- Subtraction operation test (10-3)
- Multiplication operation test (4×5)
- Division operation test (20÷4)

### Documentation Resources

- 📖 **Complete Setup Guide**: [WINDOWS_REMOTE_SETUP_GUIDE.md](./WINDOWS_REMOTE_SETUP_GUIDE.md)
  - Detailed Windows setup steps
  - Automatic port conflict handling (4723 → 4724)
  - Selenium 4 compatibility solution
  - Chinese encoding support
  - Firewall configuration
  - Complete troubleshooting
  - Advanced configuration (multiple machines, CI/CD)

- 💻 **Local Testing Guide**: [WINDOWS_LOCAL_TESTING.md](./WINDOWS_LOCAL_TESTING.md)
  - Local testing setup
  - WinAppDriver local execution
  - Administrator privilege requirements

- 🌏 **Chinese Encoding Guide**: [CHINESE_ENCODING_GUIDE.md](./CHINESE_ENCODING_GUIDE.md)
  - UTF-8 environment setup
  - Chinese test file usage
  - Windows/Mac/Linux encoding solutions

- 🔍 **Remote Environment Verification Tool**: [VERIFY_WINDOWS_REMOTE_ENV_GUIDE.md](./VERIFY_WINDOWS_REMOTE_ENV_GUIDE.md)
  - Comprehensive environment check script
  - Network, WinAppDriver, port, Session full verification
  - Troubleshooting guide

### Common Issues

#### Q: How to transfer scripts to Windows via SSH?
```bash
# 1. Confirm Windows SSH Server is started
ssh username@192.168.1.100 "Get-Service sshd"

# 2. Use SCP to transfer script
scp scripts/setup-windows-remote.ps1 username@192.168.1.100:C:/Users/username/Desktop/

# 3. Set up SSH key authentication (optional, avoid password entry)
ssh-copy-id username@192.168.1.100
```

#### Q: Cannot connect to Windows machine?
```bash
# 1. Confirm you can ping
ping 192.168.1.100

# 2. Test SSH connection (if using SSH)
ssh username@192.168.1.100

# 3. Check if Windows firewall has opened port 4723
# 4. Confirm both machines are on the same network
```

#### Q: Session creation failed?
- Confirm Windows Developer Mode is enabled
- Confirm WinAppDriver is running
- Confirm App ID is correct
- Check firewall allows port 4723

#### Q: Cannot connect SSH to Windows?
```bash
# Check SSH service on Windows
Get-Service sshd
Get-NetFirewallRule -Name *ssh*

# Restart SSH service
Restart-Service sshd

# View SSH logs
Get-EventLog -LogName Application -Source OpenSSH* -Newest 10
```

#### Q: Need to test other Windows applications?
Update `WINDOWS_APP_ID` in `.env` file and adjust UI element locators in test code accordingly.

**Get App ID for other applications:**
```powershell
# View installed applications on Windows
Get-AppxPackage | Select-Object Name, PackageFamilyName

# App ID format: {PackageFamilyName}!App
# Example: Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
```

---

## ⚙️ Environment Configuration

### Environment Variables (.env)

```bash
# Web
DEV_WEB_BASE_URL=https://dev.example.com
DEV_SELENIUM_GRID=http://127.0.0.1:4444/wd/hub

# Android
DEV_APPIUM_ANDROID=http://127.0.0.1:4723/wd/hub
ANDROID_APP_PACKAGE=com.example.app
ANDROID_APP_ACTIVITY=.MainActivity

# macOS
DEV_APPIUM_MAC=http://127.0.0.1:4723/wd/hub
MAC_BUNDLE_ID=com.apple.calculator

# Windows Remote Testing
WIN_REMOTE_URL=http://192.168.1.100:4723
WINDOWS_APP_ID=Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
```

### Driver Configuration (config/drivers/mac.yaml)

```yaml
browser: macapp
remote_url: ${ENV:MAC_REMOTE_URL:-http://127.0.0.1:4723/wd/hub}
capabilities:
  platformName: mac
  automationName: mac2
  appium:bundleId: ${ENV:MAC_BUNDLE_ID:-com.apple.calculator}
  appium:arguments: []
  appium:newCommandTimeout: 120
timeouts:
  implicit: 5
  explicit: 20
```

---

## 🐳 Docker Support (Cross-Platform)

**Full support for Windows, macOS (ARM64/Intel), Linux!**

### Using Automated Scripts (Recommended)

#### macOS / Linux

```bash
# Start Selenium Chrome (auto-detect architecture)
./scripts/start-selenium.sh standalone chrome

# Start Selenium Grid mode
./scripts/start-selenium.sh grid

# Check status
docker-compose ps
```

#### Windows

```batch
REM Start Selenium Chrome
scripts\start-selenium.bat standalone chrome

REM Start Selenium Grid mode
scripts\start-selenium.bat grid

REM Check status
docker-compose ps
```

### Manual Start

```bash
# Windows / Intel Mac / Linux
docker-compose up -d selenium-chrome

# Apple Silicon Mac (ARM64)
docker-compose -f docker-compose.yaml -f docker-compose.arm64.yaml up -d

# Stop services
docker-compose down
```

### Access Services

- **Chrome WebDriver**: http://localhost:4444
- **Chrome VNC Viewer**: http://localhost:7900
- **Grid Console**: http://localhost:4446

📖 **Detailed Documentation**: [DOCKER_SELENIUM_GUIDE.md](./DOCKER_SELENIUM_GUIDE.md)

**Note:** Windows and macOS application test drivers must run locally, Web testing fully supports Docker.

---

## 🧪 Test Execution Methods

### Robot Framework

```bash
# Basic execution
robot --variable ENV:dev --variable PLATFORM:mac tests/mac/

# Execute with tags
robot --variable ENV:dev --variable PLATFORM:mac --include calculation tests/mac/

# Parallel execution (requires pabot)
pabot --processes 4 --variable ENV:dev --variable PLATFORM:web tests/web/
```

### Python pytest

```bash
# Run all tests
python3 -m pytest tests/python/ -v

# Run specific test file
python3 -m pytest tests/python/test_mac_calculator.py -v

# Run specific test function
python3 -m pytest tests/python/test_mac_calculator.py::TestMacCalculator::test_calculator_addition_1_plus_2 -v

# Show detailed output
python3 -m pytest tests/python/test_mac_calculator.py -v -s
```

### Makefile

```bash
make test-web       # Web tests
make test-android   # Android tests
make test-mac       # macOS tests
make test-all       # All platform tests
```

---

## 🔧 Troubleshooting

### macOS Testing Related

**Q: Test error "Request failed with status code 404" or "Operation not permitted"**  
A: This is usually an Accessibility permission issue. Solution:
1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Add your terminal app (Terminal.app, iTerm, Cursor, VS Code, etc.)
3. Enable the toggle (make it blue)
4. **Important:** Restart your terminal completely
5. Verify with: `osascript -e 'tell application "System Events" to get name of first process'`

**Q: Cannot find UI elements**  
A: Calculator buttons use `title` or `label` attributes for location, not `name`. For example:
```xpath
✅ Correct: //XCUIElementTypeButton[@title="1"]
❌ Wrong: //XCUIElementTypeButton[@name="1"]
```

**Q: Calculator opens and clicks buttons, but result validation fails**  
A: This was a cross-version and language compatibility issue, now **automatically fixed**! 

**Old approach** (problematic):
- Relied on text labels like `@label="main display"` or `@label="主要顯示方式"`
- Failed when system language changed
- Failed on different macOS versions

**New approach** (working):
- Uses structural element location (e.g., `//Window//Group[1]//StaticText[1]`)
- Works on **any language** (English, Chinese, Japanese, etc.)
- Works on **any macOS version** (10.x ~ 15.x)

If you still encounter issues:
```bash
# Run test with verbose output to see which selector is being used
python3 -m pytest tests/python/test_mac_calculator.py -v -s
```

**Q: Tests fail with "Unable to find element" on specific macOS version**  
A: The test framework should auto-detect your macOS version. If issues persist:
1. Check the test output for "✓ 使用 selector 成功" message
2. If no selector works, the test will print page source for debugging
3. Report the issue with your macOS version and page source output

**Q: Equals button click has no response**  
A: Need to precisely locate the button in the calculator window, avoid selecting TouchBar:
```xpath
//XCUIElementTypeButton[@title="="]
```

**Q: Appium cannot connect (Connection refused)**  
A: Make sure Appium server is running:
```bash
# Check if Appium is running
lsof -i:4723

# Start Appium if not running
appium &

# Verify Appium is accessible
curl http://localhost:4723/status
```

### General Issues

**Q: Selenium/Appium cannot connect**  
A: Check if service is started:
```bash
# Check Appium
lsof -i:4723

# Check Selenium
curl http://localhost:4444/status
```

**Q: How to view test logs**  
A: Robot Framework generates:
- `log.html` - Detailed execution log
- `report.html` - Test report summary
- `output.xml` - Raw test data

---

## 🚦 CI/CD Integration

GitHub Actions example configuration in `.github/workflows/robot.yml`

```yaml
name: E2E Tests

on: [push, pull_request]

jobs:
  web-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Web Tests
        run: |
          pip install -r requirements.txt
          docker-compose up -d
          robot --variable ENV:dev --variable PLATFORM:web tests/web/
```

---

## 📚 References

- [Robot Framework Official Documentation](https://robotframework.org/)
- [Appium Official Documentation](https://appium.io/)
- [Appium Mac2 Driver](https://github.com/appium/appium-mac2-driver)
- [Selenium Official Documentation](https://www.selenium.dev/)
- [pytest Official Documentation](https://docs.pytest.org/)

---

## 🤝 Contributing

We welcome all forms of contributions! Before getting started, please read:

- 📋 [Contributing Guide (CONTRIBUTING.md)](./CONTRIBUTING.md)
- 📜 [Code of Conduct (CODE_OF_CONDUCT.md)](./CODE_OF_CONDUCT.md)

**Quick Start Contributing:**

1. Fork this project
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📝 License

This project is licensed under the [MIT License](./LICENSE).

---

## 🙏 Acknowledgments

Thanks to the following open source projects:

- [Robot Framework](https://robotframework.org/) - Test automation framework
- [Appium](https://appium.io/) - Cross-platform mobile/desktop app testing
- [Selenium](https://www.selenium.dev/) - Web browser automation
- [Python](https://www.python.org/) - Programming language

---

## 📧 Contact

- 🐛 **Report Issues:** [GitHub Issues](https://github.com/YOUR_USERNAME/full-client-e2e-testing/issues)
- 💡 **Feature Requests:** [GitHub Discussions](https://github.com/YOUR_USERNAME/full-client-e2e-testing/discussions)
- 📖 **Documentation Issues:** Please submit PR or open Issue directly

---

## ⭐ Star History

If this project helps you, please give us a Star! ⭐

---

<div align="center">

**Last Updated:** 2025-11-06  
**Test Status:** ✅ All Passing (5/5 macOS tests passed)  
**Supported Platforms:** Web | Android | Windows | macOS (10.x ~ 15.x)

Made with ❤️ by Davis Chang

</div>
