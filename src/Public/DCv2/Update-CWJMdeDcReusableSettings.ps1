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
