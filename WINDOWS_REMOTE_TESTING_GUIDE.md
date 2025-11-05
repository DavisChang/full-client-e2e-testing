# Windows Remote Testing Complete Guide

Complete guide for remotely controlling Windows machines from Mac to execute automated tests

---

## 📋 Table of Contents

1. [Quick Start](#quick-start) ⭐ **Recommended to Read First**
2. [Overview](#overview)
3. [System Requirements](#system-requirements)
4. [Step 1: SSH to Windows Machine](#step-1-ssh-to-windows-machine)
5. [Step 2: Configure Windows Test Environment](#step-2-configure-windows-test-environment)
6. [Step 3: Execute Tests](#step-3-execute-tests)
7. [Troubleshooting](#troubleshooting)
8. [Advanced Configuration](#advanced-configuration)

---

## ⚡ Quick Start

**Just 3 steps to run tests from Mac to Windows via SSH!**

### Step 1: Start WinAppDriver on Windows (Keep Running)

Open an administrator PowerShell window on Windows desktop:

```powershell
cd "C:\Program Files (x86)\Windows Application Driver"
.\WinAppDriver.exe 4724
```

Success when you see `Windows Application Driver listening for requests at: http://127.0.0.1:4724/`

**⚠️ Keep this window open!**

---

### Step 2: SSH Connect from Mac to Windows

```bash
ssh VSX_Web_Client@172.21.14.235
```

Enter password and you're connected!

---

### Step 3: Run Tests on Windows (via SSH)

```powershell
# Navigate to project directory
cd C:\Users\VSX_Web_Client\full-client-e2e-testing

# Activate virtual environment
.\venv\Scripts\activate

# Run tests!
robot tests\windows\calculator_full_test.robot
```

**Done!** Tests will execute automatically and generate reports.

---

### 🚀 Even Simpler Way (One-Line Command)

You can also complete everything with a single command from Mac:

```bash
ssh VSX_Web_Client@172.21.14.235 "cd C:\Users\VSX_Web_Client\full-client-e2e-testing; .\venv\Scripts\activate; robot tests\windows\calculator_full_test.robot"
```

**Tip:** WinAppDriver still needs to be pre-started and kept running on Windows.

---

### 📊 View Test Results

After tests complete, view results using:

```powershell
# List generated report files
ls *.html

# Output:
# report.html   - Test report
# log.html      - Detailed logs
# output.xml    - Raw data
```

---

## 🎯 Overview

This guide explains how to connect from Mac to Windows machine via SSH and execute Windows Calculator automated tests.

### Recommended Approach: SSH + Local Execution ⭐

```
┌─────────────┐                    ┌──────────────────────────┐
│   Mac Side  │   SSH Connection   │   Windows Side           │
│             │        (22)        │                          │
│  Terminal   │ ─────────────────> │  PowerShell              │
│  SSH Client │                    │  ↓                       │
│             │                    │  Robot Framework         │
│             │                    │  ↓                       │
│             │                    │  WinAppDriver (local)    │
│             │                    │  ↓                       │
│             │                    │  Calculator App          │
└─────────────┘                    └──────────────────────────┘
```

**Advantages:**
- ✅ Simple configuration (SSH only)
- ✅ No network configuration or firewall setup needed
- ✅ Stable and reliable
- ✅ Suitable for daily development testing

### Workflow

1. **SSH Connection** → SSH from Mac to Windows machine
2. **Start WinAppDriver** → Start WinAppDriver on Windows (local mode)
3. **Execute Tests** → Run test scripts directly on Windows via SSH

---

## 💻 System Requirements

### Windows Side

| Item | Requirement | Status |
|------|-------------|--------|
| Operating System | Windows 10/11 | ✅ Met |
| Python | 3.7+ | ✅ 3.12.10 |
| WinAppDriver | 1.2.1+ | ✅ Installed |
| Calculator | Built-in | ✅ Installed |
| SSH Server | OpenSSH Server | ✅ Enabled |
| Project Environment | venv + dependencies | ✅ Configured |

### Mac Side

| Item | Requirement | Description |
|------|-------------|-------------|
| SSH Client | Built-in | Included with macOS |
| Network Access | Can connect to Windows | Same network or VPN |

---

## Step 1: SSH to Windows Machine

### 1.1 Enable SSH Server on Windows

#### Method A: Install Using PowerShell (Recommended)

Run PowerShell as administrator on Windows:

```powershell
# 1. Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# 2. Start SSH service
Start-Service sshd

# 3. Set to automatic startup
Set-Service -Name sshd -StartupType 'Automatic'

# 4. Confirm SSH service is running
Get-Service sshd

# 5. Configure firewall (usually auto-configured)
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

#### Method B: Using Windows Settings

1. Open **Settings** → **Apps** → **Optional Features**
2. Click **Add a feature**
3. Search and install **OpenSSH Server**
4. After installation, open **Services** (services.msc)
5. Find **OpenSSH SSH Server**, right-click and select **Start**
6. Set startup type to **Automatic**

### 1.2 Get Windows Machine IP Address

Execute in Windows PowerShell:

```powershell
# View all network interfaces
ipconfig

# Or display only IPv4 address
ipconfig | findstr /i "IPv4"
```

Record the Windows machine's IP address, e.g., `172.21.31.82`

### 1.3 Connect from Mac to Windows

#### Basic SSH Connection

```bash
# Syntax: ssh <Windows_username>@<Windows_IP>
ssh VSX_Web_Client@172.21.31.82
```

#### First-Time Connection

On first connection, you'll see:

```
The authenticity of host '172.21.31.82 (172.21.31.82)' can't be established.
ECDSA key fingerprint is SHA256:...
Are you sure you want to continue connecting (yes/no)?
```

Type `yes` and press Enter, then enter the Windows user password.

#### Configure SSH Keys (Optional, for passwordless login)

```bash
# Generate SSH key on Mac (if you don't have one)
ssh-keygen -t rsa -b 4096

# Copy public key to Windows
ssh-copy-id VSX_Web_Client@172.21.31.82

# Or manually copy
cat ~/.ssh/id_rsa.pub | ssh VSX_Web_Client@172.21.31.82 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### 1.4 Verify SSH Connection

After successful connection, you should see the Windows PowerShell prompt:

```
PS C:\Users\VSX_Web_Client>
```

Test basic commands:

```powershell
# View current directory
pwd

# View Windows version
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

# View user information
whoami
```

### 1.5 SSH Troubleshooting

#### Issue 1: Connection Refused

```bash
ssh: connect to host 172.21.31.82 port 22: Connection refused
```

**Solution**:
```powershell
# Check SSH service status on Windows
Get-Service sshd

# If not running, start service
Start-Service sshd
```

#### Issue 2: Firewall Blocking

**Solution**:
```powershell
# Check firewall rules on Windows
Get-NetFirewallRule -Name sshd

# If not exists, create rule
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

#### Issue 3: Cannot Ping Windows

```bash
# Test from Mac
ping 172.21.31.82
```

If ping fails, enable ICMP on Windows:

```powershell
# Allow ping (ICMP)
New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Action Allow -Enabled True
```

---

## Step 2: Configure Windows Test Environment

After connecting to Windows, use automation script to quickly configure test environment.

### 2.1 One-Click Configuration (Recommended) ⭐

After SSH connection to Windows, run the auto-configuration script:

```powershell
# 1. Navigate to project directory
cd C:\Users\VSX_Web_Client\full-client-e2e-testing

# 2. Run verification script (auto-elevates permissions, auto-starts WinAppDriver)
powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1
```

**Script will automatically:**
- ✅ Check permissions, request elevation if not administrator (single UAC prompt)
- ✅ Check all environment (Python, venv, dependencies, WinAppDriver, Calculator)
- ✅ Automatically start WinAppDriver (local mode 127.0.0.1:4724)
- ✅ Verify WinAppDriver running status
- ✅ Display detailed check results

### 2.2 Manually Start WinAppDriver

If you need manual control, start it this way:

```powershell
# Run PowerShell as administrator, then:
cd "C:\Program Files (x86)\Windows Application Driver"
.\WinAppDriver.exe 4724
```

**Successful startup shows:**
```
Windows Application Driver listening for requests at: http://127.0.0.1:4724/
```

**⚠️ Important: Keep this window open!** Closing the window will stop WinAppDriver.

#### Method B: Transfer Script to Windows

If you don't have project files yet, transfer script from Mac:

```bash
# Execute on Mac
scp scripts/setup-windows-remote.ps1 VSX_Web_Client@172.21.31.82:C:/Users/VSX_Web_Client/
```

Then SSH to Windows and run:

```powershell
cd C:\Users\VSX_Web_Client
powershell -ExecutionPolicy Bypass -File setup-windows-remote.ps1
```

### 2.2 Manual Configuration Steps (if auto-script fails)

#### Step 1: Enable Developer Mode

```powershell
# Check developer mode status
$devModeKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
Get-ItemProperty -Path $devModeKey -Name AllowDevelopmentWithoutDevLicense

# Enable developer mode
if (-not (Test-Path $devModeKey)) {
    New-Item -Path $devModeKey -Force
}
Set-ItemProperty -Path $devModeKey -Name AllowDevelopmentWithoutDevLicense -Value 1 -Type DWord
Set-ItemProperty -Path $devModeKey -Name AllowAllTrustedApps -Value 1 -Type DWord

Write-Host "Developer mode enabled" -ForegroundColor Green
```

#### Step 2: Verify Calculator Application

```powershell
# Check if Calculator is installed
$calcAppx = Get-AppxPackage -Name Microsoft.WindowsCalculator

if ($null -eq $calcAppx) {
    Write-Host "Calculator not installed, please install from Microsoft Store" -ForegroundColor Red
} else {
    Write-Host "Calculator installed" -ForegroundColor Green
    Write-Host "App ID: $($calcAppx.PackageFamilyName)!App"
}
```

#### Step 3: Install WinAppDriver

```powershell
# Download WinAppDriver
$downloadUrl = "https://github.com/microsoft/WinAppDriver/releases/download/v1.2.1/WindowsApplicationDriver_1.2.1.msi"
$installerPath = "$env:TEMP\WinAppDriver.msi"

# Download using Invoke-WebRequest
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing

# Install
Start-Process msiexec.exe -ArgumentList "/i", $installerPath, "/quiet", "/norestart" -Wait

# Cleanup
Remove-Item $installerPath -Force

Write-Host "WinAppDriver installed" -ForegroundColor Green
```

#### Step 4: Configure Firewall

```powershell
# Create firewall rule for port 4723
New-NetFirewallRule -DisplayName "WinAppDriver-4723" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 4723 `
    -Action Allow `
    -Profile Any `
    -Enabled True

# Create firewall rule for port 4724 (backup port)
New-NetFirewallRule -DisplayName "WinAppDriver-4724" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 4724 `
    -Action Allow `
    -Profile Any `
    -Enabled True

Write-Host "Firewall rules created" -ForegroundColor Green
```

### 2.3 Start WinAppDriver

#### Check Port Availability

```powershell
# Check port 4723
$port4723 = Get-NetTCPConnection -LocalPort 4723 -ErrorAction SilentlyContinue

if ($port4723) {
    Write-Host "Port 4723 occupied, using port 4724" -ForegroundColor Yellow
    $usePort = 4724
} else {
    Write-Host "Port 4723 available" -ForegroundColor Green
    $usePort = 4723
}
```

#### Start WinAppDriver

```powershell
# Stop existing WinAppDriver processes
Get-Process -Name WinAppDriver -ErrorAction SilentlyContinue | Stop-Process -Force

# Start WinAppDriver (listening on all network interfaces)
$winAppDriverPath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"

Start-Process -FilePath $winAppDriverPath -ArgumentList "0.0.0.0", $usePort

Write-Host "WinAppDriver started on port $usePort" -ForegroundColor Green

# Wait for service to start
Start-Sleep -Seconds 5

# Verify service is running
Get-Process -Name WinAppDriver
netstat -ano | findstr ":$usePort"
```

#### Quick Start Script (save as start-winappdriver.ps1)

Create a quick start script for repeated use:

```powershell
# start-winappdriver.ps1
# Quick start WinAppDriver script

# Stop existing processes
Get-Process -Name WinAppDriver -ErrorAction SilentlyContinue | Stop-Process -Force

# Get IP address
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
    $_.IPAddress -like "172.*" -or $_.IPAddress -like "192.168.*" 
}).IPAddress | Select-Object -First 1

# Check port and select available one
$usePort = 4723
if (Get-NetTCPConnection -LocalPort 4723 -ErrorAction SilentlyContinue) {
    $usePort = 4724
}

# Start WinAppDriver
$winAppDriverPath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"
Start-Process -FilePath $winAppDriverPath -ArgumentList "0.0.0.0", $usePort

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "WinAppDriver Started" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Listen Address: 0.0.0.0:$usePort" -ForegroundColor White
Write-Host "Remote URL: http://${ip}:$usePort" -ForegroundColor White
Write-Host ""
Write-Host "Configure .env on Mac:" -ForegroundColor Yellow
Write-Host "   WIN_REMOTE_URL=http://${ip}:$usePort" -ForegroundColor Green
Write-Host "   WINDOWS_APP_ID=Microsoft.WindowsCalculator_8wekyb3d8bbwe!App" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
```

Usage:

```powershell
# Run quick start script
powershell -ExecutionPolicy Bypass -File start-winappdriver.ps1
```

### 2.4 Verify WinAppDriver Running Status

```powershell
# 1. Check process
Get-Process -Name WinAppDriver

# 2. Check port listening
netstat -ano | findstr ":4723"
netstat -ano | findstr ":4724"

# 3. Test HTTP endpoint (if you have curl or Invoke-WebRequest)
Invoke-WebRequest -Uri http://localhost:4723/status
# or
Invoke-WebRequest -Uri http://localhost:4724/status
```

Successful response should contain WinAppDriver version information.

### 2.5 Record Configuration Information

Record the following information for use on Mac side:

```
Windows IP: 172.21.31.82
WinAppDriver Port: 4724 (or 4723)
Remote URL: http://172.21.31.82:4724
App ID: Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
```

---

## Step 3: Execute Tests

Now Windows environment is configured, run tests on Windows via SSH.

### 3.1 SSH Connect from Mac to Windows

```bash
# Connect from Mac terminal
ssh VSX_Web_Client@172.21.14.235

# After successful connection, you'll see Windows PowerShell prompt
PS C:\Users\VSX_Web_Client>
```

### 3.2 Prepare Test Environment

On Windows (via SSH):

```powershell
# 1. Navigate to project directory
cd C:\Users\VSX_Web_Client\full-client-e2e-testing

# 2. Activate virtual environment
.\venv\Scripts\activate

# 3. Confirm WinAppDriver is running
Get-Process -Name "WinAppDriver" -ErrorAction SilentlyContinue
# If not running, need to start WinAppDriver in another window
```

**⚠️ Important:** WinAppDriver must already be running on Windows (see Step 2)

### 3.3 Run Tests

#### Option A: Robot Framework Tests (Full Test Suite) ⭐

```powershell
# Run full test suite
robot tests\windows\calculator_full_test.robot

# Run specific test
robot -t "Test 02: Addition Test - 1 + 2 = 3" tests\windows\calculator_full_test.robot

# Run by tags
robot -i addition tests\windows\calculator_full_test.robot
```

```bash
# Display Report
ssh vsx_web_client@172.21.14.235 "cd C:\Users\VSX_Web_Client\full-client-e2e-testing && venv\Scripts\activate && robot tests\windows\calculator_full_test.robot && start chrome report.html"
```

#### Option B: Python pytest Tests

```powershell
# Run simple test
python -m pytest tests\python\test_windows_simple.py -v

# Run specific test
python -m pytest tests\python\test_windows_simple.py::TestWindowsCalculatorSimple::test_calculator_addition_1_plus_2 -v
```

### 3.4 One-Line Command Execution (Direct from Mac)

You can also complete all steps with a single command from Mac:

```bash
# Method 1: Execute Robot Framework test
ssh VSX_Web_Client@172.21.14.235 "cd C:\Users\VSX_Web_Client\full-client-e2e-testing; .\venv\Scripts\activate; robot tests\windows\calculator_full_test.robot"

# Method 2: Execute pytest test
ssh VSX_Web_Client@172.21.14.235 "cd C:\Users\VSX_Web_Client\full-client-e2e-testing; .\venv\Scripts\activate; python -m pytest tests\python\test_windows_simple.py -v"
```

### 3.4 Test Content

Full test suite includes the following test cases:

| Test Number | Test Content | Expected Result |
|-------------|--------------|-----------------|
| Test 01 | Launch Test | Calculator successfully starts |
| Test 02 | Addition Test - 1 + 2 | Result is 3 |
| Test 03 | Addition Test - 5 + 5 | Result is 10 |
| Test 04 | Addition Test - 3 + 7 | Result is 10 |
| Test 05 | Subtraction Test - 10 - 3 | Result is 7 |
| Test 06 | Multiplication Test - 4 × 5 | Result is 20 |
| Test 07 | Division Test - 20 ÷ 4 | Result is 5 |

### 3.5 View Test Reports

After test execution completes, the following reports are generated:

```bash
# View reports on Mac
open report.html  # Test summary report
open log.html     # Detailed test logs
```

Reports include:
- Test execution time
- Pass/Fail statistics
- Detailed test steps
- Error messages and screenshots (if any)

### 3.6 Test Execution Sample Output

**Successful test output**:

```
==============================================================================
Calculator Full Test :: Complete Windows Calculator Test Suite - Testing Math Operations
==============================================================================
Test 01: Calculator Application Launch Test                           | PASS |
------------------------------------------------------------------------------
Test 02: Addition Test - 1 + 2 = 3                                   | PASS |
------------------------------------------------------------------------------
Test 03: Addition Test - 5 + 5 = 10                                  | PASS |
------------------------------------------------------------------------------
Test 04: Addition Test - 3 + 7 = 10                                  | PASS |
------------------------------------------------------------------------------
Test 05: Subtraction Test - 10 - 3 = 7                               | PASS |
------------------------------------------------------------------------------
Test 06: Multiplication Test - 4 × 5 = 20                            | PASS |
------------------------------------------------------------------------------
Test 07: Division Test - 20 ÷ 4 = 5                                  | PASS |
------------------------------------------------------------------------------
Calculator Full Test :: Complete Windows Calculator Test... | PASS |
7 tests, 7 passed, 0 failed
==============================================================================
Output:  /path/to/full-client-e2e-testing/output.xml
Log:     /path/to/full-client-e2e-testing/log.html
Report:  /path/to/full-client-e2e-testing/report.html
```

---

## 🔧 Troubleshooting

### Common Issue 1: Cannot SSH to Windows

**Symptom**:
```bash
ssh: connect to host 172.21.14.235 port 22: Connection refused
```

**Solution**:

1. **Confirm Windows IP address**
   ```powershell
   # Execute on Windows
   ipconfig | findstr /i "IPv4"
   ```

2. **Check if SSH service is running**
   ```powershell
   # Execute on Windows
   Get-Service sshd
   
   # If not running, start service
   Start-Service sshd
   ```

3. **Test network connectivity**
   ```bash
   # Execute on Mac
   ping 172.21.14.235
   ```

### Common Issue 2: WinAppDriver Not Running

**Symptom**:
```
Test failed, cannot connect to WinAppDriver
```

**Solution**:

```powershell
# Check on Windows (can execute via SSH)

# 1. Check if WinAppDriver is running
Get-Process -Name WinAppDriver -ErrorAction SilentlyContinue

# 2. If not running, start as administrator
cd "C:\Program Files (x86)\Windows Application Driver"
.\WinAppDriver.exe 4724

# 3. Verify status
Invoke-WebRequest -Uri http://127.0.0.1:4724/status
```

**⚠️ Note:** WinAppDriver must run with a desktop session (cannot start purely via SSH)

---

### Common Issue 3: Cannot Start WinAppDriver via SSH

**Symptom**:
```powershell
# Running WinAppDriver via SSH fails
.\WinAppDriver.exe 4724
# No output or error
```

**Reason:** SSH session has no desktop environment, cannot directly start GUI-related applications.

**Solution:**

**Solution A: Pre-start on Windows Desktop (Recommended)**
1. Directly open PowerShell (administrator) on Windows machine
2. Start WinAppDriver and keep window open
3. Then SSH from Mac and run tests

**Solution B: Use Automation Script**
```powershell
# Run verification script via SSH (will pop up new window)
powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1
```

---

### Common Issue 4: Test Execution Failure

**Symptom**:
```
FAIL: Unable to find element
Application did not start
```

**Diagnostic Checklist:**

```powershell
# 1. Confirm virtual environment is activated
Get-Command python
# Should show: C:\Users\VSX_Web_Client\full-client-e2e-testing\venv\Scripts\python.exe

# 2. Confirm .env configuration is correct
Get-Content .env
# Should contain:
# WIN_REMOTE_URL=http://127.0.0.1:4724
# WINDOWS_APP_ID=Microsoft.WindowsCalculator_8wekyb3d8bbwe!App

# 3. Confirm WinAppDriver is running properly
Invoke-WebRequest -Uri http://127.0.0.1:4724/status

# 4. Confirm Calculator is installed
Get-AppxPackage -Name Microsoft.WindowsCalculator
```

---

### Common Issue 5: Virtual Environment Path Error

**Symptom**:
```
Fatal error in launcher: Unable to create process
```

**Solution:**

```powershell
# Recreate virtual environment
cd C:\Users\VSX_Web_Client\full-client-e2e-testing

# Delete old virtual environment
Remove-Item -Path venv -Recurse -Force

# Create new virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate

# Reinstall dependencies
pip install -r requirements.txt
```

---

### Common Issue 6: Test Failure After Windows Lock Screen

**Reason:** WinAppDriver needs active desktop session.

**Solution:**

**Quick Configuration (Recommended):**
```powershell
# Run auto-configuration script
powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows-keep-alive.ps1
```

**Manual Configuration:**
```powershell
# Set never lock screen and sleep
powercfg -change -monitor-timeout-ac 0
powercfg -change -standby-timeout-ac 0

# Disable screen saver
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0
```

**Best Solution: Use RDP**
- RDP session remains active after disconnecting
- Use Microsoft Remote Desktop from Mac to connect
- Disconnect (not logout) after starting WinAppDriver

**Detailed Configuration:** See [WINDOWS_KEEP_ALIVE_GUIDE.md](./WINDOWS_KEEP_ALIVE_GUIDE.md)

---

### 📚 More Help

If the above methods don't solve the problem:

1. **Run auto-diagnostic script**
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1
   ```

2. **Check detailed local testing guide**
   - [WINDOWS_LOCAL_TESTING.md](./WINDOWS_LOCAL_TESTING.md)

3. **Check test logs**
   - `log.html` - Detailed test execution logs
   - `report.html` - Test result report

---

## 📝 Summary

### ✅ Advantages of SSH + Local Execution Approach

- **Simple**: Only SSH connection needed, no complex network configuration
- **Stable**: Local execution more reliable, not dependent on network conditions
- **Secure**: Only need to open SSH port (22), no need to expose WinAppDriver port
- **Flexible**: Can debug in real-time and view logs in SSH session

### 🎯 Key Points

1. **WinAppDriver must be pre-started on Windows desktop**
   - SSH session cannot directly start GUI applications
   - Keep WinAppDriver window open

2. **Tests run locally on Windows**
   - Connect to Windows via SSH
   - Activate venv on Windows and run tests
   - WinAppDriver uses local address (127.0.0.1:4724)

3. **One-line command execution**
   ```bash
   ssh VSX_Web_Client@172.21.14.235 "cd C:\Users\VSX_Web_Client\full-client-e2e-testing; .\venv\Scripts\activate; robot tests\windows\calculator_full_test.robot"
   ```

### 📌 Quick Reference

| Step | Execute Where | Command |
|------|---------------|---------|
| Start WinAppDriver | Windows Desktop | `cd "C:\Program Files (x86)\Windows Application Driver"; .\WinAppDriver.exe 4724` |
| SSH Connect | Mac | `ssh VSX_Web_Client@172.21.14.235` |
| Navigate to Project | Windows (SSH) | `cd C:\Users\VSX_Web_Client\full-client-e2e-testing` |
| Activate Environment | Windows (SSH) | `.\venv\Scripts\activate` |
| Run Tests | Windows (SSH) | `robot tests\windows\calculator_full_test.robot` |

---

## 🚀 Advanced Configuration

### Configure SSH Passwordless Login

Tired of entering password every SSH connection? Configure SSH keys:

```bash
# Generate SSH key on Mac (if you don't have one)
ssh-keygen -t rsa -b 4096

# Copy public key to Windows
# Method 1: Auto-copy (recommended)
ssh-copy-id VSX_Web_Client@172.21.14.235

# Method 2: Manual copy
cat ~/.ssh/id_rsa.pub | ssh VSX_Web_Client@172.21.14.235 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# Test passwordless login
ssh VSX_Web_Client@172.21.14.235
# Should no longer ask for password
```

### Configure SSH Alias

Simplify SSH connection command:

```bash
# Edit SSH config on Mac
nano ~/.ssh/config

# Add the following:
Host windows-test
    HostName 172.21.14.235
    User VSX_Web_Client
    Port 22

# After saving, can use alias to connect
ssh windows-test

# Running tests is also simpler
ssh windows-test "cd C:\Users\VSX_Web_Client\full-client-e2e-testing; .\venv\Scripts\activate; robot tests\windows\calculator_full_test.robot"
```

### Automated Test Script (Mac Side)

Create a Mac-side script to automate testing:

```bash
# Create run-remote-test.sh in Mac project directory
cat > run-remote-test.sh << 'EOF'
#!/bin/bash

echo "🚀 Starting remote Windows test..."
echo ""

# Windows connection info
WIN_HOST="VSX_Web_Client@172.21.14.235"
WIN_PROJECT="C:\Users\VSX_Web_Client\full-client-e2e-testing"

# Run tests
ssh $WIN_HOST "cd $WIN_PROJECT; .\venv\Scripts\activate; robot tests\windows\calculator_full_test.robot"

echo ""
echo "✅ Test completed!"
EOF

# Add execute permission to script
chmod +x run-remote-test.sh

# Usage:
./run-remote-test.sh
```

### Auto-start WinAppDriver (Windows Side)

Create a Windows startup script:

```powershell
# Create shortcut on Windows desktop
# Target: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -ExecutionPolicy Bypass -NoExit -Command "cd 'C:\Program Files (x86)\Windows Application Driver'; .\WinAppDriver.exe 4724"
# Run as administrator: Yes

# Or create PowerShell script
# C:\Users\VSX_Web_Client\Desktop\StartWinAppDriver.ps1
$host.UI.RawUI.WindowTitle = "WinAppDriver"
Write-Host "Starting WinAppDriver..." -ForegroundColor Cyan
cd "C:\Program Files (x86)\Windows Application Driver"
.\WinAppDriver.exe 4724
```

---

## 📚 Related Documentation

- **[WINDOWS_LOCAL_TESTING.md](./WINDOWS_LOCAL_TESTING.md)** - Windows Local Testing Complete Guide
- **[WINDOWS_KEEP_ALIVE_GUIDE.md](./WINDOWS_KEEP_ALIVE_GUIDE.md)** - Windows Keep Alive Configuration Guide
- **[README.md](./README.md)** - Main Project Documentation
- **[WEB_TEST_GUIDE.md](./WEB_TEST_GUIDE.md)** - Web Testing Guide

---

## 🎉 Complete!

Now you can run Windows tests remotely from Mac via SSH!

**Remember the three key steps:**
1. ✅ Start WinAppDriver on Windows (keep running)
2. ✅ SSH connect from Mac to Windows
3. ✅ Run tests on Windows

**Having issues?** Check the [Troubleshooting](#troubleshooting) section or run diagnostic script:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1
```

Happy testing! 🚀
