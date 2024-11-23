﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Dismount-ADTWimFile
{
    <#
    .SYNOPSIS
        Dismounts a WIM file from the specified mount point.

    .DESCRIPTION
        The Dismount-ADTWimFile function dismounts a WIM file from the specified mount point and discards all changes. This function ensures that the specified path is a valid WIM mount point before attempting to dismount.

    .PARAMETER Path
        The path to the WIM mount point.

        Mandatory: True

    .INPUTS
        None

        This function does not take any pipeline input.

    .OUTPUTS
        None

        This function does not return any objects.

    .EXAMPLE
        # Example 1
        Dismount-ADTWimFile -Path 'C:\Mount\WIM'

        This example dismounts the WIM file from the specified mount point and discards all changes.

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
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if (!(Test-ADTMountedWimPath -Path $_))
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'The specified path is not a WIM mount point.'))
                }
                return !!$_
            })]
        [System.IO.DirectoryInfo]$Path
    )

    begin
    {
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        # Announce commencement.
        Write-ADTLogEntry -Message "Dismounting WIM file at path [$Path]."
        try
        {
            try
            {
                # Perform the dismount and discard all changes.
                try
                {
                    $null = & $Script:CommandTable.'Dismount-WindowsImage' -Path $Path -Discard
                }
                catch
                {
                    # Re-throw if this error is anything other than a file-locked error.
                    if (!$_.Exception.ErrorCode.Equals(-1052638953))
                    {
                        throw
                    }

                    # Get all open file handles for our path.
                    Write-ADTLogEntry -Message "The directory could not be completely unmounted. Checking for any open file handles that can be closed."
                    $exeHandle = "$Script:PSScriptRoot\bin\$([System.Environment]::GetEnvironmentVariable('PROCESSOR_ARCHITECTURE'))\handle\handle.exe"
                    $pathRegex = "^$([System.Text.RegularExpressions.Regex]::Escape($Path))"
                    $pathHandles = Get-ADTProcessHandles | & { process { if ($_.Name -match $pathRegex) { return $_ } } }

                    # Throw if we have no handles to close, it means we don't know why the WIM didn't dismount.
                    if (!$pathHandles)
                    {
                        throw
                    }

                    # Close all open file handles.
                    foreach ($handle in $pathHandles)
                    {
                        Write-ADTLogEntry -Message "$(($msg = "Closing handle [$($handle.Handle)] for process [$($handle.Process) ($($handle.PID))]"))."
                        $handleResult = & $exeHandle -nobanner -c $handle.Handle -p $handle.PID -y
                        if (!$LASTEXITCODE.Equals(0))
                        {
                            Write-ADTLogEntry -Message ($msg = "$msg failed with exit code [$LASTEXITCODE]: $handleResult") -Severity 3
                            $naerParams = @{
                                Exception = [System.ApplicationException]::new($msg)
                                Category = [System.Management.Automation.ErrorCategory]::InvalidResult
                                ErrorId = 'HandleClosureFailure'
                                TargetObject = $handleResult
                                RecommendedAction = "Please review the result in this error's TargetObject property and try again."
                            }
                            throw (New-ADTErrorRecord @naerParams)
                        }
                    }

                    # Attempt the dismount again.
                    $null = & $Script:CommandTable.'Dismount-WindowsImage' -Path $Path -Discard
                }
                Write-ADTLogEntry -Message "Successfully dismounted WIM file."
                Remove-Item -LiteralPath $Path -Force -Confirm:$false
            }
            catch
            {
                & $Script:CommandTable.'Write-Error' -ErrorRecord $_
            }
        }
        catch
        {
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage 'Error occurred while attempting to dismount WIM file.'
        }
    }

    end
    {
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}
