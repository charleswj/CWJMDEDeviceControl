

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
