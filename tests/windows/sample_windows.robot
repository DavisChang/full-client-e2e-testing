*** Settings ***
Documentation    Windows calculator sanity to validate connectivity
Resource         ../../resources/keywords/environment.robot
Resource         ../../resources/keywords/windows.robot
Suite Setup      Load Automation Context    ${ENV}    ${PLATFORM}
Suite Setup      Launch Windows App

*** Variables ***
${ENV}        dev
${PLATFORM}   windows

*** Test Cases ***
Calculate One Plus Two
    [Tags]    sanity    windows
    Windows Sample Interaction
