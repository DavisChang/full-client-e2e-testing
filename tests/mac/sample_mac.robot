*** Settings ***
Documentation    macOS Calculator connectivity example
Resource         ../../resources/keywords/environment.robot
Resource         ../../resources/keywords/mac.robot
Suite Setup      Prepare Mac Calculator Suite
Suite Teardown   Close Mac Session

*** Variables ***
${ENV}        dev
${PLATFORM}   mac

*** Test Cases ***
Calculator Adds Values
    [Tags]    sanity    mac
    Mac Calculator Adds One And Two

*** Keywords ***
Prepare Mac Calculator Suite
    Load Automation Context    ${ENV}    ${PLATFORM}
    Launch Mac App
