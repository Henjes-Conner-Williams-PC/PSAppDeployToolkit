---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Get-ADTSession

## SYNOPSIS
Retrieves the most recent ADT session.

## SYNTAX

```
Get-ADTSession [<CommonParameters>]
```

## DESCRIPTION
The Get-ADTSession function returns the most recent session from the ADT module data.
If no sessions are found, it throws an error indicating that an ADT session should be opened using Open-ADTSession before calling this function.

## EXAMPLES

### EXAMPLE 1
```
Get-ADTSession
```

This example retrieves the most recent ADT session.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
### You cannot pipe objects to this function.
## OUTPUTS

### ADTSession
### Returns the most recent session object from the ADT module data.
## NOTES
An active ADT session is required to use this function.

Requires: PSADT session should be initialized using Open-ADTSession

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)

