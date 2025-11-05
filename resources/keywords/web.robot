*** Settings ***
Library    SeleniumLibrary
Resource   environment.robot
Resource   ../variables/web_locators.robot

*** Keywords ***
Launch Web App
    Open Browser    about:blank    ${BROWSER}    remote_url=${REMOTE_URL}    desired_capabilities=${DESIRED_CAPS}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Set Selenium Timeout    ${EXPLICIT_TIMEOUT}
    Go To    ${BASE_URL}

Login With Credentials
    [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
    Wait Until Element Is Visible    ${LOGIN_USERNAME}
    Input Text    ${LOGIN_USERNAME}    ${username}
    Input Text    ${LOGIN_PASSWORD}    ${password}
    Click Button    ${LOGIN_SUBMIT}
    Wait Until Page Contains Element    ${DASHBOARD_HEADER}

Close Session
    Run Keyword And Ignore Error    Capture Page Screenshot
    Close Browser

Open Google
    [Documentation]    使用 Docker Selenium Grid 開啟 Google 首頁
    ...    Remote URL: http://localhost:4444
    ...    執行環境: Docker 容器（seleniarm/standalone-chromium）
    
    # 記錄 Grid 連接信息
    Log    ==================== SELENIUM GRID 執行 ====================    level=WARN
    Log    連接到 Selenium Grid: http://localhost:4444    level=WARN
    Log    執行環境: Docker 容器（Linux/ARM64）    level=WARN
    Log    瀏覽器: Chromium 124.0 (容器化)    level=WARN
    
    ${remote_url}=    Set Variable    http://localhost:4444
    Log    Remote WebDriver URL: ${remote_url}    level=WARN
    
    # 使用 Remote WebDriver 開啟瀏覽器
    Open Browser    https://www.google.com    chrome    
    ...    remote_url=${remote_url}
    
    Log    瀏覽器已在 Docker Selenium Grid 中成功啟動    level=WARN
    
    Set Selenium Implicit Wait    10
    Set Selenium Timeout    20
    Maximize Browser Window
    
    # 添加延迟以模拟真实用户行为
    Sleep    2s
    
    Wait Until Page Contains Element    name:q    timeout=10s
    
    # 記錄 Session 信息
    ${session_id}=    Get Session Id
    Log    WebDriver Session ID: ${session_id}    level=WARN
    Log    此 Session 運行在 Docker 容器中，非本地瀏覽器    level=WARN
    Log    注意：Google 可能会检测到自动化流量并显示 CAPTCHA    level=WARN
    Log    ========================================================    level=WARN

Search On Google
    [Arguments]    ${search_term}
    Input Text    name:q    ${search_term}
    Sleep    1s    # 模拟人类输入延迟
    Press Keys    name:q    RETURN
    Sleep    3s    # 等待页面加载
    
    # 检查是否出现 CAPTCHA 或机器人验证页面
    ${is_captcha}=    Run Keyword And Return Status    Page Should Contain    unusual traffic
    Run Keyword If    ${is_captcha}    Log    检测到 Google CAPTCHA 验证页面，这是正常现象    level=WARN
    Run Keyword If    ${is_captcha}    Capture Page Screenshot    google_captcha.png
