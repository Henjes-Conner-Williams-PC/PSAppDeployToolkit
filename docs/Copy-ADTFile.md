---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Copy-ADTFile

## SYNOPSIS
Copies files and directories from a source to a destination.

## SYNTAX

```
Copy-ADTFile [-Path] <String[]> [-Destination] <String> [-Recurse] [-Flatten] [-ContinueFileCopyOnError]
 [-FileCopyMode <String>] [<CommonParameters>]
```

## DESCRIPTION
Copies files and directories from a source to a destination.
This function supports recursive copying, overwriting existing files, and returning the copied items.

## EXAMPLES

### EXAMPLE 1
```
Copy-ADTFile -Path 'C:\Path\file.txt' -Destination 'D:\Destination\file.txt'
```

Copies the file 'file.txt' from 'C:\Path' to 'D:\Destination'.

### EXAMPLE 2
```
Copy-ADTFile -Path 'C:\Path\Folder' -Destination 'D:\Destination\Folder' -Recurse
```

Recursively copies the folder 'Folder' from 'C:\Path' to 'D:\Destination'.

### EXAMPLE 3
```
Copy-ADTFile -Path 'C:\Path\file.txt' -Destination 'D:\Destination\file.txt' -Force
```

Copies the file 'file.txt' from 'C:\Path' to 'D:\Destination', overwriting the destination file if it exists.

## PARAMETERS

### -Path
Path of the file to copy.
Multiple paths can be specified.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Destination
Destination Path of the file to copy.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
Copy files in subdirectories.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Flatten
Flattens the files into the root destination directory.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContinueFileCopyOnError
If Path is an array, continue copying files if an error is encountered.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileCopyMode
Select from 'Native' or 'Robocopy'.
Default is configured in config.psd1.
Note that Robocopy supports * in file names, but not folders, in source paths.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-ADTConfig).Toolkit.FileCopyMode
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

