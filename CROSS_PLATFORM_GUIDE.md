# Cross-Platform Compatibility Guide

This document explains how to use this testing framework on **macOS** and **Windows**.

---

## 📋 Table of Contents

- [Quick Start](#quick-start)
  - [macOS / Linux](#macos--linux)
  - [Windows](#windows)
- [Virtual Environment Activation](#virtual-environment-activation)
- [Running Tests](#running-tests)
- [Platform Differences](#platform-differences)
- [Common Issues](#common-issues)

---

## 🚀 Quick Start

### macOS / Linux

```bash
# Method 1: Using Automated Script (Recommended)
chmod +x setup.sh
./setup.sh

# Method 2: Manual Setup
python3 scripts/setup.py
```

### Windows

```batch
REM Method 1: Using Batch Script (Recommended)
setup.bat

REM Method 2: Manual Setup
python scripts\setup.py
```

---

## 🔧 Virtual Environment Activation

### macOS / Linux

```bash
# Activate virtual environment
source .venv/bin/activate

# Or use dot command
. .venv/bin/activate

# Deactivate virtual environment
deactivate
```

### Windows (Command Prompt)

```batch
REM Activate virtual environment
.venv\Scripts\activate.bat

REM Deactivate virtual environment
deactivate
```

### Windows (PowerShell)

```powershell
# Note: First-time execution may require execution policy adjustment
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Activate virtual environment
.venv\Scripts\Activate.ps1

# Deactivate virtual environment
deactivate
```

---

## 🧪 Running Tests

### Using Cross-Platform Python Script (Recommended)

Unified usage across all platforms:

```bash
# macOS/Linux
python scripts/run_tests.py --platform mac --env dev

# Windows
python scripts\run_tests.py --platform mac --env dev
```

**Complete Options:**

```bash
# Robot Framework tests
python scripts/run_tests.py \
    --type robot \
    --platform mac \
    --env dev \
    --user-role standard \
    --tag smoke

# Python pytest tests
python scripts/run_tests.py \
    --type pytest \
    --suite tests/python/test_mac_calculator.py

# Clean reports
python scripts/run_tests.py --clean
```

### Using Robot Framework Directly

#### macOS / Linux

```bash
robot --variable ENV:dev --variable PLATFORM:mac tests/mac/
```

#### Windows

```batch
robot --variable ENV:dev --variable PLATFORM:mac tests\mac\
```

---

## 📊 Platform Differences

| Item | macOS / Linux | Windows |
|------|---------------|---------|
| **Python Command** | `python3` | `python` |
| **Virtual Env Path** | `.venv/bin/` | `.venv\Scripts\` |
| **Activate Venv** | `source .venv/bin/activate` | `.venv\Scripts\activate.bat` |
| **Path Separator** | `/` | `\` |
| **Environment Variables** | `export VAR=value` | `set VAR=value` |
| **Shell Scripts** | `.sh` (bash) | `.bat` / `.ps1` (cmd/PowerShell) |
| **Line Endings** | LF (`\n`) | CRLF (`\r\n`) |
| **Make** | ✅ Native support | ❌ Requires additional installation |
| **Appium Install** | `npm install -g appium` | `npm install -g appium` |

---

## 🔍 Cross-Platform Handling in Code

### Python Path Handling

✅ **Recommended: Use `pathlib.Path`**

```python
from pathlib import Path

# Automatically handles path separators
report_dir = Path("reports") / f"{env}-{platform}"
report_dir.mkdir(parents=True, exist_ok=True)

# Auto-adapts when converting to string
config_file = Path("config") / "drivers" / "mac.yaml"
```

❌ **Avoid: Hardcoded Path Separators**

```python
# Bad - Only works on Unix
path = "config/drivers/mac.yaml"

# Bad - Only works on Windows  
path = "config\\drivers\\mac.yaml"
```

### Virtual Environment Detection

```python
import platform
import sys
from pathlib import Path

def get_venv_python():
    """Get Python path in virtual environment"""
    if platform.system() == "Windows":
        return Path(".venv") / "Scripts" / "python.exe"
    else:
        return Path(".venv") / "bin" / "python"
```

### Subprocess Execution

```python
import subprocess
import sys

# ✅ Recommended: Use sys.executable
subprocess.run([sys.executable, "-m", "pytest", "tests/"])

# ✅ Recommended: Use shell=True for simple commands (but be aware of security)
subprocess.run("python --version", shell=True, check=True)
```

---

## 📝 Environment Variable Setup

### macOS / Linux (.bashrc / .zshrc)

```bash
export DEV_WEB_BASE_URL="https://dev.example.com"
export MAC_BUNDLE_ID="com.apple.calculator"
```

### Windows (Command Prompt)

```batch
set DEV_WEB_BASE_URL=https://dev.example.com
set MAC_BUNDLE_ID=com.apple.calculator
```

### Windows (PowerShell)

```powershell
$env:DEV_WEB_BASE_URL = "https://dev.example.com"
$env:MAC_BUNDLE_ID = "com.apple.calculator"
```

### Cross-Platform: Using .env File (Recommended)

Supported on both platforms:

```bash
# .env file content (unified format for all platforms)
DEV_WEB_BASE_URL=https://dev.example.com
MAC_BUNDLE_ID=com.apple.calculator
```

---

## ❓ Common Issues

### Windows Issues

**Q: PowerShell script error "Cannot be loaded because running scripts is disabled on this system"**

A: Adjust PowerShell execution policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Q: Cannot find `python` command**

A: 
1. Confirm Python 3.9+ is installed
2. Check "Add Python to PATH" during installation
3. Or manually add to system PATH

**Q: Line ending issues after Git clone**

A: Configure Git auto-conversion:
```bash
git config --global core.autocrlf true
```

**Q: Cannot execute `make` command**

A: Windows doesn't have built-in make. Please use:
- Cross-platform Python script: `python scripts/run_tests.py`
- Or install Make for Windows

### macOS Issues

**Q: Permission denied error**

A: 
```bash
# Add execute permission to scripts
chmod +x setup.sh
chmod +x scripts/setup.py
```

**Q: `command not found: python`**

A: macOS uses `python3`:
```bash
# Create alias
alias python=python3
alias pip=pip3

# Or use python3 directly
python3 scripts/setup.py
```

### Common Issues

**Q: How to check current Python version?**

A:
```bash
# macOS/Linux
python3 --version

# Windows
python --version
```

**Q: Is virtual environment properly activated?**

A: Prompt will show `(.venv)`:
```bash
# Not activated
user@computer:~/project$

# Activated
(.venv) user@computer:~/project$
```

**Q: Cross-platform team collaboration considerations?**

A:
1. Use `.env` file uniformly
2. Use Python scripts instead of shell scripts
3. Set Git line ending handling correctly
4. Provide command examples for both platforms in documentation

---

## 🎯 Best Practices

### 1. Use Cross-Platform Tools

- ✅ Python scripts (pathlib, subprocess)
- ✅ Node.js scripts (using `cross-env`, `rimraf`, etc.)
- ✅ Robot Framework (inherently cross-platform)
- ❌ Shell-specific commands (awk, sed, grep, etc.)
- ❌ Makefile (unless entire team is in Unix environment)

### 2. Path Handling

```python
# ✅ Good practice
from pathlib import Path
config = Path("config") / "drivers" / f"{platform}.yaml"

# ❌ Avoid
config = f"config/{platform}.yaml"  # Unix only
config = f"config\\{platform}.yaml"  # Windows only
```

### 3. Command Execution

```python
# ✅ Good practice
import subprocess
import sys

# Use current Python interpreter
subprocess.run([sys.executable, "-m", "pytest"])

# ❌ Avoid
subprocess.run(["python3", "-m", "pytest"])  # macOS only
subprocess.run(["python", "-m", "pytest"])   # May be ambiguous
```

### 4. Documentation Standards

In README and scripts, provide commands for both platforms:

```markdown
## Installation

### macOS / Linux
```bash
python3 scripts/setup.py
```

### Windows
```batch
python scripts\setup.py
```
```

---

## 📚 Related Resources

- [Python pathlib Documentation](https://docs.python.org/3/library/pathlib.html)
- [subprocess Module Documentation](https://docs.python.org/3/library/subprocess.html)
- [Robot Framework Cross-Platform Guide](https://robotframework.org/)
- [Git Line Ending Handling](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration#_core_autocrlf)

---

**Last Updated:** 2025-11-03  
**Maintainer:** Project Team  
**Supported Platforms:** macOS | Windows | Linux
