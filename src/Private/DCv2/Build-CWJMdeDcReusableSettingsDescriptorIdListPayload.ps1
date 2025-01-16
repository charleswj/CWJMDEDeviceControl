function Build-CWJMdeDcReusableSettingsDescriptorIdListPayload
{
  param(
    [Parameter()]
    [string]
    $Name,

    [Parameter(Mandatory=1)]
    [string]
    $InstancePathId
  )

  $DescriptorIdListEntryTemplate=@'
{
  "@odata.type": "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance",
  "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist",
  "groupSettingCollectionValue": [
    {
      "children": [
        {
          "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
          "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_name",
          "simpleSettingValue": {
            "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
            "value": null
          }
        },
        {
          "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
          "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_instancepathid",
          "simpleSettingValue": {
            "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
            "value": null
          }
        }
      ]
    }
  ]
}
'@

  $DescriptorIdListEntry = ConvertFrom-Json $DescriptorIdListEntryTemplate

  if(-not $PSBoundParameters.ContainsKey('Name'))
  {
    $Name = $InstancePathId
  }

  #Add-Member -InputObject $DescriptorIdListEntry.groupSettingCollectionValue.children.Where{$_.settingDefinitionId -like '*_name'}.simpleSettingValue -MemberType NoteProperty -Name value2 -Value $Name
  #Add-Member -InputObject $DescriptorIdListEntry.groupSettingCollectionValue.children.Where{$_.settingDefinitionId -like '*_instancepathid'}.simpleSettingValue -MemberType NoteProperty -Name value2 -Value $InstancePathId
  $DescriptorIdListEntry.groupSettingCollectionValue.children.Where{$_.settingDefinitionId -like '*_name'}.simpleSettingValue.value = $Name
  $DescriptorIdListEntry.groupSettingCollectionValue.children.Where{$_.settingDefinitionId -like '*_instancepathid'}.simpleSettingValue.value = $InstancePathId

  return $DescriptorIdListEntry
}
