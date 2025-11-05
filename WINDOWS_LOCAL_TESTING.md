# Windows Local Testing Guide

> Run tests directly on Windows machines - The fastest and simplest way

## 📋 Table of Contents

- [Quick Start (3 steps)](#quick-start)
- [Prerequisites](#prerequisites)
- [Automated Scripts](#automated-scripts)
- [Manual Setup Steps](#manual-setup-steps)
- [Running Tests](#running-tests)
- [Common Issues](#common-issues)

---

## 🚀 Quick Start

**Only 2 steps - Automates all setup!**

```powershell
# Step 1: Enter project directory
cd C:\Users\VSX_Web_Client\full-client-e2e-testing

# Step 2: Run verification script (auto-elevate privileges, auto-start WinAppDriver)
powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1

# Script will automatically:
# 1. Detect permissions, show UAC prompt if not admin (only once)
# 2. Rerun with administrator privileges
# 3. Check all environment settings
# 4. Auto-start WinAppDriver (no additional UAC)

# Done! Activate virtual environment and run tests
.\venv\Scripts\activate
robot tests\windows\calculator_full_test.robot
```

**That's it!** ✨

### 💡 Tips

- ✅ **Auto-elevate privileges** (fully automated after one UAC click)
- ✅ **Auto-bypass execution policy** (using `-ExecutionPolicy Bypass`)
- ✅ **No interaction required** (automatically handles all permissions)
- ✅ **Auto-start WinAppDriver** (no more UAC prompts)
- ✅ **Complete validation** (checks all environment and tests /status endpoint)

---

## 🔧 Prerequisites

### Required Software

| Software | Version | Purpose |
|----------|---------|---------|
| **Python** | 3.7+ | Run testing framework |
| **WinAppDriver** | 1.2.1+ | Windows application automation driver |
| **Calculator** | Built-in | Test target application |

### Check if Already Installed

```powershell
# Check Python
python --version

# Check WinAppDriver
Test-Path "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"

# Check Calculator
Get-AppxPackage -Name Microsoft.WindowsCalculator
```

---

## 🤖 Automated Scripts

### 1. Environment Verification and Startup Script

**`verify-windows-local-env.ps1`** - One-click check and start

```powershell
# Run as administrator (avoid UAC popups)
.\scripts\verify-windows-local-env.ps1
```

**Features:**
- ✅ Check Python, venv, dependency packages
- ✅ Check port 4724 availability
- ✅ **Auto-start WinAppDriver** (if not running)
- ✅ Verify WinAppDriver /status endpoint
- ✅ Check Calculator application
- ✅ Verify configuration files and test files

**Sample Output:**
```
====================================
| Windows Environment Check (4724)
====================================

[INFO] Running as Administrator

[1/8] Python
  OK Python 3.12.10
[2/8] Virtual Environment
  OK venv exists
[3/8] Python Packages
  OK robotframework
  OK selenium
  OK pytest
  OK python-dotenv
[4/8] Port 4724
  OK Port 4724 available
[5/8] WinAppDriver
  OK WinAppDriver installed
  INFO Starting WinAppDriver on port 4724...
  OK WinAppDriver started (PID: 1234)
  OK WinAppDriver /status responding
[6/8] Calculator App
  OK Calculator installed
[7/8] Configuration
  OK .env configured for 4724
[8/8] Test Files
  OK tests\windows\calculator_full_test.robot
  OK tests\python\test_windows_simple.py

====================================
| PASSED (Warnings: 0)
====================================

Ready to run tests:
  robot tests\windows\calculator_full_test.robot
```

### 2. Initial Setup Script

**`setup-windows-local.ps1`** - First-time environment setup

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows-local.ps1
```

**Features:**
- ✅ **Auto-elevate administrator privileges** (one UAC click)
- ✅ Create virtual environment
- ✅ Install all dependencies
- ✅ Auto-detect available port (4723/4724)
- ✅ Generate configuration file
- ✅ Verify WinAppDriver installation

---

## 📖 Manual Setup Steps

### Step 1: Install Python

1. Download: https://www.python.org/downloads/
2. During installation **check** "Add Python to PATH"
3. Verify: `python --version`

### Step 2: Install WinAppDriver

1. Download: https://github.com/microsoft/WinAppDriver/releases
2. Download `WindowsApplicationDriver_1.2.1.msi`
3. Install to default location

### Step 3: Setup Project Environment

```powershell
# Enter project directory
cd C:\Users\VSX_Web_Client\full-client-e2e-testing

# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate

# Upgrade pip
python -m pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

### Step 4: Create Configuration File

Create `.env` file:

```env
WIN_REMOTE_URL=http://127.0.0.1:4724
WINDOWS_APP_ID=Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
```

**Note:** Use **port 4724** because 4723 is usually occupied by system processes.

---

## 🧪 Running Tests

### Method 1: Using Automated Script (Recommended)

```powershell
# Run PowerShell as administrator
.\scripts\verify-windows-local-env.ps1

# After WinAppDriver auto-starts, run tests
.\venv\Scripts\activate
robot tests\windows\calculator_full_test.robot
```

### Method 2: Manual Start

```powershell
# Terminal 1: Start WinAppDriver (as administrator)
cd "C:\Program Files (x86)\Windows Application Driver"
.\WinAppDriver.exe 4724

# Terminal 2: Run tests
cd C:\Users\VSX_Web_Client\full-client-e2e-testing
.\venv\Scripts\activate
robot tests\windows\calculator_full_test.robot
```

### View Test Reports

```powershell
# Open HTML reports
start report.html
start log.html
```

---

## 📊 Configuration Details

### Port Configuration

**Why use 4724 instead of 4723?**

- Port 4723 is WinAppDriver's default port
- But on some Windows systems, 4723 is occupied by system process (PID 4)
- Therefore project is configured to use **port 4724**

### Configuration Files

**`.env`** - Environment variables
```env
WIN_REMOTE_URL=http://127.0.0.1:4724
WINDOWS_APP_ID=Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
```

**`requirements.txt`** - Python dependencies
```
robotframework==6.1.1
robotframework-seleniumlibrary==6.2.0
selenium==4.18.1
Appium-Python-Client==3.1.1
pytest==8.4.2
python-dotenv==1.0.1
PyYAML==6.0.1
```

---

## 🔍 Test Content

### Calculator Test Suite

**`tests\windows\calculator_full_test.robot`**

| Test Case | Description |
|-----------|-------------|
| Test 01 | Calculator application launch test |
| Test 02 | Addition test - 1 + 2 = 3 |
| Test 03 | Addition test - 5 + 5 = 10 |
| Test 04 | Addition test - 3 + 7 = 10 |
| Test 05 | Subtraction test - 10 - 3 = 7 |
| Test 06 | Multiplication test - 4 × 5 = 20 |
| Test 07 | Division test - 20 ÷ 4 = 5 |

**Success Example:**
```
Calculator Full Test
7 tests, 7 passed, 0 failed
==============================================================================
```

---

## ❓ Common Issues

### Q1: Script Cannot Run - "UnauthorizedAccess" Error

**Error Message:**
```
.\scripts\setup-windows-local.ps1 : File cannot be loaded. 
The file is not digitally signed. 
You cannot run this script on the current system.
```

**Cause:** Windows PowerShell execution policy blocks unsigned scripts.

**Solutions (choose one):**

**Method 1: Permanent Setting (Recommended)**
```powershell
# Allow running local scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then run script normally
.\scripts\verify-windows-local-env.ps1
```

**Method 2: Temporary Bypass**
```powershell
# Bypass execution policy for this run only
powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1
```

**Method 3: Check Current Policy**
```powershell
# View current execution policy
Get-ExecutionPolicy

# View all scope policies
Get-ExecutionPolicy -List
```

### Q2: Why Administrator Privileges Required?

**A:** WinAppDriver requires administrator privileges to control Windows applications.

**Solution:**
```powershell
# Right-click PowerShell
# Select "Run as administrator"
```

### Q3: How to Avoid UAC Popup Every Time?

**A:** Run script with administrator privileges to avoid.

```powershell
# After opening PowerShell as administrator
.\scripts\verify-windows-local-env.ps1  # No more UAC
```

### Q4: What if Port 4724 is Occupied?

**A:** Check and stop occupying process:

```powershell
# View process occupying port
netstat -ano | Select-String ":4724"

# Stop WinAppDriver
Stop-Process -Name "WinAppDriver" -Force
```

### Q5: Virtual Environment Path Error

**A:** Delete and rebuild venv:

```powershell
# Delete old virtual environment
Remove-Item -Path venv -Recurse -Force

# Recreate
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
```

### Q6: Test Failed - Calculator Not Found

**A:** Install Calculator from Microsoft Store:

```powershell
# Check Calculator
Get-AppxPackage -Name Microsoft.WindowsCalculator

# If not installed, open Microsoft Store
start ms-windows-store://pdp/?ProductId=9WZDNCRFHVN5
```

### Q7: WinAppDriver Returns 503 Error

**A:** Port occupied by system, use 4724:

```powershell
# Check if 4723 is occupied
netstat -ano | Select-String ":4723"

# Start with 4724
.\WinAppDriver.exe 4724
```

---

## 🛠️ Troubleshooting

### Checklist

Use verification script to auto-check all items:

```powershell
.\scripts\verify-windows-local-env.ps1
```

### Manual Check

```powershell
# 1. Python
python --version
# Expected: Python 3.x.x

# 2. Virtual Environment
Test-Path "venv\Scripts\python.exe"
# Expected: True

# 3. Dependency Packages
.\venv\Scripts\activate
pip list | Select-String "robotframework|selenium|pytest"
# Expected: Show all packages

# 4. WinAppDriver
Get-Process -Name "WinAppDriver"
# Expected: Show process information

# 5. Port Listening
netstat -ano | Select-String ":4724" | Select-String "LISTENING"
# Expected: Show LISTENING

# 6. WinAppDriver Status
Invoke-WebRequest -Uri "http://127.0.0.1:4724/status"
# Expected: StatusCode: 200

# 7. Calculator
Get-AppxPackage -Name Microsoft.WindowsCalculator
# Expected: Show application information

# 8. Configuration File
Get-Content .env
# Expected: Show configuration content
```

---

## 📝 Complete Workflow

### Daily Testing Process

```powershell
# ============================================================
# Complete Windows Local Testing Workflow
# ============================================================

# Step 1: Open PowerShell (no admin privileges needed)

# Step 2: Enter project directory
cd C:\Users\VSX_Web_Client\full-client-e2e-testing

# Step 3: Run verification script (auto-start WinAppDriver)
powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1
# If prompted for insufficient permissions, enter Y to continue

# Step 4: Activate virtual environment
.\venv\Scripts\activate

# Step 5: Run tests
robot tests\windows\calculator_full_test.robot

# Step 6: View reports
start report.html
start log.html

# Done!
```

### First-time Setup Process

```powershell
# Step 1: Install Python
# Download and install: https://www.python.org/downloads/

# Step 2: Install WinAppDriver
# Download and install: https://github.com/microsoft/WinAppDriver/releases

# Step 3: Enter project directory
cd C:\Users\VSX_Web_Client\full-client-e2e-testing

# Step 4: Run initial setup script (auto-elevate administrator privileges)
powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows-local.ps1
# Click UAC "Yes" and all setup completes automatically

# Step 5: Verify environment (auto-start WinAppDriver)
powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1

# Step 6: Run tests
.\venv\Scripts\activate
robot tests\windows\calculator_full_test.robot
```

---

## 🎯 Key Points

### ✅ Conditions for Successful Test Execution

1. **Auto-administrator privileges** - Script auto-elevates (no manual action) ✅
2. **Port 4724** - Correct port configured
3. **WinAppDriver auto-start** - verify script auto-starts ✅
4. **Virtual environment** - setup script auto-creates ✅
5. **Calculator application** - System installed

### ⚡ Best Practices

- **Use automated scripts** - Both scripts handle permissions automatically ✅
  - `setup-windows-local.ps1` - Auto-elevate and setup environment
  - `verify-windows-local-env.ps1` - Auto-elevate and start WinAppDriver
- **No manual administrator** - Click UAC "Yes" once only
- **Use port 4724** - Avoid system port conflicts
- **Regular environment verification** - Run verify script to ensure environment is normal
- **View detailed logs** - Use `log.html` for debugging

---

## 📚 Related Documentation

- [README.md](./README.md) - Main project documentation
- [WINDOWS_REMOTE_SETUP_GUIDE.md](./WINDOWS_REMOTE_SETUP_GUIDE.md) - Remote testing guide
- [requirements.txt](./requirements.txt) - Python dependency list

---

## 🎉 Summary

**Windows Local Testing - Simplest Way:**

1. ✅ Open PowerShell (normal mode is fine)
2. ✅ Run `powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1`
3. ✅ Click UAC prompt "Yes" (only once)
4. ✅ Wait for environment check and WinAppDriver startup
5. ✅ Run `robot tests\windows\calculator_full_test.robot`
6. ✅ Done!

**Features:**
- 🚀 **Auto-elevate privileges** (smart detection and auto-restart as administrator)
- 🚀 **One UAC prompt** (no subsequent confirmations needed)
- 🚀 **Auto-bypass execution policy** (no need to modify system settings)
- 🚀 **No manual WinAppDriver start** (fully automated)
- 🚀 **Complete environment verification** (includes /status endpoint test)
- 🚀 **No network setup required** (runs locally)

---

**Need Help?** Run verification script to view detailed check results, or see [Troubleshooting](#troubleshooting) section.
