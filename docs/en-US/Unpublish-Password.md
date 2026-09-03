---
external help file: password.push-help.xml
Module Name: password.push
online version:
schema: 2.0.0
---

# Unpublish-Password

## SYNOPSIS

Expires previously published password object.

## SYNTAX

```
Unpublish-Password [-Token] <String> [<CommonParameters>]
```

## DESCRIPTION

This function expires previously published password object.
Password is removed from server.

## EXAMPLES

### Example 1

```powershell
Unpublish-Password -Token 66zijpmui981wryxsg
```

This example exipres published password object represented by given token.

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

Expired published password object

## NOTES

## RELATED LINKS

[Publish-Password](Publish-Password.md)
