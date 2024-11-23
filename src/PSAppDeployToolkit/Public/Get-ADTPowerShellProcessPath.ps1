﻿#-----------------------------------------------------------------------------
#
# MARK: Get-ADTPowerShellProcessPath
#
#-----------------------------------------------------------------------------

function Get-ADTPowerShellProcessPath
{
    <#
    .SYNOPSIS
        Retrieves the path to the PowerShell executable.

    .DESCRIPTION
        The Get-ADTPowerShellProcessPath function returns the path to the PowerShell executable. It determines whether the current PowerShell session is running in Windows PowerShell or PowerShell Core and returns the appropriate executable path.

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        System.String

        Returns the path to the PowerShell executable as a string.

    .EXAMPLE
        Get-ADTPowerShellProcessPath

        This example retrieves the path to the PowerShell executable for the current session.

    .NOTES
        An active ADT session is NOT required to use this function.

        Tags: psadt
        Website: https://psappdeploytoolkit.com
        Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
        License: https://opensource.org/license/lgpl-3-0

    .LINK
        https://psappdeploytoolkit.com
    #>

    return "$PSHOME\$(('powershell.exe', 'pwsh.exe')[$PSVersionTable.PSEdition.Equals('Core')])"
}
