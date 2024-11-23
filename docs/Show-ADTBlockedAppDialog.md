---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Show-ADTBlockedAppDialog

## SYNOPSIS
Displays a dialog to inform the user about a blocked application.

## SYNTAX

```
Show-ADTBlockedAppDialog [-Title] <String> [[-UnboundArguments] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Displays a dialog to inform the user that an application is blocked.
This function ensures that only one instance of the blocked application dialog is shown at a time by using a mutex.
If another instance of the dialog is already open, the function exits without displaying a new dialog.

## EXAMPLES

### EXAMPLE 1
```
Show-ADTBlockedAppDialog -Title 'Blocked Application'
```

Displays a dialog with the title 'Blocked Application' to inform the user about a blocked application.

## PARAMETERS

### -Title
The title of the blocked application dialog.

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

### -UnboundArguments
Captures any additional arguments passed to the function.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

### None
### This function does not return any output.
## NOTES
This function can be called without an active ADT session.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)

