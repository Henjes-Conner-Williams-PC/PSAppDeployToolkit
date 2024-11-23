﻿#-----------------------------------------------------------------------------
#
# MARK: Initialize-ADTModule
#
#-----------------------------------------------------------------------------

function Initialize-ADTModule
{
    <#
    .SYNOPSIS
        Initializes the ADT module by setting up necessary configurations and environment.

    .DESCRIPTION
        The Initialize-ADTModule function sets up the environment for the ADT module by initializing necessary variables, configurations, and string tables. It ensures that the module is not initialized while there is an active ADT session in progress. This function prepares the module for use by clearing callbacks, sessions, and setting up the environment table.

    .PARAMETER ScriptDirectory
        An override directory to use for config and string loading.

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        None

        This function does not return any output.

    .EXAMPLE
        Initialize-ADTModule

        Initializes the ADT module with the default settings and configurations.

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
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$ScriptDirectory
    )

    begin
    {
        # Ensure this function isn't being called mid-flight.
        if (& $Script:CommandTable.'Test-ADTSessionActive')
        {
            $naerParams = @{
                Exception = [System.InvalidOperationException]::new("This function cannot be called while there is an active ADTSession in progress.")
                Category = [System.Management.Automation.ErrorCategory]::InvalidOperation
                ErrorId = 'InitWithActiveSessionError'
                TargetObject = & $Script:CommandTable.'Get-ADTSession'
                RecommendedAction = "Please attempt module re-initialisation once the active ADTSession(s) have been closed."
            }
            $PSCmdlet.ThrowTerminatingError((& $Script:CommandTable.'New-ADTErrorRecord' @naerParams))
        }
        & $Script:CommandTable.'Initialize-ADTFunction' -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $adtData = & $Script:CommandTable.'Get-ADTModuleData'
    }

    process
    {
        try
        {
            try
            {
                # Initialize the module's global state.
                $ModuleInitStart = [System.DateTime]::Now
                $adtData.Callbacks.Starting.Clear()
                $adtData.Callbacks.Opening.Clear()
                $adtData.Callbacks.Closing.Clear()
                $adtData.Callbacks.Finishing.Clear()
                $adtData.Sessions.Clear()
                $adtData.Environment = & $Script:CommandTable.'New-ADTEnvironmentTable'
                $adtData.Config = & $Script:CommandTable.'Import-ADTConfig' @PSBoundParameters
                $adtData.Language = & $Script:CommandTable.'Get-ADTStringLanguage'
                $adtData.Strings = & $Script:CommandTable.'Import-ADTStringTable' -UICulture $adtData.Language @PSBoundParameters
                $adtData.LastExitCode = 0
                $adtData.TerminalServerMode = $false

                # Mark the environment table as read-only before finishing.
                $adtData.Environment = $adtData.Environment.AsReadOnly()
                $adtData.Durations.ModuleInit = [System.DateTime]::Now - $ModuleInitStart
                $adtData.Initialized = $true
            }
            catch
            {
                & $Script:CommandTable.'Write-Error' -ErrorRecord $_
            }
        }
        catch
        {
            & $Script:CommandTable.'Invoke-ADTFunctionErrorHandler' -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        & $Script:CommandTable.'Complete-ADTFunction' -Cmdlet $PSCmdlet
    }
}
