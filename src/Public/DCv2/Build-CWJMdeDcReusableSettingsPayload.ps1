function Build-CWJMdeDcReusableSettingsPayload
{
  param(
    [Parameter()]
    [string]
    $Id,

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

    #TODO: not using ? remove?
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
  //"id": null //trying to only add if specified, is that even a thing?
}
'@

    #TODO: not using ? remove?
    $ReusablePolicySettings = ConvertFrom-Json $ReusablePolicySettingsTemplate



  $ReusablePolicySettings = @{
    '@odata.type'       = '#microsoft.graph.deviceManagementReusablePolicySetting'
    settingDefinitionId = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata'
    settingInstance     = @{
      '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
      settingDefinitionId         = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata'
      groupSettingCollectionValue = @(
        @{
          children = $null
        }
      )
    }
  }





  if($PSBoundParameters.ContainsKey('Id'))
  {
    $ReusablePolicySettings.Add('id', $Id)
  }

  $ReusablePolicySettings.Add('displayName', $DisplayName)
  $ReusablePolicySettings.Add('description', $Description)
  
  $ReusablePolicySettingsEntries = [System.Collections.ArrayList]::new() #TODO:not a great name
  
  $MdeDcReusableSettingsMatchTypePayload = Build-CWJMdeDcReusableSettingsMatchTypePayload -MatchType $MatchType
  
  [void]$ReusablePolicySettingsEntries.Add($MdeDcReusableSettingsMatchTypePayload)

  $DescriptorId | ForEach-Object {
    $MdeDcReusableSettingsDescriptorIdListPayload = Build-CWJMdeDcReusableSettingsDescriptorIdListPayload -InstancePathId $_
    [void]$ReusablePolicySettingsEntries.Add($MdeDcReusableSettingsDescriptorIdListPayload)
  }

  $ReusablePolicySettings.settingInstance.groupSettingCollectionValue[0].children = $ReusablePolicySettingsEntries

  return $ReusablePolicySettings
}
