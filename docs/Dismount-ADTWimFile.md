---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Dismount-ADTWimFile

## SYNOPSIS
Dismounts a WIM file from the specified mount point.

## SYNTAX

### ImagePath
```
Dismount-ADTWimFile -ImagePath <FileInfo[]> [<CommonParameters>]
```

### Path
```
Dismount-ADTWimFile -Path <DirectoryInfo[]> [<CommonParameters>]
```

## DESCRIPTION
The Dismount-ADTWimFile function dismounts a WIM file from the specified mount point and discards all changes.
This function ensures that the specified path is a valid WIM mount point before attempting to dismount.

## EXAMPLES

### EXAMPLE 1
```
Dismount-ADTWimFile -ImagePath 'C:\Path\To\File.wim'
```

This example dismounts the WIM file from all its mount points and discards all changes.

### EXAMPLE 2
```
Dismount-ADTWimFile -Path 'C:\Mount\WIM'
```

This example dismounts the WIM file from the specified mount point and discards all changes.

## PARAMETERS

### -ImagePath
The path to the WIM file.

```yaml
Type: FileInfo[]
Parameter Sets: ImagePath
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path to the WIM mount point.

```yaml
Type: DirectoryInfo[]
Parameter Sets: Path
Aliases:

Required: True
Position: Named
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
### This function does not return any objects.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)

