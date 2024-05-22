## Test Cases

### 1. Try to create a consent permissions for ACCOUNTS_READ using a wrong bearer token
- Include an incorrect bearer token in the Authorization header.
- Send a POST request to the consent permissions endpoint with ACCOUNTS_READ permission.
- Verify that the response indicates an unauthorized access error.

### 2. Try to create a consent permissions for ACCOUNTS_READ not using a bearer token
- Remove the bearer token in the Authorization header.
- Send a POST request to the consent permissions endpoint with ACCOUNTS_READ permission.
- Verify that the response indicates a missing authentication error.

### 3. Try to create a consent permissions for ACCOUNTS_READ with the right authorization data
- Include a valid bearer token in the Authorization header.
- Send a POST request to the consent permissions endpoint with ACCOUNTS_READ permission.
- Verify that the consent permissions are successfully created.

### 4. Try to create a consent permissions for CREDIT_CARD_READ using a wrong bearer token
- Repeat steps similar to test case 1, but specify CREDIT_CARD_READ permission.

### 5. Try to create a consent permissions for CREDIT_CARD_READ not using a bearer token
- Repeat steps similar to test case 2, but specify CREDIT_CARD_READ permission.

### 6. Try to create a consent permissions for CREDIT_CARD_READ with the right authorization data
- Repeat steps similar to test case 3, but specify CREDIT_CARD_READ permission.

### 7. Try to create a consent permissions for something different than CREDIT_CARD_READ or ACCOUNTS_READ with the right authorization data
- Include a valid bearer token in the Authorization header.
- Send a POST request to the consent permissions endpoint with a permission other than CREDIT_CARD_READ or ACCOUNTS_READ. e.g.: CREDIT_CARD_READs
- Verify that the response should indicate an error related to not allowed information in the permissions field
- <span style="color:red;">BUG: When we pass something different than CREDIT_CARD_READ or ACCOUNTS_READ, we should be able to see a message telling us the problem with an error like "422, Unprocessable Entity" but we see an "500, internal server error".</span>
- Priority: medium to low - it is an improvement, can be fixed in the front too


### 8. Try to update a consent permissions for AUTHORISED with the right authorization data
- Include a valid bearer token in the Authorization header.
- Send a PUT request to the consent permissions endpoint for an existing consent with AUTHORISED status.
- Verify that the consent status is successfully updated to AUTHORISED.

### 9. Try to update a consent permissions for AUTHORISED with the wrong authorization data
- Repeat steps similar to test case 8, but include an incorrect bearer token.

### 10. Try to update a consent permissions for AUTHORISED not using a bearer token
- Repeat steps similar to test case 8, but do not include a bearer token.

### 11. Try to update a consent permissions for AUTHORISED with the right authorization data but with the wrong CONSENTID
- Include a valid bearer token in the Authorization header.
- Send a PUT request to the consent permissions endpoint but using a non-existing CONSENTID.
- Verify that the response indicates a consent not found error.

### 12. Try to update a consent permissions for REJECTED with the right authorization data
- Repeat steps similar to test case 8, but specify REJECTED status.

### 13. Try to update a consent permissions for REJECTED with the wrong authorization data
- Repeat steps similar to test case 12, but include an incorrect bearer token.

### 14. Try to update a consent permissions for REJECTED not using a bearer token
- Repeat steps similar to test case 12, but do not include a bearer token.

### 15. Try to update a consent permissions for REJECTED with the right authorization data but with the wrong CONSENTID
- Repeat steps similar to test case 11, but specify REJECTED status.

### 16. Try to update a consent permissions for REJECTED after this one is AUTHORISED
- Repeat steps similar to test case 8, but attempt to update a consent that is already in AUTHORISED status.

### 17. Try to update a consent permissions for AUTHORISED after this one is REJECTED
- Repeat steps similar to test case 12, but attempt to update a consent that is already in REJECTED status.

### 18. Try to update a consent permissions for something different than AUTHORISED or REJECTED
- Include a valid bearer token in the Authorization header.
- Send a PUT request to the consent permissions endpoint for an existing consent with a status other than AUTHORISED or REJECTED.
- Verify that the response indicates an invalid status error.

### 19. Try to create a consent permissions for ACCOUNTS_READ using a past date to the expirationDateTime field
- Include a past date to the expirationDateTime field
- Send a POST request to the consent permissions endpoint with ACCOUNTS_READ permission.
- Verify that the response should indicate a past date error.
- <span style="color:red;">BUG: The user is able to use a paste date without issues.</span>
- Priority: high - it is an error and the created consent permission cant be updated with a past date


### 20. Reject an already rejected consent permission
- Include a valid bearer token in the Authorization header.
- Send a PUT request to the consent permissions endpoint for an existing consent with REJECTED status.
- Verify that the consent status is successfully updated to REJECTED.
- Do the second step of this test again
- A message informing that the status is already rejected should be displayed
- <span style="color:red;">BUG: A "400, Bad Request" response is displayed, instead of a better error. The request body is fine, but the response message could reflect the actual error.</span>
- Priority: medium - the user should know the current status of the consent permission if something like this happens


### 21. Authorise an already authorised consent permission
- Include a valid bearer token in the Authorization header.
- Send a PUT request to the consent permissions endpoint for an existing consent with AUTHORISED status.
- Verify that the consent status is successfully updated to AUTHORISED.
- Do the second step of this test again
- A message informing that the status is already AUTHORISED should be displayed
- <span style="color:red;">BUG: The user can Authorize indefinitely, but a message informing that the consent permission is already authorized should be displayed.</span>
- Priority: medium - the user should know the current status of the consent permission if something like this happens


### 22. Try to update an expired consent permission
- Include a valid bearer token in the Authorization header.
- Send a PUT request to the consent permissions endpoint for an existing consent with the expirationDatTime field in the past.
- Verify that the response indicates the Consent expired error.
- <span style="color:red;">BUG: A "400, Bad Request" response is displayed, instead of a better error. The request body is fine, but the response message could reflect the actual error.</span>
- Priority: low - it is an improvement


## Security Test Cases

### 1. Test token expiration with time
- Having an expiration time agreed with the security team, generate a new token, wait for this time + 1s and try to use it in the endpoint
- The token should not be accepted anymore and the application should request a new one
- <span style="color:red;">BUG: The token is not expiring.</span>
- Priority: high - security tokens need to expire with time, or a malicious person can save the token and use it later

### 2. Test token expiration when new tokens are created
- Having a valid token, create a new one for the same client and try to use it in the endpoint
- The token should not be accepted anymore and the application should request a new one
- <span style="color:red;">BUG: The token is not expiring.</span>
- Priority: high - security tokens need to expire when new tokens are created, or a malicious person can save the token and use it later 

### 3. Test that token generated for the client1 is not accepted to update client2 consent permissions
- Having a valid token for client1, create a consent permissions for ACCOUNTS_READ
- Having a valid token for client2, try to update the consent permission
- The client2 token should not be accepted on clients1 operations
- <span style="color:red;">BUG: The token from client2 is being accepted.</span>
- Priority: high - if this is a real wanted behavior, I may have misunderstood the intention
