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

function New-CWJMdeDcReusableSettings
{
  param(
    [Parameter(Mandatory=1)]
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

  $ReusableSettingsPayload = Build-CWJMdeDcReusableSettingsPayload @PSBoundParameters

  $ReusableSettingsPayloadJson = ConvertTo-Json -InputObject $ReusableSettingsPayload -Depth 100

  $InvokeMgGraphRequestParams = @{
    Method = 'POST'
    Uri    = "beta/deviceManagement/reusablePolicySettings"
    Body   = $ReusableSettingsPayloadJson
  }

  Invoke-MgGraphRequest @InvokeMgGraphRequestParams
}

function Update-CWJMdeDcReusableSettings
{
  param(
    [Parameter(Mandatory=1)]
    [string]
    $Id,
    
    [Parameter(Mandatory=1)]
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

  $ReusableSettingsPayload = Build-CWJMdeDcReusableSettingsPayload @PSBoundParameters

  $ReusableSettingsPayloadJson = ConvertTo-Json -InputObject $ReusableSettingsPayload -Depth 100
  
  $InvokeMgGraphRequestParams = @{
    Method = 'PUT'
    Uri    = "beta/deviceManagement/reusablePolicySettings('{0}')" -f $Id
    Body   = $ReusableSettingsPayloadJson
  }
  
  Invoke-MgGraphRequest @InvokeMgGraphRequestParams
}

function Remove-CWJMdeDcReusableSettings
{
  param(
    [Parameter(Mandatory=1, ParameterSetName='Id')]
    [string]
    $Id

    #[Parameter(Mandatory=1, ParameterSetName='DisplayName')]
    #[string]
    #$DisplayName
  )

  $InvokeMgGraphRequestParams = @{
    Method = 'DELETE'
    Uri    = "beta/deviceManagement/reusablePolicySettings('{0}')" -f $Id
  }
  
  Invoke-MgGraphRequest @InvokeMgGraphRequestParams
}

function Get-CWJMdeDcReusableSettings
{
  param(
    [Parameter()]
    [string]
    $Id
  )

  $uri = 'beta/deviceManagement/reusablePolicySettings'

  if($PSBoundParameters.ContainsKey('Id'))
  {    
    $filter = "id eq '{0}'" -f $Id
    $uri = '{0}?$filter={1}' -f $uri, $filter
  }

  $InvokeMgGraphRequestParams = @{
    Method = 'GET'
    Uri    = $uri
  }
  
  Invoke-MgGraphRequest @InvokeMgGraphRequestParams
}





function Build-CWJMdeDcPolicyIncludedOrExcludedIdListPayload
{
    param(
        [switch]
        $Excluded,

        [Parameter(Mandatory=1)]
        [string]
        $Id
    )


    if($Excluded)
    {
        $IncludedOrExcluded = 'excluded'
    }
    else
    {
        $IncludedOrExcluded = 'included'
    }

    $IncludedOrExcludedIdListPayload = @{
        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
        'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{{ruleid}}_ruledata_{0}idlist_groupid' -f $IncludedOrExcluded
        'simpleSettingValue' = @{
            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationReferenceSettingValue'
            'value' = $Id
        }
    }

    return $IncludedOrExcludedIdListPayload

}




function Build-CWJMdeDcPolicyPayload
{
    param(
        [Parameter()]
        [string]
        $Id,
    
        [Parameter(Mandatory=1)]
        [string]
        $Name,
    
        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [string]
        $IncludedIdList,

        [Parameter()]
        [string]
        $ExcludedIdList

        
    
    )












    $Policy = @{
        'creationSource' = $null
        'platforms' = 'windows10'
        'technologies' = 'mdm,microsoftSense'
        'roleScopeTagIds' = @(
            '0'
        )
        'settings' = @(
            @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
                'settingInstance' = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}'
                    'groupSettingCollectionValue' = @(
                        @{
                            'children' = @(
                                @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata'
                                    'groupSettingCollectionValue' = @(
                                        @{
                                            'children' = @(
                                                @{
                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_name'
                                                    'simpleSettingValue' = @{
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                        'value' = $Name
                                                    }
                                                }
                                                @{
                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_includedidlist'
                                                    'groupSettingCollectionValue' = @(
                                                        @{
                                                            'children' = @(
                                                                @{
                                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_includedidlist_groupid'
                                                                    'simpleSettingValue' = @{
                                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationReferenceSettingValue'
                                                                        'value' = $IncludedIdList
                                                                    }
                                                                }
                                                            )
                                                        }
                                                    )
                                                }
                                                @{
                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_excludedidlist'
                                                    'groupSettingCollectionValue' = @(
                                                        @{
                                                            'children' = @(
                                                                @{
                                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_excludedidlist_groupid'
                                                                    'simpleSettingValue' = @{
                                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationReferenceSettingValue'
                                                                        'value' = $ExcludedIdList
                                                                    }
                                                                }
                                                            )
                                                        }
                                                    )
                                                }
                                                @{
                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry'
                                                    'groupSettingCollectionValue' = @(
                                                        @{
                                                            'children' = @(
                                                                @{
                                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_type'
                                                                    'choiceSettingValue' = @{
                                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                                                        'value' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_type_allow'
                                                                        'children' = @(
                                                                            @{
                                                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                                                'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_options'
                                                                                'choiceSettingValue' = @{
                                                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                                                                    'value' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_options_0'
                                                                                    'children' = @()
                                                                                }
                                                                            }
                                                                        )
                                                                    }
                                                                }
                                                                @{
                                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance'
                                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_accesmask'
                                                                    'choiceSettingCollectionValue' = @(
                                                                        @{
                                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                                                            'value' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_accesmask_32'
                                                                            'children' = @()
                                                                        }
                                                                        @{
                                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                                                            'value' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_accesmask_16'
                                                                            'children' = @()
                                                                        }
                                                                        @{
                                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                                                            'value' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_accesmask_8'
                                                                            'children' = @()
                                                                        }
                                                                        @{
                                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                                                            'value' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_accesmask_4'
                                                                            'children' = @()
                                                                        }
                                                                        @{
                                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                                                            'value' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_accesmask_2'
                                                                            'children' = @()
                                                                        }
                                                                        @{
                                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                                                            'value' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_accesmask_1'
                                                                            'children' = @()
                                                                        }
                                                                    )
                                                                }
                                                                @{
                                                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                                    'settingDefinitionId' = 'device_vendor_msft_defender_configuration_devicecontrol_policyrules_{ruleid}_ruledata_entry_id'
                                                                    'simpleSettingValue' = @{
                                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                                        'value' = '{2ff1733f-9a80-4e46-9e6a-a0953380eeb8}'
                                                                    }
                                                                }
                                                            )
                                                        }
                                                    )
                                                }
                                            )
                                        }
                                    )
                                    'settingInstanceTemplateReference' = @{
                                        'settingInstanceTemplateId' = '46c91d1a-89d2-4f6a-93f8-7a1dc4184024'
                                    }
                                }
                            )
                        }
                    )
                    'settingInstanceTemplateReference' = @{
                        'settingInstanceTemplateId' = 'a5c5409c-886a-4909-81c7-28156aee9419'
                    }
                }
            }
        )
        'templateReference' = @{
            'templateId' = '0f2034c6-3cd6-4ee1-bd37-f3c0693e9548_1'
            'templateFamily' = 'endpointSecurityAttackSurfaceReduction'
            'templateDisplayName' = 'Device Control'
            'templateDisplayVersion' = 'Version 1'
        }
    }


    if($Policy.ContainsKey('Id'))
    {
      $Policy.Add('id', $Id)
    }
  
    $Policy.Add('name', $Name)
    $Policy.Add('description', $Description)













    return $Policy
}

function New-CWJMdeDcPolicy
{
    param(
        [Parameter(Mandatory=1)]
        [string]
        $Name,
    
        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [string]
        $IncludedIdList,

        [Parameter()]
        [string]
        $ExcludedIdList

    )

    $PolicyPayload = Build-CWJMdeDcPolicyPayload @PSBoundParameters

    $PolicyPayloadJson = ConvertTo-Json -InputObject $PolicyPayload -Depth 100

    $InvokeMgGraphRequestParams = @{
        Method = 'POST'
        Uri    = "beta/deviceManagement/configurationPolicies"
        Body   = $PolicyPayloadJson
    }

    Invoke-MgGraphRequest @InvokeMgGraphRequestParams
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









function New-CWJMdeDcGroupXml
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Guid]
        $Guid = [Guid]::NewGuid(),

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [ValidateSet('FriendlyNameId','PrimaryId','VID_PID','BusId','DeviceId','HardwareId','InstancePathId','SerialNumberId','PID','VID','DeviceEncryptionStateId','GroupId')]
        [string]
        $DescriptorIdName = 'InstancePathId',

        [Parameter(ValueFromPipeline=1)]
        [string[]]
        $DescriptorIdValues,

        [Parameter()]
        [ValidateSet('MatchAny','MatchAll','MatchExcludeAny','MatchExcludeAll')]
        [string]
        $MatchType = 'MatchAny'
    )

    begin
    {
        $DescriptorIdValuesCombined = [System.Collections.ArrayList]::new()
    }

    process
    {
        foreach($DescriptorIdValue in $DescriptorIdValues)
        {
            [void]$DescriptorIdValuesCombined.Add($DescriptorIdValue)
        }
    }

    end
    {
        $XmlDocument = [System.Xml.XmlDocument]::new()

        $elementGroup = $XmlDocument.CreateElement('Group')
        $elementGroup.SetAttribute('Id', $Guid.ToString('B'))
        [void]$XmlDocument.AppendChild($elementGroup)

        $commentText = ' ./Vendor/MSFT/Defender/Configuration/DeviceControl/PolicyGroups/%7b{0}%7d/GroupData ' -f $Guid.ToString()
        $comment = $XmlDocument.CreateComment($commentText)
        [void]$elementGroup.AppendChild($comment)

        $elementMatchType = $XmlDocument.CreateElement('MatchType')
        $TextNode = $XmlDocument.CreateTextNode($MatchType)
        [void]$elementMatchType.AppendChild($TextNode)
        [void]$elementGroup.AppendChild($elementMatchType)

        $elementDescriptorIdList = $XmlDocument.CreateElement('DescriptorIdList')
        [void]$elementGroup.AppendChild($elementDescriptorIdList)

        foreach($DescriptorIdValue in $DescriptorIdValuesCombined)
        {
            $elementDescriptorId = $XmlDocument.CreateElement($DescriptorIdName)

            $TextNode = $XmlDocument.CreateTextNode($DescriptorIdValue)
            [void]$elementDescriptorId.AppendChild($TextNode)

            # This section for potential future use to include comment
            # $commentText = 'xxx'
            # $comment = $XmlDocument.CreateComment($commentText)
            # [void]$elementDescriptorIdList.AppendChild($comment)

            [void]$elementDescriptorIdList.AppendChild($elementDescriptorId)
        }

        $XmlWriterSettings = [System.Xml.XmlWriterSettings]::new()
        $XmlWriterSettings.Encoding = [System.Text.UTF8Encoding]::new($false)
        $XmlWriterSettings.Indent = $true
        $XmlWriterSettings.IndentChars = '    '
        $XmlWriterSettings.OmitXmlDeclaration = $true

        if($PSBoundParameters.ContainsKey('Path'))
        {
            $XmlWriter = [System.Xml.XmlWriter]::Create($Path, $XmlWriterSettings)
            $XmlDocument.Save($XmlWriter)
            $XmlWriter.Dispose()
        }
        else
        {
            $StringBuilder = [System.Text.StringBuilder]::new()
            $XmlWriter = [System.Xml.XmlWriter]::Create($StringBuilder, $XmlWriterSettings)
            $XmlDocument.Save($XmlWriter)
            $StringBuilder.ToString()
            $XmlWriter.Dispose()
        }
    }
}





function New-CWJMdeDcRuleXml
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Guid]
        $Guid = [Guid]::NewGuid(),

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [string]
        $Name, #TODO:supposed to default to "a"? Don't think so but...

        [Parameter()]
        [Guid[]]
        $IncludedIdList,

        [Parameter()]
        [Guid[]]
        $ExcludedIdList,

        [Parameter()]
        [Hashtable[]]
        $Entries
    )

    #begin
    #{
    #    $DescriptorIdValuesCombined = [System.Collections.ArrayList]::new()
    #}

    #process
    #{
    #    foreach($DescriptorIdValue in $DescriptorIdValues)
    #    {
    #        [void]$DescriptorIdValuesCombined.Add($DescriptorIdValue)
    #    }
    #}

    #end
    #{
        $XmlDocument = [System.Xml.XmlDocument]::new()

        $elementPolicyRule = $XmlDocument.CreateElement('PolicyRule')
        $elementPolicyRule.SetAttribute('Id', $Guid.ToString('B'))
        [void]$XmlDocument.AppendChild($elementPolicyRule)

        $commentText = ' ./Vendor/MSFT/Defender/Configuration/DeviceControl/PolicyRules/%7b{0}%7d/RuleData ' -f $Guid.ToString()
        $comment = $XmlDocument.CreateComment($commentText)
        [void]$elementPolicyRule.AppendChild($comment)

        $elementName = $XmlDocument.CreateElement('Name')
        $TextNode = $XmlDocument.CreateTextNode($Name)
        [void]$elementName.AppendChild($TextNode)
        [void]$elementPolicyRule.AppendChild($elementName)

        $elementIncludedIdList = $XmlDocument.CreateElement('IncludedIdList')
        [void]$elementPolicyRule.AppendChild($elementIncludedIdList)

        foreach($IncludedId in $IncludedIdList)
        {
            $elementGroupId = $XmlDocument.CreateElement('GroupId')
            $TextNode = $XmlDocument.CreateTextNode($IncludedId.ToString('B'))
            [void]$elementGroupId.AppendChild($TextNode)
            [void]$elementIncludedIdList.AppendChild($elementGroupId)
        }

        $elementExcludedIdList = $XmlDocument.CreateElement('ExcludedIdList')
        [void]$elementPolicyRule.AppendChild($elementExcludedIdList)

        foreach($ExcludedId in $ExcludedIdList)
        {
            $elementGroupId = $XmlDocument.CreateElement('GroupId')
            $TextNode = $XmlDocument.CreateTextNode($ExcludedId.ToString('B'))
            [void]$elementGroupId.AppendChild($TextNode)
            [void]$elementExcludedIdList.AppendChild($elementGroupId)
        }

        foreach($Entry in $Entries)
        {
            $elementEntry = $XmlDocument.CreateElement('Entry')
            $elementEntry.SetAttribute('Id', [Guid]::NewGuid().ToString('B')) #TODO:allow specifying?
            [void]$elementPolicyRule.AppendChild($elementEntry)

            'Type', 'Options', 'AccessMask', 'Sid', 'ComputerSid' | %{
                if($Entry.ContainsKey($_))
                {
                    $elementEntryElement = $XmlDocument.CreateElement($_)
                    $TextNode = $XmlDocument.CreateTextNode($Entry.Item($_))
                    [void]$elementEntryElement.AppendChild($TextNode)
                    [void]$elementEntry.AppendChild($elementEntryElement)
                }
            }
        }

        $XmlWriterSettings = [System.Xml.XmlWriterSettings]::new()
        $XmlWriterSettings.Encoding = [System.Text.UTF8Encoding]::new($false)
        $XmlWriterSettings.Indent = $true
        $XmlWriterSettings.IndentChars = '    '
        $XmlWriterSettings.OmitXmlDeclaration = $true

        if($PSBoundParameters.ContainsKey('Path'))
        {
            $XmlWriter = [System.Xml.XmlWriter]::Create($Path, $XmlWriterSettings)
            $XmlDocument.Save($XmlWriter)
            $XmlWriter.Dispose()
        }
        else
        {
            $StringBuilder = [System.Text.StringBuilder]::new()
            $XmlWriter = [System.Xml.XmlWriter]::Create($StringBuilder, $XmlWriterSettings)
            $XmlDocument.Save($XmlWriter)
            $StringBuilder.ToString()
            $XmlWriter.Dispose()
        }
    #}
}
