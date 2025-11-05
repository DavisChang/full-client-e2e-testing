*** Settings ***
Documentation    完整的 Windows Calculator 測試套件 - 測試加減乘除
...              需要遠程 Windows 機器運行 WinAppDriver
...              配置: WIN_REMOTE_URL 和 WINDOWS_APP_ID 在 .env 文件中
Resource         ../../resources/keywords/windows.robot
Test Setup       Launch Windows Calculator
Test Teardown    Close Windows Session

*** Test Cases ***
Test 01: Calculator 應用程式啟動測試
    [Documentation]    驗證 Calculator 應用程式可以成功啟動
    [Tags]    smoke    windows    calculator
    # Launch Windows Calculator 在 Test Setup 中執行，這裡無需額外操作
    Log    Calculator 應用已成功啟動

Test 02: 加法測試 - 1 + 2 = 3
    [Documentation]    測試基本加法：1 + 2 = 3
    [Tags]    windows    calculator    addition
    Test Windows Calculator Addition 1 Plus 2

Test 03: 加法測試 - 5 + 5 = 10
    [Documentation]    測試加法：5 + 5 = 10
    [Tags]    windows    calculator    addition
    Test Windows Calculator Addition 5 Plus 5

Test 04: 加法測試 - 3 + 7 = 10
    [Documentation]    測試加法：3 + 7 = 10
    [Tags]    windows    calculator    addition
    Test Windows Calculator Addition 3 Plus 7

Test 05: 減法測試 - 10 - 3 = 7
    [Documentation]    測試減法：10 - 3 = 7
    [Tags]    windows    calculator    subtraction
    Test Windows Calculator Subtraction 10 Minus 3

Test 06: 乘法測試 - 4 × 5 = 20
    [Documentation]    測試乘法：4 × 5 = 20
    [Tags]    windows    calculator    multiplication
    Test Windows Calculator Multiplication 4 Times 5

Test 07: 除法測試 - 20 ÷ 4 = 5
    [Documentation]    測試除法：20 ÷ 4 = 5
    [Tags]    windows    calculator    division
    Test Windows Calculator Division 20 Divide 4

