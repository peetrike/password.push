---
external help file: password.push-help.xml
Module Name: password.push
online version:
schema: 2.0.0
---

# Publish-Password

## SYNOPSIS

Publishes password to Password Push server.

## SYNTAX

### Password (Default)
```
Publish-Password -Payload <String> [<CommonParameters>]
```

### Secure
```
Publish-Password -SecurePassword <SecureString> [<CommonParameters>]
```

## DESCRIPTION

This function publishes password to previously connected Password Push server.

## EXAMPLES

### Example 1

```powershell
Publish-Password -Payload $Password
```

This example publishes provided string to Password Pusher server.

### Example 2

```powershell
$SecurePassword = Read-Host -AsSecureString -Prompt 'Enter password to push'
Publish-Password -SecurePassword $SecurePassword
```

This example publishes provided securestring to Password Pusher server.

## PARAMETERS

### -Payload

String to publish to Password Pusher server.

```yaml
Type: String
Parameter Sets: Password
Aliases: Password

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePassword

SecureString to publish to Password Pusher server.

```yaml
Type: SecureString
Parameter Sets: Secure
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

Published password object containing shareable link

## NOTES

## RELATED LINKS

[Connect-PushServer](Connect-PushServer.md)

[Get-PasswordUrl](Get-PasswordUrl.md)

[Read-Password](Read-Password.md)

[Unpublish-Password](Unpublish-Password.md)
