﻿#-----------------------------------------------------------------------------
#
# MARK: Start-ADTMsiProcess
#
#-----------------------------------------------------------------------------

function Start-ADTMsiProcess
{
    <#
    .SYNOPSIS
        Executes msiexec.exe to perform actions such as install, uninstall, patch, repair, or active setup for MSI and MSP files or MSI product codes.

    .DESCRIPTION
        This function utilizes msiexec.exe to handle various operations on MSI and MSP files, as well as MSI product codes.
        The operations include installation, uninstallation, patching, repair, and setting up active configurations.

        If the -Action parameter is set to "Install" and the MSI is already installed, the function will terminate without performing any actions.

        The function automatically sets default switches for msiexec based on preferences defined in the XML configuration file.
        Additionally, it generates a log file name and creates a verbose log for all msiexec operations, ensuring detailed tracking.

        The MSI or MSP file is expected to reside in the "Files" subdirectory of the App Deploy Toolkit, with transform files expected to be in the same directory as the MSI file.

    .PARAMETER Action
        Specifies the action to be performed. Available options: Install, Uninstall, Patch, Repair, ActiveSetup.

    .PARAMETER Path
        The file path to the MSI/MSP or the product code of the installed MSI.

    .PARAMETER Transforms
        The name(s) of the transform file(s) to be applied to the MSI. The transform files should be in the same directory as the MSI file.

    .PARAMETER Patches
        The name(s) of the patch (MSP) file(s) to be applied to the MSI for the "Install" action. The patch files should be in the same directory as the MSI file.

    .PARAMETER Parameters
        Overrides the default parameters specified in the XML configuration file. The install default is: "REBOOT=ReallySuppress /QB!". The uninstall default is: "REBOOT=ReallySuppress /QN".

    .PARAMETER AddParameters
        Adds additional parameters to the default set specified in the XML configuration file. The install default is: "REBOOT=ReallySuppress /QB!". The uninstall default is: "REBOOT=ReallySuppress /QN".

    .PARAMETER SecureParameters
        Hides all parameters passed to the MSI or MSP file from the toolkit log file.

    .PARAMETER LoggingOptions
        Overrides the default logging options specified in the XML configuration file.

    .PARAMETER LogName
        Overrides the default log file name. The default log file name is generated from the MSI file name. If LogName does not end in .log, it will be automatically appended.

        For uninstallations, by default the product code is resolved to the DisplayName and version of the application.

    .PARAMETER WorkingDirectory
        Overrides the working directory. The working directory is set to the location of the MSI file.

    .PARAMETER SkipMSIAlreadyInstalledCheck
        Skips the check to determine if the MSI is already installed on the system. Default is: $false.

    .PARAMETER IncludeUpdatesAndHotfixes
        Include matches against updates and hotfixes in results.

    .PARAMETER NoWait
        Immediately continue after executing the process.

    .PARAMETER PassThru
        Returns ExitCode, STDOut, and STDErr output from the process.

    .PARAMETER IgnoreExitCodes
        List the exit codes to ignore or * to ignore all exit codes.

    .PARAMETER PriorityClass
        Specifies priority class for the process. Options: Idle, Normal, High, AboveNormal, BelowNormal, RealTime. Default: Normal

    .PARAMETER NoExitOnProcessFailure
        Specifies whether the function shouldn't call Close-ADTSession when the process returns an exit code that is considered an error/failure.

    .PARAMETER RepairFromSource
        Specifies whether we should repair from source. Also rewrites local cache. Default: $false

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        PSADT.Types.ProcessResult

        Returns a PSObject with the results of the installation if -PassThru is specified.
        - ExitCode
        - StdOut
        - StdErr

    .EXAMPLE
        Start-ADTMsiProcess -Action 'Install' -Path 'Adobe_FlashPlayer_11.2.202.233_x64_EN.msi'

        Install an MSI.

    .EXAMPLE
        Start-ADTMsiProcess -Action 'Install' -Path 'Adobe_FlashPlayer_11.2.202.233_x64_EN.msi' -Transform 'Adobe_FlashPlayer_11.2.202.233_x64_EN_01.mst' -Parameters '/QN'

        Install an MSI, applying a transform and overriding the default MSI toolkit parameters.

    .EXAMPLE
        [PSObject]$ExecuteMSIResult = Start-ADTMsiProcess -Action 'Install' -Path 'Adobe_FlashPlayer_11.2.202.233_x64_EN.msi' -PassThru

        Install an MSI and stores the result of the execution into a variable by using the -PassThru option.

    .EXAMPLE
        Start-ADTMsiProcess -Action 'Uninstall' -Path '{26923b43-4d38-484f-9b9e-de460746276c}'

        Uninstall an MSI using a product code.

    .EXAMPLE
        Start-ADTMsiProcess -Action 'Patch' -Path 'Adobe_Reader_11.0.3_EN.msp'

        Install an MSP.

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
    [OutputType([System.Int32])]
    param
    (
        [Parameter(Mandatory = $false)]
        [ValidateSet('Install', 'Uninstall', 'Patch', 'Repair', 'ActiveSetup')]
        [System.String]$Action = 'Install',

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Please enter either the path to the MSI/MSP file or the ProductCode')]
        [ValidateScript({
                if (($_ -notmatch (Get-ADTEnvironment).MSIProductCodeRegExPattern) -and (('.msi', '.msp') -notcontains [System.IO.Path]::GetExtension($_)))
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'The specified input either has an invalid file extension or is not an MSI UUID.'))
                }
                return !!$_
            })]
        [Alias('FilePath')]
        [System.String]$Path,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$Transforms,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias('Arguments')]
        [System.String]$Parameters,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$AddParameters,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$SecureParameters,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$Patches,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$LoggingOptions,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$LogName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$WorkingDirectory,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$SkipMSIAlreadyInstalledCheck,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$IncludeUpdatesAndHotfixes,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$NoWait,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$PassThru,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$IgnoreExitCodes,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Idle', 'Normal', 'High', 'AboveNormal', 'BelowNormal', 'RealTime')]
        [System.Diagnostics.ProcessPriorityClass]$PriorityClass = 'Normal',

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$NoExitOnProcessFailure,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$RepairFromSource
    )

    begin
    {
        $adtSession = Initialize-ADTModuleIfUnitialized -Cmdlet $PSCmdlet; $adtConfig = Get-ADTConfig
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            try
            {
                # If the path matches a product code.
                if (($pathIsProductCode = $Path -match (Get-ADTEnvironment).MSIProductCodeRegExPattern))
                {
                    # Resolve the product code to a publisher, application name, and version.
                    Write-ADTLogEntry -Message 'Resolving product code to a publisher, application name, and version.'
                    $productCodeNameVersion = Get-ADTInstalledApplication -ProductCode $Path -IncludeUpdatesAndHotfixes:$IncludeUpdatesAndHotfixes | & $Script:CommandTable.'Select-Object' -Property Publisher, DisplayName, DisplayVersion -First 1 -ErrorAction Ignore

                    # Build the log file name.
                    if (!$LogName)
                    {
                        $LogName = if ($productCodeNameVersion)
                        {
                            if ($productCodeNameVersion.Publisher)
                            {
                                (Remove-ADTInvalidFileNameChars -Name ($productCodeNameVersion.Publisher + '_' + $productCodeNameVersion.DisplayName + '_' + $productCodeNameVersion.DisplayVersion)) -replace ' '
                            }
                            else
                            {
                                (Remove-ADTInvalidFileNameChars -Name ($productCodeNameVersion.DisplayName + '_' + $productCodeNameVersion.DisplayVersion)) -replace ' '
                            }
                        }
                        else
                        {
                            # Out of other options, make the Product Code the name of the log file.
                            $Path
                        }
                    }
                }
                elseif (!$LogName)
                {
                    # Get the log file name without file extension.
                    $LogName = ([System.IO.FileInfo]$Path).BaseName
                }
                else
                {
                    while ('.log', '.txt' -contains [System.IO.Path]::GetExtension($LogName))
                    {
                        $LogName = [System.IO.Path]::GetFileNameWithoutExtension($LogName)
                    }
                }

                # Build the log file path.
                $logPath = if ($adtSession -and $adtConfig.Toolkit.CompressLogs)
                {
                    & $Script:CommandTable.'Join-Path' -Path $adtSession.GetPropertyValue('LogTempFolder') -ChildPath $LogName
                }
                else
                {
                    # Create the Log directory if it doesn't already exist.
                    if (![System.IO.Directory]::Exists($adtConfig.MSI.LogPath))
                    {
                        $null = [System.IO.Directory]::CreateDirectory($adtConfig.MSI.LogPath)
                    }

                    # Build the log file path.
                    & $Script:CommandTable.'Join-Path' -Path $adtConfig.MSI.LogPath -ChildPath $LogName
                }

                # Set the installation parameters.
                if ($adtSession -and $adtSession.IsNonInteractive())
                {
                    $msiInstallDefaultParams = $adtConfig.MSI.SilentParams
                    $msiUninstallDefaultParams = $adtConfig.MSI.SilentParams
                }
                else
                {
                    $msiInstallDefaultParams = $adtConfig.MSI.InstallParams
                    $msiUninstallDefaultParams = $adtConfig.MSI.UninstallParams
                }

                # Build the MSI parameters.
                switch ($action)
                {
                    'Install'
                    {
                        $option = '/i'
                        $msiLogFile = "$logPath" + '_Install'
                        $msiDefaultParams = $msiInstallDefaultParams
                    }
                    'Uninstall'
                    {
                        $option = '/x'
                        $msiLogFile = "$logPath" + '_Uninstall'
                        $msiDefaultParams = $msiUninstallDefaultParams
                    }
                    'Patch'
                    {
                        $option = '/update'
                        $msiLogFile = "$logPath" + '_Patch'
                        $msiDefaultParams = $msiInstallDefaultParams
                    }
                    'Repair'
                    {
                        $option = "/f$(if ($RepairFromSource) {'vomus'})"
                        $msiLogFile = "$logPath" + '_Repair'
                        $msiDefaultParams = $msiInstallDefaultParams
                    }
                    'ActiveSetup'
                    {
                        $option = '/fups'
                        $msiLogFile = "$logPath" + '_ActiveSetup'
                        $msiDefaultParams = $null
                    }
                }

                # Append the username to the log file name if the toolkit is not running as an administrator, since users do not have the rights to modify files in the ProgramData folder that belong to other users.
                if (!(Test-ADTCallerIsAdmin))
                {
                    $msiLogFile = $msiLogFile + '_' + (Remove-ADTInvalidFileNameChars -Name ([System.Environment]::UserName))
                }

                # Append ".log" to the MSI logfile path and enclose in quotes.
                if ([IO.Path]::GetExtension($msiLogFile) -ne '.log')
                {
                    $msiLogFile = "`"$($msiLogFile + '.log')`""
                }

                # If the MSI is in the Files directory, set the full path to the MSI.
                $msiFile = if ($adtSession -and [System.IO.File]::Exists(($dirFilesPath = [System.IO.Path]::Combine($adtSession.GetPropertyValue('DirFiles'), $Path))))
                {
                    $dirFilesPath
                }
                elseif (& $Script:CommandTable.'Test-Path' -LiteralPath $Path)
                {
                    (& $Script:CommandTable.'Get-Item' -LiteralPath $Path).FullName
                }
                elseif ($pathIsProductCode)
                {
                    $Path
                }
                else
                {
                    Write-ADTLogEntry -Message "Failed to find MSI file [$Path]." -Severity 3
                    $naerParams = @{
                        Exception = [System.IO.FileNotFoundException]::new("Failed to find MSI file [$Path].")
                        Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
                        ErrorId = 'MsiFileNotFound'
                        TargetObject = $Path
                        RecommendedAction = "Please confirm the path of the MSI file and try again."
                    }
                    throw (New-ADTErrorRecord @naerParams)
                }

                # Set the working directory of the MSI.
                if (!$pathIsProductCode -and !$workingDirectory)
                {
                    $WorkingDirectory = [System.IO.Path]::GetDirectoryName($msiFile)
                }

                # Enumerate all transforms specified, qualify the full path if possible and enclose in quotes.
                $mstFile = if ($Transforms)
                {
                    # Fix up any bad file paths.
                    for ($i = 0; $i -lt $Transforms.Length; $i++)
                    {
                        if (($FullPath = & $Script:CommandTable.'Join-Path' -Path (& $Script:CommandTable.'Split-Path' -Path $msiFile -Parent) -ChildPath $Transforms[$i].Replace('.\', '')) -and [System.IO.File]::Exists($FullPath))
                        {
                            $Transforms[$i] = $FullPath
                        }
                    }

                    # Echo an msiexec.exe compatible string back out with all transforms.
                    "`"$($Transforms -join ';')`""
                }

                # Enumerate all patches specified, qualify the full path if possible and enclose in quotes.
                $mspFile = if ($Patches)
                {
                    # Fix up any bad file paths.
                    for ($i = 0; $i -lt $patches.Length; $i++)
                    {
                        if (($FullPath = & $Script:CommandTable.'Join-Path' -Path (& $Script:CommandTable.'Split-Path' -Path $msiFile -Parent) -ChildPath $patches[$i].Replace('.\', '')) -and [System.IO.File]::Exists($FullPath))
                        {
                            $Patches[$i] = $FullPath
                        }
                    }

                    # Echo an msiexec.exe compatible string back out with all patches.
                    "`"$($Patches -join ';')`""
                }

                # Get the ProductCode of the MSI.
                $MSIProductCode = If ($pathIsProductCode)
                {
                    $Path
                }
                elseif ([System.IO.Path]::GetExtension($msiFile) -eq '.msi')
                {
                    try
                    {
                        [Hashtable]$GetMsiTablePropertySplat = @{ Path = $msiFile; Table = 'Property' }
                        if ($Transforms) { $GetMsiTablePropertySplat.Add('TransformPath', $transforms) }
                        Get-ADTMsiTableProperty @GetMsiTablePropertySplat | & $Script:CommandTable.'Select-Object' -ExpandProperty ProductCode -ErrorAction Stop
                    }
                    catch
                    {
                        Write-ADTLogEntry -Message "Failed to get the ProductCode from the MSI file. Continue with requested action [$Action]..."
                    }
                }

                # Start building the MsiExec command line starting with the base action and file.
                $argsMSI = "$option `"$msiFile`""

                # Add MST.
                if ($mstFile)
                {
                    $argsMSI = "$argsMSI TRANSFORMS=$mstFile TRANSFORMSSECURE=1"
                }

                # Add MSP.
                if ($mspFile)
                {
                    $argsMSI = "$argsMSI PATCH=$mspFile"
                }

                # Replace default parameters if specified.
                $argsMSI = if ($Parameters)
                {
                    "$argsMSI $Parameters"
                }
                else
                {
                    "$argsMSI $msiDefaultParams"
                }

                # Add reinstallmode and reinstall variable for Patch.
                If ($action -eq 'Patch')
                {
                    $argsMSI = "$argsMSI REINSTALLMODE=ecmus REINSTALL=ALL"
                }

                # Append parameters to default parameters if specified.
                if ($AddParameters)
                {
                    $argsMSI = "$argsMSI $AddParameters"
                }

                # Add custom Logging Options if specified, otherwise, add default Logging Options from Config file.
                $argsMSI = if ($LoggingOptions)
                {
                    "$argsMSI $LoggingOptions $msiLogFile"
                }
                else
                {
                    "$argsMSI $($adtConfig.MSI.LoggingOptions) $msiLogFile"
                }

                # Check if the MSI is already installed. If no valid ProductCode to check or SkipMSIAlreadyInstalledCheck supplied, then continue with requested MSI action.
                $IsMsiInstalled = if ($MSIProductCode -and !$SkipMSIAlreadyInstalledCheck)
                {
                    !!(Get-ADTInstalledApplication -ProductCode $MSIProductCode -IncludeUpdatesAndHotfixes:$IncludeUpdatesAndHotfixes)
                }
                else
                {
                    $Action -ne 'Install'
                }

                # Bypass if we're installing and the MSI is already installed, otherwise proceed.
                $ExecuteResults = if ($IsMsiInstalled -and ($Action -eq 'Install'))
                {
                    Write-ADTLogEntry -Message "The MSI is already installed on this system. Skipping action [$Action]..."
                    [PSADT.Types.ProcessResult]@{ ExitCode = 1638; StdOut = [System.String]::Empty; StdErr = [System.String]::Empty }
                }
                elseif ((!$IsMsiInstalled -and ($Action -eq 'Install')) -or $IsMsiInstalled)
                {
                    # Build the hashtable with the options that will be passed to Start-ADTProcess using splatting.
                    Write-ADTLogEntry -Message "Executing MSI action [$Action]..."
                    $ExecuteProcessSplat = @{
                        Path = "$([System.Environment]::SystemDirectory)\msiexec.exe"
                        Parameters = $argsMSI
                        WindowStyle = 'Normal'
                        NoExitOnProcessFailure = $NoExitOnProcessFailure
                    }
                    if ($WorkingDirectory)
                    {
                        $ExecuteProcessSplat.Add('WorkingDirectory', $WorkingDirectory)
                    }
                    if ($SecureParameters)
                    {
                        $ExecuteProcessSplat.Add('SecureParameters', $SecureParameters)
                    }
                    if ($PassThru)
                    {
                        $ExecuteProcessSplat.Add('PassThru', $PassThru)
                    }
                    if ($IgnoreExitCodes)
                    {
                        $ExecuteProcessSplat.Add('IgnoreExitCodes', $IgnoreExitCodes)
                    }
                    if ($PriorityClass)
                    {
                        $ExecuteProcessSplat.Add('PriorityClass', $PriorityClass)
                    }
                    if ($NoWait)
                    {
                        $ExecuteProcessSplat.Add('NoWait', $NoWait)
                    }

                    # Call the Start-ADTProcess function.
                    Start-ADTProcess @ExecuteProcessSplat

                    # Refresh environment variables for Windows Explorer process as Windows does not consistently update environment variables created by MSIs.
                    Update-ADTDesktop
                }
                else
                {
                    Write-ADTLogEntry -Message "The MSI is not installed on this system. Skipping action [$Action]..."
                }

                # Return the results if passing through.
                if ($PassThru -and $ExecuteResults)
                {
                    return $ExecuteResults
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
