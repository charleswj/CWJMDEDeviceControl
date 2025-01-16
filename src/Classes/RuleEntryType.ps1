Add-Type -Language CSharp -TypeDefinition @'
namespace CWJ.Modules.CWJMDEDeviceControl
{
    public enum RuleEntryType //or Type?
    {
        Allow,
        Deny,
        AuditAllow,
        AuditDeny,
    }
}
'@