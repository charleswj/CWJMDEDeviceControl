function Set-CWJMdeDcLocalPolicySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('True', 'False')]
        [string]
        $DeviceControlEnabled,

        [Parameter()]
        [ValidateSet('Allow', 'Deny')]
        [string]
        $DefaultEnforcement,

        [Parameter()]
        [CWJ.Modules.CWJMDEDeviceControl.PrimaryId[]]
        $SecuredDevicesConfiguration,

        [Parameter()]
        [ValidateSet('True', 'False')]
        [string]
        $DeduplicateAccessEvents,

        [Parameter()]
        [xml]
        $PolicyGroups,

        [Parameter()]
        [xml]
        $PolicyRules,

        [Parameter()]
        [ValidateSet('DeviceControlEnabled', 'DefaultEnforcement','SecuredDevicesConfiguration','DeduplicateAccessEvents','PolicyGroups','PolicyRules')]
        [string[]]
        $RemoveSetting
    )
    
    $key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager'
    #TODO:create key if missing

    

    $ValueName = 'DeviceControlEnabled'

    if($PSBoundParameters.ContainsKey($ValueName))
    {
        if($ExecutionContext.SessionState.PSVariable.Get($ValueName).Value -eq 'True')
        {
            Set-ItemProperty -Path $key -Name $ValueName -Value 1 -Type DWord
        }
        else
        {
            Set-ItemProperty -Path $key -Name $ValueName -Value 0 -Type DWord
        }
    }



    $ValueName = 'DefaultEnforcement'

    if($PSBoundParameters.ContainsKey($ValueName))
    {
        if($ExecutionContext.SessionState.PSVariable.Get($ValueName).Value -eq 'Allow')
        {
            Set-ItemProperty -Path $key -Name $ValueName -Value 1 -Type DWord
        }
        else
        {
            Set-ItemProperty -Path $key -Name $ValueName -Value 2 -Type DWord
        }
    }



    $ValueName = 'SecuredDevicesConfiguration'

    if($PSBoundParameters.ContainsKey($ValueName))
    {
        $Value = ($ExecutionContext.SessionState.PSVariable.Get($ValueName).Value | Group-Object).Name -join '|'

        Set-ItemProperty -Path $key -Name $ValueName -Value $Value -Type String
    }
    #TODO:add none to enum



    $ValueName = 'DeduplicateAccessEvents'

    if($PSBoundParameters.ContainsKey($ValueName))
    {
        if($ExecutionContext.SessionState.PSVariable.Get($ValueName).Value -eq 'True')
        {
            Set-ItemProperty -Path $key -Name $ValueName -Value 1 -Type DWord
        }
        else
        {
            Set-ItemProperty -Path $key -Name $ValueName -Value 0 -Type DWord
        }
    }



    $ValueName = 'PolicyGroups' #TODO duplicate for PolicyRules

    if($PSBoundParameters.ContainsKey($ValueName))
    {
        $XmlDocument = $ExecutionContext.SessionState.PSVariable.Get($ValueName).Value

        # keep this in case we load from path later, would need its own param
        # $XmlDocument = [System.Xml.XmlDocument]::new()
        # $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        # $XmlDocument.Load($Path)

        if($XmlDocument.SelectSingleNode('/').FirstChild.LocalName -cne $ValueName)
        {
            Write-Error "Invalid XML input for $ValueName parameter" -ErrorAction Stop
        }

        $Value = _writeXml -InputObject $XmlDocument

        #$ValueName = '{0}_Test' -f $ValueName #TODO: remove this

        Set-ItemProperty -Path $key -Name $ValueName -Value $Value -Type String
    }



    $ValueName = 'PolicyRules' #TODO duplicate for PolicyRules

    if($PSBoundParameters.ContainsKey($ValueName))
    {
        $XmlDocument = $ExecutionContext.SessionState.PSVariable.Get($ValueName).Value

        # keep this in case we load from path later, would need its own param
        # $XmlDocument = [System.Xml.XmlDocument]::new()
        # $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        # $XmlDocument.Load($Path)

        if($XmlDocument.SelectSingleNode('/').FirstChild.LocalName -cne $ValueName)
        {
            Write-Error "Invalid XML input for $ValueName parameter" -ErrorAction Stop
        }

        $Value = _writeXml -InputObject $XmlDocument

        #$ValueName = '{0}_Test' -f $ValueName #TODO: remove this

        Set-ItemProperty -Path $key -Name $ValueName -Value $Value -Type String
    }



    $ValueName = 'RemoveSetting'

    if($PSBoundParameters.ContainsKey($ValueName))
    {
        $Value = ($ExecutionContext.SessionState.PSVariable.Get($ValueName).Value | Group-Object).Name

        Remove-ItemProperty -Path $key -Name $Value
    }

    <#

    #to add, is in GPO
    Software\Policies\Microsoft\Windows Defender\Device Control                CustomSupportLink
    Software\Policies\Microsoft\Windows Defender\Device Control                PolicyRefreshFailureInterval
    Software\Policies\Microsoft\Windows Defender\Device Control                AzureAdRefreshInterval
    Software\Policies\Microsoft\Windows Defender\Device Control                DataDuplicationRemoteLocation        string
    Software\Policies\Microsoft\Windows Defender\Device Control                DataDuplicationLocalRetentionPeriod  0-10000
    Software\Policies\Microsoft\Windows Defender\Device Control                DataDuplicationMaximumQuota          5-5000

    #to add, not in GPO
                                                                            DataDuplicationDirectory             string???
    #>
}