---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Out-ADTPowerShellEncodedCommand

## SYNOPSIS
Encodes a PowerShell command into a Base64 string.

## SYNTAX

```
Out-ADTPowerShellEncodedCommand [-Command] <String> [<CommonParameters>]
```

## DESCRIPTION
This function takes a PowerShell command as input and encodes it into a Base64 string.
This is useful for passing commands to PowerShell through mechanisms that require encoded input.

## EXAMPLES

### EXAMPLE 1
```
Out-ADTPowerShellEncodedCommand -Command 'Get-Process'
```

Encodes the "Get-Process" command into a Base64 string.

## PARAMETERS

### -Command
The PowerShell command to be encoded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
### You cannot pipe objects to this function.
## OUTPUTS

### System.String
### This function returns the encoded Base64 string representation of the input command.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)

