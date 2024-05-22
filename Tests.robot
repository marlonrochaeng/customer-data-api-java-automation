*** Settings ***
Library               RequestsLibrary
Library  DependencyLibrary

Resource    Utils.robot

Suite Setup    Generate Bearer

*** Variables ***
${default url}        http://127.0.0.1:8080/test-api/consents/v1/consents
${inner dict}=    Create Dictionary    permissions=ACCOUNTS_READ    expirationDateTime=2024-12-21T13:54:31Z
${data dict}=    Create Dictionary    data=${inner dict}
${inner dict cc read}=    Create Dictionary    permissions=CREDIT_CARD_READ    expirationDateTime=2024-12-21T13:54:31Z
${data dict cc read}=    Create Dictionary    data=${inner dict}
${valid consent id}
${valid consent id cc read}



*** Test Cases ***
Test01 - Try to create a consent permissions for ACCOUNTS_READ using a wrong bearer token
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${invalid bearer}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Unauthorized

Test02 - Try to create a consent permissions for ACCOUNTS_READ not using a bearer token
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${empty}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Unauthorized

Test03 - Try to create a consent permissions for ACCOUNTS_READ with the right authorization data
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict}=    Create Dictionary    permissions=ACCOUNTS_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict}=    Create Dictionary    data=${inner dict}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    201
    Should Not Be Empty    ${response.json()}[data][consentId]
    Set Local Variable    ${valid consent id}     ${response.json()}[data][consentId]

    Log To Console    ${response.json()}[data][consentId]

Test04 - Try to create a consent permissions for CREDIT_CARD_READ using a wrong bearer token
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${invalid bearer}

    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict cc read}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Unauthorized

Test05 - Try to create a consent permissions for CREDIT_CARD_READ not using a bearer token
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${empty}
    ${inner dict}=    Create Dictionary    permissions=CREDIT_CARD_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict}=    Create Dictionary    data=${inner dict}

    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict cc read}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    401
    Should Be Equal    ${response.json()}[message]    Unauthorized

Test06 - Try to create a consent permissions for CREDIT_CARD_READ with the right authorization data
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict cc read}=    Create Dictionary    permissions=CREDIT_CARD_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict cc read}=    Create Dictionary    data=${inner dict cc read}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict cc read}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    201
    Should Not Be Empty    ${response.json()}[data][consentId]
    Set Local Variable    ${valid consent id cc read}     ${response.json()}[data][consentId]

Test07 - Try to create a consent permissions for something different than CREDIT_CARD_READ or ACCOUNTS_READ with the right authorization data
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict cc read}=    Create Dictionary    permissions=CREDIT_CARD_READs    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict cc read}=    Create Dictionary    data=${inner dict cc read}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict cc read}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    400

Test08 - Try to update a consent permissions for AUTHORISED with the right authorization data
    #works on postman, need to fix in the automation
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict}=    Create Dictionary    permissions=ACCOUNTS_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict}=    Create Dictionary    data=${inner dict}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    ${inner-dict-accept-reject}=    Create Dictionary     status=AUTHORISED
    ${outer-dict-accept-reject}=    Create Dictionary     data=${inner-dict-accept-reject}
    ${response}=    POST  ${default url}/${response.json()}[data][consentId]     headers=${headers}    json=${outer-dict-accept-reject}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    400
    
Test09 - Try to update a consent permissions for AUTHORISED with the wrong authorization data
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict}=    Create Dictionary    permissions=ACCOUNTS_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict}=    Create Dictionary    data=${inner dict}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${invalid bearer}
    ${inner-dict-accept-reject}=    Create Dictionary     status=AUTHORISED
    ${outer-dict-accept-reject}=    Create Dictionary     data=${inner-dict-accept-reject}
    ${response}=    POST  ${default url}/${response.json()}[data][consentId]     headers=${headers}    json=${outer-dict-accept-reject}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    401
    
Test10 - Try to update a consent permissions for AUTHORISED not using a bearer token
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict}=    Create Dictionary    permissions=ACCOUNTS_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict}=    Create Dictionary    data=${inner dict}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${empty}
    ${inner-dict-accept-reject}=    Create Dictionary     status=AUTHORISED
    ${outer-dict-accept-reject}=    Create Dictionary     data=${inner-dict-accept-reject}
    ${response}=    POST  ${default url}/${response.json()}[data][consentId]     headers=${headers}    json=${outer-dict-accept-reject}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    401

Test11 - Try to update a consent permissions for REJECTED with the right authorization data
    #works on postman, need to fix in the automation
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict}=    Create Dictionary    permissions=ACCOUNTS_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict}=    Create Dictionary    data=${inner dict}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    ${inner-dict-accept-reject}=    Create Dictionary     status=REJECTED
    ${outer-dict-accept-reject}=    Create Dictionary     data=${inner-dict-accept-reject}
    ${response}=    POST  ${default url}/${response.json()}[data][consentId]     headers=${headers}    json=${outer-dict-accept-reject}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    400

Test12 - Try to update a consent permissions for REJECTED with the wrong authorization data
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict}=    Create Dictionary    permissions=ACCOUNTS_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict}=    Create Dictionary    data=${inner dict}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${invalid bearer}
    ${inner-dict-accept-reject}=    Create Dictionary     status=REJECTED
    ${outer-dict-accept-reject}=    Create Dictionary     data=${inner-dict-accept-reject}
    ${response}=    POST  ${default url}/${response.json()}[data][consentId]     headers=${headers}    json=${outer-dict-accept-reject}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    401

Test13 - Try to update a consent permissions for REJECTED not using a bearer token
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${valid bearer}
    ${inner dict}=    Create Dictionary    permissions=ACCOUNTS_READ    expirationDateTime=2024-12-21T13:54:31Z
    ${data dict}=    Create Dictionary    data=${inner dict}
    ${response}=    POST  ${default url}  headers=${headers}    json=${data dict}    expected_status=anything

    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${empty}
    ${inner-dict-accept-reject}=    Create Dictionary     status=REJECTED
    ${outer-dict-accept-reject}=    Create Dictionary     data=${inner-dict-accept-reject}
    ${response}=    POST  ${default url}/${response.json()}[data][consentId]     headers=${headers}    json=${outer-dict-accept-reject}   expected_status=anything

    Should Be Equal As Integers    ${response.status_code}    401