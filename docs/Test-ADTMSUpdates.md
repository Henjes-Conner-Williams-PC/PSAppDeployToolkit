---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Test-ADTMSUpdates

## SYNOPSIS
Test whether a Microsoft Windows update is installed.

## SYNTAX

```
Test-ADTMSUpdates [-KbNumber] <String> [<CommonParameters>]
```

## DESCRIPTION
This function checks if a specified Microsoft Windows update, identified by its KB number, is installed on the local machine.
It first attempts to find the update using the Get-HotFix cmdlet and, if unsuccessful, uses a COM object to search the update history.

## EXAMPLES

### EXAMPLE 1
```
Test-ADTMSUpdates -KBNumber 'KB2549864'
```

Checks if the Microsoft Update 'KB2549864' is installed and returns true or false.

## PARAMETERS

### -KbNumber
KBNumber of the update.

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

### System.Boolean
### Returns $true if the update is installed, otherwise returns $false.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
