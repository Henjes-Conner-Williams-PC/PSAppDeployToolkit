---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Start-ADTProcess

## SYNOPSIS
Execute a process with optional arguments, working directory, window style.

## SYNTAX

```
Start-ADTProcess [-Path] <String> [[-Parameters] <String[]>] [-SecureParameters]
 [[-WindowStyle] <ProcessWindowStyle>] [-CreateNoWindow] [[-WorkingDirectory] <String>] [-NoWait] [-PassThru]
 [-WaitForMsiExec] [[-MsiExecWaitTime] <Int32>] [[-IgnoreExitCodes] <String[]>]
 [[-PriorityClass] <ProcessPriorityClass>] [-NoExitOnProcessFailure] [-UseShellExecute] [<CommonParameters>]
```

## DESCRIPTION
Executes a process, e.g.
a file included in the Files directory of the App Deploy Toolkit, or a file on the local machine.
Provides various options for handling the return codes (see Parameters).

## EXAMPLES

### EXAMPLE 1
```
Start-ADTProcess -Path 'setup.exe' -Parameters '/S' -IgnoreExitCodes 1,2
```

### EXAMPLE 2
```
Start-ADTProcess -Path "$dirFiles\Bin\setup.exe" -Parameters '/S' -WindowStyle 'Hidden'
```

### EXAMPLE 3
```
# If the file is in the "Files" directory of the App Deploy Toolkit, only the file name needs to be specified.
```

Start-ADTProcess -Path 'uninstall_flash_player_64bit.exe' -Parameters '/uninstall' -WindowStyle 'Hidden'

### EXAMPLE 4
```
# Launch InstallShield "setup.exe" from the ".\Files" sub-directory and force log files to the logging folder.
```

Start-ADTProcess -Path 'setup.exe' -Parameters "-s -f2\`"$((Get-ADTConfig).Toolkit.LogPath)\$installName.log\`""

### EXAMPLE 5
```
# Launch InstallShield "setup.exe" with embedded MSI and force log files to the logging folder.
```

Start-ADTProcess -Path 'setup.exe' -Parameters "/s /v\`"ALLUSERS=1 /qn /L* \\\`"$((Get-ADTConfig).Toolkit.LogPath)\$installName.log\`"\`""

## PARAMETERS

### -Path
Path to the file to be executed.
If the file is located directly in the "Files" directory of the App Deploy Toolkit, only the file name needs to be specified.

Otherwise, the full path of the file must be specified.
If the files is in a subdirectory of "Files", use the "$dirFiles" variable as shown in the example.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FilePath

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parameters
Arguments to be passed to the executable

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Arguments

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecureParameters
Hides all parameters passed to the executable from the Toolkit log file

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

### -WindowStyle
Style of the window of the process executed.
Options: Normal, Hidden, Maximized, Minimized.
Default: Normal.
Only works for native Windows GUI applications.
If the WindowStyle is set to Hidden, UseShellExecute should be set to $true.

Note: Not all processes honor WindowStyle.
WindowStyle is a recommendation passed to the process.
They can choose to ignore it.

```yaml
Type: ProcessWindowStyle
Parameter Sets: (All)
Aliases:
Accepted values: Normal, Hidden, Minimized, Maximized

Required: False
Position: 3
Default value: Normal
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateNoWindow
Specifies whether the process should be started with a new window to contain it.
Only works for Console mode applications.
UseShellExecute should be set to $false.
Default is false.

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

### -WorkingDirectory
The working directory used for executing the process.
Defaults to the directory of the file being executed.
The use of UseShellExecute affects this parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoWait
Immediately continue after executing the process.

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

### -PassThru
If NoWait is not specified, returns an object with ExitCode, STDOut and STDErr output from the process.
If NoWait is specified, returns an object with Id, Handle and ProcessName.

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

### -WaitForMsiExec
Sometimes an EXE bootstrapper will launch an MSI install.
In such cases, this variable will ensure that this function waits for the msiexec engine to become available before starting the install.

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

### -MsiExecWaitTime
Specify the length of time in seconds to wait for the msiexec engine to become available.
Default: 600 seconds (10 minutes).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: (Get-ADTConfig).MSI.MutexWaitTime
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreExitCodes
List the exit codes to ignore or * to ignore all exit codes.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PriorityClass
Specifies priority class for the process.
Options: Idle, Normal, High, AboveNormal, BelowNormal, RealTime.
Default: Normal

```yaml
Type: ProcessPriorityClass
Parameter Sets: (All)
Aliases:
Accepted values: Normal, Idle, High, RealTime, BelowNormal, AboveNormal

Required: False
Position: 7
Default value: Normal
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoExitOnProcessFailure
Specifies whether the function shouldn't call Close-ADTSession when the process returns an exit code that is considered an error/failure.
Default: $false

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

### -UseShellExecute
Specifies whether to use the operating system shell to start the process.
$true if the shell should be used when starting the process; $false if the process should be created directly from the executable file.

The word "Shell" in this context refers to a graphical shell (similar to the Windows shell) rather than command shells (for example, bash or sh) and lets users launch graphical applications or open documents.
It lets you open a file or a url and the Shell will figure out the program to open it with.

The WorkingDirectory property behaves differently depending on the value of the UseShellExecute property.
When UseShellExecute is true, the WorkingDirectory property specifies the location of the executable.
When UseShellExecute is false, the WorkingDirectory property is not used to find the executable.
Instead, it is used only by the process that is started and has meaning only within the context of the new process.

If you set UseShellExecute to $true, there will be no available output from the process.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this function.
## OUTPUTS

### None. This function does not generate any output.
## NOTES

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
