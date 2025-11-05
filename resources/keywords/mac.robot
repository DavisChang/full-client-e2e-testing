*** Settings ***
Library    Process
Library    OperatingSystem
Resource   environment.robot

*** Keywords ***
Launch Mac App
    Log    啟動 Mac Calculator 測試
    ${result}=    Run Process    python3    -m    pytest
    ...    tests/python/test_mac_calculator.py::TestMacCalculator::test_calculator_launches
    ...    -v    -s
    ...    cwd=${EXECDIR}
    Log    ${result.stdout}
    Should Be Equal As Integers    ${result.rc}    0    Calculator 啟動失敗

Mac Calculator Adds One And Two
    [Documentation]    測試 1 + 2 = 3
    Log    執行加法測試：1 + 2 = 3
    ${result}=    Run Process    python3    -m    pytest
    ...    tests/python/test_mac_calculator.py::TestMacCalculator::test_calculator_addition_1_plus_2
    ...    -v    -s
    ...    cwd=${EXECDIR}
    Log    ${result.stdout}
    Run Keyword If    ${result.rc} != 0    Log    ⚠️ 測試失敗（可能需要 Accessibility 權限）    WARN
    Should Be Equal As Integers    ${result.rc}    0    加法測試失敗 - 請檢查是否已授予 Terminal.app Accessibility 權限

Test Calculator Addition 5 Plus 5
    [Documentation]    測試 5 + 5 = 10
    Log    執行加法測試：5 + 5 = 10
    ${result}=    Run Process    python3    -m    pytest
    ...    tests/python/test_mac_calculator.py::TestMacCalculator::test_calculator_addition_5_plus_5
    ...    -v    -s
    ...    cwd=${EXECDIR}
    Log    ${result.stdout}
    Should Be Equal As Integers    ${result.rc}    0    5+5 測試失敗

Test Calculator Addition 3 Plus 7
    [Documentation]    測試 3 + 7 = 10
    Log    執行加法測試：3 + 7 = 10
    ${result}=    Run Process    python3    -m    pytest
    ...    tests/python/test_mac_calculator.py::TestMacCalculator::test_calculator_addition_3_plus_7
    ...    -v    -s
    ...    cwd=${EXECDIR}
    Log    ${result.stdout}
    Should Be Equal As Integers    ${result.rc}    0    3+7 測試失敗

Test Calculator Multiplication
    [Documentation]    測試 4 × 5 = 20
    Log    執行乘法測試：4 × 5 = 20
    ${result}=    Run Process    python3    -m    pytest
    ...    tests/python/test_mac_calculator.py::TestMacCalculator::test_calculator_multiplication
    ...    -v    -s
    ...    cwd=${EXECDIR}
    Log    ${result.stdout}
    Should Be Equal As Integers    ${result.rc}    0    乘法測試失敗

Close Mac Session
    Log    Calculator 測試完成
