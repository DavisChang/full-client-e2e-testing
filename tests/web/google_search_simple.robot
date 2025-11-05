*** Settings ***
Documentation    Google 搜尋簡單測試 - 開啟頁面並輸入關鍵字
...              使用 Docker Selenium Grid 執行
Resource         ../../resources/keywords/environment.robot
Resource         ../../resources/keywords/web.robot
Suite Setup      Run Keywords
...              Load Automation Context    ${ENV}    ${PLATFORM}
...              AND    Open Google
Suite Teardown   Close Session

*** Variables ***
${ENV}        dev
${PLATFORM}   web

*** Test Cases ***
Test Open Google Homepage
    [Tags]    smoke    web    google
    [Documentation]    測試 Google 首頁能否正常載入
    Page Should Contain    Google
    Capture Page Screenshot    google_homepage.png

Test Input Search Text
    [Tags]    smoke    web    google
    [Documentation]    測試輸入搜尋關鍵字（不執行搜尋）
    Input Text    name:q    apple
    ${value}=    Get Value    name:q
    Should Be Equal    ${value}    apple
    Capture Page Screenshot    google_input_apple.png
