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
