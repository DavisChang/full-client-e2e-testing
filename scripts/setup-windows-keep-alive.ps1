# Windows Keep Alive Configuration Script
# Configure Windows to stay logged in for testing environment

# Check administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "====================================" -ForegroundColor Yellow
    Write-Host " Requesting Administrator Access" -ForegroundColor Yellow
    Write-Host "====================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[INFO] System configuration requires Administrator privileges" -ForegroundColor Cyan
    Write-Host "[INFO] Restarting as Administrator..." -ForegroundColor Cyan
    Write-Host ""
    
    $scriptPath = $MyInvocation.MyCommand.Path
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command `"cd '$PWD'; & '$scriptPath'`""
    exit
}

Write-Host "====================================" -ForegroundColor Cyan
Write-Host " Windows Keep Alive Configuration" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[INFO] Running as Administrator" -ForegroundColor Green
Write-Host ""
Write-Host "WARNING: This will reduce system security" -ForegroundColor Yellow
Write-Host "         Only use on dedicated test machines" -ForegroundColor Yellow
Write-Host ""
Write-Host "This script will:" -ForegroundColor Cyan
Write-Host "  - Set screen and sleep to 'Never'" -ForegroundColor White
Write-Host "  - Disable screen saver" -ForegroundColor White
Write-Host "  - Disable automatic lock" -ForegroundColor White
Write-Host "  - Enable Remote Desktop (RDP)" -ForegroundColor White
Write-Host ""
$confirm = Read-Host "Continue? (y/N)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host ""
    Write-Host "Cancelled" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}

Write-Host ""
Write-Host "Starting configuration..." -ForegroundColor Cyan
Write-Host ""

# Step 1: Configure power settings
Write-Host "[1/5] Configuring power settings..." -ForegroundColor Yellow
try {
    powercfg -change -monitor-timeout-ac 0 | Out-Null
    powercfg -change -standby-timeout-ac 0 | Out-Null
    powercfg -change -hibernate-timeout-ac 0 | Out-Null
    powercfg -change -disk-timeout-ac 0 | Out-Null
    Write-Host "  OK Power settings configured" -ForegroundColor Green
}
catch {
    Write-Host "  WARN Power settings may not be fully configured: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Step 2: Disable screen saver
Write-Host "[2/5] Disabling screen saver..." -ForegroundColor Yellow
try {
    $regPath = "HKCU:\Control Panel\Desktop"
    Set-ItemProperty -Path $regPath -Name ScreenSaveActive -Value 0 -ErrorAction Stop
    Set-ItemProperty -Path $regPath -Name ScreenSaveTimeOut -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $regPath -Name ScreenSaverIsSecure -Value 0 -ErrorAction SilentlyContinue
    Write-Host "  OK Screen saver disabled" -ForegroundColor Green
}
catch {
    Write-Host "  WARN Screen saver configuration failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Step 3: Disable automatic lock
Write-Host "[3/5] Disabling automatic lock..." -ForegroundColor Yellow
try {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name InactivityTimeoutSecs -Value 0 -Type DWord -ErrorAction Stop
    Write-Host "  OK Automatic lock disabled" -ForegroundColor Green
}
catch {
    Write-Host "  WARN Automatic lock configuration failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Step 4: Enable Remote Desktop
Write-Host "[4/5] Enabling Remote Desktop (RDP)..." -ForegroundColor Yellow
try {
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 -ErrorAction Stop
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1 -ErrorAction SilentlyContinue
    
    try {
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction Stop | Out-Null
        Write-Host "  OK Remote Desktop enabled" -ForegroundColor Green
    }
    catch {
        Write-Host "  WARN Firewall rules may not be configured" -ForegroundColor Yellow
        try {
            New-NetFirewallRule -DisplayName "Remote Desktop (TCP-In)" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow -ErrorAction Stop | Out-Null
            Write-Host "  OK Firewall rule created" -ForegroundColor Green
        }
        catch {
            Write-Host "  WARN Please manually configure firewall for port 3389" -ForegroundColor Yellow
        }
    }
}
catch {
    Write-Host "  WARN Remote Desktop configuration failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Step 5: Verify configuration
Write-Host "[5/5] Verifying configuration..." -ForegroundColor Yellow
Write-Host ""

$allGood = $true

# Check power settings
try {
    $monitorTimeout = powercfg -query SCHEME_CURRENT SUB_VIDEO VIDEOIDLE | Select-String "Current AC Power Setting Index"
    $sleepTimeout = powercfg -query SCHEME_CURRENT SUB_SLEEP STANDBYIDLE | Select-String "Current AC Power Setting Index"
    
    if ($monitorTimeout -like "*0x00000000*") {
        Write-Host "  OK Power - Monitor timeout: Never" -ForegroundColor Green
    }
    else {
        Write-Host "  FAIL Power - Monitor timeout: Not configured" -ForegroundColor Red
        $allGood = $false
    }
    
    if ($sleepTimeout -like "*0x00000000*") {
        Write-Host "  OK Power - Sleep timeout: Never" -ForegroundColor Green
    }
    else {
        Write-Host "  FAIL Power - Sleep timeout: Not configured" -ForegroundColor Red
        $allGood = $false
    }
}
catch {
    Write-Host "  WARN Cannot verify power settings" -ForegroundColor Yellow
    $allGood = $false
}

# Check screen saver
try {
    $screenSaver = Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -ErrorAction Stop
    if ($screenSaver.ScreenSaveActive -eq 0) {
        Write-Host "  OK Screen saver: Disabled" -ForegroundColor Green
    }
    else {
        Write-Host "  FAIL Screen saver: Still enabled" -ForegroundColor Red
        $allGood = $false
    }
}
catch {
    Write-Host "  WARN Cannot verify screen saver settings" -ForegroundColor Yellow
}

# Check Remote Desktop
try {
    $rdp = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -ErrorAction Stop
    if ($rdp.fDenyTSConnections -eq 0) {
        Write-Host "  OK Remote Desktop (RDP): Enabled" -ForegroundColor Green
    }
    else {
        Write-Host "  FAIL Remote Desktop (RDP): Not enabled" -ForegroundColor Red
        $allGood = $false
    }
}
catch {
    Write-Host "  WARN Cannot verify Remote Desktop settings" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "====================================" -ForegroundColor $(if ($allGood) { "Green" } else { "Yellow" })
Write-Host " Configuration Complete!" -ForegroundColor $(if ($allGood) { "Green" } else { "Yellow" })
Write-Host "====================================" -ForegroundColor $(if ($allGood) { "Green" } else { "Yellow" })
Write-Host ""

if ($allGood) {
    Write-Host "All settings configured correctly" -ForegroundColor Green
}
else {
    Write-Host "Some settings may not be fully configured" -ForegroundColor Yellow
    Write-Host "Please manually check items marked as FAIL above" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Keep Windows logged in (do not lock or log out)" -ForegroundColor White
Write-Host "  2. Start WinAppDriver (keep window open)" -ForegroundColor White
Write-Host "     cd `"C:\Program Files (x86)\Windows Application Driver`"" -ForegroundColor Gray
Write-Host "     .\WinAppDriver.exe 4724" -ForegroundColor Gray
Write-Host "  3. Use RDP connection (recommended - session stays active after disconnect)" -ForegroundColor White
Write-Host ""

# Display IP address
try {
    $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
        $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.*" 
    }).IPAddress | Select-Object -First 1
    
    if ($ip) {
        Write-Host "Windows IP Address: " -NoNewline -ForegroundColor Yellow
        Write-Host $ip -ForegroundColor Cyan
        Write-Host ""
        Write-Host "To connect from Mac RDP:" -ForegroundColor Yellow
        Write-Host "  1. Open Microsoft Remote Desktop" -ForegroundColor White
        Write-Host "  2. Add PC: $ip" -ForegroundColor Gray
        Write-Host "  3. Username: $env:USERNAME" -ForegroundColor Gray
    }
}
catch {
    Write-Host "Cannot get IP address" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "For more information:" -ForegroundColor Yellow
Write-Host "  WINDOWS_KEEP_ALIVE_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

