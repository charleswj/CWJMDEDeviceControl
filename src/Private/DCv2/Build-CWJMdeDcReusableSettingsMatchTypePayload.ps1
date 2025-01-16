function Build-CWJMdeDcReusableSettingsMatchTypePayload
{
    param(
        [Parameter(Mandatory=1)]
        [string]
        [ValidateSet('MatchAll', 'MatchAny')]
        $MatchType
    )

    $MatchTypeEntryTemplate=@'
{
  "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
  "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype",
  "choiceSettingValue": {
    "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
    "children": []
  }
}
'@

    $MatchTypeEntry = ConvertFrom-Json $MatchTypeEntryTemplate

    if($MatchType -eq 'MatchAny')
    {
        $value = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_matchany'
    }
    elseif($MatchType -eq 'MatchAll')
    {
        $value = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_matchall'
    }

    Add-Member -InputObject $MatchTypeEntry.choiceSettingValue -MemberType NoteProperty -Name value -Value $value
    
    return $MatchTypeEntry
}
