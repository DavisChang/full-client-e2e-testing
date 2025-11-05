*** Settings ***
Library    SeleniumLibrary
Resource   environment.robot
Resource   ../variables/android_locators.robot

*** Keywords ***
Launch Android App
    ${options}=    Evaluate    __import__('appium.options.common', fromlist=['AppiumOptions']).AppiumOptions().load_capabilities(${DESIRED_CAPS})
    Create Webdriver    Remote    options=${options}    command_executor=${REMOTE_URL}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Set Selenium Timeout    ${EXPLICIT_TIMEOUT}

Android Login Flow
    Wait Until Element Is Visible    ${ANDROID_LOGIN_USERNAME}
    Input Text    ${ANDROID_LOGIN_USERNAME}    ${USERNAME}
    Input Text    ${ANDROID_LOGIN_PASSWORD}    ${PASSWORD}
    Click Element    ${ANDROID_LOGIN_SUBMIT}
    Wait Until Element Is Visible    ${ANDROID_HOME_HEADER}
