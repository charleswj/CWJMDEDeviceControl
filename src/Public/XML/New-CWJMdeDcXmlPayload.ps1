function New-CWJMdeDcXmlPayload
{
    [Alias('New-CWJMdeDcPayloadXml')] #TODO: temporary to ensure old function names still work
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=1, ValueFromPipeline=1)]
        [xml[]]
        $InputObject,

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [switch]
        $Compress
    )

    begin
    {
        $xmls = [System.Collections.Generic.List[xml]]::new()
    }

    process
    {
        $nodeNameToUse = $null

        foreach($xml in $InputObject)
        {
            $validNodeNames = @{
                Group      = 'PolicyGroups'
                PolicyRule = 'PolicyRules'
            }

            $detectedNodeName = $xml.SelectSingleNode('/').FirstChild.LocalName

            if($nodeNameToUse -eq $null)
            {
                $nodeNameToUse = $detectedNodeName
            }

            if($nodeNameToUse -cne $detectedNodeName)
            {
                Write-Error 'Mismatched XML input' -ErrorAction Stop
            }
            elseif($detectedNodeName -cnotin $validNodeNames.Keys)
            {
                Write-Error 'Invalid XML input' -ErrorAction Stop
            }

            $xmls.Add($xml)
        }
    }

    end
    {
        $XmlDocument = [System.Xml.XmlDocument]::new()

        $elementTop = $XmlDocument.CreateElement($validNodeNames.Item($nodeNameToUse))
        [void]$XmlDocument.AppendChild($elementTop)

        foreach($xml in $xmls)
        {
            [void]$elementTop.AppendChild($XmlDocument.ImportNode($xml.SelectSingleNode("/$nodeNameToUse"), $true))
        }

        $_writeXmlParams = @{
            InputObject = $XmlDocument
            Compress    = $Compress
        }
        if($PSBoundParameters.ContainsKey('Path'))
        {
            $_writeXmlParams.Add('Path', $Path)
        }
        _writeXml @_writeXmlParams
    }
}