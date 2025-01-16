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
