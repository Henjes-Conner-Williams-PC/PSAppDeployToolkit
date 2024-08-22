---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# New-ADTShortcut

## SYNOPSIS
Creates a new .lnk or .url type shortcut.

## SYNTAX

```
New-ADTShortcut [-Path] <String> -TargetPath <String> [-Arguments <String>] [-IconLocation <String>]
 [-IconIndex <Int32>] [-Description <String>] [-WorkingDirectory <String>] [-WindowStyle <String>]
 [-RunAsAdmin] [-Hotkey <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new shortcut .lnk or .url file, with configurable options.
This function allows you to specify various parameters such as the target path, arguments, icon location, description, working directory, window style, run as administrator, and hotkey.

## EXAMPLES

### EXAMPLE 1
```
New-ADTShortcut -Path "$env:ProgramData\Microsoft\Windows\Start Menu\My Shortcut.lnk" -TargetPath "$env:WinDir\System32\notepad.exe" -IconLocation "$env:WinDir\System32\notepad.exe" -Description 'Notepad' -WorkingDirectory "$env:HomeDrive\$env:HomePath"
```

Creates a new shortcut for Notepad with the specified parameters.

## PARAMETERS

### -Path
Path to save the shortcut.

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

### -TargetPath
Target path or URL that the shortcut launches.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Arguments
Arguments to be passed to the target path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconLocation
Location of the icon used for the shortcut.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconIndex
The index of the icon.
Executables, DLLs, ICO files with multiple icons need the icon index to be specified.
This parameter is an Integer.
The first index is 0.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the shortcut.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkingDirectory
Working Directory to be used for the target path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowStyle
Windows style of the application.
Options: Normal, Maximized, Minimized.
Default is: Normal.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunAsAdmin
Set shortcut to run program as administrator.
This option will prompt user to elevate when executing shortcut.

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

### -Hotkey
Create a Hotkey to launch the shortcut, e.g.
"CTRL+SHIFT+F".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
### This function does not return any output.
## NOTES
Url shortcuts only support TargetPath, IconLocation and IconIndex.
Other parameters are ignored.

An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
