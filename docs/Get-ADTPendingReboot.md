---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Get-ADTPendingReboot

## SYNOPSIS
Get the pending reboot status on a local computer.

## SYNTAX

```
Get-ADTPendingReboot [<CommonParameters>]
```

## DESCRIPTION
Check WMI and the registry to determine if the system has a pending reboot operation from any of the following:
a) Component Based Servicing (Vista, Windows 2008)
b) Windows Update / Auto Update (XP, Windows 2003 / 2008)
c) SCCM 2012 Clients (DetermineIfRebootPending WMI method)
d) App-V Pending Tasks (global based Appv 5.0 SP2)
e) Pending File Rename Operations (XP, Windows 2003 / 2008)

## EXAMPLES

### EXAMPLE 1
```
Get-ADTPendingReboot
```

This example retrieves the pending reboot status on the local computer and returns a custom object with detailed information.

### EXAMPLE 2
```
(Get-ADTPendingReboot).IsSystemRebootPending
```

This example returns a boolean value determining whether or not there is a pending reboot operation.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
### You cannot pipe objects to this function.
## OUTPUTS

### PSADT.Types.RebootInfo
### Returns a custom object with the following properties:
### - ComputerName
### - LastBootUpTime
### - IsSystemRebootPending
### - IsCBServicingRebootPending
### - IsWindowsUpdateRebootPending
### - IsSCCMClientRebootPending
### - IsFileRenameRebootPending
### - PendingFileRenameOperations
### - ErrorMsg
## NOTES
ErrorMsg only contains something if an error occurred.

An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
