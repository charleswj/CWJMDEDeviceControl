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
        [System.Security.Principal.SecurityIdentifier]
        $Sid, #TODO:multiple allowed?
        
        [Parameter()]
        [System.Security.Principal.SecurityIdentifier]
        $ComputerSid
    )

    
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
            else
            {
                $value = $ExecutionContext.SessionState.PSVariable.Get($_).Value
            }
            $entry.Add($_, $value)
        }
    }

    return $entry
}