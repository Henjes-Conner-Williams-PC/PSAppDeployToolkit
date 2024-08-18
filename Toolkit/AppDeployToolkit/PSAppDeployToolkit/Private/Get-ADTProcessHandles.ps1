﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Get-ADTProcessHandles
{
    # Get CSV data from the binary and confirm success.
    $exeHandle = "$Script:PSScriptRoot\bin\$([System.Environment]::GetEnvironmentVariable('PROCESSOR_ARCHITECTURE'))\handle\handle.exe"
    $exeHandleResults = & $exeHandle -nobanner -v
    if ($Global:LastExitCode -ne 0)
    {
        $naerParams = @{
            Exception = [System.ApplicationException]::new("The call to [$exeHandle] failed with exit code [$Global:LASTEXITCODE].")
            Category = [System.Management.Automation.ErrorCategory]::InvalidResult
            ErrorId = 'HandleExecutableFailure'
            TargetObject = $exeHandleResults
            RecommendedAction = "Please review the result in this error's TargetObject property and try again."
        }
        throw (New-ADTErrorRecord @naerParams)
    }

    # Convert CSV data to objects and re-process to remove non-word characters before returning data to the caller.
    if (($handles = $exeHandleResults | & $Script:CommandTable.'ConvertFrom-Csv'))
    {
        return $handles | & $Script:CommandTable.'Select-Object' -Property ($handles[0].PSObject.Properties.Name | & {
                process
                {
                    @{ Label = $_ -replace '[^\w]'; Expression = [scriptblock]::Create("`$_.'$_'.Trim()") }
                }
            })
    }
}