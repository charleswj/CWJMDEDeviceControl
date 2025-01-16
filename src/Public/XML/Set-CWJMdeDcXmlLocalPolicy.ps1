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

    
    # if($PSCmdlet.ParameterSetName -eq 'InputObject')
    # {
    #     $XmlDocument = $InputObject
    # }
    # else
    # {
    #     $XmlDocument = [System.Xml.XmlDocument]::new()

    #     $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)

    #     $XmlDocument.Load($Path)
    # }



    # $detectedNodeName = $XmlDocument.SelectSingleNode('/').FirstChild.LocalName

    # if($detectedNodeName -cnotin 'PolicyRules','PolicyGroups')
    # {
    #     Write-Error 'Invalid XML input' -ErrorAction Stop
    # }

    
    # $xmlString = _writeXml -InputObject $XmlDocument

    
    # $ValueName = '{0}_Test' -f $detectedNodeName #TODO: remove this

    # $SetItemPropertyParams = @{
    #     Path  = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager'
    #     Name  = $ValueName
    #     Value = $xmlString
    # }

    # Set-ItemProperty @SetItemPropertyParams

    # #TODO:create key if missing
}