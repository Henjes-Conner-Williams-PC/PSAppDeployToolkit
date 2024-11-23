﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Get-ADTEnvironment
{
    <#
    .SYNOPSIS
        Retrieves the environment data for the ADT module.

    .DESCRIPTION
        The Get-ADTEnvironment function retrieves the environment data for the ADT module. This function ensures that the ADT module has been initialized before attempting to retrieve the environment data. If the module is not initialized, it throws an error.

    .INPUTS
        None

        This function does not take any pipeline input.

    .OUTPUTS
        System.Hashtable

        Returns the environment data as a hashtable.

    .EXAMPLE
        $environment = Get-ADTEnvironment

        This example retrieves the environment data for the ADT module and stores it in the $environment variable.

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
    param
    (
    )

    # Return the environment database if initialised.
    if (!($adtData = Get-ADTModuleData).Environment -or !$adtData.Environment.Count)
    {
        $naerParams = @{
            Exception = [System.InvalidOperationException]::new("Please ensure that [Initialize-ADTModule] is called before using any $($MyInvocation.MyCommand.Module.Name) functions.")
            Category = [System.Management.Automation.ErrorCategory]::InvalidOperation
            ErrorId = 'ADTEnvironmentDatabaseEmpty'
            TargetObject = $adtData.Environment
            RecommendedAction = "Please ensure the module is initialised via [Initialize-ADTModule] and try again."
        }
        $PSCmdlet.ThrowTerminatingError((New-ADTErrorRecord @naerParams))
    }
    return $adtData.Environment
}
