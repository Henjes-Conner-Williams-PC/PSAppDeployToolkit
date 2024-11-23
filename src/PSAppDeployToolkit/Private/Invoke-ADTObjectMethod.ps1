﻿#---------------------------------------------------------------------------
#
#
#
#---------------------------------------------------------------------------

function Invoke-ADTObjectMethod
{
    <#

    .SYNOPSIS
    Invoke method on any object.

    .DESCRIPTION
    Invoke method on any object with or without using named parameters.

    .PARAMETER InputObject
    Specifies an object which has methods that can be invoked.

    .PARAMETER MethodName
    Specifies the name of a method to invoke.

    .PARAMETER ArgumentList
    Argument to pass to the method being executed. Allows execution of method without specifying named parameters.

    .PARAMETER Parameter
    Argument to pass to the method being executed. Allows execution of method by using named parameters.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.Object. The object returned by the method being invoked.

    .EXAMPLE
    $ShellApp = New-Object -ComObject 'Shell.Application'
    $null = Invoke-ADTObjectMethod -InputObject $ShellApp -MethodName 'MinimizeAll'

    Minimizes all windows.

    .EXAMPLE
    $ShellApp = New-Object -ComObject 'Shell.Application'
    $null = Invoke-ADTObjectMethod -InputObject $ShellApp -MethodName 'Explore' -Parameter @{'vDir'='C:\Windows'}

    Opens the C:\Windows folder in a Windows Explorer window.

    .NOTES
    This is an internal script function and should typically not be called directly.

    .NOTES
    This function can be called without an active ADT session.

    .LINK
    https://psappdeploytoolkit.com

    #>

    [CmdletBinding(DefaultParameterSetName = 'Positional')]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Object]$InputObject,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [System.String]$MethodName,

        [Parameter(Mandatory = $false, Position = 2, ParameterSetName = 'Positional')]
        [ValidateNotNullOrEmpty()]
        [System.Object[]]$ArgumentList,

        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Named')]
        [ValidateNotNullOrEmpty()]
        [System.Collections.Hashtable]$Parameter
    )

    begin
    {
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            try
            {
                switch ($PSCmdlet.ParameterSetName)
                {
                    Named
                    {
                        # Invoke method by using parameter names.
                        return $InputObject.GetType().InvokeMember($MethodName, [System.Reflection.BindingFlags]::InvokeMethod, $null, $InputObject, [System.Object[]]$Parameter.Values, $null, $null, [System.String[]]$Parameter.Keys)
                    }
                    Positional
                    {
                        # Invoke method without using parameter names.
                        return $InputObject.GetType().InvokeMember($MethodName, [System.Reflection.BindingFlags]::InvokeMethod, $null, $InputObject, $ArgumentList, $null, $null, $null)
                    }
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
