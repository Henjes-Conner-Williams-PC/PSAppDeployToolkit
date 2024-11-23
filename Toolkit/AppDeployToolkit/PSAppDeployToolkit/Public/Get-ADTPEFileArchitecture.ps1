﻿#---------------------------------------------------------------------------
#
# 
#
#---------------------------------------------------------------------------

function Get-ADTPEFileArchitecture
{
    <#

    .SYNOPSIS
    Determine if a PE file is a 32-bit or a 64-bit file.

    .DESCRIPTION
    Determine if a PE file is a 32-bit or a 64-bit file by examining the file's image file header.

    PE file extensions: .exe, .dll, .ocx, .drv, .sys, .scr, .efi, .cpl, .fon

    .PARAMETER FilePath
    Path to the PE file to examine.

    .INPUTS
    System.IO.FileInfo. Accepts a FileInfo object from the pipeline.

    .OUTPUTS
    System.String. Returns a string indicating the file binary type.

    .EXAMPLE
    Get-ADTPEFileArchitecture -FilePath "$env:windir\notepad.exe"

    .NOTES
    This is an internal script function and should typically not be called directly.

    .NOTES
    This function can be called without an active ADT session.

    .LINK
    https://psappdeploytoolkit.com

    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({
            if (![System.IO.File]::Exists($_) -or ($_ -notmatch '\.(exe|dll|ocx|drv|sys|scr|efi|cpl|fon)$'))
            {
                $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName FilePath -ProvidedValue $_ -ExceptionMessage 'One or more files either does not exist or has an invalid extension.'))
            }
            return !!$_
        })]
        [System.IO.FileInfo[]]$FilePath
    )

    begin
    {
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        [System.Int32]$MACHINE_OFFSET = 4
        [System.Int32]$PE_POINTER_OFFSET = 60
        [System.Byte[]]$data = [System.Byte[]]::new(4096)
    }

    process
    {
        foreach ($Path in $filePath)
        {
            try
            {
                try
                {
                    # Read the first 4096 bytes of the file.
                    $stream = [System.IO.FileStream]::new($Path.FullName, 'Open', 'Read')
                    $null = $stream.Read($data, 0, $data.Count)
                    $stream.Flush()
                    $stream.Close()

                    # Get the file header from the header's address, factoring in any offsets.
                    $PEArchitecture = switch ($PE_IMAGE_FILE_HEADER = [System.BitConverter]::ToUInt16($data, [System.BitConverter]::ToInt32($data, $PE_POINTER_OFFSET) + $MACHINE_OFFSET))
                    {
                        0 {
                            # The contents of this file are assumed to be applicable to any machine type
                            'Native'
                        }
                        0x014c {
                            # File for Windows 32-bit systems
                            '32BIT'
                        }
                        0x0200 {
                            # File for Intel Itanium x64 processor family
                            'Itanium-x64'
                        }
                        0x8664 {
                            # File for Windows 64-bit systems
                            '64BIT'
                        }
                        default {
                            'Unknown'
                        }
                    }
                    Write-ADTLogEntry -Message "File [$($Path.FullName)] has a detected file architecture of [$PEArchitecture]."

                    # Output the string to the pipeline.
                    $PEArchitecture
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
    }

    end
    {
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}
