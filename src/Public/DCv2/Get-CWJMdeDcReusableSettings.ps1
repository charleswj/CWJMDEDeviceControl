function Get-CWJMdeDcReusableSettings
{
    [CmdletBinding(DefaultParameterSetName='default')]
    param(
        [Parameter(ParameterSetName='Id')]
        [string]
        $Id,

        [Parameter(ParameterSetName='DisplayName')]
        [string]
        $DisplayName

        # [Parameter()]
        # [switch]
        # $IncludeSettings #TODO delete or actually use
    )

    #TODO: will likely truncate when >100 Reusable Settings

    $uriPath = 'beta/deviceManagement/reusablePolicySettings'

    $selectProperties = [System.Collections.Generic.List[string]]@(
        'id'
        'displayname'
        'description'
        'lastModifiedDateTime'
        'version'
        'referencingConfigurationPolicyCount'
        'settinginstance'
    )

    $uriQueryStringElements = [System.Collections.Generic.List[string]]::new()
    $uriQueryStringFilterElements = [System.Collections.Generic.List[string]]::new()

    if($PSBoundParameters.ContainsKey('Id'))
    {
        $uriPath = $uriPath, $Id -join '/'
    }
    elseif($PSBoundParameters.ContainsKey('DisplayName'))
    {    
        $uriQueryStringFilterElements.Add(("displayname eq '{0}'" -f $DisplayName))
    }
    else
    {
        [void]$selectProperties.Remove('settinginstance')
    }

    # only filter out non-device control reusable settings if not specifying by ID (because then filter isn't supported)
    if(-not $PSBoundParameters.ContainsKey('Id'))
    {
        $uriQueryStringFilterElements.Add(("settingDefinitionId eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata'"))
    }

    if($uriQueryStringFilterElements.Count -gt 0)
    {
        $uriQueryStringFilter = $uriQueryStringFilterElements -join ' and '
        $uriQueryStringElements.Add(('$filter={0}' -f $uriQueryStringFilter))
    }

    $uriQueryStringSelect = $selectProperties -join ','
    $uriQueryStringElements.Add(('$select={0}' -f $uriQueryStringSelect))

    $uriQueryString = $uriQueryStringElements -join '&'

    $uri = $uriPath, $uriQueryString -join '?'

    $InvokeMgGraphRequestParams = @{
        Method = 'GET'
        Uri    = $uri
    }

    $global:response = Invoke-MgGraphRequest @InvokeMgGraphRequestParams

    if($response.'@odata.context' -like '*/$entity')
    {
        $responseItems = $response
    }
    else
    {
        $responseItems = $response.value
    }

    foreach($item in $responseItems)
    {
        if($item.ContainsKey('settinginstance'))
        {
            $settinginstanceChildren = $item.Item('settinginstance').Item('groupSettingCollectionValue')[0].Item('children')
            
            $thing3 = foreach($thing1 in $settinginstanceChildren.Where{$_.settingDefinitionId -like '*_descriptoridlist'})
            {
                foreach($thing2 in $thing1.groupSettingCollectionValue[0].Item('children'))
                {
                    #TODO: hide when DescriptorIdName="name"?
                    [pscustomobject]@{
                        DescriptorIdName  = $thing2.Item('settingDefinitionId') -replace '.*_'
                        DescriptorIdValue = $thing2.Item('simpleSettingValue').Item('Value')
                    }
                }
            }

            $outputGroupObject = [pscustomobject]@{
                Id            = [guid]$settinginstanceChildren.Where{$_.settingDefinitionId -like '*_id'}.simpleSettingValue.Item('value')
                MatchType     = $settinginstanceChildren.Where{$_.settingDefinitionId -like '*_matchtype'}.choiceSettingValue.Item('value') -replace '.*_'
                DescriptorIds = $thing3
            }
        }
        else
        {
            $outputGroupObject = $null
        }

        [pscustomobject]@{
            Id                  = $item.Item('id')
            DisplayName         = $item.Item('displayname')
            Description         = $item.Item('description')
            LastModified        = $item.Item('lastModifiedDateTime')
            Version             = $item.Item('version')
            UsedInNumberOfRules = $item.Item('referencingConfigurationPolicyCount')
            # settinginstance     = $item.Item('settinginstance') #TODO remove this later
            Group               = $outputGroupObject
        }
    }
}
