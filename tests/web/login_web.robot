*** Settings ***
Documentation    Smoke login coverage for web client
...              使用 Docker Selenium Grid 執行
...              Remote URL: http://localhost:4444
Resource         ../../resources/keywords/environment.robot
Resource         ../../resources/keywords/web.robot
Suite Setup      Run Keywords
...              Load Automation Context    ${ENV}    ${PLATFORM}    ${USER_ROLE}
...              AND    Launch Web App
Suite Teardown   Close Session

*** Variables ***
${ENV}        dev
${PLATFORM}   web
${USER_ROLE}  standard

*** Test Cases ***
User Can Login To Web Dashboard
    [Tags]    smoke    web
    Login With Credentials
    Page Should Contain Element    ${DASHBOARD_HEADER}
