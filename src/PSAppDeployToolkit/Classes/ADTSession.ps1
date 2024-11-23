﻿#-----------------------------------------------------------------------------
#
# MARK: ADTSession
#
#-----------------------------------------------------------------------------

class ADTSession
{
    # Private variables for modules to use that aren't for public access.
    hidden [AllowEmptyCollection()][System.Collections.Hashtable]$ExtensionData = @{}

    # Internal variables that aren't for public access.
    hidden [ValidateNotNullOrEmpty()][System.Boolean]$CompatibilityMode = (Test-ADTNonNativeCaller)
    hidden [ValidateNotNullOrEmpty()][System.Management.Automation.PSVariableIntrinsics]$CallerVariables
    hidden [AllowEmptyCollection()][System.Collections.Generic.List[System.IO.FileInfo]]$MountedWimFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
    hidden [ValidateNotNullOrEmpty()][PSADT.Types.ProcessObject[]]$DefaultMsiExecutablesList
    hidden [ValidateNotNullOrEmpty()][System.Boolean]$ZeroConfigInitiated
    hidden [ValidateNotNullOrEmpty()][System.Boolean]$RunspaceOrigin
    hidden [ValidateNotNullOrEmpty()][System.String]$RegKeyDeferHistory
    hidden [ValidateNotNullOrEmpty()][System.String]$DeploymentTypeName
    hidden [ValidateNotNullOrEmpty()][System.Boolean]$DeployModeNonInteractive
    hidden [ValidateNotNullOrEmpty()][System.Boolean]$DeployModeSilent
    hidden [ValidateNotNullOrEmpty()][System.Boolean]$Instantiated
    hidden [ValidateNotNullOrEmpty()][System.Boolean]$Opened
    hidden [ValidateNotNullOrEmpty()][System.Boolean]$Closed
    hidden [ValidateNotNullOrEmpty()][System.String]$LogPath
    hidden [ValidateNotNullOrEmpty()][System.Int32]$ExitCode

    # Deploy-Application.ps1 parameters.
    [ValidateSet('Install', 'Uninstall', 'Repair')][System.String]$DeploymentType = 'Install'
    [ValidateSet('Interactive', 'NonInteractive', 'Silent')][System.String]$DeployMode = 'Interactive'
    [ValidateNotNullOrEmpty()][System.Boolean]$AllowRebootPassThru
    [ValidateNotNullOrEmpty()][System.Boolean]$TerminalServerMode
    [ValidateNotNullOrEmpty()][System.Boolean]$DisableLogging

    # Deploy-Application.ps1 variables.
    [AllowEmptyString()][System.String]$AppVendor
    [AllowEmptyString()][System.String]$AppName
    [AllowEmptyString()][System.String]$AppVersion
    [AllowEmptyString()][System.String]$AppArch
    [AllowEmptyString()][System.String]$AppLang
    [AllowEmptyString()][System.String]$AppRevision
    [ValidateNotNullOrEmpty()][System.Int32[]]$AppExitCodes = 0
    [ValidateNotNullOrEmpty()][System.Int32[]]$AppRebootCodes = 1641, 3010
    [ValidateNotNullOrEmpty()][System.Version]$AppScriptVersion
    [ValidateNotNullOrEmpty()][System.String]$AppScriptDate
    [ValidateNotNullOrEmpty()][System.String]$AppScriptAuthor
    [ValidateNotNullOrEmpty()][System.String]$InstallName
    [ValidateNotNullOrEmpty()][System.String]$InstallTitle
    [ValidateNotNullOrEmpty()][System.String]$DeployAppScriptFriendlyName
    [ValidateNotNullOrEmpty()][System.Version]$DeployAppScriptVersion
    [ValidateNotNullOrEmpty()][System.String]$DeployAppScriptDate
    [AllowEmptyCollection()][System.Collections.IDictionary]$DeployAppScriptParameters
    [ValidateNotNullOrEmpty()][System.String]$InstallPhase = 'Initialization'

    # Calculated variables we publicise.
    [ValidateNotNullOrEmpty()][System.DateTime]$CurrentDateTime = [System.DateTime]::Now
    [ValidateNotNullOrEmpty()][System.String]$CurrentTime
    [ValidateNotNullOrEmpty()][System.String]$CurrentDate
    [ValidateNotNullOrEmpty()][System.TimeSpan]$CurrentTimeZoneBias
    [ValidateNotNullOrEmpty()][System.String]$ScriptDirectory
    [ValidateNotNullOrEmpty()][System.String]$DirFiles
    [ValidateNotNullOrEmpty()][System.String]$DirSupportFiles
    [ValidateNotNullOrEmpty()][System.String]$DefaultMsiFile
    [ValidateNotNullOrEmpty()][System.String]$DefaultMstFile
    [ValidateNotNullOrEmpty()][System.String[]]$DefaultMspFiles
    [ValidateNotNullOrEmpty()][System.Boolean]$UseDefaultMsi
    [ValidateNotNullOrEmpty()][System.String]$LogTempFolder
    [ValidateNotNullOrEmpty()][System.String]$LogName

    # Constructors.
    ADTSession([System.Management.Automation.SessionState]$SessionState)
    {
        $this.Init(@{ SessionState = $SessionState })
    }
    ADTSession([System.Collections.Generic.Dictionary[System.String, System.Object]]$Parameters)
    {
        $this.Init($Parameters)
    }

    # Private methods.
    hidden [System.Void] Init([System.Collections.IDictionary]$Parameters)
    {
        # Get the current environment.
        $adtEnv = Get-ADTEnvironment

        # Ensure this session isn't being re-instantiated.
        if ($this.Instantiated)
        {
            $naerParams = @{
                Exception = [System.InvalidOperationException]::new("The current $($adtEnv.appDeployToolkitName) session has already been instantiated.")
                Category = [System.Management.Automation.ErrorCategory]::InvalidOperation
                ErrorId = 'ADTSessionAlreadyInstantiated'
                TargetObject = $this
                TargetName = '[ADTSession]'
                TargetType = 'Init()'
                RecommendedAction = "Please review your setup to ensure this ADTSession object isn't being instantiated twice."
            }
            throw (New-ADTErrorRecord @naerParams)
        }

        # Confirm the main system automation params are present.
        foreach ($param in ('SessionState' | & { process { if (!$Parameters.ContainsKey($_)) { return $_ } } }))
        {
            $naerParams = @{
                Exception = [System.ArgumentException]::new('One or more mandatory parameters are missing.', $param)
                Category = [System.Management.Automation.ErrorCategory]::InvalidArgument
                ErrorId = 'MandatoryParameterMissing'
                TargetObject = $Parameters
                TargetName = '[ADTSession]'
                TargetType = 'Init()'
                RecommendedAction = "Please review the supplied parameters to this object's constructor and try again."
            }
            throw (New-ADTErrorRecord @naerParams)
        }

        # Confirm the main system automation params aren't null.
        foreach ($param in ('SessionState' | & { process { if (!$Parameters.$_) { return $_ } } }))
        {
            $naerParams = @{
                Exception = [System.ArgumentNullException]::new($param, 'One or more mandatory parameters are null.')
                Category = [System.Management.Automation.ErrorCategory]::InvalidData
                ErrorId = 'MandatoryParameterNullOrEmpty'
                TargetObject = $Parameters
                TargetName = '[ADTSession]'
                TargetType = 'Init()'
                RecommendedAction = "Please review the supplied parameters to this object's constructor and try again."
            }
            throw (New-ADTErrorRecord @naerParams)
        }

        # Establish start date/time first so we can accurately mark the start of execution.
        $this.CurrentTime = & $Script:CommandTable.'Get-Date' -Date $this.CurrentDateTime -UFormat '%T'
        $this.CurrentDate = & $Script:CommandTable.'Get-Date' -Date $this.CurrentDateTime -UFormat '%d-%m-%Y'
        $this.CurrentTimeZoneBias = [System.TimeZone]::CurrentTimeZone.GetUtcOffset($this.CurrentDateTime)

        # Process provided parameters and amend some incoming values.
        $Properties = (& $Script:CommandTable.'Get-Member' -InputObject $this -MemberType Property -Force).Name
        $Parameters.GetEnumerator() | & { process { if ($Properties.Contains($_.Key) -and ![System.String]::IsNullOrWhiteSpace((& $Script:CommandTable.'Out-String' -InputObject $_.Value))) { $this.($_.Key) = $_.Value } } }
        $this.DeploymentType = $adtEnv.culture.TextInfo.ToTitleCase($this.DeploymentType.ToLower())
        $this.CallerVariables = $Parameters.SessionState.PSVariable

        # Establish script directories before returning.
        $this.ScriptDirectory = if (![System.String]::IsNullOrWhiteSpace(($rootLocation = $this.CallerVariables.GetValue('PSScriptRoot', $null))))
        {
            if ($this.CompatibilityMode)
            {
                [System.IO.Directory]::GetParent($rootLocation).FullName
            }
            else
            {
                $rootLocation
            }
        }
        else
        {
            $PWD.Path
        }
        'DirFiles', 'DirSupportFiles' | & { process { if ([System.String]::IsNullOrWhiteSpace($this.$_)) { $this.$_ = "$($this.ScriptDirectory)\$($_ -replace '^Dir')" } } }
        $this.Instantiated = $true
    }

    hidden [System.Void] WriteZeroConfigDivider()
    {
        # Print an extra divider when we process a Zero-Config setup before the main logging starts.
        if (!$this.ZeroConfigInitiated)
        {
            $this.WriteLogDivider(2)
            $this.ZeroConfigInitiated = $true
        }
    }

    hidden [System.Void] DetectDefaultWimFile()
    {
        # If the default Deploy-Application.ps1 hasn't been modified, and there's not already a mounted WIM file, check for WIM files and modify the install accordingly.
        if (![System.String]::IsNullOrWhiteSpace($this.AppName))
        {
            return
        }

        # If there's already a mounted WIM file, return early.
        if ($this.MountedWimFiles.Count)
        {
            return
        }

        # Find the first WIM file in the Files folder and use that as our install.
        if (!($wimFile = & $Script:CommandTable.'Get-ChildItem' -Path "$($this.DirFiles)\*.wim" -ErrorAction Ignore | & $Script:CommandTable.'Select-Object' -ExpandProperty FullName -First 1))
        {
            return
        }

        # Mount the WIM file and reset DirFiles to the mount point.
        $this.WriteZeroConfigDivider()
        $this.WriteLogEntry("Discovered Zero-Config WIM file [$wimFile].")
        Mount-ADTWimFile -ImagePath $wimFile -Path ($this.DirFiles = [System.IO.Path]::Combine($this.DirFiles, [System.IO.Path]::GetRandomFileName())) -Index 1 -InformationAction Ignore
        $this.WriteLogEntry("Successfully mounted WIM file to [$($this.DirFiles)].")
        $this.WriteLogEntry("Using [$($this.DirFiles)] as the base DirFiles directory.")
    }

    hidden [System.Void] DetectDefaultMsi([System.Collections.Specialized.OrderedDictionary]$ADTEnv)
    {
        # If the default Deploy-Application.ps1 hasn't been modified, check for MSI / MST and modify the install accordingly.
        if (![System.String]::IsNullOrWhiteSpace($this.AppName))
        {
            return
        }

        # Find the first MSI file in the Files folder and use that as our install.
        if ([System.String]::IsNullOrWhiteSpace($this.DefaultMsiFile))
        {
            # Get all MSI files and return early if we haven't found anything.
            if (($msiFile = ($msiFiles = & $Script:CommandTable.'Get-ChildItem' -Path "$($this.DirFiles)\*.msi" -ErrorAction Ignore) | & { process { if ($_.Name.EndsWith(".$($ADTEnv.envOSArchitecture).msi")) { return $_ } } } | & $Script:CommandTable.'Select-Object' -ExpandProperty FullName -First 1))
            {
                $this.WriteZeroConfigDivider()
                $this.WriteLogEntry("Discovered $($ADTEnv.envOSArchitecture) Zero-Config MSI under $(($this.DefaultMsiFile = $msiFile))")
            }
            elseif (($msiFile = $msiFiles | & $Script:CommandTable.'Select-Object' -ExpandProperty FullName -First 1))
            {
                $this.WriteZeroConfigDivider()
                $this.WriteLogEntry("Discovered Arch-Independent Zero-Config MSI under $(($this.DefaultMsiFile = $msiFile))")
            }
            else
            {
                return
            }
        }
        else
        {
            $this.WriteZeroConfigDivider()
            $this.WriteLogEntry("Discovered Zero-Config MSI installation file [$($this.DefaultMsiFile)].")
        }

        # Discover if there is a zero-config MST file.
        if ([System.String]::IsNullOrWhiteSpace($this.DefaultMstFile))
        {
            if ([System.IO.File]::Exists(($mstFile = [System.IO.Path]::ChangeExtension($this.DefaultMsiFile, 'mst'))))
            {
                $this.DefaultMstFile = $mstFile
            }
        }
        if (![System.String]::IsNullOrWhiteSpace($this.DefaultMstFile))
        {
            $this.WriteLogEntry("Discovered Zero-Config MST installation file [$($this.DefaultMstFile)].")
        }

        # Discover if there are zero-config MSP files. Name multiple MSP files in alphabetical order to control order in which they are installed.
        if (!$this.DefaultMspFiles)
        {
            if (($mspFiles = & $Script:CommandTable.'Get-ChildItem' -Path "$($this.DirFiles)\*.msp" | & $Script:CommandTable.'Select-Object' -ExpandProperty FullName))
            {
                $this.DefaultMspFiles = $mspFiles
            }
        }
        if ($this.DefaultMspFiles)
        {
            $this.WriteLogEntry("Discovered Zero-Config MSP installation file(s) [$($this.DefaultMspFiles -join ',')].")
        }

        # Read the MSI and get the installation details.
        $gmtpParams = @{ Path = $this.DefaultMsiFile }; if ($this.DefaultMstFile) { $gmtpParams.Add('TransformPath', $this.DefaultMstFile) }
        $msiProps = Get-ADTMsiTableProperty @gmtpParams -Table File 6>$null

        # Generate list of MSI executables for testing later on.
        if (($msiProcs = $msiProps | & $Script:CommandTable.'Get-Member' -MemberType NoteProperty | & { process { if ([System.IO.Path]::GetExtension($_.Name) -eq '.exe') { @{ Name = [System.IO.Path]::GetFileNameWithoutExtension($_.Name) -replace '^_' } } } }))
        {
            $this.WriteLogEntry("MSI Executable List [$(($this.DefaultMsiExecutablesList = $msiProcs).Name)].")
        }

        # Update our app variables with new values.
        $msiProps = Get-ADTMsiTableProperty @gmtpParams -Table Property 6>$null
        $this.WriteLogEntry("App Vendor [$($msiProps.Manufacturer)].")
        $this.WriteLogEntry("App Name [$(($this.AppName = $msiProps.ProductName))].")
        $this.WriteLogEntry("App Version [$(($this.AppVersion = $msiProps.ProductVersion))].")
        $this.UseDefaultMsi = $true
    }

    hidden [System.Void] SetAppProperties([System.Collections.Specialized.OrderedDictionary]$ADTEnv)
    {
        # Set up sample variables if Dot Sourcing the script, app details have not been specified
        if ([System.String]::IsNullOrWhiteSpace($this.AppName))
        {
            $this.AppName = $ADTEnv.appDeployToolkitName

            if (![System.String]::IsNullOrWhiteSpace($this.AppVendor))
            {
                $this.AppVendor = [System.String]::Empty
            }
            if ([System.String]::IsNullOrWhiteSpace($this.AppVersion))
            {
                $this.AppVersion = $ADTEnv.appDeployMainScriptVersion.ToString()
            }
            if ([System.String]::IsNullOrWhiteSpace($this.AppLang))
            {
                $this.AppLang = $ADTEnv.currentLanguage
            }
            if ([System.String]::IsNullOrWhiteSpace($this.AppRevision))
            {
                $this.AppRevision = '01'
            }
        }

        # Sanitize the application details, as they can cause issues in the script.
        $this.AppVendor = Remove-ADTInvalidFileNameChars -Name $this.AppVendor
        $this.AppName = Remove-ADTInvalidFileNameChars -Name $this.AppName
        $this.AppVersion = Remove-ADTInvalidFileNameChars -Name $this.AppVersion
        $this.AppArch = Remove-ADTInvalidFileNameChars -Name $this.AppArch
        $this.AppLang = Remove-ADTInvalidFileNameChars -Name $this.AppLang
        $this.AppRevision = Remove-ADTInvalidFileNameChars -Name $this.AppRevision
    }

    hidden [System.Void] SetInstallProperties([System.Collections.Specialized.OrderedDictionary]$ADTEnv, [System.Collections.Hashtable]$ADTConfig)
    {
        # Build the Installation Title.
        if ([System.String]::IsNullOrWhiteSpace($this.InstallTitle))
        {
            $this.InstallTitle = "$($this.AppVendor) $($this.AppName) $($this.AppVersion)".Trim() -replace '\s{2,}', ' '
        }

        # Build the Installation Name.
        if ([System.String]::IsNullOrWhiteSpace($this.InstallName))
        {
            $this.InstallName = "$($this.AppVendor)_$($this.AppName)_$($this.AppVersion)_$($this.AppArch)_$($this.AppLang)_$($this.AppRevision)"
        }
        $this.InstallName = ($this.InstallName -replace '\s').Trim('_') -replace '[_]+', '_'

        # Set the Defer History registry path.
        $this.RegKeyDeferHistory = "$($ADTConfig.Toolkit.RegPath)\$($ADTEnv.appDeployToolkitName)\DeferHistory\$($this.InstallName)"
    }

    hidden [System.Void] WriteLogDivider([System.UInt32]$Count)
    {
        # Write divider as requested.
        $this.WriteLogEntry((1..$Count | & { process { '*' * 79 } }))
    }

    hidden [System.Void] WriteLogDivider()
    {
        # Write divider as requested.
        $this.WriteLogDivider(1)
    }

    hidden [System.Void] InitLogging([System.Collections.Specialized.OrderedDictionary]$ADTEnv, [System.Collections.Hashtable]$ADTConfig)
    {
        # Generate log paths from our installation properties.
        $this.LogTempFolder = & $Script:CommandTable.'Join-Path' -Path $ADTEnv.envTemp -ChildPath "$($this.InstallName)_$($this.DeploymentType)"
        if ($ADTConfig.Toolkit.CompressLogs)
        {
            # If the temp log folder already exists from a previous ZIP operation, then delete all files in it to avoid issues.
            if ([System.IO.Directory]::Exists($this.LogTempFolder))
            {
                [System.IO.Directory]::Remove($this.LogTempFolder, $true)
            }
            $this.LogPath = [System.IO.Directory]::CreateDirectory($this.LogTempFolder).FullName
        }
        else
        {
            $this.LogPath = [System.IO.Directory]::CreateDirectory($ADTConfig.Toolkit.LogPath).FullName
        }

        # Generate the log filename to use. Append the username to the log file name if the toolkit is not running as an administrator, since users do not have the rights to modify files in the ProgramData folder that belong to other users.
        $this.LogName = if ($ADTEnv.IsAdmin)
        {
            "$($this.InstallName)_$($ADTEnv.appDeployToolkitName)_$($this.DeploymentType).log"
        }
        else
        {
            "$($this.InstallName)_$($ADTEnv.appDeployToolkitName)_$($this.DeploymentType)_$(Remove-ADTInvalidFileNameChars -Name $ADTEnv.envUserName).log"
        }
        $logFile = [System.IO.Path]::Combine($this.LogPath, $this.LogName)

        # Check if log file needs to be rotated.
        if ([System.IO.File]::Exists($logFile) -and !$ADTConfig.Toolkit.LogAppend)
        {
            $logFileInfo = [System.IO.FileInfo]$logFile
            $logFileSizeMB = $logFileInfo.Length / 1MB

            # Rotate if we've exceeded the size already.
            if (($ADTConfig.Toolkit.LogMaxSize -gt 0) -and ($logFileSizeMB -gt $ADTConfig.Toolkit.LogMaxSize))
            {
                try
                {
                    # Get new log file path.
                    $logFileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($logFile)
                    $logFileExtension = [System.IO.Path]::GetExtension($logFile)
                    $Timestamp = $logFileInfo.LastWriteTime.ToString('yyyy-MM-dd-HH-mm-ss')
                    $ArchiveLogFileName = "{0}_{1}{2}" -f $logFileNameWithoutExtension, $Timestamp, $logFileExtension
                    [String]$ArchiveLogFilePath = & $Script:CommandTable.'Join-Path' -Path $this.LogPath -ChildPath $ArchiveLogFileName

                    # Log message about archiving the log file.
                    $this.WriteLogEntry("Maximum log file size [$($ADTConfig.Toolkit.LogMaxSize) MB] reached. Rename log file to [$ArchiveLogFileName].", 2)

                    # Rename the file
                    & $Script:CommandTable.'Move-Item' -LiteralPath $logFileInfo.FullName -Destination $ArchiveLogFilePath -Force

                    # Start new log file and log message about archiving the old log file.
                    $this.WriteLogEntry("Previous log file was renamed to [$ArchiveLogFileName] because maximum log file size of [$($ADTConfig.Toolkit.LogMaxSize) MB] was reached.", 2)

                    # Get all log files (including any .lo_ files that may have been created by previous toolkit versions) sorted by last write time
                    $logFiles = $(& $Script:CommandTable.'Get-ChildItem' -LiteralPath $this.LogPath -Filter ("{0}_*{1}" -f $logFileNameWithoutExtension, $logFileExtension); & $Script:CommandTable.'Get-Item' -LiteralPath ([IO.Path]::ChangeExtension($logFile, 'lo_')) -ErrorAction Ignore) | & $Script:CommandTable.'Sort-Object' -Property LastWriteTime

                    # Keep only the max number of log files
                    if ($logFiles.Count -gt $ADTConfig.Toolkit.LogMaxHistory)
                    {
                        $logFiles | & $Script:CommandTable.'Select-Object' -First ($logFiles.Count - $ADTConfig.Toolkit.LogMaxHistory) | & $Script:CommandTable.'Remove-Item'
                    }
                }
                catch
                {
                    $this.WriteLogEntry("Failed to rotate the log file [$($logFile)].`n$(Resolve-ADTErrorRecord -ErrorRecord $_)", 3)
                }
            }
        }

        # Open log file with commencement message.
        $this.WriteLogDivider(2)
        $this.WriteLogEntry("[$($this.InstallName)] setup started.")
    }

    hidden [System.Void] LogScriptInfo([System.Management.Automation.PSObject]$ADTData, [System.Collections.Specialized.OrderedDictionary]$ADTEnv)
    {
        # Announce provided deployment script info.
        if ($this.AppScriptVersion)
        {
            $this.WriteLogEntry("[$($this.InstallName)] script version is [$($this.AppScriptVersion)]")
        }
        if ($this.AppScriptDate)
        {
            $this.WriteLogEntry("[$($this.InstallName)] script date is [$($this.AppScriptDate)]")
        }
        if ($this.AppScriptAuthor)
        {
            $this.WriteLogEntry("[$($this.InstallName)] script author is [$($this.AppScriptAuthor)]")
        }
        if ($this.DeployAppScriptFriendlyName -and $this.DeployAppScriptVersion)
        {
            $this.WriteLogEntry("[$($this.DeployAppScriptFriendlyName)] script version is [$($this.DeployAppScriptVersion)]")
        }
        if ($this.DeployAppScriptParameters -and $this.DeployAppScriptParameters.Count)
        {
            $this.WriteLogEntry("The following parameters were passed to [$($this.DeployAppScriptFriendlyName)]: [$($this.DeployAppScriptParameters | Resolve-ADTBoundParameters)]")
        }
        $this.WriteLogEntry("[$($ADTEnv.appDeployToolkitName)] module version is [$($ADTEnv.appDeployMainScriptVersion)]")
        $this.WriteLogEntry("[$($ADTEnv.appDeployToolkitName)] module imported in [$($ADTData.Durations.ModuleImport.TotalSeconds)] seconds.")
        $this.WriteLogEntry("[$($ADTEnv.appDeployToolkitName)] module initialised in [$($ADTData.Durations.ModuleInit.TotalSeconds)] seconds.")

        # Announce session instantiation mode.
        if ($this.CompatibilityMode)
        {
            $this.WriteLogEntry("[$($ADTEnv.appDeployToolkitName)] session mode is [Compatibility]. This mode is for the transition of v3.x scripts and is not for new development.", 2)
            $this.WriteLogEntry("Information on how to migrate this script to Native mode is available at [https://psappdeploytoolkit.com/].", 2)
            return
        }
        $this.WriteLogEntry("[$($ADTEnv.appDeployToolkitName)] session mode is [Native].")
    }

    hidden [System.Void] LogSystemInfo([System.Collections.Specialized.OrderedDictionary]$ADTEnv)
    {
        # Report on all determined system info.
        $this.WriteLogEntry("Computer Name is [$($ADTEnv.envComputerNameFQDN)]")
        $this.WriteLogEntry("Current User is [$($ADTEnv.ProcessNTAccount)]")
        $this.WriteLogEntry("OS Version is [$($ADTEnv.envOSName)$(if ($ADTEnv.envOSServicePack) {" $($ADTEnv.envOSServicePack)"}) $($ADTEnv.envOSArchitecture) $($ADTEnv.envOSVersion)]")
        $this.WriteLogEntry("OS Type is [$($ADTEnv.envOSProductTypeName)]")
        $this.WriteLogEntry("Current Culture is [$($ADTEnv.culture.Name)], language is [$($ADTEnv.currentLanguage)] and UI language is [$($ADTEnv.currentUILanguage)]")
        $this.WriteLogEntry("Hardware Platform is [$($ADTEnv.envHardwareType)]")
        $this.WriteLogEntry("PowerShell Host is [$($ADTEnv.envHost.Name)] with version [$($ADTEnv.envHost.Version)]")
        $this.WriteLogEntry("PowerShell Version is [$($ADTEnv.envPSVersion) $($ADTEnv.psArchitecture)]")
        if ($ADTEnv.envCLRVersion)
        {
            $this.WriteLogEntry("PowerShell CLR (.NET) version is [$($ADTEnv.envCLRVersion)]")
        }
    }

    hidden [System.Void] LogUserInfo([System.Management.Automation.PSObject]$ADTData, [System.Collections.Specialized.OrderedDictionary]$ADTEnv, [System.Collections.Hashtable]$ADTConfig)
    {
        # Log details for all currently logged in users.
        $this.WriteLogEntry("Display session information for all logged on users:`n$($ADTEnv.LoggedOnUserSessions | & $Script:CommandTable.'Format-List' | & $Script:CommandTable.'Out-String')", $true)

        # Provide detailed info about current process state.
        if ($ADTEnv.usersLoggedOn)
        {
            $this.WriteLogEntry("The following users are logged on to the system: [$($ADTEnv.usersLoggedOn -join ', ')].")

            # Check if the current process is running in the context of one of the logged in users
            if ($ADTEnv.CurrentLoggedOnUserSession)
            {
                $this.WriteLogEntry("Current process is running with user account [$($ADTEnv.ProcessNTAccount)] under logged in user session for [$($ADTEnv.CurrentLoggedOnUserSession.NTAccount)].")
            }
            else
            {
                $this.WriteLogEntry("Current process is running under a system account [$($ADTEnv.ProcessNTAccount)].")
            }

            # Guard Intune detection code behind a variable.
            if ($ADTConfig.Toolkit.OobeDetection -and ([System.Environment]::OSVersion.Version -ge '10.0.16299.0') -and ![PSADT.Utilities]::OobeCompleted())
            {
                $this.WriteLogEntry("Detected OOBE in progress, changing deployment mode to silent.")
                $this.DeployMode = 'Silent'
            }

            # Display account and session details for the account running as the console user (user with control of the physical monitor, keyboard, and mouse)
            if ($ADTEnv.CurrentConsoleUserSession)
            {
                $this.WriteLogEntry("The following user is the console user [$($ADTEnv.CurrentConsoleUserSession.NTAccount)] (user with control of physical monitor, keyboard, and mouse).")
            }
            else
            {
                $this.WriteLogEntry('There is no console user logged in (user with control of physical monitor, keyboard, and mouse).')
            }

            # Display the account that will be used to execute commands in the user session when toolkit is running under the SYSTEM account
            if ($ADTEnv.RunAsActiveUser)
            {
                $this.WriteLogEntry("The active logged on user is [$($ADTEnv.RunAsActiveUser.NTAccount)].")
            }
        }
        else
        {
            $this.WriteLogEntry('No users are logged on to the system.')
        }

        # Log which language's UI messages are loaded from the config file
        $this.WriteLogEntry("The current execution context has a primary UI language of [$($ADTEnv.currentLanguage)].")

        # Advise whether the UI language was overridden.
        if ($ADTConfig.UI.LanguageOverride)
        {
            $this.WriteLogEntry("The config file was configured to override the detected primary UI language with the following UI language: [$($ADTConfig.UI.LanguageOverride)].")
        }
        $this.WriteLogEntry("The following UI messages were imported from the config file: [$($ADTData.Language)].")
    }

    hidden [System.Void] PerformSCCMTests([System.Collections.Specialized.OrderedDictionary]$ADTEnv)
    {
        # Check if script is running from a SCCM Task Sequence.
        if ($ADTEnv.RunningTaskSequence)
        {
            $this.WriteLogEntry('Successfully found COM object [Microsoft.SMS.TSEnvironment]. Therefore, script is currently running from a SCCM Task Sequence.')
        }
        else
        {
            $this.WriteLogEntry('Unable to find COM object [Microsoft.SMS.TSEnvironment]. Therefore, script is not currently running from a SCCM Task Sequence.')
        }
    }

    hidden [System.Void] PerformSystemAccountTests([System.Collections.Specialized.OrderedDictionary]$ADTEnv, [System.Collections.Hashtable]$ADTConfig)
    {
        # Return early if we're not in session 0.
        if (!$ADTEnv.SessionZero)
        {
            $this.WriteLogEntry('Session 0 not detected.')
            return
        }

        # If the script was launched with deployment mode set to NonInteractive, then continue
        if ($this.DeployMode -eq 'NonInteractive')
        {
            $this.WriteLogEntry("Session 0 detected but deployment mode was manually set to [$($this.DeployMode)].")
        }
        elseif ($ADTConfig.Toolkit.SessionDetection)
        {
            # If the process is not able to display a UI, enable NonInteractive mode
            if (!$ADTEnv.IsProcessUserInteractive)
            {
                $this.DeployMode = 'NonInteractive'
                $this.WriteLogEntry("Session 0 detected, process not running in user interactive mode; deployment mode set to [$($this.DeployMode)].")
            }
            elseif (!$ADTEnv.usersLoggedOn)
            {
                $this.DeployMode = 'NonInteractive'
                $this.WriteLogEntry("Session 0 detected, process running in user interactive mode, no users logged in; deployment mode set to [$($this.DeployMode)].")
            }
            else
            {
                $this.WriteLogEntry('Session 0 detected, process running in user interactive mode, user(s) logged in.')
            }
        }
        else
        {
            $this.WriteLogEntry("Session 0 detected but toolkit is configured to not adjust deployment mode.")
        }
    }

    hidden [System.Void] SetDeploymentProperties()
    {
        # Set Deploy Mode switches.
        $this.WriteLogEntry("Installation is running in [$($this.DeployMode)] mode.")
        switch ($this.DeployMode)
        {
            Silent
            {
                $this.DeployModeNonInteractive = $true
                $this.DeployModeSilent = $true
                break
            }
            NonInteractive
            {
                $this.DeployModeNonInteractive = $true
                break
            }
        }

        # Check deployment type (install/uninstall).
        $this.WriteLogEntry("Deployment type is [$(($this.DeploymentTypeName = (Get-ADTStringTable).DeploymentType.($this.DeploymentType)))].")
    }

    hidden [System.Void] TestDefaultMsi()
    {
        # Advise the caller if a zero-config MSI was found.
        if ($this.UseDefaultMsi)
        {
            $this.WriteLogEntry("Discovered Zero-Config MSI installation file [$($this.DefaultMsiFile)].")
        }
    }

    hidden [System.Void] TestAdminRequired([System.Collections.Specialized.OrderedDictionary]$ADTEnv, [System.Collections.Hashtable]$ADTConfig)
    {
        # Check current permissions and exit if not running with Administrator rights.
        if ($ADTConfig.Toolkit.RequireAdmin -and !$ADTEnv.IsAdmin)
        {
            $naerParams = @{
                Exception = [System.UnauthorizedAccessException]::new("[$($ADTEnv.appDeployToolkitName)] has a toolkit config option [RequireAdmin] set to [True] and the current user is not an Administrator, or PowerShell is not elevated. Please re-run the deployment script as an Administrator or change the option in the config file to not require Administrator rights.")
                Category = [System.Management.Automation.ErrorCategory]::PermissionDenied
                ErrorId = 'CallerNotLocalAdmin'
                TargetObject = $this
                TargetName = '[ADTSession]'
                TargetType = 'TestAdminRequired()'
                RecommendedAction = "Please review the executing user's permissions or the supplied config and try again."
            }
            $this.WriteLogEntry($naerParams.Exception.Message, 3)
            Show-ADTDialogBox -Text $naerParams.Exception.Message -Icon Stop
            throw (New-ADTErrorRecord @naerParams)
        }
    }

    # Public methods.
    [System.Object] GetPropertyValue([System.String]$Name)
    {
        # This getter exists as once the object is opened, we need to read the variable from the caller's scope.
        # We must get the variable every time as syntax like `$var = 'val'` always constructs a new PSVariable...
        if (!$this.CompatibilityMode -or !$this.Opened)
        {
            return $this.$Name
        }
        else
        {
            return $this.CallerVariables.Get($Name).Value
        }
    }

    [System.Void] SetPropertyValue([System.String]$Name, [System.Object]$Value)
    {
        # This getter exists as once the object is opened, we need to read the variable from the caller's scope.
        # We must get the variable every time as syntax like `$var = 'val'` always constructs a new PSVariable...
        if (!$this.CompatibilityMode -or !$this.Opened)
        {
            $this.$Name = $Value
        }
        else
        {
            $this.CallerVariables.Set($Name, $Value)
        }
    }

    [System.String] GetDeploymentStatus()
    {
        if (($this.ExitCode -eq ($adtConfig = Get-ADTConfig).UI.DefaultExitCode) -or ($this.ExitCode -eq $adtConfig.UI.DeferExitCode))
        {
            return 'FastRetry'
        }
        elseif ($this.GetPropertyValue('AppRebootCodes').Contains($this.ExitCode))
        {
            return 'RestartRequired'
        }
        elseif ($this.GetPropertyValue('AppExitCodes').Contains($this.ExitCode))
        {
            return 'Complete'
        }
        else
        {
            return 'Error'
        }
    }

    hidden [System.Void] Open()
    {
        # Get the current environment and config.
        $adtData = Get-ADTModuleData
        $adtEnv = Get-ADTEnvironment
        $adtConfig = Get-ADTConfig

        # Ensure this session isn't being opened twice.
        if ($this.Opened)
        {
            $naerParams = @{
                Exception = [System.InvalidOperationException]::new("The current $($adtEnv.appDeployToolkitName) session has already been opened.")
                Category = [System.Management.Automation.ErrorCategory]::InvalidOperation
                ErrorId = 'ADTSessionAlreadyOpened'
                TargetObject = $this
                TargetName = '[ADTSession]'
                TargetType = 'Open()'
                RecommendedAction = "Please review your setup to ensure this ADTSession object isn't being opened again."
            }
            throw (New-ADTErrorRecord @naerParams)
        }

        # Initialise PSADT session.
        $this.DetectDefaultWimFile()
        $this.DetectDefaultMsi($adtEnv)
        $this.SetAppProperties($adtEnv)
        $this.SetInstallProperties($adtEnv, $adtConfig)
        $this.InitLogging($adtEnv, $adtConfig)
        $this.LogScriptInfo($adtData, $adtEnv)
        $this.LogSystemInfo($adtEnv)
        $this.WriteLogDivider()
        $this.LogUserInfo($adtData, $adtEnv, $adtConfig)
        $this.PerformSCCMTests($adtEnv)
        $this.PerformSystemAccountTests($adtEnv, $adtConfig)
        $this.SetDeploymentProperties()
        $this.TestDefaultMsi()
        $this.TestAdminRequired($adtEnv, $adtConfig)

        # If terminal server mode was specified, change the installation mode to support it.
        if ($this.TerminalServerMode)
        {
            Enable-ADTTerminalServerInstallMode
        }

        # Change the install phase since we've finished initialising. This should get overwritten shortly.
        $this.InstallPhase = 'Execution'

        # Export session's public variables to the user's scope. For these, we can't capture the Set-Variable
        # PassThru data as syntax like `$var = 'val'` constructs a new PSVariable every time.
        if ($this.CompatibilityMode)
        {
            $this.PSObject.Properties | & { process { $this.CallerVariables.Set($_.Name, $_.Value) } }
        }
        $this.Opened = $true
    }

    hidden [System.Void] Close()
    {
        # Get the current environment and config.
        $adtEnv = Get-ADTEnvironment
        $adtConfig = Get-ADTConfig

        # Ensure this session isn't being closed twice.
        if ($this.Closed)
        {
            $naerParams = @{
                Exception = [System.InvalidOperationException]::new("The current $($adtEnv.appDeployToolkitName) session has already been closed.")
                Category = [System.Management.Automation.ErrorCategory]::InvalidOperation
                ErrorId = 'ADTSessionAlreadyClosed'
                TargetObject = $this
                TargetName = '[ADTSession]'
                TargetType = 'Close()'
                RecommendedAction = "Please review your setup to ensure this ADTSession object isn't being closed again."
            }
            throw (New-ADTErrorRecord @naerParams)
        }

        # Change the install phase in preparation for closing out.
        $this.InstallPhase = 'Finalization'

        # Store app/deployment details string. If we're exiting before properties are set, use a generic string.
        if ([System.String]::IsNullOrWhiteSpace(($deployString = "$($this.GetPropertyValue('InstallName')) $($this.GetDeploymentTypeName().ToLower())".Trim())))
        {
            $deployString = "$($adtEnv.appDeployToolkitName) deployment"
        }

        # Process resulting exit code.
        switch ($this.GetDeploymentStatus())
        {
            FastRetry
            {
                # Just advise of the exit code with the appropriate severity.
                $this.WriteLogEntry("$deployString completed with exit code [$($this.ExitCode)].", 2)
                break
            }
            Error
            {
                # Just advise of the exit code with the appropriate severity.
                $this.WriteLogEntry("$deployString completed with exit code [$($this.ExitCode)].", 3)
                break
            }
            default
            {
                # Clean up app deferral history.
                if ($this.RegKeyDeferHistory -and (& $Script:CommandTable.'Test-Path' -LiteralPath $this.RegKeyDeferHistory))
                {
                    $this.WriteLogEntry('Removing deferral history...')
                    Remove-ADTRegistryKey -Key $this.RegKeyDeferHistory -Recurse
                }

                # Handle reboot prompts on successful script completion.
                if ($_.Equals('RestartRequired') -and $this.GetPropertyValue('AllowRebootPassThru'))
                {
                    $this.WriteLogEntry('A restart has been flagged as required.')
                }
                else
                {
                    $this.ExitCode = 0
                }
                $this.WriteLogEntry("$deployString completed with exit code [$($this.ExitCode)].", 0)
                break
            }
        }

        # Update the module's last tracked exit code.
        if ($this.ExitCode)
        {
            (Get-ADTModuleData).LastExitCode = $this.ExitCode
        }

        # Unmount any stored WIM file entries.
        if ($this.MountedWimFiles.Count)
        {
            $this.MountedWimFiles.Reverse(); Dismount-ADTWimFile -ImagePath $this.MountedWimFiles
            $this.MountedWimFiles.Clear()
        }

        # Write out a log divider to indicate the end of logging.
        $this.WriteLogDivider()
        $this.SetPropertyValue('DisableLogging', $true)
        $this.Closed = $true

        # Return early if we're not archiving log files.
        if (!$adtConfig.Toolkit.CompressLogs)
        {
            return
        }

        # Archive the log files to zip format and then delete the temporary logs folder.
        $DestinationArchiveFileName = "$($this.GetPropertyValue('InstallName'))_$($this.GetPropertyValue('DeploymentType'))_{0}.zip"
        try
        {
            # Get all archive files sorted by last write time
            $ArchiveFiles = & $Script:CommandTable.'Get-ChildItem' -LiteralPath $adtConfig.Toolkit.LogPath -Filter ([System.String]::Format($DestinationArchiveFileName, '*')) | & $Script:CommandTable.'Sort-Object' LastWriteTime
            $DestinationArchiveFileName = [System.String]::Format($DestinationArchiveFileName, [System.DateTime]::Now.ToString('yyyy-MM-dd-HH-mm-ss'))

            # Keep only the max number of archive files
            if ($ArchiveFiles.Count -gt $adtConfig.Toolkit.LogMaxHistory)
            {
                $ArchiveFiles | & $Script:CommandTable.'Select-Object' -First ($ArchiveFiles.Count - $adtConfig.Toolkit.LogMaxHistory) | & $Script:CommandTable.'Remove-Item'
            }
            & $Script:CommandTable.'Compress-Archive' -LiteralPath $this.GetPropertyValue('LogTempFolder') -DestinationPath $($adtConfig.Toolkit.LogPath)\$DestinationArchiveFileName -Force
            [System.IO.Directory]::Delete($this.GetPropertyValue('LogTempFolder'), $true)
        }
        catch
        {
            $this.WriteLogEntry("Failed to manage archive file [$DestinationArchiveFileName].`n$(Resolve-ADTErrorRecord -ErrorRecord $_)", 3)
        }
    }

    [System.Void] WriteLogEntry([System.String[]]$Message, [System.Nullable[System.UInt32]]$Severity, [System.String]$Source, [System.String]$ScriptSection, [System.Boolean]$DebugMessage, [System.String]$LogType, [System.String]$LogFileDirectory, [System.String]$LogFileName)
    {
        # Get the current config.
        $adtConfig = Get-ADTConfig

        # Perform early return checks before wasting time.
        if (($this.GetPropertyValue('DisableLogging') -and !$adtConfig.Toolkit.LogWriteToHost) -or ($DebugMessage -and !$adtConfig.Toolkit.LogDebugMessage))
        {
            return
        }

        # Establish logging date/time vars.
        $dateNow = [System.DateTime]::Now
        $logTime = $dateNow.ToString('HH\:mm\:ss.fff')

        # Get caller's invocation info, we'll need it for some variables.
        $caller = & $Script:CommandTable.'Get-PSCallStack' | & { process { if (![System.String]::IsNullOrWhiteSpace($_.Command) -and ($_.Command -notmatch '^Write-(Log|ADTLogEntry)$')) { return $_ } } } | & $Script:CommandTable.'Select-Object' -First 1

        # Set up default values if not specified.
        if ($null -eq $Severity)
        {
            $Severity = 1
        }
        if ([System.String]::IsNullOrWhiteSpace($Source))
        {
            $Source = $caller.Command
        }
        if ([System.String]::IsNullOrWhiteSpace($ScriptSection))
        {
            $ScriptSection = $this.GetPropertyValue('InstallPhase')
        }
        if ([System.String]::IsNullOrWhiteSpace($LogType))
        {
            $LogType = $adtConfig.Toolkit.LogStyle
        }
        if ([System.String]::IsNullOrWhiteSpace($LogFileDirectory))
        {
            $LogFileDirectory = $this.LogPath
        }
        elseif (!(& $Script:CommandTable.'Test-Path' -LiteralPath $LogFileDirectory -PathType Container))
        {
            $null = & $Script:CommandTable.'New-Item' -Path $LogFileDirectory -Type Directory -Force
        }
        if ([System.String]::IsNullOrWhiteSpace($LogFileName))
        {
            $LogFileName = $this.GetPropertyValue('LogName')
        }

        # Cache all data pertaining to current severity.
        $sevData = $Script:Logging.Severities[$Severity]

        # Store log string to format with message.
        $logFormats = @{
            Legacy = [System.String]::Format($Script:Logging.Formats.Legacy, '{0}', $dateNow.ToString([System.Globalization.DateTimeFormatInfo]::CurrentInfo.ShortDatePattern), $logTime, $ScriptSection, $Source, $sevData.Name)
            CMTrace = [System.String]::Format($Script:Logging.Formats.CMTrace, '{0}', $ScriptSection, $logTime + $this.GetPropertyValue('CurrentTimeZoneBias').TotalMinutes, $dateNow.ToString([System.Globalization.DateTimeFormatInfo]::InvariantInfo.ShortDatePattern), $Source, $Severity, $caller.ScriptName)
        }

        # Write out all non-null messages to disk or host if configured/permitted to do so.
        if (![System.String]::IsNullOrWhiteSpace(($outFile = [System.IO.Path]::Combine($LogFileDirectory, $LogFileName))) -and !$this.GetPropertyValue('DisableLogging'))
        {
            $logLine = $logFormats.$LogType
            $Message | & { process { if (![System.String]::IsNullOrWhiteSpace($_)) { [System.String]::Format($logLine, $_) } } } | & $Script:CommandTable.'Out-File' -LiteralPath $outFile -Append -NoClobber -Force -Encoding UTF8
        }
        if ($adtConfig.Toolkit.LogWriteToHost)
        {
            $conLine = $logFormats.Legacy
            $colours = $sevData.Colours
            $Message | & { process { if (![System.String]::IsNullOrWhiteSpace($_)) { [System.String]::Format($conLine, $_) } } } | & $Script:CommandTable.'Write-Host' @colours
        }
    }

    [System.Void] WriteLogEntry([System.String[]]$Message)
    {
        $this.WriteLogEntry($Message, $null, $null, $null, $false, $null, $null, $null)
    }

    [System.Void] WriteLogEntry([System.String[]]$Message, [System.Nullable[System.UInt32]]$Severity)
    {
        $this.WriteLogEntry($Message, $Severity, $null, $null, $false, $null, $null, $null)
    }

    [System.Void] WriteLogEntry([System.String[]]$Message, [System.Boolean]$DebugMessage)
    {
        $this.WriteLogEntry($Message, $null, $null, $null, $DebugMessage, $null, $null, $null)
    }

    [System.Void] WriteLogEntry([System.String[]]$Message, [System.Nullable[System.UInt32]]$Severity, [System.Boolean]$DebugMessage)
    {
        $this.WriteLogEntry($Message, $Severity, $null, $null, $DebugMessage, $null, $null, $null)
    }

    [System.Void] WriteLogEntry([System.String[]]$Message, [System.Nullable[System.UInt32]]$Severity, [System.String]$Source, [System.String]$ScriptSection, [System.Boolean]$DebugMessage)
    {
        $this.WriteLogEntry($Message, $Severity, $Source, $ScriptSection, $DebugMessage, $null, $null, $null)
    }

    [System.Collections.Generic.List[System.IO.FileInfo]] GetMountedWimFiles()
    {
        return $this.MountedWimFiles
    }

    [PSADT.Types.ProcessObject[]] GetDefaultMsiExecutablesList()
    {
        return $this.DefaultMsiExecutablesList
    }

    [System.String] GetDeploymentTypeName()
    {
        return $this.DeploymentTypeName
    }

    [System.Boolean] IsNonInteractive()
    {
        return $this.DeployModeNonInteractive
    }

    [System.Boolean] IsSilent()
    {
        return $this.DeployModeSilent
    }

    [System.Void] SetExitCode([System.Int32]$Value)
    {
        $this.ExitCode = $Value
    }
}
