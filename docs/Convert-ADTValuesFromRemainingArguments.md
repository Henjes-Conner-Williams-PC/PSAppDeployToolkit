---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Convert-ADTValuesFromRemainingArguments

## SYNOPSIS
Converts the collected values from a ValueFromRemainingArguments parameter value into a dictionary or PowerShell.exe command line arguments.

## SYNTAX

```
Convert-ADTValuesFromRemainingArguments
 [-RemainingArguments] <System.Collections.Generic.List`1[System.Object]> [<CommonParameters>]
```

## DESCRIPTION
This function converts the collected values from a ValueFromRemainingArguments parameter value into a dictionary or PowerShell.exe command line arguments.

## EXAMPLES

### EXAMPLE 1
```
Convert-ADTValuesFromRemainingArguments -RemainingArguments $args
```

Converts an $args array into a $PSBoundParameters-compatible dictionary.

## PARAMETERS

### -RemainingArguments
The collected values to enumerate and process into a dictionary.

```yaml
Type: System.Collections.Generic.List`1[System.Object]
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

### System.Collections.Generic.Dictionary[System.String, System.Object]
### Convert-ADTValuesFromRemainingArguments returns a dictionary of the processed input.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
