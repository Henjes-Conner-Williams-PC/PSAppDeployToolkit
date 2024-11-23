﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Get-ADTConfig
{
    <#
    .SYNOPSIS
        Retrieves the configuration data for the ADT module.

    .DESCRIPTION
        The Get-ADTConfig function retrieves the configuration data for the ADT module. This function ensures that the ADT module has been initialized before attempting to retrieve the configuration data. If the module is not initialized, it throws an error.

    .INPUTS
        None

        This function does not take any pipeline input.

    .OUTPUTS
        System.Hashtable

        Returns the configuration data as a hashtable.

    .EXAMPLE
        $config = Get-ADTConfig

        This example retrieves the configuration data for the ADT module and stores it in the $config variable.

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

    # Return the config database if initialised.
    if (!($adtData = Get-ADTModuleData).Config -or !$adtData.Config.Count)
    {
        $naerParams = @{
            Exception = [System.InvalidOperationException]::new("Please ensure that [Initialize-ADTModule] is called before using any $($MyInvocation.MyCommand.Module.Name) functions.")
            Category = [System.Management.Automation.ErrorCategory]::InvalidOperation
            ErrorId = 'ADTConfigNotLoaded'
            TargetObject = $adtData.Config
            RecommendedAction = "Please ensure the module is initialised via [Initialize-ADTModule] and try again."
        }
        $PSCmdlet.ThrowTerminatingError((New-ADTErrorRecord @naerParams))
    }
    return $adtData.Config
}
