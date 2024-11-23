﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Test-ADTCallerIsAdmin
{
    <#
    .SYNOPSIS
        Checks if the current user has administrative privileges.

    .DESCRIPTION
        This function checks if the current user is a member of the Administrators group. It returns a boolean value indicating whether the user has administrative privileges.

    .INPUTS
        None

        This function does not take any piped input.

    .OUTPUTS
        System.Boolean

        Returns $true if the current user is an administrator, otherwise $false.

    .EXAMPLE
        Test-ADTCallerIsAdmin

        Checks if the current user has administrative privileges and returns true or false.

    .NOTES
        An active ADT session is NOT required to use this function.

        Tags: psadt
        Website: https://psappdeploytoolkit.com
        Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
        License: https://opensource.org/license/lgpl-3-0

    .LINK
        https://psappdeploytoolkit.com
    #>

    return [System.Security.Principal.WindowsPrincipal]::new([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltinRole]::Administrator)
}
