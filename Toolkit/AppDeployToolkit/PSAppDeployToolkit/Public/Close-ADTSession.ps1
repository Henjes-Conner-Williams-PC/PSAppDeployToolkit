﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Close-ADTSession
{
    <#
    .SYNOPSIS
        Closes the active ADT session.

    .DESCRIPTION
        The Close-ADTSession function closes the active ADT session, updates the session's exit code if provided, invokes all registered callbacks, and cleans up the session state. If this is the last session, it flags the module as uninitialized and exits the process with the last exit code.

    .PARAMETER ExitCode
        The exit code to set for the session.

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        None

        This function does not generate any output.

    .EXAMPLE
        Close-ADTSession

        This example closes the active ADT session without setting an exit code.

    .EXAMPLE
        Close-ADTSession -ExitCode 0

        This example closes the active ADT session and sets the exit code to 0.

    .NOTES
        An active ADT session is required to use this function.

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
        [System.Int32]$ExitCode
    )

    begin
    {
        # Make this function continue on error and ensure the caller doesn't override ErrorAction.
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorAction $ErrorActionPreference
    }

    process
    {
        # Return early if there's no active session to close.
        if (!(Test-ADTSessionActive))
        {
            return
        }
        $adtSession = Get-ADTSession
        $adtData = Get-ADTModuleData

        # Update the session's exit code with the provided value.
        if ($PSBoundParameters.ContainsKey('ExitCode'))
        {
            $adtSession.SetExitCode($ExitCode)
        }

        # Invoke all callbacks and capture all errors.
        $callbackErrors = foreach ($callback in $($adtData.Callbacks.Closing; if ($adtData.Sessions.Count.Equals(1)) { $adtData.Callbacks.Finishing }))
        {
            try
            {
                try
                {
                    & $callback
                }
                catch
                {
                    & $Script:CommandTable.'Write-Error' -ErrorRecord $_
                }
            }
            catch
            {
                Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Failure occurred while invoking callback [$($callback.Name)]." -PassThru
            }
        }

        # Close out the active session and clean up session state.
        try
        {
            try
            {
                $adtSession.Close()
            }
            catch
            {
                & $Script:CommandTable.'Write-Error' -ErrorRecord $_
            }
        }
        catch
        {
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Failure occurred while closing ADTSession for [$($adtSession.InstallName)]."
        }
        finally
        {
            $null = $adtData.Sessions.Remove($adtSession)
        }

        # Return early if this wasn't the last session.
        if ($adtData.Sessions.Count)
        {
            return
        }

        # Flag the module as uninitialised upon last session closure.
        $adtData.Initialised = $false

        # Return early if this function was called from the command line.
        if ($adtSession.RunspaceOrigin)
        {
            return
        }

        # If a callback failed and we're in a proper console, forcibly exit the process.
        # The proper closure of a blocking dialog can stall a traditional exit indefinitely.
        if ($Host.Name.Equals('ConsoleHost') -and $callbackErrors)
        {
            [System.Environment]::Exit($adtData.LastExitCode)
        }
        exit $adtData.LastExitCode
    }

    end
    {
        # Finalise function.
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}
