function Set-CWJMdeDcXmlLocalPolicy
{
    [Alias('Set-CWJMdeDcLocalPolicyXml')] #TODO: temporary to ensure old function names still work
    [CmdletBinding(DefaultParameterSetName='InputObject')]
    param(
        [Parameter(Mandatory=1, ValueFromPipeline=1, ParameterSetName='InputObject')]
        [xml]
        $InputObject,

        [Parameter(Mandatory=1, ParameterSetName='Path')]
        [string]
        $Path
    )
    
    Write-Error 'Cmdlet deprecated, use Set-CWJMdeDcLocalPolicySetting with PolicyGroups and/or PolicyRules parameters' -ErrorAction Stop
}