---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Update-ADTDesktop

## SYNOPSIS
Refresh the Windows Explorer Shell, which causes the desktop icons and the environment variables to be reloaded.

## SYNTAX

```
Update-ADTDesktop [<CommonParameters>]
```

## DESCRIPTION
This function refreshes the Windows Explorer Shell, causing the desktop icons and environment variables to be reloaded.
This can be useful after making changes that affect the desktop or environment variables, ensuring that the changes are reflected immediately.

## EXAMPLES

### EXAMPLE 1
```
Update-ADTDesktop
```

Refreshes the Windows Explorer Shell, reloading the desktop icons and environment variables.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
### You cannot pipe objects to this function.
## OUTPUTS

### None
### This function does not return any objects.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)

