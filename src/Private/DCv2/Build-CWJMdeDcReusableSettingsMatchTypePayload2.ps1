function Build-CWJMdeDcReusableSettingsMatchTypePayload2
{
  param(
    [Parameter(Mandatory=1)]
    [string]
    [ValidateSet('MatchAll', 'MatchAny')]
    $MatchType
  )

  $MatchTypeEntry = @{
    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
    settingDefinitionId = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype'
    choiceSettingValue  = @{
      '@odata.type'= "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
      children     = @()
    }
  }

  if($MatchType -eq 'MatchAny')
  {
      $value = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_matchany'
  }
  elseif($MatchType -eq 'MatchAll')
  {
      $value = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_matchall'
  }

  $MatchTypeEntry.choiceSettingValue.Add('value', $value)
  
  return $MatchTypeEntry
}
