---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Get-ADTConfig

## SYNOPSIS
Retrieves the configuration data for the ADT module.

## SYNTAX

```
Get-ADTConfig [<CommonParameters>]
```

## DESCRIPTION
The Get-ADTConfig function retrieves the configuration data for the ADT module.
This function ensures that the ADT module has been initialized before attempting to retrieve the configuration data.
If the module is not initialized, it throws an error.

## EXAMPLES

### EXAMPLE 1
```
$config = Get-ADTConfig
```

This example retrieves the configuration data for the ADT module and stores it in the $config variable.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
### You cannot pipe objects to this function.
## OUTPUTS

### System.Collections.Hashtable
### Returns the configuration data as a hashtable.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)

