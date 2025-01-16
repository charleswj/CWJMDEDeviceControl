function New-CWJMdeDcXmlGroup
{
    [Alias('New-CWJMdeDcGroupXml')] #TODO: temporary to ensure old function names still work
    [CmdletBinding()]
    param(
        [Parameter()]
        [Guid]
        $Guid = [Guid]::NewGuid(),

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [ValidateSet('FriendlyNameId','PrimaryId','VID_PID','BusId','DeviceId','HardwareId','InstancePathId','SerialNumberId','PID','VID','DeviceEncryptionStateId','GroupId')]
        [string]
        $DescriptorIdName = 'InstancePathId',

        [Parameter(ValueFromPipeline=1)]
        [string[]]
        $DescriptorIdValues,

        [Parameter()]
        [ValidateSet('MatchAny','MatchAll','MatchExcludeAny','MatchExcludeAll')]
        [string]
        $MatchType = 'MatchAny'
    )

    begin
    {
        $DescriptorIdValuesCombined = [System.Collections.ArrayList]::new()
    }

    process
    {
        foreach($DescriptorIdValue in $DescriptorIdValues)
        {
            [void]$DescriptorIdValuesCombined.Add($DescriptorIdValue)
        }
    }

    end
    {
        $XmlDocument = [System.Xml.XmlDocument]::new()

        $elementGroup = $XmlDocument.CreateElement('Group')
        $elementGroup.SetAttribute('Id', $Guid.ToString('B'))
        [void]$XmlDocument.AppendChild($elementGroup)

        $commentText = ' ./Vendor/MSFT/Defender/Configuration/DeviceControl/PolicyGroups/%7b{0}%7d/GroupData ' -f $Guid.ToString()
        $comment = $XmlDocument.CreateComment($commentText)
        [void]$elementGroup.AppendChild($comment)

        $elementMatchType = $XmlDocument.CreateElement('MatchType')
        $TextNode = $XmlDocument.CreateTextNode($MatchType)
        [void]$elementMatchType.AppendChild($TextNode)
        [void]$elementGroup.AppendChild($elementMatchType)

        $elementDescriptorIdList = $XmlDocument.CreateElement('DescriptorIdList')
        [void]$elementGroup.AppendChild($elementDescriptorIdList)

        foreach($DescriptorIdValue in $DescriptorIdValuesCombined)
        {
            $elementDescriptorId = $XmlDocument.CreateElement($DescriptorIdName)

            $TextNode = $XmlDocument.CreateTextNode($DescriptorIdValue)
            [void]$elementDescriptorId.AppendChild($TextNode)

            # This section for potential future use to include comment
            # $commentText = 'xxx'
            # $comment = $XmlDocument.CreateComment($commentText)
            # [void]$elementDescriptorIdList.AppendChild($comment)

            [void]$elementDescriptorIdList.AppendChild($elementDescriptorId)
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
}