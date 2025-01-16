function New-CWJMdeDcXmlRule
{
    [Alias('New-CWJMdeDcRuleXml')] #TODO: temporary to ensure old function names still work
    [CmdletBinding()]
    param(
        [Parameter()]
        [Guid]
        $Guid = [Guid]::NewGuid(),

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [string]
        $Name, #TODO:supposed to default to "a"? Don't think so but...

        [Parameter()]
        [Guid[]]
        $IncludedIdList,

        [Parameter()]
        [Guid[]]
        $ExcludedIdList,

        [Parameter()]
        [Hashtable[]]
        $Entries
    )

    $XmlDocument = [System.Xml.XmlDocument]::new()

    $elementPolicyRule = $XmlDocument.CreateElement('PolicyRule')
    $elementPolicyRule.SetAttribute('Id', $Guid.ToString('B'))
    [void]$XmlDocument.AppendChild($elementPolicyRule)

    $commentText = ' ./Vendor/MSFT/Defender/Configuration/DeviceControl/PolicyRules/%7b{0}%7d/RuleData ' -f $Guid.ToString()
    $comment = $XmlDocument.CreateComment($commentText)
    [void]$elementPolicyRule.AppendChild($comment)

    $elementName = $XmlDocument.CreateElement('Name')
    $TextNode = $XmlDocument.CreateTextNode($Name)
    [void]$elementName.AppendChild($TextNode)
    [void]$elementPolicyRule.AppendChild($elementName)

    $elementIncludedIdList = $XmlDocument.CreateElement('IncludedIdList')
    [void]$elementPolicyRule.AppendChild($elementIncludedIdList)

    foreach($IncludedId in $IncludedIdList)
    {
        $elementGroupId = $XmlDocument.CreateElement('GroupId')
        $TextNode = $XmlDocument.CreateTextNode($IncludedId.ToString('B'))
        [void]$elementGroupId.AppendChild($TextNode)
        [void]$elementIncludedIdList.AppendChild($elementGroupId)
    }

    $elementExcludedIdList = $XmlDocument.CreateElement('ExcludedIdList')
    [void]$elementPolicyRule.AppendChild($elementExcludedIdList)

    foreach($ExcludedId in $ExcludedIdList)
    {
        $elementGroupId = $XmlDocument.CreateElement('GroupId')
        $TextNode = $XmlDocument.CreateTextNode($ExcludedId.ToString('B'))
        [void]$elementGroupId.AppendChild($TextNode)
        [void]$elementExcludedIdList.AppendChild($elementGroupId)
    }

    foreach($Entry in $Entries)
    {
        $elementEntry = $XmlDocument.CreateElement('Entry')
        $elementEntry.SetAttribute('Id', $Entry.Item('Id')) #TODO:allow specifying?
        [void]$elementPolicyRule.AppendChild($elementEntry)

        'Type', 'Options', 'AccessMask', 'Sid', 'ComputerSid' | ForEach-Object{
            if($Entry.ContainsKey($_))
            {
                $elementEntryElement = $XmlDocument.CreateElement($_)
                $TextNode = $XmlDocument.CreateTextNode($Entry.Item($_))
                [void]$elementEntryElement.AppendChild($TextNode)
                [void]$elementEntry.AppendChild($elementEntryElement)
            }
        }
    }

    $_writeXmlParams = @{
        InputObject = $XmlDocument
    }
    if($PSBoundParameters.ContainsKey('Path'))
    {
        $_writeXmlParams.Add('Path', $Path)
    }
    _writeXml @_writeXmlParams
}