function Get-CWJMdeDcLocalPolicySetting
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]
        $DeviceControlEnabled,

        [Parameter()]
        [switch]
        $DefaultEnforcement,

        [Parameter()]
        [switch]
        $SecuredDevicesConfiguration,

        [Parameter()]
        [switch]
        $DeduplicateAccessEvents,

        [Parameter()]
        [switch]
        $PolicyGroups,

        [Parameter()]
        [switch]
        $PolicyRules
    )
    
    $key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager'

    $properties = Get-ItemProperty -Path $key

    $outputObject = [ordered]@{}

    'DeviceControlEnabled',
    'DefaultEnforcement',
    'SecuredDevicesConfiguration',
    'DeduplicateAccessEvents',
    'PolicyGroups',
    'PolicyRules' | %{
        $ValueName = $_

        $outputObject.Add($ValueName, $properties.$ValueName)
    }

    return [pscustomobject]$outputObject

    
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