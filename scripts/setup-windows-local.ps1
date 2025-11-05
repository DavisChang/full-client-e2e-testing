# ============================================================================
# Windows Local Testing - Setup Script
# One-click setup for running tests directly on Windows
# ============================================================================

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "====================================" -ForegroundColor Yellow
    Write-Host " Requesting Administrator Access" -ForegroundColor Yellow
    Write-Host "====================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[INFO] Setup operations require Administrator privileges" -ForegroundColor Cyan
    Write-Host "[INFO] Restarting script as Administrator..." -ForegroundColor Cyan
    Write-Host ""
    
    # Re-launch as administrator
    $scriptPath = $MyInvocation.MyCommand.Path
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command `"cd '$PWD'; & '$scriptPath'`""
    exit
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Windows Local Testing Environment Setup" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[INFO] Running as Administrator" -ForegroundColor Green
Write-Host ""

# ============================================================================
# Step 1: Check Python
# ============================================================================
Write-Host "[1/6] Checking Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    if ($pythonVersion -like "*Python*") {
        Write-Host "   [OK] $pythonVersion" -ForegroundColor Green
    } else {
        throw "Python not found"
    }
} catch {
    Write-Host "   [ERROR] Python is not installed or not in PATH!" -ForegroundColor Red
    Write-Host "" -ForegroundColor Yellow
    Write-Host "   Please install Python from:" -ForegroundColor Yellow
    Write-Host "   https://www.python.org/downloads/" -ForegroundColor White
    Write-Host "" -ForegroundColor Yellow
    Write-Host "   Make sure to check 'Add Python to PATH' during installation!" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# ============================================================================
# Step 2: Create virtual environment
# ============================================================================
Write-Host "[2/6] Setting up virtual environment..." -ForegroundColor Yellow
if (Test-Path "venv") {
    Write-Host "   [OK] Virtual environment already exists" -ForegroundColor Green
} else {
    Write-Host "   Creating virtual environment..." -ForegroundColor Gray
    python -m venv venv
    Write-Host "   [OK] Virtual environment created" -ForegroundColor Green
}
Write-Host ""

# ============================================================================
# Step 3: Install dependencies
# ============================================================================
Write-Host "[3/6] Installing dependencies..." -ForegroundColor Yellow
& .\venv\Scripts\activate.ps1

Write-Host "   Upgrading pip..." -ForegroundColor Gray
python -m pip install --upgrade pip --quiet

Write-Host "   Installing requirements..." -ForegroundColor Gray
pip install -r requirements.txt --quiet

Write-Host "   [OK] Dependencies installed" -ForegroundColor Green
Write-Host ""

# ============================================================================
# Step 4: Create .env configuration
# ============================================================================
Write-Host "[4/6] Creating configuration..." -ForegroundColor Yellow
if (Test-Path ".env") {
    Write-Host "   [OK] .env file already exists" -ForegroundColor Green
} else {
    @"
# Windows Local Testing Configuration
WIN_REMOTE_URL=http://127.0.0.1:4723
WINDOWS_APP_ID=Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
"@ | Out-File -FilePath .env -Encoding utf8
    Write-Host "   [OK] .env file created" -ForegroundColor Green
}
Write-Host ""

# ============================================================================
# Step 5: Check WinAppDriver
# ============================================================================
Write-Host "[5/6] Checking WinAppDriver..." -ForegroundColor Yellow
$winAppDriverPath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"
if (Test-Path $winAppDriverPath) {
    Write-Host "   [OK] WinAppDriver is installed" -ForegroundColor Green
} else {
    Write-Host "   [WARNING] WinAppDriver not found!" -ForegroundColor Yellow
    Write-Host "" -ForegroundColor Yellow
    Write-Host "   Installing WinAppDriver..." -ForegroundColor Yellow
    
    # Check if running as admin
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if ($isAdmin) {
        # Download and install
        $downloadUrl = "https://github.com/microsoft/WinAppDriver/releases/download/v1.2.1/WindowsApplicationDriver_1.2.1.msi"
        $installerPath = "$env:TEMP\WinAppDriver.msi"
        
        try {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing
            Start-Process msiexec.exe -ArgumentList "/i", $installerPath, "/quiet", "/norestart" -Wait
            Remove-Item $installerPath -Force
            Write-Host "   [OK] WinAppDriver installed" -ForegroundColor Green
        } catch {
            Write-Host "   [ERROR] Failed to install WinAppDriver" -ForegroundColor Red
            Write-Host "   Please install manually from:" -ForegroundColor Yellow
            Write-Host "   https://github.com/microsoft/WinAppDriver/releases" -ForegroundColor White
        }
    } else {
        Write-Host "   [ERROR] Need Administrator privileges to install WinAppDriver" -ForegroundColor Red
        Write-Host "" -ForegroundColor Yellow
        Write-Host "   Option 1: Re-run this script as Administrator" -ForegroundColor Yellow
        Write-Host "   Option 2: Install manually from:" -ForegroundColor Yellow
        Write-Host "   https://github.com/microsoft/WinAppDriver/releases" -ForegroundColor White
    }
}
Write-Host ""

# ============================================================================
# Step 6: Check Calculator app
# ============================================================================
Write-Host "[6/6] Checking Calculator application..." -ForegroundColor Yellow
$calcApp = Get-AppxPackage -Name Microsoft.WindowsCalculator
if ($calcApp) {
    Write-Host "   [OK] Calculator is installed" -ForegroundColor Green
    $appId = "$($calcApp.PackageFamilyName)!App"
    Write-Host "   App ID: $appId" -ForegroundColor Cyan
    
    # Update .env with correct App ID
    $envContent = Get-Content .env -Raw
    $envContent = $envContent -replace "WINDOWS_APP_ID=.*", "WINDOWS_APP_ID=$appId"
    $envContent | Out-File -FilePath .env -Encoding utf8 -NoNewline
} else {
    Write-Host "   [ERROR] Calculator not found!" -ForegroundColor Red
    Write-Host "   Please install from Microsoft Store" -ForegroundColor Yellow
}
Write-Host ""

# ============================================================================
# Summary
# ============================================================================
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Configuration Summary:" -ForegroundColor Cyan
Write-Host "  Project Directory: $(Get-Location)" -ForegroundColor White
Write-Host "  Python Version: $pythonVersion" -ForegroundColor White
Write-Host "  Virtual Environment: .\venv" -ForegroundColor White
Write-Host "  Configuration File: .env" -ForegroundColor White
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Run verification script (auto-starts WinAppDriver):" -ForegroundColor Yellow
Write-Host '   powershell -ExecutionPolicy Bypass -File .\scripts\verify-windows-local-env.ps1' -ForegroundColor White
Write-Host ""
Write-Host "2. Or manually start and test:" -ForegroundColor Yellow
Write-Host '   cd "C:\Program Files (x86)\Windows Application Driver"' -ForegroundColor White
if ($usePort -eq 4724) {
    Write-Host '   .\WinAppDriver.exe 4724' -ForegroundColor White
} else {
    Write-Host '   .\WinAppDriver.exe' -ForegroundColor White
}
Write-Host '   robot tests\windows\calculator_full_test.robot' -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

