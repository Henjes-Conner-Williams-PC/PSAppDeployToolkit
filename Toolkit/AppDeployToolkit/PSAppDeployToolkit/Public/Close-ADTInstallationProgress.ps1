﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Close-ADTInstallationProgress
{
    <#
    .SYNOPSIS
        Closes the dialog created by Show-ADTInstallationProgress.

    .DESCRIPTION
        Closes the dialog created by Show-ADTInstallationProgress. This function is called by the Close-ADTSession function to close a running instance of the progress dialog if found.

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        None

        This function does not generate any output.

    .EXAMPLE
        # Example 1
        Close-ADTInstallationProgress

        This example closes the dialog created by Show-ADTInstallationProgress.

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

    begin
    {
        $adtSession = Initialize-ADTDialogFunction -Cmdlet $PSCmdlet
        $adtConfig = Get-ADTConfig
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            try
            {
                # Return early if we're silent, a window wouldn't have ever opened.
                if (!(Test-ADTInstallationProgressRunning))
                {
                    return
                }
                if ($adtSession -and $adtSession.IsSilent())
                {
                    Write-ADTLogEntry -Message "Bypassing $($MyInvocation.MyCommand.Name) [Mode: $($adtSession.GetPropertyValue('DeployMode'))]"
                    return
                }

                # Call the underlying function to close the progress window.
                & $Script:DialogDispatcher.($adtConfig.UI.DialogStyle).($MyInvocation.MyCommand.Name)
                Remove-ADTSessionFinishingCallback -Callback $MyInvocation.MyCommand

                # Send out the final toast notification.
                if ($adtSession)
                {
                    switch ($adtSession.GetDeploymentStatus())
                    {
                        FastRetry
                        {
                            Show-ADTBalloonTip -BalloonTipIcon Warning -BalloonTipText "$($adtSession.GetDeploymentTypeName()) $((Get-ADTStringTable).BalloonText.$_)"
                            break
                        }
                        Error
                        {
                            Show-ADTBalloonTip -BalloonTipIcon Error -BalloonTipText "$($adtSession.GetDeploymentTypeName()) $((Get-ADTStringTable).BalloonText.$_)"
                            break
                        }
                        default
                        {
                            Show-ADTBalloonTip -BalloonTipIcon Info -BalloonTipText "$($adtSession.GetDeploymentTypeName()) $((Get-ADTStringTable).BalloonText.$_)"
                            break
                        }
                    }
                }
            }
            catch
            {
                & $Script:CommandTable.'Write-Error' -ErrorRecord $_
            }
        }
        catch
        {
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}
