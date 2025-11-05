*** Settings ***
Documentation    完整的 macOS Calculator 測試套件 - 測試加減乘除
Resource         ../../resources/keywords/environment.robot
Resource         ../../resources/keywords/mac.robot
Suite Setup      Prepare Mac Calculator Suite
Suite Teardown   Close Mac Session

*** Variables ***
${ENV}        dev
${PLATFORM}   mac

*** Test Cases ***
Test 01: Calculator 應用程式啟動測試
    [Tags]    smoke    mac    startup
    [Documentation]    驗證 Calculator 應用程式可以成功啟動
    Log    ✓ Calculator 應用程式已啟動

Test 02: 加法測試 - 1 + 2 = 3
    [Tags]    calculation    addition    mac
    [Documentation]    測試基本加法：1 + 2 = 3
    Mac Calculator Adds One And Two

Test 03: 加法測試 - 5 + 5 = 10
    [Tags]    calculation    addition    mac
    [Documentation]    測試加法：5 + 5 = 10
    Test Calculator Addition 5 Plus 5

Test 04: 加法測試 - 3 + 7 = 10
    [Tags]    calculation    addition    mac
    [Documentation]    測試加法：3 + 7 = 10
    Test Calculator Addition 3 Plus 7

Test 05: 乘法測試 - 4 × 5 = 20
    [Tags]    calculation    multiplication    mac
    [Documentation]    測試乘法：4 × 5 = 20
    Test Calculator Multiplication

*** Keywords ***
Prepare Mac Calculator Suite
    Load Automation Context    ${ENV}    ${PLATFORM}
    Launch Mac App

