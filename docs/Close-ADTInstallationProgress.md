---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Close-ADTInstallationProgress

## SYNOPSIS
Closes the dialog created by Show-ADTInstallationProgress.

## SYNTAX

```
Close-ADTInstallationProgress [<CommonParameters>]
```

## DESCRIPTION
Closes the dialog created by Show-ADTInstallationProgress.
This function is called by the Close-ADTSession function to close a running instance of the progress dialog if found.

## EXAMPLES

### EXAMPLE 1
```
Close-ADTInstallationProgress
```

This example closes the dialog created by Show-ADTInstallationProgress.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
### You cannot pipe objects to this function.
## OUTPUTS

### None
### This function does not generate any output.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)

