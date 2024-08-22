---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Set-ADTActiveSetup

## SYNOPSIS
Creates an Active Setup entry in the registry to execute a file for each user upon login.

## SYNTAX

### Create
```
Set-ADTActiveSetup -StubExePath <String> [-Arguments <String>] [-Wow6432Node] [-Version <String>]
 [-Locale <String>] [-DisableActiveSetup] [-NoExecuteForCurrentUser] [<CommonParameters>]
```

### Purge
```
Set-ADTActiveSetup [-Wow6432Node] [-PurgeActiveSetupKey] [<CommonParameters>]
```

## DESCRIPTION
Active Setup allows handling of per-user changes registry/file changes upon login.

A registry key is created in the HKLM registry hive which gets replicated to the HKCU hive when a user logs in.

If the "Version" value of the Active Setup entry in HKLM is higher than the version value in HKCU, the file referenced in "StubPath" is executed.

This Function:
    - Creates the registry entries in HKLM:SOFTWARE\Microsoft\Active Setup\Installed Components\$installName.
    - Creates StubPath value depending on the file extension of the $StubExePath parameter.
    - Handles Version value with YYYYMMDDHHMMSS granularity to permit re-installs on the same day and still trigger Active Setup after Version increase.
    - Copies/overwrites the StubPath file to $StubExePath destination path if file exists in 'Files' subdirectory of script directory.
    - Executes the StubPath file for the current user based on $NoExecuteForCurrentUser (no need to logout/login to trigger Active Setup).

## EXAMPLES

### EXAMPLE 1
```
Set-ADTActiveSetup -StubExePath 'C:\Users\Public\Company\ProgramUserConfig.vbs' -Arguments '/Silent' -Description 'Program User Config' -Key 'ProgramUserConfig' -Locale 'en'
```

### EXAMPLE 2
```
Set-ADTActiveSetup -StubExePath "$envWinDir\regedit.exe" -Arguments "/S `"%SystemDrive%\Program Files (x86)\PS App Deploy\PSAppDeployHKCUSettings.reg`"" -Description 'PS App Deploy Config' -Key 'PS_App_Deploy_Config'
```

### EXAMPLE 3
```
# Delete "ProgramUserConfig" active setup entry from all registry hives.
```

Set-ADTActiveSetup -Key 'ProgramUserConfig' -PurgeActiveSetupKey

## PARAMETERS

### -StubExePath
Use this parameter to specify the destination path of the file that will be executed upon user login.

Note: Place the file you want users to execute in the '\Files' subdirectory of the script directory and the toolkit will install it to the path specificed in this parameter.

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Arguments
Arguments to pass to the file being executed.

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wow6432Node
Specify this switch to use Active Setup entry under Wow6432Node on a 64-bit OS.
Default is: $false.

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

### -Version
Optional.
Specify version for Active setup entry.
Active Setup is not triggered if Version value has more than 8 consecutive digits.
Use commas to get around this limitation.
Default: YYYYMMDDHHMMSS

Note:
    - Do not use this parameter if it is not necessary.
PSADT will handle this parameter automatically using the time of the installation as the version number.
    - In Windows 10, Scripts and EXEs might be blocked by AppLocker.
Ensure that the path given to -StubExePath will permit end users to run Scripts and EXEs unelevated.

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: ((& $Script:CommandTable.'Get-Date' -Format 'yyMM,ddHH,mmss').ToString())
Accept pipeline input: False
Accept wildcard characters: False
```

### -Locale
Optional.
Arbitrary string used to specify the installation language of the file being executed.
Not replicated to HKCU.

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableActiveSetup
Disables the Active Setup entry so that the StubPath file will not be executed.
This also enables -NoExecuteForCurrentUser.

```yaml
Type: SwitchParameter
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PurgeActiveSetupKey
Remove Active Setup entry from HKLM registry hive.
Will also load each logon user's HKCU registry hive to remove Active Setup entry.
Function returns after purging.

```yaml
Type: SwitchParameter
Parameter Sets: Purge
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoExecuteForCurrentUser
Specifies whether the StubExePath should be executed for the current user.
Since this user is already logged in, the user won't have the application started without logging out and logging back in.

```yaml
Type: SwitchParameter
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this function.
## OUTPUTS

### System.Boolean. Returns $true if Active Setup entry was created or updated, $false if Active Setup entry was not created or updated.
## NOTES
This function can be called without an active ADT session.

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
