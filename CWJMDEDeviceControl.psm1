function New-CWJMdeDcReusableSettingsMatchType
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
    "value": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_matchany",
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

    $MatchTypeEntry.choiceSettingValue.value = $value
    
    return $MatchTypeEntry
}

function New-CWJMdeDcReusableSettingsDescriptorIdList
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

  if(-not $PSBoundParameters.Keys.Contains('Name'))
  {
    $Name = $InstancePathId
  }

  $DescriptorIdListEntry.groupSettingCollectionValue.children.Where{$_.settingDefinitionId -like '*_name'}.simpleSettingValue.value = $Name
  $DescriptorIdListEntry.groupSettingCollectionValue.children.Where{$_.settingDefinitionId -like '*_instancepathid'}.simpleSettingValue.value = $InstancePathId

  return $DescriptorIdListEntry
}




function New-CWJMdeDcReusableSettings #TODO: should this be New or Set or ???
{
  param(
    [Parameter(Mandatory=1)]
    [string]
    $Id, #TODO: only set for modification, not when new
    
    [Parameter()]
    [string]
    $DisplayName,

    [Parameter()]
    [string]
    $Description,

    [Parameter()]
    [ValidateSet('MatchAll', 'MatchAny')]
    [string]
    $MatchType = 'MatchAny',

    [Parameter()]
    [ValidateSet('InstancePathId')]
    [string]
    $DescriptorIdType = 'InstancePathId',

    [Parameter(Mandatory=1)]
    [string[]]
    $DescriptorId
  )


  $ReusablePolicySettingsTemplate = @'
{
  "displayName": null,
  "description": null,
  "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata",
  "settingInstance": {
    "@odata.type": "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance",
    "settingDefinitionId": "device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata",
    "groupSettingCollectionValue": [
      {
        "children": null
      }
    ]
  },
  "@odata.type": "#microsoft.graph.deviceManagementReusablePolicySetting",
  "id": null
}
'@

  $ReusablePolicySettings = ConvertFrom-Json $ReusablePolicySettingsTemplate

  $ReusablePolicySettings.id          = $Id
  $ReusablePolicySettings.displayName = $DisplayName
  $ReusablePolicySettings.description = $Description
  
  $ReusablePolicySettingsEntries = [System.Collections.ArrayList]::new() #TODO:not a great name
  
  $MdeDcReusableSettingsMatchType = New-CWJMdeDcReusableSettingsMatchType -MatchType $MatchType
  
  [void]$ReusablePolicySettingsEntries.Add($MdeDcReusableSettingsMatchType)

  $DescriptorId | ForEach-Object {
    $MdeDcReusableSettingsDescriptorIdList = New-CWJMdeDcReusableSettingsDescriptorIdList -InstancePathId $_
    [void]$ReusablePolicySettingsEntries.Add($MdeDcReusableSettingsDescriptorIdList)
  }

  $ReusablePolicySettings.settingInstance.groupSettingCollectionValue[0].children = $ReusablePolicySettingsEntries

  $ReusablePolicySettingsJson = ConvertTo-Json $ReusablePolicySettings -Depth 10

  return $ReusablePolicySettingsJson
}












<#

GUI name        "settingDefinitionId": xxx
BusId           device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_busid
DeviceId        device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_deviceid
FriendlyNameId  device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_friendlynameid
HardwareId      device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_hardwareid
InstancePathId  device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_instancepathid
Name            device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_name
PID             device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_pid
PrimaryId       device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_primaryid
SerialNumberId  device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_serialnumberid
VID             device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_vid
VID_PID         device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_vid_pid

#>



#Invoke-MgGraphRequest -Method PUT -Uri "beta/deviceManagement/reusablePolicySettings('72b19ec1-3250-4dbb-8a00-5f2c86e7b0c9')" -Body $reusablePolicySettingsJson


<#

$a = Invoke-MgGraphRequest -Method GET -Uri @'
beta/deviceManagement/reusablePolicySettings('72b19ec1-3250-4dbb-8a00-5f2c86e7b0c9')?$select=description,displayName,id,settingDefinitionId,settingInstance
'@

#>



