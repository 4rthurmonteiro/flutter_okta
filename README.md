# flutter_okta

## Create dev account

You can create Developer Edition Account at https://developer.okta.com/signup/

## Okta rest api

https://developer.okta.com/code/rest/ 

### Register

- Rest api: https://developer.okta.com/docs/reference/api/users/#create-user-with-password
```
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d '{
  "profile": {
    "firstName": "Isaac",
    "lastName": "Brock",
    "email": "isaac.brock@example.com",
    "login": "isaac.brock@example.com",
    "mobilePhone": "555-415-1337"
  },
  "credentials": {
    "password" : { "value": "tlpWENT2m" }
  }
}' "https://${yourOktaDomain}/api/v1/users?activate=true"
```

### Social login

https://developer.okta.com/docs/guides/add-an-external-idp/google/before-you-begin/

#### Google

https://developer.okta.com/docs/guides/add-an-external-idp/google/create-an-app-at-idp/

* Create an App at the Identity Provider
- Access: https://console.developers.google.com/
- Select Credentials => Create Credentials => OAuth client ID => Select the Web application application type 
=> Name your OAuth 2.0 client => Fill Authorized redirect URIs: add the Okta redirect URI. (ex: https://dev-xxxxxxx.okta.com/oauth2/v1/authorize/callback) 
=> click Create => Save the OAuth Client ID and Client Secret values so you can add them to the Okta configuration in the next section.

* Create an Identity Provider in Okta
- Access: https://dev-xxxxxxx-admin.okta.com/dev/console
- Hover over Users and then select Social & Identity Providers
- Add Identity Provider -> Add an Identity Provider -> Add Google
- Fill Client ID and Client Secret from previous step (Google OAuth credentials)
* Register an App in Okta
- In your Okta org, click Applications, and then Add Application
- Select the appropriate platform for your use case, enter a name for your new application, and then click Next.
- In Allowed grant types: Enable Implicit + Check both Allow ID Token with implicit grant type + Allow Access Token with implicit grant type 
- Add Custom Login redirect URIs: `okta://com.okta.dev-xxxxxxx`
- Scroll to the Client Credentials section and copy the client ID that you use to complete the Authorize URL in the next step
* Create the Authorization URL
https://${yourOktaDomain}/oauth2/v1/authorize?idp=0oaaq9pjc2ujmFZexample&client_id=GkGw4K49N4UEE1example&response_type=id_token%20token&response_mode=fragment&scope=openid&redirect_uri=${Login redirect URI}&state=any&nonce=any&prompt=login

> After successful authentication, the user is redirected to the redirect URI that you specified, along with an #id_token= and &access_token fragment in the URL
> Get user info from access token: 
```
curl --location --request GET 'https://dev-xxxxxxx.okta.com/oauth2/v1/userinfo' \
--header 'Accept: application/json' \
--header 'Authorization: Bearer access_token'
```

