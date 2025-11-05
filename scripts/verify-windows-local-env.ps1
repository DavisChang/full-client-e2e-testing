# ============================================================================
# Windows Local Testing - Environment Verification (Port 4724)
# ============================================================================

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "====================================" -ForegroundColor Yellow
    Write-Host " Requesting Administrator Access" -ForegroundColor Yellow
    Write-Host "====================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[INFO] WinAppDriver requires Administrator privileges" -ForegroundColor Cyan
    Write-Host "[INFO] Restarting script as Administrator..." -ForegroundColor Cyan
    Write-Host ""
    
    # Re-launch as administrator
    $scriptPath = $MyInvocation.MyCommand.Path
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command `"cd '$PWD'; & '$scriptPath'`""
    exit
}

Write-Host "====================================" -ForegroundColor Cyan
Write-Host " Windows Environment Check (4724)" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[INFO] Running as Administrator" -ForegroundColor Green
Write-Host ""

$errors = 0
$warnings = 0

# Python
Write-Host "[1/8] Python" -ForegroundColor Yellow
$pyCheck = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK $pyCheck" -ForegroundColor Green
} else {
    Write-Host "  FAIL Python not found" -ForegroundColor Red
    $errors++
}

# Virtual Environment
Write-Host "[2/8] Virtual Environment" -ForegroundColor Yellow
if (Test-Path 'venv\Scripts\python.exe') {
    Write-Host "  OK venv exists" -ForegroundColor Green
} else {
    Write-Host "  FAIL venv not found" -ForegroundColor Red
    $errors++
}

# Packages
Write-Host "[3/8] Python Packages" -ForegroundColor Yellow
if (Test-Path 'venv\Scripts\activate.ps1') {
    & .\venv\Scripts\activate.ps1
    $pkgs = @("robotframework", "selenium", "pytest", "python-dotenv")
    foreach ($p in $pkgs) {
        $null = pip show $p 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  OK $p" -ForegroundColor Green
        } else {
            Write-Host "  FAIL $p missing" -ForegroundColor Red
            $errors++
        }
    }
}

# Port 4724
Write-Host "[4/8] Port 4724" -ForegroundColor Yellow
$port = netstat -ano | Select-String ":4724" | Select-String "LISTENING"
if ($port) {
    Write-Host "  INFO Port 4724 in use" -ForegroundColor Yellow
    $warnings++
} else {
    Write-Host "  OK Port 4724 available" -ForegroundColor Green
}

# WinAppDriver
Write-Host "[5/8] WinAppDriver" -ForegroundColor Yellow
$winAppPath = 'C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe'
if (Test-Path $winAppPath) {
    Write-Host "  OK WinAppDriver installed" -ForegroundColor Green
    $proc = Get-Process -Name "WinAppDriver" -ErrorAction SilentlyContinue
    if ($proc) {
        Write-Host "  OK WinAppDriver running (PID: $($proc.Id))" -ForegroundColor Green
        
        # Check if it's listening on 4724
        $listening = netstat -ano | Select-String ":4724" | Select-String "LISTENING" | Select-String $proc.Id
        if ($listening) {
            Write-Host "  OK Listening on port 4724" -ForegroundColor Green
            
            # Test /status endpoint
            try {
                $statusResponse = Invoke-WebRequest -Uri "http://127.0.0.1:4724/status" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
                if ($statusResponse.StatusCode -eq 200) {
                    Write-Host "  OK WinAppDriver /status responding (200)" -ForegroundColor Green
                } else {
                    Write-Host "  WARN WinAppDriver /status returned: $($statusResponse.StatusCode)" -ForegroundColor Yellow
                    $warnings++
                }
            } catch {
                Write-Host "  WARN WinAppDriver /status not responding: $($_.Exception.Message)" -ForegroundColor Yellow
                $warnings++
            }
        } else {
            Write-Host "  WARN Not listening on port 4724" -ForegroundColor Yellow
            $warnings++
        }
    } else {
        Write-Host "  WARN WinAppDriver not running" -ForegroundColor Yellow
        Write-Host "  INFO Starting WinAppDriver on port 4724..." -ForegroundColor Cyan
        
        # Start WinAppDriver directly (already running as admin)
        try {
            Write-Host "  INFO Starting in new window..." -ForegroundColor Gray
            $winAppJob = Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$host.UI.RawUI.WindowTitle = 'WinAppDriver (Port 4724)'; Write-Host '========================================' -ForegroundColor Cyan; Write-Host '  WinAppDriver Running on Port 4724' -ForegroundColor Green; Write-Host '  (Administrator Mode)' -ForegroundColor Green; Write-Host '========================================' -ForegroundColor Cyan; Write-Host ''; Write-Host 'Keep this window open!' -ForegroundColor Yellow; Write-Host ''; cd 'C:\Program Files (x86)\Windows Application Driver'; .\WinAppDriver.exe 4724" -PassThru
            
            Write-Host "  INFO Waiting for WinAppDriver to start..." -ForegroundColor Gray
            Start-Sleep -Seconds 3
            
            # Verify it started
            $procCheck = Get-Process -Name "WinAppDriver" -ErrorAction SilentlyContinue
            if ($procCheck) {
                Write-Host "  OK WinAppDriver started (PID: $($procCheck.Id))" -ForegroundColor Green
                
                # Wait a bit more for it to be ready
                Start-Sleep -Seconds 2
                
                # Test status endpoint
                try {
                    $statusCheck = Invoke-WebRequest -Uri "http://127.0.0.1:4724/status" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
                    if ($statusCheck.StatusCode -eq 200) {
                        Write-Host "  OK WinAppDriver /status responding" -ForegroundColor Green
                    }
                } catch {
                    Write-Host "  WARN WinAppDriver started but /status not responding yet" -ForegroundColor Yellow
                    $warnings++
                }
            } else {
                Write-Host "  WARN Failed to start WinAppDriver" -ForegroundColor Yellow
                $warnings++
            }
        } catch {
            Write-Host "  WARN Could not start WinAppDriver: $($_.Exception.Message)" -ForegroundColor Yellow
            $warnings++
        }
    }
} else {
    Write-Host "  FAIL WinAppDriver not installed" -ForegroundColor Red
    $errors++
}

# Calculator
Write-Host "[6/8] Calculator App" -ForegroundColor Yellow
$calc = Get-AppxPackage -Name Microsoft.WindowsCalculator -ErrorAction SilentlyContinue
if ($calc) {
    Write-Host "  OK Calculator installed" -ForegroundColor Green
} else {
    Write-Host "  FAIL Calculator not found" -ForegroundColor Red
    $errors++
}

# Config
Write-Host "[7/8] Configuration" -ForegroundColor Yellow
if (Test-Path '.env') {
    $env = Get-Content .env -Raw
    if ($env -match '4724') {
        Write-Host "  OK .env configured for 4724" -ForegroundColor Green
    } else {
        Write-Host "  WARN .env not configured for 4724" -ForegroundColor Yellow
        $warnings++
    }
} else {
    Write-Host "  FAIL .env not found" -ForegroundColor Red
    $errors++
}

# Tests
Write-Host "[8/8] Test Files" -ForegroundColor Yellow
$tests = @('tests\windows\calculator_full_test.robot', 'tests\python\test_windows_simple.py')
foreach ($t in $tests) {
    if (Test-Path $t) {
        Write-Host "  OK $t" -ForegroundColor Green
    } else {
        Write-Host "  FAIL $t" -ForegroundColor Red
        $errors++
    }
}

# Summary
Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
if ($errors -eq 0) {
    Write-Host " PASSED (Warnings: $warnings)" -ForegroundColor Green
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Ready to run tests:" -ForegroundColor Cyan
    Write-Host '  .\venv\Scripts\activate' -ForegroundColor White
    Write-Host '  robot tests\windows\calculator_full_test.robot' -ForegroundColor White
    Write-Host ""
    Write-Host "Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} else {
    Write-Host " FAILED (Errors: $errors)" -ForegroundColor Red
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Fix errors by running:" -ForegroundColor Yellow
    Write-Host '  powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows-local.ps1' -ForegroundColor White
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
