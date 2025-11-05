# 應用程式 UI 自動化測試完整指南
# App UI Automation Testing Guide

**開發與測試協作的完整參考手冊**

---

## 📋 目錄

1. [概述與目標受眾](#概述與目標受眾)
2. [UI 自動化基礎原理](#ui-自動化基礎原理)
3. [開發人員指南](#開發人員指南---如何讓應用更易於測試)
4. [測試人員指南](#測試人員指南---如何編寫測試)
5. [完整實戰示例](#完整實戰示例)
6. [多場景測試示例](#多場景測試示例)
7. [最佳實踐](#最佳實踐)
8. [故障排除](#故障排除)
9. [工具參考](#工具參考)
10. [附錄](#附錄)

---

## 概述與目標受眾

### 📖 文檔目的

本指南旨在幫助開發人員和測試人員理解並實踐 **桌面應用程式 UI 自動化測試**。通過本指南，您將學會：

- **開發人員**：如何設計和開發具備可測試性的應用程式
- **測試人員**：如何為桌面應用編寫自動化測試
- **團隊協作**：如何建立高效的測試流程和規範

### 👥 目標受眾

| 角色 | 獲得的價值 |
|------|-----------|
| **應用開發人員** | 學習如何添加 UI 元件標識，讓應用易於自動化測試 |
| **QA 測試人員** | 掌握元件定位技術，編寫穩定可靠的測試用例 |
| **自動化工程師** | 深入理解不同平台的 UI 自動化原理和最佳實踐 |
| **技術主管** | 建立測試標準，提升團隊協作效率 |

### 🎯 為什麼開發和測試需要協作？

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  開發人員添加            測試人員編寫           產品質量     │
│  可測試性標識    ──►    自動化測試     ──►     持續保障     │
│  (5分鐘)               (30分鐘)               (長期受益)    │
│                                                             │
└─────────────────────────────────────────────────────────────┘

❌ 沒有協作的後果：
   - 測試用例不穩定，經常失敗
   - 定位器複雜且易碎
   - 測試維護成本高

✅ 良好協作的成果：
   - 測試穩定可靠
   - 定位器簡單清晰
   - 測試易於維護和擴展
```

### 🛠️ 技術棧概覽

本項目使用的測試技術棧：

| 平台 | 自動化框架 | 驅動程序 | 程式語言 |
|------|-----------|---------|---------|
| **macOS** | Appium | Mac2 Driver | Python + Robot Framework |
| **Windows** | WinAppDriver | WinAppDriver | Python + Robot Framework |
| **Web** | Selenium | ChromeDriver | Python + Robot Framework |
| **Android** | Appium | UiAutomator2 | Python + Robot Framework |

---

## UI 自動化基礎原理

### 🔍 什麼是 UI 自動化測試？

UI 自動化測試是通過程式碼**模擬用戶操作**來驗證應用功能的測試方法。

```
人工測試流程：
用戶看到按鈕 → 點擊按鈕 → 輸入文字 → 驗證結果
    ↓           ↓         ↓          ↓
自動化測試流程：
程式定位按鈕 → 程式點擊 → 程式輸入 → 程式驗證
```

### 🍎 macOS UI 自動化原理

#### 技術架構

```
┌─────────────────────────────────────────────────────────┐
│                    測試代碼 (Python)                      │
│                         ↓                                │
│                   Appium Client                          │
│                         ↓                                │
│                   Appium Server                          │
│                         ↓                                │
│                  Mac2 Driver                             │
│                         ↓                                │
│               XCTest Framework (Apple)                   │
│                         ↓                                │
│            Accessibility API (macOS)                     │
│                         ↓                                │
│                  您的應用程式 UI                          │
└─────────────────────────────────────────────────────────┘
```

#### 核心概念

**1. XCUIElement 元件類型**

macOS 使用 XCTest 框架定義的元件類型：

```python
# 常見元件類型
XCUIElementTypeButton          # 按鈕
XCUIElementTypeTextField       # 文字輸入框
XCUIElementTypeStaticText      # 靜態文字/標籤
XCUIElementTypeWindow          # 視窗
XCUIElementTypeTable           # 表格
XCUIElementTypeCell            # 單元格
XCUIElementTypePopUpButton     # 下拉選單
XCUIElementTypeCheckBox        # 核取方塊
```

**2. 元件屬性**

每個 UI 元件都有多個屬性可用於定位：

| 屬性 | 說明 | 範例 | 推薦度 |
|------|------|------|--------|
| **label** | 元件的可訪問性標籤 | "one", "add", "submit" | ⭐⭐⭐⭐⭐ |
| **title** | 元件的標題 | "=", "Button" | ⭐⭐⭐⭐ |
| **identifier** | 唯一識別符 | "btn_login" | ⭐⭐⭐⭐⭐ |
| **value** | 元件的值 | "3", "Hello" | ⭐⭐⭐ |
| **name** | 元件名稱 | "Calculator" | ⭐⭐⭐ |

**3. 定位方式**

使用 XPath 定位元件：

```python
from selenium.webdriver.common.by import By

# 範例 1：通過 label 定位按鈕
button = driver.find_element(
    By.XPATH, 
    '//XCUIElementTypeButton[@label="one"]'
)

# 範例 2：通過 identifier 定位（更穩定）
button = driver.find_element(
    By.XPATH,
    '//XCUIElementTypeButton[@identifier="btn_submit"]'
)

# 範例 3：組合條件定位（避免歧義）
button = driver.find_element(
    By.XPATH,
    '//XCUIElementTypeWindow[@name="Calculator"]//XCUIElementTypeButton[@label="equals" and @title="="]'
)
```

#### 實際案例：Calculator 按鈕

```python
# Mac Calculator 的按鈕 "1"
# 元件屬性：
# - Type: XCUIElementTypeButton
# - label: "one"        ← 英文小寫
# - title: "1"
# - enabled: true

# 定位代碼
button_1 = driver.find_element(
    By.XPATH,
    '//XCUIElementTypeButton[@label="one"]'
)
button_1.click()
```

### 🪟 Windows UI 自動化原理

#### 技術架構

```
┌─────────────────────────────────────────────────────────┐
│                    測試代碼 (Python)                      │
│                         ↓                                │
│              WinAppDriver Client                         │
│                         ↓                                │
│              WinAppDriver Server                         │
│                         ↓                                │
│           UI Automation API (Microsoft)                  │
│                         ↓                                │
│                  您的應用程式 UI                          │
└─────────────────────────────────────────────────────────┘
```

#### 核心概念

**1. UI Automation 控制項類型**

Windows 使用 UI Automation 定義的控制項類型：

```python
# 常見控制項類型
Button              # 按鈕
Edit                # 文字輸入框
Text                # 文字標籤
Window              # 視窗
List                # 列表
ListItem            # 列表項
ComboBox            # 下拉選單
CheckBox            # 核取方塊
```

**2. 元件屬性**

| 屬性 | 說明 | 範例 | 推薦度 |
|------|------|------|--------|
| **AutomationId** | 自動化識別符 | "CalculatorResults" | ⭐⭐⭐⭐⭐ |
| **Name** | 元件名稱 | "One", "Plus" | ⭐⭐⭐⭐ |
| **ClassName** | CSS 類別名稱 | "Button" | ⭐⭐ |
| **ControlType** | 控制項類型 | "Button", "Edit" | ⭐⭐ |

**3. 定位方式**

WinAppDriver 支援多種定位策略：

```python
# 方式 1：使用 Name（最常用）
element = driver.find_element("name", "One")

# 方式 2：使用 Accessibility ID（最穩定）
element = driver.find_element("accessibility id", "CalculatorResults")

# 方式 3：使用 ClassName
element = driver.find_element("class name", "Button")

# 方式 4：使用 XPath（較少用）
element = driver.find_element("xpath", "//Button[@Name='One']")
```

#### 實際案例：Calculator 按鈕

```python
# Windows Calculator 的按鈕 "1"
# 元件屬性：
# - ControlType: Button
# - Name: "One"         ← 首字母大寫
# - AutomationId: "num1Button"
# - ClassName: "Button"

# 定位代碼（推薦方式 1：使用 Name）
driver.find_element("name", "One").click()

# 定位代碼（推薦方式 2：使用 AutomationId）
driver.find_element("accessibility id", "num1Button").click()
```

### 📊 macOS vs Windows 對比

| 特性 | macOS (Appium + Mac2) | Windows (WinAppDriver) |
|------|-----------------------|------------------------|
| **定位語法** | XPath | name / accessibility id |
| **元件類型前綴** | XCUIElementType* | 無前綴 (Button, Edit...) |
| **主要定位屬性** | `@label` | `name` |
| **次要定位屬性** | `@identifier` | `accessibility id` |
| **按鈕名稱大小寫** | 小寫 (one, add) | 首字母大寫 (One, Plus) |
| **獲取文字** | `get_attribute('value')` | `element.text` |
| **啟動應用** | `bundle_id` | `app` (Package Family Name) |
| **權限要求** | Accessibility 權限 | 開發者模式 + WinAppDriver |

### 🔍 macOS 和 Windows 元件定位原理詳解

#### macOS 元件定位深入解析

**定位方式 1：使用 XPath + label 屬性（最常用）**

```python
# 定位按鈕 "1"
button_1 = driver.find_element(By.XPATH, '//XCUIElementTypeButton[@label="one"]')

# 定位加號按鈕
button_plus = driver.find_element(By.XPATH, '//XCUIElementTypeButton[@label="add"]')

# 定位結果顯示框
result = driver.find_element(By.XPATH, '//XCUIElementTypeStaticText[@label="main display"]')
```

**關鍵要點：**
- 使用 **`@label`** 屬性（不是 `@name`）
- 按鈕的 label 是英文小寫（如 "one", "two", "add", "multiply"）
- 需要精確定位以避免選中 TouchBar 元素：`[@label="equals" and @title="="]`

**定位方式 2：使用 identifier（最穩定）**

```python
# 如果開發人員添加了 identifier
button = driver.find_element(
    By.XPATH,
    '//XCUIElementTypeButton[@identifier="btn_submit"]'
)
```

**查看 macOS 元件屬性的方法：**

```bash
# 方法 1：使用 Accessibility Inspector（推薦）
open /Applications/Xcode.app/Contents/Applications/Accessibility\ Inspector.app

# 使用步驟：
# 1. 啟動 Accessibility Inspector
# 2. 點擊目標按鈕查看屬性
# 3. 重點關注：Label, Title, Identifier, Type
```

**方法 2：使用 Appium Inspector**

1. 啟動 Appium Desktop
2. 連接到 Appium Server (http://127.0.0.1:4723)
3. 啟動應用並查看元件樹

---

#### Windows 元件定位深入解析

**定位方式 1：使用 Name 屬性（最常用）**

```python
# 定位按鈕 "1"
driver.find_element("name", "One")  # 注意首字母大寫

# 定位運算符
driver.find_element("name", "Plus")
driver.find_element("name", "Minus")
driver.find_element("name", "Multiply by")  # 注意是 "Multiply by" 不是 "Multiply"
```

**定位方式 2：使用 Accessibility ID（最穩定）**

```python
# 定位結果顯示框
find_url = f"{base_url}/element"
payload = {"using": "accessibility id", "value": "CalculatorResults"}
response = requests.post(find_url, json=payload)
```

**關鍵要點：**
- 按鈕名稱是**首字母大寫**的英文（如 "One", "Two", "Plus"）
- 結果顯示使用 **AutomationId**: `CalculatorResults`
- 需要處理 "Display is" 前綴：`result.replace("Display is", "").strip()`

**查看 Windows 元件屬性的方法：**

```powershell
# 方法 1：使用 Inspect.exe（Windows SDK 工具）
# 路徑通常在：
cd "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64"
.\inspect.exe

# 使用步驟：
# 1. 啟動 Inspect.exe
# 2. 將鼠標移到目標元件上
# 3. 查看屬性：Name, AutomationId, ClassName, ControlType
```

**方法 2：使用 Accessibility Insights**

下載地址：https://accessibilityinsights.io/

---

### 📊 關鍵區別詳細對比表

| 功能 | macOS (Appium/Mac2) | Windows (WinAppDriver) |
|------|---------------------|------------------------|
| **定位語法** | XPath | Name / Accessibility ID |
| **屬性名稱** | `@label` | `name` / `accessibility id` |
| **按鈕名稱大小寫** | 小寫 (one, two, add) | 首字母大寫 (One, Two, Plus) |
| **元件類型** | XCUIElementType* | UIA 控制類型 |
| **結果獲取** | `get_attribute('value')` | `element.text` 或 HTTP GET |
| **啟動方式** | `bundle_id` | `app` (Package Family Name) |
| **查看工具** | Accessibility Inspector | Inspect.exe |
| **權限需求** | Accessibility 權限 | 開發者模式 |
| **主要屬性** | label, identifier | Name, AutomationId |

### 🛠️ 實用工具參考表

| 平台 | 工具 | 用途 | 獲取方式 |
|------|------|------|---------|
| macOS | Accessibility Inspector | 查看元件屬性 | Xcode 內建 |
| macOS | Appium Inspector | 查看元件樹 | https://github.com/appium/appium-inspector |
| Windows | Inspect.exe | 查看 UI Automation 屬性 | Windows SDK |
| Windows | Accessibility Insights | UI 元件分析 | https://accessibilityinsights.io/ |
| 通用 | Appium Desktop | 可視化元件定位 | https://github.com/appium/appium-desktop |

### 🎯 核心原則

無論是 macOS 還是 Windows，UI 自動化測試的核心原則相同：

1. **定位元件** - 找到要操作的 UI 元件
2. **執行操作** - 點擊、輸入、滑動等
3. **驗證結果** - 檢查應用狀態是否符合預期

```python
# 通用測試模式
def test_button_click():
    # 1. 定位元件
    button = find_element(...)
    
    # 2. 執行操作
    button.click()
    
    # 3. 驗證結果
    result = get_result_text()
    assert result == "expected_value"
```

### 💡 定位策略最佳實踐

**優先級排序（從高到低）：**

**macOS:**
1. ⭐⭐⭐⭐⭐ `identifier` - 最穩定，開發人員明確設置
2. ⭐⭐⭐⭐ `label` - 較穩定，但可能隨語言變化
3. ⭐⭐⭐ 組合屬性 - `[@label="submit" and @title="Submit"]`
4. ⭐⭐ 層級定位 - `//Window[@name="App"]//Button[@label="ok"]`
5. ⭐ 索引定位 - 避免使用 `//Button[3]`

**Windows:**
1. ⭐⭐⭐⭐⭐ `AutomationId` - 最穩定，開發人員明確設置
2. ⭐⭐⭐⭐ `Name` - 較穩定，但可能隨語言變化
3. ⭐⭐⭐ `ClassName + Name` - 組合使用更精確
4. ⭐⭐ XPath - 作為備用方案
5. ⭐ 索引定位 - 避免使用

---

## 開發人員指南 - 如何讓應用更易於測試

### 🎨 為什麼開發人員需要關注可測試性？

**投入 5 分鐘，節省 5 小時！**

```
沒有標識的按鈕：
測試代碼：driver.find_element(By.XPATH, '//Button[contains(@Name, "...")][3]')
問題：UI 改動後定位器失效，測試大量失敗 ❌

有明確標識的按鈕：
測試代碼：driver.find_element("accessibility id", "btn_login")
優勢：即使 UI 改動，測試依然穩定 ✅
```

### 📝 開發規範建議

#### ✅ 應該做的事

1. **為所有可交互元件設置唯一標識符**
   - macOS: 設置 `accessibilityIdentifier`
   - Windows: 設置 `AutomationId`

2. **使用有意義的命名**
   - ✅ 好的命名: `btn_submit`, `txt_username`, `lbl_result`
   - ❌ 不好的命名: `button1`, `text2`, `label3`

3. **保持標識符穩定**
   - 標識符應該是持久的，不隨 UI 改動而變化

4. **為重要元件設置 Accessibility Label**
   - 幫助測試和輔助功能（Accessibility）用戶

#### ❌ 應該避免的事

1. **不要使用隨機生成的 ID**
2. **不要在不同元件上重複使用相同的標識符**
3. **不要頻繁更改已有的標識符**（除非有充分理由）

### 🍎 macOS 開發指南 (Swift/Objective-C)

#### Swift 範例

**為按鈕添加 Accessibility 標識**

```swift
import SwiftUI

// 範例 1：SwiftUI Button
struct LoginView: View {
    var body: some View {
        Button("登入") {
            performLogin()
        }
        .accessibilityIdentifier("btn_login")  // ✅ 添加測試標識
        .accessibilityLabel("登入按鈕")         // ✅ 添加描述
    }
}

// 範例 2：UIKit Button
class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = UIButton()
        loginButton.setTitle("登入", for: .normal)
        
        // ✅ 設置測試標識
        loginButton.accessibilityIdentifier = "btn_login"
        loginButton.accessibilityLabel = "登入按鈕"
        
        view.addSubview(loginButton)
    }
}

// 範例 3：TextField
struct UsernameField: View {
    @State private var username = ""
    
    var body: some View {
        TextField("使用者名稱", text: $username)
            .accessibilityIdentifier("txt_username")  // ✅
            .accessibilityLabel("使用者名稱輸入框")
    }
}
```

**為複雜元件添加標識**

```swift
// 範例：自定義 Calculator 按鈕
struct CalculatorButton: View {
    let title: String
    let identifier: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.largeTitle)
        }
        .accessibilityIdentifier(identifier)  // ✅ 使用參數化標識
        .accessibilityLabel("\(title) 按鈕")
    }
}

// 使用
CalculatorButton(title: "1", identifier: "btn_number_1") {
    appendNumber(1)
}
CalculatorButton(title: "+", identifier: "btn_operator_plus") {
    setOperator(.add)
}
```

**測試代碼（對應上面的 Swift 代碼）**

```python
from appium import webdriver
from selenium.webdriver.common.by import By

# 連接到應用
driver = webdriver.Remote("http://127.0.0.1:4723", options=options)

# ✅ 使用 identifier 定位（最穩定）
login_button = driver.find_element(
    By.XPATH,
    '//XCUIElementTypeButton[@identifier="btn_login"]'
)
login_button.click()

# 輸入使用者名稱
username_field = driver.find_element(
    By.XPATH,
    '//XCUIElementTypeTextField[@identifier="txt_username"]'
)
username_field.send_keys("testuser")
```

#### Objective-C 範例

```objective-c
// ViewController.m
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 創建登入按鈕
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"登入" forState:UIControlStateNormal];
    
    // ✅ 設置測試標識
    loginButton.accessibilityIdentifier = @"btn_login";
    loginButton.accessibilityLabel = @"登入按鈕";
    
    // 創建文字輸入框
    UITextField *usernameField = [[UITextField alloc] init];
    usernameField.placeholder = @"使用者名稱";
    
    // ✅ 設置測試標識
    usernameField.accessibilityIdentifier = @"txt_username";
    usernameField.accessibilityLabel = @"使用者名稱輸入框";
    
    [self.view addSubview:loginButton];
    [self.view addSubview:usernameField];
}
```

### 🪟 Windows 開發指南 (C#/WPF/WinUI)

#### WPF (XAML + C#) 範例

**XAML 中設置 AutomationId**

```xml
<!-- LoginWindow.xaml -->
<Window x:Class="MyApp.LoginWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="登入" Height="300" Width="400">
    <Grid>
        <!-- ✅ 使用 AutomationProperties.AutomationId -->
        <TextBox 
            x:Name="UsernameTextBox"
            AutomationProperties.AutomationId="txt_username"
            AutomationProperties.Name="使用者名稱"
            Margin="10" />
        
        <PasswordBox 
            x:Name="PasswordBox"
            AutomationProperties.AutomationId="txt_password"
            AutomationProperties.Name="密碼"
            Margin="10,50,10,10" />
        
        <Button 
            x:Name="LoginButton"
            Content="登入"
            AutomationProperties.AutomationId="btn_login"
            AutomationProperties.Name="登入按鈕"
            Click="LoginButton_Click"
            Margin="10,90,10,10" />
            
        <TextBlock 
            x:Name="ResultLabel"
            AutomationProperties.AutomationId="lbl_result"
            AutomationProperties.Name="結果顯示"
            Margin="10,130,10,10" />
    </Grid>
</Window>
```

**C# 代碼中設置 AutomationId**

```csharp
// LoginWindow.xaml.cs
using System.Windows;
using System.Windows.Automation;

namespace MyApp
{
    public partial class LoginWindow : Window
    {
        public LoginWindow()
        {
            InitializeComponent();
            
            // 如果需要在程式碼中動態設置
            SetAutomationProperties();
        }
        
        private void SetAutomationProperties()
        {
            // ✅ 為動態創建的控制項設置 AutomationId
            AutomationProperties.SetAutomationId(UsernameTextBox, "txt_username");
            AutomationProperties.SetName(UsernameTextBox, "使用者名稱");
            
            AutomationProperties.SetAutomationId(LoginButton, "btn_login");
            AutomationProperties.SetName(LoginButton, "登入按鈕");
        }
        
        private void LoginButton_Click(object sender, RoutedEventArgs e)
        {
            string username = UsernameTextBox.Text;
            // 執行登入邏輯...
            ResultLabel.Text = "登入成功";
        }
    }
}
```

#### WinUI 3 範例

```xml
<!-- MainWindow.xaml (WinUI 3) -->
<Window
    x:Class="MyApp.MainWindow"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    
    <StackPanel Orientation="Vertical" Padding="20">
        <!-- ✅ WinUI 3 同樣使用 AutomationProperties -->
        <TextBox 
            PlaceholderText="電子郵件"
            AutomationProperties.AutomationId="txt_email"
            AutomationProperties.Name="電子郵件輸入框" />
        
        <Button 
            Content="提交"
            AutomationProperties.AutomationId="btn_submit"
            AutomationProperties.Name="提交按鈕"
            Click="SubmitButton_Click" />
    </StackPanel>
</Window>
```

#### Windows Forms 範例

```csharp
// LoginForm.cs
using System;
using System.Windows.Forms;

namespace MyApp
{
    public partial class LoginForm : Form
    {
        private TextBox usernameTextBox;
        private Button loginButton;
        
        public LoginForm()
        {
            InitializeComponent();
            SetupUI();
        }
        
        private void SetupUI()
        {
            // 創建文字輸入框
            usernameTextBox = new TextBox
            {
                Location = new System.Drawing.Point(10, 10),
                Size = new System.Drawing.Size(200, 20),
                Name = "txt_username"  // ✅ 設置 Name 屬性
            };
            // ✅ 設置 AccessibleName（用於 UI Automation）
            usernameTextBox.AccessibleName = "使用者名稱";
            
            // 創建按鈕
            loginButton = new Button
            {
                Text = "登入",
                Location = new System.Drawing.Point(10, 40),
                Size = new System.Drawing.Size(100, 30),
                Name = "btn_login"  // ✅ 設置 Name 屬性
            };
            loginButton.AccessibleName = "登入按鈕";
            loginButton.Click += LoginButton_Click;
            
            // 添加控制項
            this.Controls.Add(usernameTextBox);
            this.Controls.Add(loginButton);
        }
        
        private void LoginButton_Click(object sender, EventArgs e)
        {
            string username = usernameTextBox.Text;
            // 執行登入邏輯...
        }
    }
}
```

**測試代碼（對應上面的 C# 代碼）**

```python
import requests

# WinAppDriver 連接
base_url = "http://127.0.0.1:4723/session/{session_id}"

# ✅ 使用 AutomationId 定位（最穩定）
def find_by_automation_id(automation_id):
    response = requests.post(
        f"{base_url}/element",
        json={"using": "accessibility id", "value": automation_id}
    )
    return response.json()['value']

# 輸入使用者名稱
username_element = find_by_automation_id("txt_username")
# 輸入文字...

# 點擊登入按鈕
login_button = find_by_automation_id("btn_login")
# 點擊...
```

### 📋 命名規範建議

建立團隊統一的命名規範：

```
格式：[類型前綴]_[功能描述]

類型前綴：
btn_    - 按鈕 (Button)
txt_    - 文字輸入框 (TextBox/TextField)
lbl_    - 標籤/文字 (Label/Text)
chk_    - 核取方塊 (CheckBox)
rdo_    - 單選按鈕 (RadioButton)
cmb_    - 下拉選單 (ComboBox)
lst_    - 列表 (List)
tbl_    - 表格 (Table)
dlg_    - 對話框 (Dialog)
wnd_    - 視窗 (Window)

範例：
✅ btn_submit          - 提交按鈕
✅ btn_cancel          - 取消按鈕
✅ txt_username        - 使用者名稱輸入框
✅ txt_password        - 密碼輸入框
✅ lbl_result          - 結果標籤
✅ chk_remember_me     - 記住我核取方塊
✅ cmb_country         - 國家下拉選單
```

### 🔄 開發測試協作流程

```
┌─────────────────────────────────────────────────────────────┐
│  第 1 步：需求討論                                           │
│  ├─ 開發：了解哪些功能需要自動化測試                        │
│  └─ 測試：說明測試需要哪些元件標識                          │
├─────────────────────────────────────────────────────────────┤
│  第 2 步：開發實現                                           │
│  ├─ 開發：實現功能 + 添加 Accessibility 標識（5 分鐘）     │
│  └─ 開發：提供元件標識列表給測試團隊                        │
├─────────────────────────────────────────────────────────────┤
│  第 3 步：測試編寫                                           │
│  ├─ 測試：使用提供的標識編寫測試用例                        │
│  └─ 測試：驗證功能並給予反饋                                │
├─────────────────────────────────────────────────────────────┤
│  第 4 步：持續維護                                           │
│  ├─ 開發：保持標識穩定，修改時通知測試團隊                  │
│  └─ 測試：定期執行測試，發現問題及時反饋                    │
└─────────────────────────────────────────────────────────────┘
```

### 📄 元件標識文檔範例

開發人員應該為測試團隊提供元件標識文檔：

```markdown
# 登入頁面元件標識

## 文字輸入框
- `txt_username` - 使用者名稱輸入框
- `txt_password` - 密碼輸入框

## 按鈕
- `btn_login` - 登入按鈕
- `btn_forgot_password` - 忘記密碼連結

## 標籤
- `lbl_error` - 錯誤訊息標籤
- `lbl_welcome` - 歡迎訊息標籤

## 核取方塊
- `chk_remember_me` - 記住我核取方塊
```

---

## 測試人員指南 - 如何編寫測試

（待續...由於內容很長，我將分段創建）

