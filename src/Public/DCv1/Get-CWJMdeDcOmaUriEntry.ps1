function Get-CWJMdeDcOmaUriEntry
{
    [CmdletBinding(DefaultParameterSetName='default')]
    param(
        [Parameter(Mandatory=1)]
        [guid]
        $DeviceConfigurationId,
        
        [Parameter(Mandatory=1, ParameterSetName='DisplayName')]
        [string]
        $DisplayName,

        [Parameter(Mandatory=1, ParameterSetName='OmaUri')]
        [string]
        $OmaUri
    )


    $InvokeMgGraphRequestParams = @{
        Method = 'GET'
        Uri    = 'beta/deviceManagement/deviceConfigurations/{0}' -f $DeviceConfigurationId
    }

    $result = Invoke-MgGraphRequest @InvokeMgGraphRequestParams

    [PSCustomObject]$result.omaSettings.Where{
        $_.Item($PSCmdlet.ParameterSetName) -eq $ExecutionContext.SessionState.PSVariable.Get($PSCmdlet.ParameterSetName).Value
    }
}