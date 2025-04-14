function _writeXml
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=1,ValueFromPipeline=1)]
        [xml]
        $InputObject,

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [switch]
        $Compress
    )

    $XmlDocument = $InputObject

    $XmlWriterSettings = [System.Xml.XmlWriterSettings]::new()
    $XmlWriterSettings.Encoding = [System.Text.UTF8Encoding]::new($false)
    $XmlWriterSettings.Indent = -not $Compress
    $XmlWriterSettings.IndentChars = '    '
    $XmlWriterSettings.OmitXmlDeclaration = $true

    if($PSBoundParameters.ContainsKey('Path'))
    {
        $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        
        $XmlWriter = [System.Xml.XmlWriter]::Create($Path, $XmlWriterSettings)
        $XmlDocument.Save($XmlWriter)
        $XmlWriter.Dispose()
    }
    else
    {
        $StringBuilder = [System.Text.StringBuilder]::new()
        $XmlWriter = [System.Xml.XmlWriter]::Create($StringBuilder, $XmlWriterSettings)
        $XmlDocument.Save($XmlWriter)
        $StringBuilder.ToString()
        $XmlWriter.Dispose()
    }
}