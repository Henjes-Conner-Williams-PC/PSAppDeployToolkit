﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Remove-ADTFile
{
    <#
    .SYNOPSIS
        Removes one or more items from a given path on the filesystem.

    .DESCRIPTION
        This function removes one or more items from a given path on the filesystem. It can handle both wildcard paths and literal paths. If the specified path does not exist, it logs a warning instead of throwing an error. The function can also delete items recursively if the Recurse parameter is specified.

    .PARAMETER Path
        Specifies the path on the filesystem to be resolved. The value of Path will accept wildcards. Will accept an array of values.

    .PARAMETER LiteralPath
        Specifies the path on the filesystem to be resolved. The value of LiteralPath is used exactly as it is typed; no characters are interpreted as wildcards. Will accept an array of values.

    .PARAMETER Recurse
        Deletes the files in the specified location(s) and in all child items of the location(s).

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        None

        This function does not generate any output.

    .EXAMPLE
        Remove-ADTFile -Path 'C:\Windows\Downloaded Program Files\Temp.inf'

        Removes the specified file.

    .EXAMPLE
        Remove-ADTFile -LiteralPath 'C:\Windows\Downloaded Program Files' -Recurse

        Removes the specified folder and all its contents recursively.

    .NOTES
        This function continues on received errors by default. To have the function stop on an error, please provide `-ErrorAction Stop` on the end of your call.

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
        [Parameter(Mandatory = $true, ParameterSetName = 'Path')]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'LiteralPath')]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$LiteralPath,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$Recurse
    )

    begin
    {
        # Make this function continue on error.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorAction SilentlyContinue
    }

    process
    {
        foreach ($Item in $(if ($PSCmdlet.ParameterSetName -eq 'Path') { $Path } else { $LiteralPath }))
        {
            # Resolve the specified path, if the path does not exist, display a warning instead of an error.
            try
            {
                try
                {
                    $Item = if ($PSCmdlet.ParameterSetName -eq 'Path')
                    {
                        (& $Script:CommandTable.'Resolve-Path' -Path $Item).Path
                    }
                    else
                    {
                        (& $Script:CommandTable.'Resolve-Path' -LiteralPath $Item).Path
                    }
                }
                catch [System.Management.Automation.ItemNotFoundException]
                {
                    Write-ADTLogEntry -Message "Unable to resolve the path [$Item] because it does not exist." -Severity 2
                    continue
                }
                catch [System.Management.Automation.DriveNotFoundException]
                {
                    Write-ADTLogEntry -Message "Unable to resolve the path [$Item] because the drive does not exist." -Severity 2
                    continue
                }
                catch
                {
                    & $Script:CommandTable.'Write-Error' -ErrorRecord $_
                }
            }
            catch
            {
                Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Failed to resolve the path for deletion [$Item]."
                continue
            }

            # Delete specified path if it was successfully resolved.
            try
            {
                try
                {
                    if (& $Script:CommandTable.'Test-Path' -LiteralPath $Item -PathType Container)
                    {
                        if (!$Recurse)
                        {
                            Write-ADTLogEntry -Message "Skipping folder [$Item] because the Recurse switch was not specified."
                            continue
                        }
                        Write-ADTLogEntry -Message "Deleting file(s) recursively in path [$Item]..."
                    }
                    else
                    {
                        Write-ADTLogEntry -Message "Deleting file in path [$Item]..."
                    }
                    $null = & $Script:CommandTable.'Remove-Item' -LiteralPath $Item -Recurse:$Recurse -Force
                }
                catch
                {
                    & $Script:CommandTable.'Write-Error' -ErrorRecord $_
                }
            }
            catch
            {
                Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Failed to delete items in path [$Item]."
            }
        }
    }

    end
    {
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}
