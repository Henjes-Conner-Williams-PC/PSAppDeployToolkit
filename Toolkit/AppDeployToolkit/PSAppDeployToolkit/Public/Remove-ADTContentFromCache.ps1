﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Remove-ADTContentFromCache
{
    <#

    .SYNOPSIS
    Removes the toolkit content from the cache folder on the local machine and reverts the $dirFiles and $supportFiles directory

    .DESCRIPTION
    Removes the toolkit content from the cache folder on the local machine and reverts the $dirFiles and $supportFiles directory

    .PARAMETER Path
    The path to the software cache folder.

    .EXAMPLE
    Remove-ADTContentFromCache -Path 'C:\Windows\Temp\PSAppDeployToolkit'

    .LINK
    https://psappdeploytoolkit.com

    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$Path = "$((Get-ADTConfig).Toolkit.CachePath)\$((Get-ADTSession).GetPropertyValue('installName'))"
    )

    begin
    {
        try
        {
            $adtSession = Get-ADTSession
            $parentPath = $adtSession.GetPropertyValue('scriptParentPath')
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        if (![System.IO.Directory]::Exists($Path))
        {
            Write-ADTLogEntry -Message "Cache folder [$Path] does not exist."
            return
        }

        Write-ADTLogEntry -Message "Removing cache folder [$Path]."
        try
        {
            try
            {
                & $Script:CommandTable.'Remove-Item' -Path $Path -Recurse
                $adtSession.SetPropertyValue('DirFiles', (& $Script:CommandTable.'Join-Path' -Path $parentPath -ChildPath Files))
                $adtSession.SetPropertyValue('DirSupportFiles', (& $Script:CommandTable.'Join-Path' -Path $parentPath -ChildPath SupportFiles))
            }
            catch
            {
                & $Script:CommandTable.'Write-Error' -ErrorRecord $_
            }
        }
        catch
        {
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Failed to remove cache folder [$Path]."
        }
    }

    end
    {
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}