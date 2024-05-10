function New-CWJMdeDcReusableSettingsMatchTypeEntry
{
    param(
        [Parameter(Mandatory=1)]
        [ValidateSet('MatchAny', 'MatchAll')]
        $MatchType
    )

    $global:MatchTypeEntryTemplate=@'
{
  "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
  "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype",
  "choiceSettingValue": {
    "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
    "value": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_matchany",
    "children": []
  }
}
'@

    $global:MatchTypeEntry = ConvertFrom-Json $MatchTypeEntryTemplate

    if($MatchType -eq 'MatchAny')
    {
        $value = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_matchany'
    }
    elseif($MatchType -eq 'MatchAll')
    {
        $value = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_matchall'
    }

    $MatchTypeEntry.choiceSettingValue.value = $value
    
    return $MatchTypeEntry
}




function New-CWJReusableSettings
{

a
$ReusablePolicySettingsTemplate = @'
{
  "displayName": "<<<DISPLAYNAME>>>",
  "description": "<<<DESCRIPTION>>>",
  "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata",
  "settingInstance": {
    "@odata.type": "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance",
    "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata",
    "groupSettingCollectionValue": [
      {
        "children": [
        ]
      }
    ]
  },
  "@odata.type": "#microsoft.graph.deviceManagementReusablePolicySetting",
  "id": "<<<GUID>>>"
}
'@

$ReusablePolicySettings = ConvertFrom-Json $ReusablePolicySettingsTemplate




$global:DescriptorIdListTemplate=@'
{
  "@odata.type": "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance",
  "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist",
  "groupSettingCollectionValue": [
    {
      "children": [
        {
          "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
          "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_instancepathid",
          "simpleSettingValue": {
            "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
            "value": "<<<deviceInstancePathId>>>"
          }
        },
        {
          "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
          "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_name",
          "simpleSettingValue": {
            "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
            "value": "<<<deviceName>>>"
          }
        }
      ]
    }
  ]
}
'@

$global:ReusablePolicySettingsChildren = [System.Collections.ArrayList]::new() #TODO:not a great name

$MdeDcReusableSettingsMatchTypeEntry = New-CWJMdeDcReusableSettingsMatchTypeEntry -MatchType MatchAny

[void]$ReusablePolicySettingsChildren.Add($MdeDcReusableSettingsMatchTypeEntry)

1..2|%{
    $global:DescriptorIdList = ConvertFrom-Json $DescriptorIdListTemplate
    $DescriptorIdList.groupSettingCollectionValue.children.Where{$_.settingDefinitionId -like '*_name'}.simpleSettingValue.value = 'name_{0}' -f $_
    $DescriptorIdList.groupSettingCollectionValue.children.Where{$_.settingDefinitionId -like '*_instancepathid'}.simpleSettingValue.value = 'instancepathid_{0}' -f $_
    [void]$ReusablePolicySettingsChildren.Add($DescriptorIdList)
}

$reusablePolicySettings.settingInstance.groupSettingCollectionValue[0].children = $ReusablePolicySettingsChildren

$global:reusablePolicySettingsJson = ConvertTo-Json $reusablePolicySettings -Depth 10

#Invoke-MgGraphRequest -Method PUT -Uri "beta/deviceManagement/reusablePolicySettings('72b19ec1-3250-4dbb-8a00-5f2c86e7b0c9')" -Body $reusablePolicySettingsJson


<#

$a = Invoke-MgGraphRequest -Method GET -Uri @'
beta/deviceManagement/reusablePolicySettings('72b19ec1-3250-4dbb-8a00-5f2c86e7b0c9')?$select=description,displayName,id,settingDefinitionId,settingInstance
'@

#>


}
