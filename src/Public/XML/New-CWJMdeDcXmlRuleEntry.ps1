function New-CWJMdeDcXmlRuleEntry
{
    [Alias('New-CWJMdeDcRuleEntryXml')] #TODO: temporary to ensure old function names still work
    [CmdletBinding()]
    param(
        [Parameter()]
        [Guid]
        $Guid = [Guid]::NewGuid(),

        [Parameter(Mandatory=1)]
        [CWJ.Modules.CWJMDEDeviceControl.RuleEntryType]
        $Type,
        
        [Parameter()]
        [int]
        $Options, #TODO:mandatory?
        
        [Parameter()]
        [CWJ.Modules.CWJMDEDeviceControl.RuleEntryAccessMask[]]
        $AccessMask, #TODO:mandatory?
        
        [Parameter()]
        $Sid, #TODO:multiple allowed?
        
        [Parameter()]
        [System.Security.Principal.SecurityIdentifier]
        $ComputerSid
    )

    
    # Detect whether $Sid is a valid Sid or GUID, or throw
    if($PSBoundParameters.ContainsKey('Sid'))
    {
        $sidFormatted = $null

        try{ $sidFormatted=[System.Security.Principal.SecurityIdentifier]::new($Sid) }catch{}
        try{ $sidFormatted=[guid]::new($Sid)                                         }catch{}

        if($null -eq $sidFormatted)
        {
            throw ('''{0}'' is not a valid SID or GUID.' -f $Sid)
        }
    }

  
    $entry = [ordered]@{}

    $entry.Add('Id', $Guid.ToString('B'))

    'Type', 'Options', 'AccessMask', 'Sid', 'ComputerSid' | ForEach-Object{
        if($PSBoundParameters.ContainsKey($_))
        {
            if($_ -eq 'AccessMask')
            {
                $value = $ExecutionContext.SessionState.PSVariable.Get($_).Value.Value__

                # get the sum of only unique enum values
                #TODO: is there a better way to do this?
                $value = (($value | Group-Object -NoElement).Name | Measure-Object -Sum).Sum
            }
            elseif($_ -eq 'Sid')
            {
                $value = $sidFormatted
            }
            else
            {
                $value = $ExecutionContext.SessionState.PSVariable.Get($_).Value
            }
            $entry.Add($_, $value)
        }
    }

    return $entry
}