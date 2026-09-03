---
external help file: password.push-help.xml
Module Name: password.push
online version:
schema: 2.0.0
---

# Get-PasswordUrl

## SYNOPSIS

Retrieves pushed password URL

## SYNTAX

```
Get-PasswordUrl [-Token] <String> [<CommonParameters>]
```

## DESCRIPTION

This function retrieves previously published password URL.  
The URL can be used to obtain published password.

## EXAMPLES

### Example 1

```powershell
Get-PasswordUrl -Token 66zijpmui981wryxsg
```

This example retrieves published password url represented by given token.

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

### System.Uri

URL object for published password.

## NOTES

## RELATED LINKS

[Publish-Password](Publish-Password.md)

[Read-Password](Read-Password.md)
