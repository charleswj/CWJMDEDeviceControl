function Remove-CWJMdeDcReusableSettings
{
  param(
    [Parameter()]
    [string]
    $Id
  )

  $InvokeMgGraphRequestParams = @{
    Method = 'DELETE'
    Uri    = "beta/deviceManagement/reusablePolicySettings('{0}')" -f $Id
  }
  
  Invoke-MgGraphRequest @InvokeMgGraphRequestParams
}
