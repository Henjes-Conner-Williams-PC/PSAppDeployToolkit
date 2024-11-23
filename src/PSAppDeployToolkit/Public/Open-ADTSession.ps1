﻿#-----------------------------------------------------------------------------
#
# MARK: Open-ADTSession
#
#-----------------------------------------------------------------------------

function Open-ADTSession
{
    <#
    .SYNOPSIS
        Opens a new ADT session.

    .DESCRIPTION
        This function initializes and opens a new ADT session with the specified parameters. It handles the setup of the session environment and processes any callbacks defined for the session. If the session fails to open, it handles the error and closes the session if necessary.

    .PARAMETER SessionState
        Caller's SessionState.

    .PARAMETER DeploymentType
        Specifies the type of deployment: Install, Uninstall, or Repair.

    .PARAMETER DeployMode
        Specifies the deployment mode: Interactive, NonInteractive, or Silent.

    .PARAMETER AllowRebootPassThru
        Allows reboot pass-through.

    .PARAMETER TerminalServerMode
        Enables Terminal Server mode.

    .PARAMETER DisableLogging
        Disables logging for the session.

    .PARAMETER AppVendor
        Specifies the application vendor.

    .PARAMETER AppName
        Specifies the application name.

    .PARAMETER AppVersion
        Specifies the application version.

    .PARAMETER AppArch
        Specifies the application architecture.

    .PARAMETER AppLang
        Specifies the application language.

    .PARAMETER AppRevision
        Specifies the application revision.

    .PARAMETER AppExitCodes
        Specifies the application exit codes.

    .PARAMETER AppRebootCodes
        Specifies the application reboot codes.

    .PARAMETER AppScriptVersion
        Specifies the application script version.

    .PARAMETER AppScriptDate
        Specifies the application script date.

    .PARAMETER AppScriptAuthor
        Specifies the application script author.

    .PARAMETER InstallName
        Specifies the install name.

    .PARAMETER InstallTitle
        Specifies the install title.

    .PARAMETER DeployAppScriptFriendlyName
        Specifies the friendly name of the deploy application script.

    .PARAMETER DeployAppScriptVersion
        Specifies the version of the deploy application script.

    .PARAMETER DeployAppScriptDate
        Specifies the date of the deploy application script.

    .PARAMETER DeployAppScriptParameters
        Specifies the parameters for the deploy application script.

    .PARAMETER ScriptDirectory
        Specifies the base path for Files and SupportFiles.

    .PARAMETER DefaultMsiFile
        Specifies the default MSI file.

    .PARAMETER DefaultMstFile
        Specifies the default MST file.

    .PARAMETER DefaultMspFiles
        Specifies the default MSP files.

    .PARAMETER PassThru
        Passes the session object through the pipeline.

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        ADTSession

        This function returns the session object if -PassThru is specified.

    .EXAMPLE
        Open-ADTSession -SessionState $ExecutionContext.SessionState -DeploymentType "Install" -DeployMode "Interactive"

        Opens a new ADT session with the specified parameters.

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
        [System.Management.Automation.SessionState]$SessionState,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Parameter')]
        [ValidateSet('Install', 'Uninstall', 'Repair')]
        [System.String]$DeploymentType,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Parameter')]
        [ValidateSet('Interactive', 'NonInteractive', 'Silent')]
        [System.String]$DeployMode,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Parameter')]
        [System.Management.Automation.SwitchParameter]$AllowRebootPassThru,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Parameter')]
        [System.Management.Automation.SwitchParameter]$TerminalServerMode,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Parameter')]
        [System.Management.Automation.SwitchParameter]$DisableLogging,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyString()]
        [System.String]$AppVendor,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyString()]
        [System.String]$AppName,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyString()]
        [System.String]$AppVersion,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyString()]
        [System.String]$AppArch,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyString()]
        [System.String]$AppLang,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyString()]
        [System.String]$AppRevision,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [ValidateNotNullOrEmpty()]
        [System.Version]$AppScriptVersion,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [ValidateNotNullOrEmpty()]
        [System.String]$AppScriptDate,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [ValidateNotNullOrEmpty()]
        [System.String]$AppScriptAuthor,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyString()]
        [System.String]$InstallName,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyString()]
        [System.String]$InstallTitle,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [ValidateNotNullOrEmpty()]
        [System.String]$DeployAppScriptFriendlyName,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [ValidateNotNullOrEmpty()]
        [System.Version]$DeployAppScriptVersion,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [ValidateNotNullOrEmpty()]
        [System.String]$DeployAppScriptDate,

        [Parameter(Mandatory = $false, HelpMessage = 'Frontend Variable')]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary]$DeployAppScriptParameters,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Int32[]]$AppExitCodes,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Int32[]]$AppRebootCodes,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$ScriptDirectory,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$DefaultMsiFile,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$DefaultMstFile,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$DefaultMspFiles,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$PassThru
    )

    begin
    {
        # Initialise function.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $adtData = Get-ADTModuleData
        $adtSession = $null
        $errRecord = $null
    }

    process
    {
        # If this function is being called from the console or by AppDeployToolkitMain.ps1, clear all previous sessions and go for full re-initialisation.
        if (($PSBoundParameters.RunspaceOrigin = $MyInvocation.CommandOrigin.Equals([System.Management.Automation.CommandOrigin]::Runspace)) -or (Test-ADTNonNativeCaller))
        {
            $adtData.Sessions.Clear()
        }

        # Commence the opening process.
        try
        {
            try
            {
                # Initialise the module before opening the first session.
                if (($firstSession = !$adtData.Sessions.Count))
                {
                    Initialize-ADTModule
                }
                $adtData.Sessions.Add(($adtSession = [ADTSession]::new($PSBoundParameters)))
                $adtSession.Open()

                # Invoke all callbacks.
                foreach ($callback in $(if ($firstSession) { $adtData.Callbacks.Starting }; $adtData.Callbacks.Opening))
                {
                    & $callback
                }

                # Export the environment table to variables within the caller's scope.
                if ($firstSession)
                {
                    $null = $ExecutionContext.InvokeCommand.InvokeScript($SessionState, { $args[1].GetEnumerator() | . { process { & $args[0] -Name $_.Key -Value $_.Value -Option ReadOnly -Force } } $args[0] }.Ast.GetScriptBlock(), $Script:CommandTable.'New-Variable', $adtData.Environment)
                }
            }
            catch
            {
                & $Script:CommandTable.'Write-Error' -ErrorRecord $_
            }
        }
        catch
        {
            # Cache off the ErrorRecord object.
            $errRecord = $_

            # Only verbosely log error output for unexpected errors.
            if (!$_.FullyQualifiedErrorId.StartsWith('CallerNotLocalAdmin'))
            {
                Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_ -LogMessage "Failure occurred while opening new ADTSession object."
            }
        }
        finally
        {
            # Terminate early if we have an active session that failed to open properly.
            if ($adtSession -and $errRecord)
            {
                Close-ADTSession -ExitCode 60008
            }
        }

        # Return the most recent session if passing through.
        if ($PassThru)
        {
            return $adtSession
        }
    }

    end
    {
        # Finalise function.
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}
