# password.push

## about_password.push


# SHORT DESCRIPTION

Password Pusher API wrapper module.

# LONG DESCRIPTION

This module works as wrapper to Password Pusher API.

Password Pusher server allows to save passwords for sharing them with other people.

Password Pusher creates encrypted links that self-destruct after viewing.

# EXAMPLES

```powershell
$secret = Read-Host -AsSecureString -Prompt 'Enter password to share'
$result = Publish-Password -SecretPassword $secret
$result | Select-Object -Property url_token, html_url
```

This example publishes password on https://oss.pwpush.com server and provides
token and shareable URL that can be sent to person that needs shared password.

Token can later be used to access published password on server.

```powershell
Connect-PushServer -Server pwpush.com
$text = get-content -path password.csv
$result = Publish-Password -Payload $text
$result.html_url
```

This example connects to alternate Password Pusher server and publishes
group of passwords from .csv file to the server.

```powershell
Connect-PushServer -Server myserver.com -Save
```

This example connects to custom server and saves the server name for future use.
Saving server allows to use saved server automatically in future sessions

# NOTE

There is difference in functinality between commercial and OSS versions.
Custom server might also turn off some functionality.

# SEE ALSO

[Password Pusher server](https://pwpush.com)

[Password Pusher OSS API](https://oss.pwpush.com/help/api)

# KEYWORDS

- Password
- pwpush
- sharing
