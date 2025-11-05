# Windows Keep Alive Configuration Guide

Ensure Windows remains logged in so WinAppDriver can run properly

---

## 🎯 Why Keep Logged In?

**WinAppDriver requires an active desktop session to run!**

- ❌ Windows locks → WinAppDriver cannot control applications
- ❌ Windows sleeps → WinAppDriver stops responding
- ❌ Display turns off → Some UI tests may fail
- ✅ Stay logged in → Tests run normally

---

## ⚡ Quick Configuration (PowerShell One-Click Setup)

Run PowerShell as administrator and execute the following commands:

```powershell
# Disable auto-lock and sleep
Write-Host "Configuring Windows keep alive..." -ForegroundColor Cyan

# 1. Set never turn off display (when plugged in)
powercfg -change -monitor-timeout-ac 0

# 2. Set never sleep (when plugged in)
powercfg -change -standby-timeout-ac 0

# 3. Set never hibernate (when plugged in)
powercfg -change -hibernate-timeout-ac 0

# 4. Set never turn off hard disk (when plugged in)
powercfg -change -disk-timeout-ac 0

# If laptop, also set battery mode (optional)
# powercfg -change -monitor-timeout-dc 0
# powercfg -change -standby-timeout-dc 0

Write-Host "✅ Power settings configured" -ForegroundColor Green

# 5. Disable screen saver
$regPath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regPath -Name ScreenSaveActive -Value 0
Write-Host "✅ Screen saver disabled" -ForegroundColor Green

# 6. Disable auto-lock (requires restart to take effect)
# Note: This reduces security, use only on test machines
$regPath2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
if (-not (Test-Path $regPath2)) {
    New-Item -Path $regPath2 -Force | Out-Null
}
Set-ItemProperty -Path $regPath2 -Name InactivityTimeoutSecs -Value 0 -Type DWord -ErrorAction SilentlyContinue
Write-Host "✅ Auto-lock disabled" -ForegroundColor Green

# 7. Display current settings
Write-Host ""
Write-Host "Current power settings:" -ForegroundColor Yellow
powercfg -query SCHEME_CURRENT SUB_VIDEO VIDEOIDLE
powercfg -query SCHEME_CURRENT SUB_SLEEP STANDBYIDLE

Write-Host ""
Write-Host "✅ Configuration complete! Windows will stay logged in" -ForegroundColor Green
Write-Host ""
Write-Host "Recommendations:" -ForegroundColor Yellow
Write-Host "  - Ensure Windows is logged in (don't lock screen)" -ForegroundColor White
Write-Host "  - Use RDP remote connection (session stays active after disconnect)" -ForegroundColor White
Write-Host "  - Regularly check Windows is still logged in" -ForegroundColor White
```

---

## 🖥️ Method 1: GUI Configuration (Windows Settings)

### Step 1: Configure Power & Sleep Settings

1. Open **Settings** (press `Win + I`)
2. Click **System** → **Power & sleep**
3. Set the following options to **Never**:
   - **Screen** → When plugged in, turn off after: **Never**
   - **Sleep** → When plugged in, PC goes to sleep after: **Never**

![Power Settings](https://user-images.githubusercontent.com/placeholder/power-settings.png)

### Step 2: Disable Screen Saver

1. In search bar, type **screen saver**
2. Select **Change screen saver**
3. In dropdown, select **(None)**
4. Uncheck **On resume, display logon screen**
5. Click **OK**

### Step 3: Disable Lock Screen Timeout

1. Press `Win + R`, type `gpedit.msc` (Group Policy Editor)
2. Navigate to: **Computer Configuration** → **Administrative Templates** → **Control Panel** → **Personalization**
3. Double-click **Do not display the lock screen**
4. Select **Enabled**
5. Click **OK**

### Step 4: Disable Dynamic Lock

1. **Settings** → **Accounts** → **Sign-in options**
2. Find **Dynamic lock**
3. Uncheck **Allow Windows to automatically lock your device when you're away**

---

## 🔧 Method 2: PowerShell Configuration (Recommended)

Run the following commands as administrator:

### Configure Power Settings

```powershell
# View current power plans
powercfg -list

# View current settings (when plugged in)
powercfg -query SCHEME_CURRENT

# === Configure "Never" Options ===

# Screen: never turn off (when plugged in)
powercfg -change -monitor-timeout-ac 0

# Sleep: never sleep (when plugged in)
powercfg -change -standby-timeout-ac 0

# Hibernate: never hibernate (when plugged in)
powercfg -change -hibernate-timeout-ac 0

# Hard disk: never turn off (when plugged in)
powercfg -change -disk-timeout-ac 0

# === If laptop, also configure battery mode ===
# powercfg -change -monitor-timeout-dc 30  # Battery: 30 minutes
# powercfg -change -standby-timeout-dc 60  # Battery: 60 minutes
```

### Disable Screen Saver

```powershell
# Disable screen saver
$regPath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regPath -Name ScreenSaveActive -Value 0

# Verify settings
Get-ItemProperty -Path $regPath -Name ScreenSaveActive
```

### Disable Auto-Lock

```powershell
# Set inactivity timeout to 0 (disabled)
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Set-ItemProperty -Path $regPath -Name InactivityTimeoutSecs -Value 0 -Type DWord

# Verify settings
Get-ItemProperty -Path $regPath -Name InactivityTimeoutSecs
```

---

## 🖱️ Method 3: Using RDP (Recommended for Remote Testing)

**Why recommend RDP?**
- ✅ RDP session stays active after disconnecting
- ✅ Doesn't trigger lock screen
- ✅ WinAppDriver can continue running

### Enable RDP on Windows

```powershell
# Enable Remote Desktop
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

# Enable Network Level Authentication (NLA) - optional but recommended
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1

# Configure firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

Write-Host "✅ Remote Desktop enabled" -ForegroundColor Green
```

### Connect from Mac to Windows RDP

**Option 1: Use Microsoft Remote Desktop (Recommended)**

1. Install **Microsoft Remote Desktop** from Mac App Store
2. Open app, click **Add PC**
3. Enter:
   - **PC name**: `172.21.14.235`
   - **User account**: `VSX_Web_Client`
4. Click **Add**
5. Double-click to connect

**Option 2: Use Command Line**

```bash
# Use open command to open RDP
open rdp://full%20address=s:172.21.14.235
```

### RDP Workflow

```bash
# 1. Connect from Mac to Windows RDP
# Use Microsoft Remote Desktop to connect

# 2. Start WinAppDriver in RDP session
# (On Windows desktop)
cd "C:\Program Files (x86)\Windows Application Driver"
.\WinAppDriver.exe 4724

# 3. Disconnect RDP (don't logout!)
# Click X to close RDP window, don't click "logout"

# 4. Run tests from Mac via SSH
ssh VSX_Web_Client@172.21.14.235 "cd C:\Users\VSX_Web_Client\full-client-e2e-testing; .\venv\Scripts\activate; robot tests\windows\calculator_full_test.robot"

# ✅ Tests run normally because RDP session is still active!
```

---

## 📋 Verify Configuration

Run the following commands to verify settings are correct:

```powershell
# Check power settings
Write-Host "=== Power Settings ===" -ForegroundColor Cyan
$scheme = powercfg -getactivescheme
Write-Host "Current power plan: $scheme"

# Check screen timeout
$monitorTimeout = powercfg -query SCHEME_CURRENT SUB_VIDEO VIDEOIDLE | Select-String "Current AC Power Setting Index"
Write-Host "Screen turn off timeout: $monitorTimeout"

# Check sleep timeout
$sleepTimeout = powercfg -query SCHEME_CURRENT SUB_SLEEP STANDBYIDLE | Select-String "Current AC Power Setting Index"
Write-Host "Sleep timeout: $sleepTimeout"

# Check screen saver
$screenSaver = Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive
Write-Host "Screen saver: $($screenSaver.ScreenSaveActive) (0=disabled)"

Write-Host ""
if ($monitorTimeout -like "*0x00000000*" -and $sleepTimeout -like "*0x00000000*") {
    Write-Host "✅ Configuration correct! Windows will stay logged in" -ForegroundColor Green
} else {
    Write-Host "⚠️  Some settings may be incorrect, please check" -ForegroundColor Yellow
}
```

---

## 🔒 Security Considerations

**Important:** These settings reduce system security, only recommended for test environments!

### Production Environment Recommendations

1. **Use Dedicated Test Machines**
   - Don't disable lock screen on daily work computers
   - Use separate test machines

2. **Network Isolation**
   - Place test machines on isolated network
   - Use firewall to restrict access

3. **Use Service Accounts**
   - Create dedicated test user accounts
   - Limit permissions for those accounts

4. **Regular Monitoring**
   - Monitor test machine activities
   - Keep systems and software updated

---

## 🛠️ Automation Script

Create a complete configuration script:

```powershell
# Save as: setup-windows-keep-alive.ps1

# Check administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Please run this script as administrator" -ForegroundColor Red
    exit 1
}

Write-Host "====================================" -ForegroundColor Cyan
Write-Host " Windows Keep Alive Configuration Tool" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  Warning: This will reduce system security" -ForegroundColor Yellow
Write-Host "   Only recommended for dedicated test machines" -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Continue? (y/N)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Cancelled" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "[1/5] Configuring power settings..." -ForegroundColor Yellow
powercfg -change -monitor-timeout-ac 0
powercfg -change -standby-timeout-ac 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -disk-timeout-ac 0
Write-Host "  ✅ Power settings configured" -ForegroundColor Green

Write-Host "[2/5] Disabling screen saver..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0
Write-Host "  ✅ Screen saver disabled" -ForegroundColor Green

Write-Host "[3/5] Disabling auto-lock..." -ForegroundColor Yellow
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name InactivityTimeoutSecs -Value 0 -Type DWord -ErrorAction SilentlyContinue
Write-Host "  ✅ Auto-lock disabled" -ForegroundColor Green

Write-Host "[4/5] Enabling Remote Desktop..." -ForegroundColor Yellow
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue
Write-Host "  ✅ Remote Desktop enabled" -ForegroundColor Green

Write-Host "[5/5] Verifying configuration..." -ForegroundColor Yellow
$verification = @{
    "Power - Screen timeout" = (powercfg -query SCHEME_CURRENT SUB_VIDEO VIDEOIDLE | Select-String "Current AC Power Setting Index").ToString().Contains("0x00000000")
    "Power - Sleep timeout" = (powercfg -query SCHEME_CURRENT SUB_SLEEP STANDBYIDLE | Select-String "Current AC Power Setting Index").ToString().Contains("0x00000000")
    "Screen saver" = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive).ScreenSaveActive -eq 0
    "Remote Desktop" = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections").fDenyTSConnections -eq 0
}

Write-Host ""
Write-Host "Configuration results:" -ForegroundColor Cyan
foreach ($key in $verification.Keys) {
    $status = if ($verification[$key]) { "✅" } else { "❌" }
    Write-Host "  $status $key" -ForegroundColor $(if ($verification[$key]) { "Green" } else { "Red" })
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host " Configuration Complete!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Ensure Windows is logged in" -ForegroundColor White
Write-Host "  2. Start WinAppDriver" -ForegroundColor White
Write-Host "  3. Use RDP connection (recommended)" -ForegroundColor White
Write-Host ""
Write-Host "Windows IP: " -NoNewline -ForegroundColor Yellow
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.*" }).IPAddress | Select-Object -First 1
Write-Host $ip -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
```

Run after saving:

```powershell
powershell -ExecutionPolicy Bypass -File setup-windows-keep-alive.ps1
```

---

## 📊 Configuration Comparison

| Configuration Item | Default | Test Environment Recommendation | Description |
|-------------------|---------|--------------------------------|-------------|
| Screen turn off | 10 minutes | **Never** | Keep display on |
| Enter sleep | 30 minutes | **Never** | Prevent system hibernation |
| Screen saver | Enabled | **Disabled** | Avoid triggering lock screen |
| Auto-lock | Enabled | **Disabled** | Stay logged in |
| Remote Desktop | Disabled | **Enabled** | Allow RDP connection |

---

## 🎯 Best Practices

### Recommended Workflow

1. **Initial Setup (One-time)**
   ```powershell
   # Run configuration script
   powershell -ExecutionPolicy Bypass -File setup-windows-keep-alive.ps1
   ```

2. **Daily Usage**
   ```bash
   # Connect from Mac using RDP
   # Use Microsoft Remote Desktop to connect to 172.21.14.235
   
   # Start WinAppDriver in RDP session
   # Then disconnect RDP (don't logout)
   
   # Run tests using SSH
   ssh VSX_Web_Client@172.21.14.235 "cd C:\Users\VSX_Web_Client\full-client-e2e-testing; .\venv\Scripts\activate; robot tests\windows\calculator_full_test.robot"
   ```

3. **Regular Checks**
   ```powershell
   # Verify Windows is still logged in
   query user
   
   # Check if WinAppDriver is running
   Get-Process -Name WinAppDriver
   ```

---

## ❓ FAQ

### Q1: Still auto-locks after configuration?

**Reason:** May be enforced by group policy or corporate domain policy

**Solution:**
```powershell
# Check group policy
gpresult /h gpresult.html
# View gpresult.html to find lock screen related policies

# If domain policy, need to contact IT administrator
```

### Q2: Session disappears after RDP disconnect?

**Reason:** RDP settings issue

**Solution:**
```powershell
# Make sure it's "disconnect" not "logout"
# Check session status
query user
# Should see Disc (disconnected) not logged out
```

### Q3: Tests fail after screen turns off?

**Reason:** Some UI tests require active display

**Solution:**
- Use RDP to keep session active
- Or use virtual display adapter (HDMI dummy plug)

### Q4: How to restore default settings?

```powershell
# Restore default power settings
powercfg -restoredefaultschemes

# Enable screen saver
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 1

# Enable auto-lock
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name InactivityTimeoutSecs -ErrorAction SilentlyContinue

Write-Host "✅ Default settings restored" -ForegroundColor Green
```

---

## 📚 Related Documentation

- **[WINDOWS_LOCAL_TESTING.md](./WINDOWS_LOCAL_TESTING.md)** - Windows Local Testing Guide
- **[WINDOWS_REMOTE_TESTING_GUIDE.md](./WINDOWS_REMOTE_TESTING_GUIDE.md)** - Windows Remote Testing Guide
- **[README.md](./README.md)** - Main Project Documentation

---

## ✅ Summary

Keeping Windows logged in is crucial for remote automation testing:

1. **Quick Configuration** - Use provided PowerShell script for one-click setup
2. **Use RDP** - Session stays active after RDP disconnect (recommended)
3. **Regular Checks** - Ensure Windows is still logged in
4. **Security Considerations** - Only use on dedicated test machines

Now your Windows will stay logged in and tests can run smoothly! 🎉
