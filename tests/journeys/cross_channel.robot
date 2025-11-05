*** Settings ***
Documentation    Cross-channel scenario covering web → android → windows journey
Resource         ../../resources/keywords/environment.robot
Resource         ../../resources/keywords/web.robot
Resource         ../../resources/keywords/android.robot
Resource         ../../resources/keywords/windows.robot
Suite Setup      Set Test Variable    ${GLOBAL_ENV}    ${ENV}

*** Variables ***
${ENV}        dev
${USER_ROLE}  standard

*** Test Cases ***
Web To Mobile To Desktop Login Journey
    [Tags]    e2e    crosschannel
    Comment    Load web context and perform login
    Load Automation Context    ${ENV}    web    ${USER_ROLE}
    Launch Web App
    Login With Credentials
    Close Session

    Comment    Switch to Android and continue journey
    Load Automation Context    ${ENV}    android    ${USER_ROLE}
    Launch Android App
    Android Login Flow

    Comment    Validate desktop companion app connectivity
    Load Automation Context    ${ENV}    windows
    Launch Windows App
    Windows Sample Interaction
