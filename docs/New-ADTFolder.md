---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# New-ADTFolder

## SYNOPSIS
Create a new folder.

## SYNTAX

```
New-ADTFolder [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Create a new folder if it does not exist.
This function checks if the specified path already exists and creates the folder if it does not.
It logs the creation process and handles any errors that may occur during the folder creation.

## EXAMPLES

### EXAMPLE 1
```
New-ADTFolder -Path "$env:WinDir\System32"
```

Creates a new folder at the specified path if it does not already exist.

## PARAMETERS

### -Path
Path to the new folder to create.

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

