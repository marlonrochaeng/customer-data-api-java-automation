*** Settings ***
Library    OperatingSystem
Library    String

*** Keywords ***
Generate Bearer
    ${token first part}=     Run     echo -n '{"alg": "none","typ": "JWT"}' | base64
    ${token secnd part}=     Run     echo -n '{"scope": "consents","client_id": "client12"}' | base64
    ${token first part}=    Fetch From Right    ${token first part}    ${SPACE}
    ${token secnd part}=    Fetch From Right    ${token secnd part}    ${SPACE}
    Set Global Variable    ${valid bearer}     ${token first part}.${token secnd part}.
    Set Global Variable    ${invalid bearer}     ${token first part},${token secnd part},
