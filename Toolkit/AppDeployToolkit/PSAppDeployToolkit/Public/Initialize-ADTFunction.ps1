﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Initialize-ADTFunction
{
    <#
    .SYNOPSIS
        Initializes the ADT function environment.

    .DESCRIPTION
        Initializes the ADT function environment by setting up necessary variables and logging function start details. It ensures that the function always stops on errors and handles verbose logging.

    .PARAMETER Cmdlet
        The cmdlet that is being initialized.

    .PARAMETER SessionState
        The session state of the cmdlet.

    .INPUTS
        None

        This function does not take any piped input.

    .OUTPUTS
        None

        This function does not return any output.

    .EXAMPLE
        Initialize-ADTFunction -Cmdlet $PSCmdlet

        Initializes the ADT function environment for the given cmdlet.

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
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCmdlet]$Cmdlet,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.SessionState]$SessionState
    )

    # Internal worker function to set variables within the caller's scope.
    function Set-CallerVariable
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'This is an internal worker function that requires no end user confirmation.')]
        [CmdletBinding(SupportsShouldProcess = $false)]
        param
        (
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [System.String]$Name,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [System.Object]$Value
        )

        # Directly go up the scope tree if its an in-session function.
        if ($SessionState.Equals($ExecutionContext.SessionState))
        {
            & $Script:CommandTable.'Set-Variable' -Name $Name -Value $Value -Scope 2 -Force -Confirm:$false -WhatIf:$false
        }
        else
        {
            $SessionState.PSVariable.Set($Name, $Value)
        }
    }

    # Ensure this function always stops, no matter what.
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

    # Write debug log messages.
    Write-ADTLogEntry -Message 'Function Start' -Source $Cmdlet.MyInvocation.MyCommand.Name -DebugMessage
    if ($CmdletBoundParameters = $Cmdlet.MyInvocation.BoundParameters | & $Script:CommandTable.'Format-Table' -Property @{ Label = 'Parameter'; Expression = { "[-$($_.Key)]" } }, @{ Label = 'Value'; Expression = { $_.Value }; Alignment = 'Left' }, @{ Label = 'Type'; Expression = { if ($_.Value) { $_.Value.GetType().Name } }; Alignment = 'Left' } -AutoSize -Wrap | & $Script:CommandTable.'Out-String')
    {
        Write-ADTLogEntry -Message "Function invoked with bound parameter(s):`n$CmdletBoundParameters" -Source $Cmdlet.MyInvocation.MyCommand.Name -DebugMessage
    }
    else
    {
        Write-ADTLogEntry -Message 'Function invoked without any bound parameters.' -Source $Cmdlet.MyInvocation.MyCommand.Name -DebugMessage
    }

    # Amend the caller's $ErrorActionPreference to archive off their provided value so we can always stop on a dime.
    # For the caller-provided values, we deliberately use a string value to escape issues when 'Ignore' is passed.
    # https://github.com/PowerShell/PowerShell/issues/1759#issuecomment-442916350
    if ($Cmdlet.MyInvocation.BoundParameters.ContainsKey('ErrorAction'))
    {
        # Caller's value directly against the function.
        Set-CallerVariable -Name OriginalErrorAction -Value $Cmdlet.MyInvocation.BoundParameters.ErrorAction.ToString()
    }
    elseif ($PSBoundParameters.ContainsKey('ErrorAction'))
    {
        # A function's own specified override.
        Set-CallerVariable -Name OriginalErrorAction -Value $PSBoundParameters.ErrorAction.ToString()
    }
    else
    {
        # The module's default ErrorActionPreference.
        Set-CallerVariable -Name OriginalErrorAction -Value $Script:ErrorActionPreference
    }
    Set-CallerVariable -Name ErrorActionPreference -Value $Script:ErrorActionPreference

    # Handle the caller's -Verbose parameter, which doesn't always work between them and the module barrier.
    # https://github.com/PowerShell/PowerShell/issues/4568
    if ($Cmdlet.MyInvocation.BoundParameters.ContainsKey('Verbose'))
    {
        $Cmdlet.SessionState.PSVariable.Set('OriginalVerbosity', $Global:VerbosePreference)
        $Global:VerbosePreference = [System.Management.Automation.ActionPreference]::Continue
    }
}
