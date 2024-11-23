﻿#-----------------------------------------------------------------------------
#
# MARK: Test-ADTOobeCompleted
#
#-----------------------------------------------------------------------------

function Test-ADTOobeCompleted
{
    <#
    .SYNOPSIS
        Checks if the device's Out-of-Box Experience (OOBE) has completed or not.

    .DESCRIPTION
        This function checks if the current device has completed the Out-of-Box Experience (OOBE).

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        System.Boolean

        Returns $true if the device has proceeded past the OOBE, otherwise $false.

    .EXAMPLE
        Test-ADTOobeCompleted

        Checks if the device has completed the OOBE or not and returns true or false.

    .NOTES
        An active ADT session is NOT required to use this function.

        Tags: psadt
        Website: https://psappdeploytoolkit.com
        Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
        License: https://opensource.org/license/lgpl-3-0

    .LINK
        https://psappdeploytoolkit.com
    #>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
    )

    begin
    {
        # Initialize function.
        & $Script:CommandTable.'Initialize-ADTFunction' -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        # Return whether the OOBE is completed via an API call.
        try
        {
            try
            {
                return ([PSADT.Shared.Utility]::IsOOBEComplete())
            }
            catch
            {
                # Re-writing the ErrorRecord with Write-Object ensures the correct PositionMessage is used.
                & $Script:CommandTable.'Write-Error' -ErrorRecord $_
            }
        }
        catch
        {
            # Process the caught error, log it and throw depending on the specified ErrorAction.
            & $Script:CommandTable.'Invoke-ADTFunctionErrorHandler' -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Error determining whether the OOBE has been completed or not."
        }
    }

    end
    {
        # Finalize function.
        & $Script:CommandTable.'Complete-ADTFunction' -Cmdlet $PSCmdlet
    }
}
