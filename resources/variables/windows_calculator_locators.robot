*** Variables ***
# Windows Calculator UI Automation Locators
# 這些定位器用於 Windows Calculator 應用
# 使用 WinAppDriver 的 Name 或 AutomationId 屬性

# 數字按鈕 (使用 Name 屬性)
${WIN_CALC_BUTTON_ZERO}        name:Zero
${WIN_CALC_BUTTON_ONE}          name:One
${WIN_CALC_BUTTON_TWO}          name:Two
${WIN_CALC_BUTTON_THREE}        name:Three
${WIN_CALC_BUTTON_FOUR}         name:Four
${WIN_CALC_BUTTON_FIVE}         name:Five
${WIN_CALC_BUTTON_SIX}          name:Six
${WIN_CALC_BUTTON_SEVEN}        name:Seven
${WIN_CALC_BUTTON_EIGHT}        name:Eight
${WIN_CALC_BUTTON_NINE}         name:Nine

# 運算符按鈕
${WIN_CALC_BUTTON_PLUS}         name:Plus
${WIN_CALC_BUTTON_MINUS}        name:Minus
${WIN_CALC_BUTTON_MULTIPLY}     name:Multiply by
${WIN_CALC_BUTTON_DIVIDE}       name:Divide by
${WIN_CALC_BUTTON_EQUALS}       name:Equals

# 其他按鈕
${WIN_CALC_BUTTON_CLEAR}        name:Clear
${WIN_CALC_BUTTON_CLEAR_ENTRY}  name:Clear entry
${WIN_CALC_BUTTON_DECIMAL}      name:Decimal separator

# 結果顯示 (使用 AutomationId)
${WIN_CALC_RESULT_DISPLAY}      accessibility_id:CalculatorResults

# 計算器主窗口
${WIN_CALC_WINDOW}              name:Calculator

# 注意：實際的 Python 測試使用以下方式定位元素：
# - By.NAME: 使用按鈕的顯示名稱（如 "One", "Plus" 等）
# - By.ACCESSIBILITY_ID: 使用 AutomationId（如 "CalculatorResults"）
#
# 這些變量主要用於 Robot Framework 直接操作 UI 的情況
# 當前的測試策略是通過 Python pytest 進行測試，更加穩定可靠

