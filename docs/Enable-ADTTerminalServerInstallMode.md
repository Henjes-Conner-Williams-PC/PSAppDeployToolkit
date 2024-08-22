---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Enable-ADTTerminalServerInstallMode

## SYNOPSIS
Changes to user install mode for Remote Desktop Session Host/Citrix servers.

## SYNTAX

```
Enable-ADTTerminalServerInstallMode [<CommonParameters>]
```

## DESCRIPTION
The Enable-ADTTerminalServerInstallMode function changes the server mode to user install mode for Remote Desktop Session Host/Citrix servers.
This is useful for ensuring that applications are installed in a way that is compatible with multi-user environments.

## EXAMPLES

### EXAMPLE 1
```
Enable-ADTTerminalServerInstallMode
```

This example changes the server mode to user install mode for Remote Desktop Session Host/Citrix servers.

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
