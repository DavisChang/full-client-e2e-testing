*** Settings ***
Documentation    Android smoke login scenario
Resource         ../../resources/keywords/environment.robot
Resource         ../../resources/keywords/android.robot
Suite Setup      Load Automation Context    ${ENV}    ${PLATFORM}    ${USER_ROLE}
Suite Setup      Launch Android App

*** Variables ***
${ENV}        dev
${PLATFORM}   android
${USER_ROLE}  standard

*** Test Cases ***
User Can Login On Android
    [Tags]    smoke    android
    Android Login Flow
