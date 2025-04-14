function Get-CWJMdeDcReusableSettingsOld
{
  [CmdletBinding(DefaultParameterSetName='default')]
  param(
    [Parameter(ParameterSetName='Id')]
    [string]
    $Id,

    [Parameter(ParameterSetName='DisplayName')]
    [string]
    $DisplayName
  )

  #TODO: will likely truncate when >100 Reusable Settings

  $uriPath = 'beta/deviceManagement/reusablePolicySettings'

  $uriQueryStringElements = [System.Collections.Generic.List[string]]::new()

  if($PSBoundParameters.ContainsKey('Id'))
  {    
    $filter = "id eq '{0}'" -f $Id
  }
  elseif($PSBoundParameters.ContainsKey('DisplayName'))
  {    
    $filter = "displayname eq '{0}'" -f $DisplayName
  }
  
  $selectProperties = 'id',
                      'displayname',
                      'description',
                      'settingDefinitionId',
                      'lastModifiedDateTime',
                      'version',
                      'referencingConfigurationPolicyCount'

  if($filter -ne $null)
  {
    $uriQueryStringElement = '$filter={0}' -f $filter
    $uriQueryStringElements.Add($uriQueryStringElement)

    $selectProperties += 'settinginstance'
  }

  $select = $selectProperties -join ','
  $uriQueryStringElement = '$select={0}' -f $select
  $uriQueryStringElements.Add($uriQueryStringElement)

  $uriQueryString = $uriQueryStringElements -join '&'
  
  $uri = '{0}?{1}' -f $uriPath, $uriQueryString

  $InvokeMgGraphRequestParams = @{
    Method = 'GET'
    Uri    = $uri
  }
  
  $response = Invoke-MgGraphRequest @InvokeMgGraphRequestParams

  $entries = $response.Item('value')

  foreach($entry in $entries)
  {
    $outputObject = [ordered]@{}

    foreach($selectProperty in $selectProperties)
    {
      $value = $entry.Item($selectProperty)

      # Write-Warning ('{0} [{1}]' -f $selectProperty,$value.GetType())

      $outputObject.Add($selectProperty, $value)
  
    }

    [pscustomobject]$outputObject

  }

  
}




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
  )

  #TODO: will likely truncate when >100 Reusable Settings

  $uriPath = 'beta/deviceManagement/reusablePolicySettings'

  $selectProperties = 'id',
                      'displayname',
                      'description',
                      'settingDefinitionId',
                      'lastModifiedDateTime',
                      'version',
                      'referencingConfigurationPolicyCount'

  $uriQueryStringElements = [System.Collections.Generic.List[string]]::new()

  if($PSBoundParameters.ContainsKey('Id'))
  {
    $uriPath = $uriPath, $Id -join '/'

    $selectProperties += 'settinginstance'
  }
  elseif($PSBoundParameters.ContainsKey('DisplayName'))
  {    
    $filter = "displayname eq '{0}'" -f $DisplayName

    $uriQueryStringElement = '$filter={0}' -f $filter
    $uriQueryStringElements.Add($uriQueryStringElement)

    $selectProperties += 'settinginstance'
  }
  
  $select = $selectProperties -join ','
  $uriQueryStringElement = '$select={0}' -f $select
  $uriQueryStringElements.Add($uriQueryStringElement)

  $uriQueryString = $uriQueryStringElements -join '&'
  
  $uri = '{0}?{1}' -f $uriPath, $uriQueryString

  $InvokeMgGraphRequestParams = @{
    Method = 'GET'
    Uri    = $uri
  }
  
  $response = Invoke-MgGraphRequest @InvokeMgGraphRequestParams


  return $response
  
  



  # $global:entries = $response.Item('value')
  # Write-Verbose 2
  # foreach($entry in $entries)
  # {
  #   # Write-Verbose 1
  #   $outputObject = [ordered]@{}

  #   foreach($selectProperty in $selectProperties)
  #   {
  #     $selectPropertyValue = $entry.Item($selectProperty)

  #     # Write-Warning ('{0} [{1}]' -f $selectProperty,$selectPropertyValue.GetType())

  #     $outputObject.Add($selectProperty, $selectPropertyValue)
  
  #   }

  #   [pscustomobject]$outputObject

  # }

  
}
