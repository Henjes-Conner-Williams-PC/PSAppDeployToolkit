﻿function ConvertTo-ADTNTAccountOrSID
{
    <#

    .SYNOPSIS
    Convert between NT Account names and their security identifiers (SIDs).

    .DESCRIPTION
    Specify either the NT Account name or the SID and get the other. Can also convert well known sid types.

    .PARAMETER AccountName
    The Windows NT Account name specified in <domain>\<username> format.

    Use fully qualified account names (e.g., <domain>\<username>) instead of isolated names (e.g, <username>) because they are unambiguous and provide better performance.

    .PARAMETER SID
    The Windows NT Account SID.

    .PARAMETER WellKnownSIDName
    Specify the Well Known SID name translate to the actual SID (e.g., LocalServiceSid).

    To get all well known SIDs available on system: [Enum]::GetNames([Security.Principal.WellKnownSidType])

    .PARAMETER WellKnownToNTAccount
    Convert the Well Known SID to an NTAccount name

    .INPUTS
    System.String. Accepts a string containing the NT Account name or SID.

    .OUTPUTS
    System.String. Returns the NT Account name or SID.

    .EXAMPLE
    ConvertTo-ADTNTAccountOrSID -AccountName 'CONTOSO\User1'

    Converts a Windows NT Account name to the corresponding SID.

    .EXAMPLE
    ConvertTo-ADTNTAccountOrSID -SID 'S-1-5-21-1220945662-2111687655-725345543-14012660'

    Converts a Windows NT Account SID to the corresponding NT Account Name.

    .EXAMPLE
    ConvertTo-ADTNTAccountOrSID -WellKnownSIDName 'NetworkServiceSid'

    Converts a Well Known SID name to a SID.

    .NOTES
    This is an internal script function and should typically not be called directly.

    The conversion can return an empty result if the user account does not exist anymore or if translation fails.

    http://blogs.technet.com/b/askds/archive/2011/07/28/troubleshooting-sid-translation-failures-from-the-obvious-to-the-not-so-obvious.aspx

    .LINK
    https://psappdeploytoolkit.com

    .LINK
    http://msdn.microsoft.com/en-us/library/system.security.principal.wellknownsidtype(v=vs.110).aspx

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NTAccountToSID', ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$AccountName,

        [Parameter(Mandatory = $true, ParameterSetName = 'SIDToNTAccount', ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$SID,

        [Parameter(Mandatory = $true, ParameterSetName = 'WellKnownName', ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$WellKnownSIDName,

        [Parameter(Mandatory = $false, ParameterSetName = 'WellKnownName')]
        [System.Management.Automation.SwitchParameter]$WellKnownToNTAccount
    )

    begin {
        Initialize-ADTFunction -Cmdlet $PSCmdlet
    }

    process {
        switch ($PSCmdlet.ParameterSetName)
        {
            'SIDToNTAccount' {
                $msg = "the SID [$SID] to an NT Account name"
                Write-ADTLogEntry -Message "Converting $msg."

                try
                {
                    return [System.Security.Principal.SecurityIdentifier]::new($SID).Translate([System.Security.Principal.NTAccount])
                }
                catch
                {
                    Write-ADTLogEntry -Message "Unable to convert $msg. It may not be a valid account anymore or there is some other problem.`n$(Resolve-ADTError)" -Severity 2
                }
            }
            'NTAccountToSID' {
                $msg = "the NT Account [$AccountName] to a SID"
                Write-ADTLogEntry -Message "Converting $msg."

                try
                {
                    return [System.Security.Principal.NTAccount]::new($AccountName).Translate([System.Security.Principal.SecurityIdentifier])
                }
                catch
                {
                    Write-ADTLogEntry -Message "Unable to convert $msg. It may not be a valid account anymore or there is some other problem.`n$(Resolve-ADTError)" -Severity 2
                }
            }
            'WellKnownName' {
                [String]$ConversionType = if ($WellKnownToNTAccount)
                {
                    'NTAccount'
                }
                else
                {
                    'SID'
                }
                [String]$msg = "the Well Known SID Name [$WellKnownSIDName] to a $ConversionType"
                Write-ADTLogEntry -Message "Converting $msg."

                # Get the SID for the root domain.
                $DomainSid = try
                {
                    [System.Security.Principal.SecurityIdentifier]::new([System.DirectoryServices.DirectoryEntry]::new("LDAP://$((Get-CimInstance -ClassName Win32_ComputerSystem).Domain.ToLower())").ObjectSid[0], 0)
                }
                catch
                {
                    Write-ADTLogEntry -Message 'Unable to get Domain SID from Active Directory. Setting Domain SID to $null.' -Severity 2
                }

                # Get the SID for the well known SID name.
                try
                {
                    $NTAccountSID = [System.Security.Principal.SecurityIdentifier]::new([System.Security.Principal.WellKnownSidType]::$WellKnownSIDName, $DomainSid)
                    if ($WellKnownToNTAccount)
                    {
                        return $NTAccountSID.Translate([System.Security.Principal.NTAccount])
                    }
                    return $NTAccountSID
                }
                catch
                {
                    Write-ADTLogEntry -Message "Failed to convert $msg. It may not be a valid account anymore or there is some other problem.`n$(Resolve-ADTError)" -Severity 3
                }
            }
        }
    }

    end {
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}
