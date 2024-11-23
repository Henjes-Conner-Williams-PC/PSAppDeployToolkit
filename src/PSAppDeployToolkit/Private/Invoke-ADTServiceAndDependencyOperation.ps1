﻿#-----------------------------------------------------------------------------
#
# MARK: Invoke-ADTServiceAndDependencyOperation
#
#-----------------------------------------------------------------------------

function Invoke-ADTServiceAndDependencyOperation
{
    <#

    .SYNOPSIS
    Process Windows service and its dependencies.

    .DESCRIPTION
    Process Windows service and its dependencies.

    .PARAMETER Service
    Specify the name of the service.

    .PARAMETER SkipDependentServices
    Choose to skip checking for dependent services. Default is: $false.

    .PARAMETER PendingStatusWait
    The amount of time to wait for a service to get out of a pending state before continuing. Default is 60 seconds.

    .PARAMETER PassThru
    Return the System.ServiceProcess.ServiceController service object.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.ServiceProcess.ServiceController. Returns the service object.

    .EXAMPLE
    Invoke-ADTServiceAndDependencyOperation -Service wuauserv -Operation Start

    .EXAMPLE
    Invoke-ADTServiceAndDependencyOperation -Service wuauserv -Operation Stop

    .LINK
    https://psappdeploytoolkit.com

    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if (!$_.Name)
                {
                    $PSCmdlet.ThrowTerminatingError((& $Script:CommandTable.'New-ADTValidateScriptErrorRecord' -ParameterName Service -ProvidedValue $_ -ExceptionMessage 'The specified service does not exist.'))
                }
                return !!$_
            })]
        [System.ServiceProcess.ServiceController]$Service,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Start', 'Stop')]
        [System.String]$Operation,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$SkipDependentServices,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.TimeSpan]$PendingStatusWait = [System.TimeSpan]::FromSeconds(60),

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$PassThru
    )

    # Internal worker function.
    function Invoke-DependentServiceOperation
    {
        # Discover all dependent services.
        & $Script:CommandTable.'Write-ADTLogEntry' -Message "Discovering all dependent service(s) for service [$Name] which are not '$($status = if ($Operation -eq 'Start') {'Running'} else {'Stopped'})'."
        if (!($dependentServices = & $Script:CommandTable.'Get-Service' -Name $Service.ServiceName -DependentServices | & { process { if ($_.Status -ne $status) { return $_ } } }))
        {
            & $Script:CommandTable.'Write-ADTLogEntry' -Message "Dependent service(s) were not discovered for service [$Name]."
            return
        }

        # Action each found dependent service.
        foreach ($dependent in $dependentServices)
        {
            & $Script:CommandTable.'Write-ADTLogEntry' -Message "$(('Starting', 'Stopping')[$Operation -eq 'Start']) dependent service [$($dependent.ServiceName)] with display name [$($dependent.DisplayName)] and a status of [$($dependent.Status)]."
            try
            {
                $dependent | & "$($Operation)-Service" -Force -WarningAction Ignore
            }
            catch
            {
                & $Script:CommandTable.'Write-ADTLogEntry' -Message "Failed to $($Operation.ToLower()) dependent service [$($dependent.ServiceName)] with display name [$($dependent.DisplayName)] and a status of [$($dependent.Status)]. Continue..." -Severity 2
            }
        }
    }

    # Wait up to 60 seconds if service is in a pending state.
    if (([System.ServiceProcess.ServiceControllerStatus]$desiredStatus = @{ ContinuePending = 'Running'; PausePending = 'Paused'; StartPending = 'Running'; StopPending = 'Stopped' }[$Service.Status]))
    {
        & $Script:CommandTable.'Write-ADTLogEntry' -Message "Waiting for up to [$($PendingStatusWait.TotalSeconds)] seconds to allow service pending status [$($Service.Status)] to reach desired status [$DesiredStatus]."
        $Service.WaitForStatus($desiredStatus, $PendingStatusWait)
        $Service.Refresh()
    }

    # Discover if the service is currently running.
    & $Script:CommandTable.'Write-ADTLogEntry' -Message "Service [$($Service.ServiceName)] with display name [$($Service.DisplayName)] has a status of [$($Service.Status)]."
    if (($Operation -eq 'Stop') -and ($Service.Status -ne 'Stopped'))
    {
        # Process all dependent services.
        if (!$SkipDependentServices)
        {
            Invoke-DependentServiceOperation
        }

        # Stop the parent service.
        & $Script:CommandTable.'Write-ADTLogEntry' -Message "Stopping parent service [$($Service.ServiceName)] with display name [$($Service.DisplayName)]."
        $Service = $Service | & $Script:CommandTable.'Stop-Service' -PassThru -WarningAction Ignore -Force
    }
    elseif (($Operation -eq 'Start') -and ($Service.Status -ne 'Running'))
    {
        # Start the parent service.
        & $Script:CommandTable.'Write-ADTLogEntry' -Message "Starting parent service [$($Service.ServiceName)] with display name [$($Service.DisplayName)]."
        $Service = $Service | & $Script:CommandTable.'Start-Service' -PassThru -WarningAction Ignore

        # Process all dependent services.
        if (!$SkipDependentServices)
        {
            Invoke-DependentServiceOperation
        }
    }

    # Return the service object if option selected.
    if ($PassThru)
    {
        return $Service
    }
}
