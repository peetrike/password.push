---
external help file: password.push-help.xml
Module Name: password.push
online version:
schema: 2.0.0
---

# Read-Password

## SYNOPSIS

Obtains published password object from Password Pusher server

## SYNTAX

```
Read-Password [-Token] <String> [<CommonParameters>]
```

## DESCRIPTION

This function published password object from Password Pusher server.
This counts as one read on password.

## EXAMPLES

### Example 1

```powershell
Read-Password -Token 66zijpmui981wryxsg
```

This example receives password represented by give token.

## PARAMETERS

### -Token

Specifies token that was returned by published password.

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

Published password object with included password

## NOTES

## RELATED LINKS

[Publish-Password](Publish-Password.md)

[Unpublish-Password](Unpublish-Password.md)
