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
        [ValidateNotNullOrEmpty()]
        $Sid, #TODO:multiple allowed?
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $ComputerSid #TODO:multiple allowed?
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
            # elseif($_ -eq 'Sid')
            elseif($_ -in 'Sid','ComputerSid')
            {
                # Detect whether Sid/ComputerSid is a valid Sid or GUID, or throw

                $valueNew = $null

                $valueOriginal = $ExecutionContext.SessionState.PSVariable.Get($_).Value

                try{ $valueNew=[System.Security.Principal.SecurityIdentifier]::new($valueOriginal) }catch{}
                try{ $valueNew=[guid]::new($valueOriginal)                                         }catch{}

                if($null -eq $valueNew)
                {
                    throw ('''{0}'' is not a valid SID or GUID for the {1} parameter' -f $valueOriginal, $_)
                }
                else
                {
                    $ExecutionContext.SessionState.PSVariable.Set($_, $valueNew)
                }
                $value = $valueNew
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