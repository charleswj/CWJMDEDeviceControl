$InstancePathId = New-CWJMdeDcInstancePathId -NumberOfDevices 10

$group = New-CWJMdeDcGroupXml -Guid 00000000-0000-0000-0000-000000000001 -DescriptorIdValues $InstancePathId

$entries=@()

$entries += New-CWJMdeDcRuleEntryXml -Type Allow -Options 0 -AccessMask Read,Write,Execute

#$entries += New-CWJMdeDcRuleEntryXml -Type AuditDeny -Options 3 -AccessMask DeviceAll,FileAll

$rules=@()

$rules += New-CWJMdeDcRuleXml -IncludedIdList 00000000-0000-0000-0000-000000000001 -Entries $entries

$rules += New-CWJMdeDcRuleXml -IncludedIdList 00000000-0000-0000-0000-000000000001 -Entries $entries -Guid 99999999-9999-9999-9999-999999999999

$policygroups = New-CWJMdeDcPayloadXml -InputObject $group

$policyrules = New-CWJMdeDcPayloadXml -InputObject $rules

Set-CWJMdeDcLocalPolicySetting -PolicyGroups $policygroups

Set-CWJMdeDcLocalPolicySetting -PolicyRules $policyrules
