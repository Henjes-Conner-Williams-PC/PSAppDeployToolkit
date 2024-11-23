﻿#
# Module manifest for module 'PSAppDeployToolkit'
#
# Generated on: 2024-04-13
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'PSAppDeployToolkit.psm1'

    # Version number of this module.
    ModuleVersion = '3.91.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID = 'd64dedeb-6c11-4251-911e-a62d7e031d0f'

    # Author of this module
    Author = 'PSAppDeployToolkit Team'

    # Company or vendor of this module
    CompanyName = 'PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham and Muhammad Mashwani)'

    # Copyright statement for this module
    Copyright = 'Copyright © 2024 PSAppDeployToolkit Team. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Enterprise App Deployment, Simplified.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    DotNetFrameworkVersion = '4.6.2.0'

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    CLRVersion = '4.0.0.0'

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @(
        'System.ServiceProcess'
        'System.Drawing'
        'System.Windows.Forms'
        'PresentationCore'
        'PresentationFramework'
        'WindowsBase'
        'PSAppDeployToolkit.dll'
        'lib\ProgressWindow\PSADT.UserInterface.dll'
    )

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Add-ADTEdgeExtension'
        'Add-ADTSessionClosingCallback'
        'Add-ADTSessionFinishingCallback'
        'Add-ADTSessionOpeningCallback'
        'Add-ADTSessionStartingCallback'
        'Block-ADTAppExecution'
        'Close-ADTInstallationProgress'
        'Close-ADTSession'
        'Complete-ADTFunction'
        'Convert-ADTRegistryPath'
        'Convert-ADTValuesFromRemainingArguments'
        'Copy-ADTContentToCache'
        'Copy-ADTFile'
        'Copy-ADTFileToUserProfiles'
        'Disable-ADTTerminalServerInstallMode'
        'Dismount-ADTWimFile'
        'Enable-ADTTerminalServerInstallMode'
        'Execute-ProcessAsUser'
        'Get-ADTBoundParametersAndDefaultValues'
        'Get-ADTConfig'
        'Get-ADTEnvironment'
        'Get-ADTFileVersion'
        'Get-ADTFreeDiskSpace'
        'Get-ADTIniValue'
        'Get-ADTInstalledApplication'
        'Get-ADTLoggedOnUser'
        'Get-ADTMsiProductCodeRegexPattern'
        'Get-ADTPendingReboot'
        'Get-ADTPowerShellProcessPath'
        'Get-ADTRedirectedUri'
        'Get-ADTRegistryKey'
        'Get-ADTRunAsActiveUser'
        'Get-ADTSchedulerTask'
        'Get-ADTServiceStartMode'
        'Get-ADTSession'
        'Get-ADTShortcut'
        'Get-ADTStringTable'
        'Get-ADTUniversalDate'
        'Get-ADTUriFileName'
        'Get-ADTUserProfiles'
        'Get-ADTWindowTitle'
        'Initialize-ADTFunction'
        'Initialize-ADTModule'
        'Install-ADTMSUpdates'
        'Install-ADTSCCMSoftwareUpdates'
        'Invoke-ADTAllUsersRegistryChange'
        'Invoke-ADTCommandWithRetries'
        'Invoke-ADTRegSvr32'
        'Invoke-ADTFunctionErrorHandler'
        'Invoke-ADTSCCMTask'
        'Invoke-ADTWebDownload'
        'Mount-ADTWimFile'
        'New-ADTErrorRecord'
        'New-ADTFolder'
        'New-ADTMsiTransform'
        'New-ADTShortcut'
        'New-ADTValidateScriptErrorRecord'
        'Open-ADTSession'
        'Out-ADTPowerShellEncodedCommand'
        'Register-ADTDll'
        'Remove-ADTContentFromCache'
        'Remove-ADTEdgeExtension'
        'Remove-ADTFile'
        'Remove-ADTFileFromUserProfiles'
        'Remove-ADTFolder'
        'Uninstall-ADTApplication'
        'Remove-ADTInvalidFileNameChars'
        'Remove-ADTRegistryKey'
        'Remove-ADTSessionClosingCallback'
        'Remove-ADTSessionFinishingCallback'
        'Remove-ADTSessionOpeningCallback'
        'Remove-ADTSessionStartingCallback'
        'Resolve-ADTErrorRecord'
        'Send-ADTKeys'
        'Set-ADTActiveSetup'
        'Set-ADTIniValue'
        'Set-ADTItemPermission'
        'Set-ADTRegistryKey'
        'Set-ADTServiceStartMode'
        'Set-ADTShortcut'
        'Show-ADTBalloonTip'
        'Show-ADTBlockedAppDialog'
        'Show-ADTDialogBox'
        'Show-ADTHelpConsole'
        'Show-ADTInstallationProgress'
        'Show-ADTInstallationPrompt'
        'Show-ADTInstallationRestartPrompt'
        'Show-ADTInstallationWelcome'
        'Start-ADTMsiProcess'
        'Start-ADTMspProcess'
        'Start-ADTProcess'
        'Start-ADTServiceAndDependencies'
        'Stop-ADTServiceAndDependencies'
        'Test-ADTBattery'
        'Test-ADTCallerIsAdmin'
        'Test-ADTModuleInitialized'
        'Test-ADTMSUpdates'
        'Test-ADTNetworkConnection'
        'Test-ADTOobeCompleted'
        'Test-ADTPowerPoint'
        'Test-ADTRegistryValue'
        'Test-ADTServiceExists'
        'Test-ADTSessionActive'
        'Unblock-ADTAppExecution'
        'Unregister-ADTDll'
        'Update-ADTDesktop'
        'Update-ADTEnvironmentPsProvider'
        'Update-ADTGroupPolicy'
        'Write-ADTLogEntry'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    # VariablesToExport = ''

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = 'psappdeploytoolkit', 'adt', 'psadt', 'appdeployment', 'appdeploy', 'deployment', 'toolkit'

            # A URL to the license for this module.
            LicenseUri = 'https://psappdeploytoolkit.com/docs/license'

            # A URL to the main website for this project.
            ProjectUri = 'https://psappdeploytoolkit.com'

            # A URL to an icon representing this module.
            IconUri = 'https://psappdeploytoolkit.com/documentation/assets/logo.ico'

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI = 'https://psappdeploytoolkit.com/docs'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
