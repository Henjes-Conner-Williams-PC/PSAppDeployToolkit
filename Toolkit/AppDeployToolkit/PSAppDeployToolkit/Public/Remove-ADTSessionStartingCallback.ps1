﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

<#
    .SYNOPSIS
        Removes a callback function from the ADT session starting event.

    .DESCRIPTION
        This function removes a specified callback function from the ADT session starting event. The callback function must be provided as a parameter. If the operation fails, it throws a terminating error.

    .PARAMETER Callback
        The callback function to remove from the ADT session starting event.

        Mandatory: True

    .INPUTS
        System.Management.Automation.CommandInfo[]

        An array of CommandInfo objects representing the callback functions to be removed.

    .OUTPUTS
        None

        This function does not generate any output.

    .EXAMPLE
        # Example 1
        Remove-ADTSessionStartingCallback -Callback (Get-Command -Name 'MyCallbackFunction')

        Removes the specified callback function from the ADT session starting event.

    .NOTES
        An active ADT session is NOT required to use this function.

        Tags: psadt
        Website: https://psappdeploytoolkit.com
        Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
        License: https://opensource.org/license/lgpl-3-0

    .LINK
        https://psappdeploytoolkit.com
#>

function Remove-ADTSessionStartingCallback
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.CommandInfo[]]$Callback
    )

    # Send it off to the backend function.
    try
    {
        Invoke-ADTSessionCallbackOperation -Type Starting -Action Remove @PSBoundParameters
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
