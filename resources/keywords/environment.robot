*** Settings ***
Library    Collections
Library    ../libs/env_loader.py

*** Keywords ***
Load Automation Context
    [Arguments]    ${environment}=dev    ${platform}=web    ${user_role}=standard
    ${ctx}=    Load Context    ${environment}    ${platform}    ${user_role}
    Set Suite Variable    ${CTX}    ${ctx}
