---
external help file: password.push-help.xml
Module Name: password.push
online version:
schema: 2.0.0
---

# Connect-PushServer

## SYNOPSIS

Connects to provided Password Pusher server

## SYNTAX

```
Connect-PushServer [-Server] <String> [[-Scope] <Object>] [-Save] [<CommonParameters>]
```

## DESCRIPTION

This function establishes connection to provided Password Pusher server.
The server name can be saved for future use with **Save** parameter.

## EXAMPLES

### Example 1

```powershell
Connect-PushServer -Server pwpush.com
```

This example connects to provided Password Pusher server.

### Example 2

```powershell
Connect-PushServer -Server pwpush.com -Save
```

This example connects to provided Password Pusher server and saves the server
name for future use.

## PARAMETERS

### -Save

Saves provided server name to future use.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope

Specifies the scope to save at.  The default scope is User.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: Enterprise, Machine, User

Required: False
Position: 1
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server

Specifies Password Pusher server name to connect

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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

Password Pusher server version object

## NOTES

## RELATED LINKS

[Publish-Password](Publish-Password.md)
