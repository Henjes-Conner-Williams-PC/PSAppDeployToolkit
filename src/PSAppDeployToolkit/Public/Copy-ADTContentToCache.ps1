﻿#-----------------------------------------------------------------------------
#
# MARK: Copy-ADTContentToCache
#
#-----------------------------------------------------------------------------

function Copy-ADTContentToCache
{
    <#
    .SYNOPSIS
        Copies the toolkit content to a cache folder on the local machine and sets the $dirFiles and $supportFiles directory to the cache path.

    .DESCRIPTION
        Copies the toolkit content to a cache folder on the local machine and sets the $dirFiles and $supportFiles directory to the cache path.
        This function is useful in environments where an Endpoint Management solution does not provide a managed cache for source files, such as Intune.
        It is important to clean up the cache in the uninstall section for the current version and potentially also in the pre-installation section for previous versions.

    .PARAMETER Path
        The path to the software cache folder.

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        None

        This function does not generate any output.

    .EXAMPLE
        Copy-ADTContentToCache -Path 'C:\Windows\Temp\PSAppDeployToolkit'

        This example copies the toolkit content to the specified cache folder.

    .NOTES
        An active ADT session is required to use this function.

        This can be used in the absence of an Endpoint Management solution that provides a managed cache for source files, e.g. Intune is lacking this functionality whereas ConfigMgr includes this functionality.

        Since this cache folder is effectively unmanaged, it is important to cleanup the cache in the uninstall section for the current version and potentially also in the pre-installation section for previous versions.

        This can be done using [Remove-ADTFile -Path "(Get-ADTConfig).Toolkit.CachePath\$installName" -Recurse -ErrorAction Ignore]

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
        [System.String]$Path = "$((& $Script:CommandTable.'Get-ADTConfig').Toolkit.CachePath)\$((& $Script:CommandTable.'Get-ADTSession').GetPropertyValue('installName'))"
    )

    begin
    {
        try
        {
            $adtSession = & $Script:CommandTable.'Get-ADTSession'
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        & $Script:CommandTable.'Initialize-ADTFunction' -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        # Create the cache folder if it does not exist.
        if (![System.IO.Directory]::Exists($Path))
        {
            & $Script:CommandTable.'Write-ADTLogEntry' -Message "Creating cache folder [$Path]."
            try
            {
                try
                {
                    $null = & $Script:CommandTable.'New-Item' -Path $Path -ItemType Directory
                }
                catch
                {
                    & $Script:CommandTable.'Write-Error' -ErrorRecord $_
                }
            }
            catch
            {
                & $Script:CommandTable.'Invoke-ADTFunctionErrorHandler' -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Failed to create cache folder [$Path]."
                return
            }
        }
        else
        {
            & $Script:CommandTable.'Write-ADTLogEntry' -Message "Cache folder [$Path] already exists."
        }

        # Copy the toolkit content to the cache folder.
        & $Script:CommandTable.'Write-ADTLogEntry' -Message "Copying toolkit content to cache folder [$Path]."
        try
        {
            try
            {
                Copy-File -Path (& $Script:CommandTable.'Join-Path' $adtSession.GetPropertyValue('ScriptDirectory') '*') -Destination $Path -Recurse
                $adtSession.SetPropertyValue('DirFiles', "$Path\Files")
                $adtSession.SetPropertyValue('DirSupportFiles', "$Path\SupportFiles")
            }
            catch
            {
                & $Script:CommandTable.'Write-Error' -ErrorRecord $_
            }
        }
        catch
        {
            & $Script:CommandTable.'Invoke-ADTFunctionErrorHandler' -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Failed to copy toolkit content to cache folder [$Path]."
        }
    }

    end
    {
        & $Script:CommandTable.'Complete-ADTFunction' -Cmdlet $PSCmdlet
    }
}
