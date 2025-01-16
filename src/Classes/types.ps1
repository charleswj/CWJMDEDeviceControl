
<#
Add-Type -Language CSharp -TypeDefinition @'
namespace CWJ.Modules.CWJMDEDeviceControl
{
    public enum DescriptorIdName
    {
        FriendlyNameId,
        PrimaryId,
        VID_PID,
        BusId,
        DeviceId,
        HardwareId,
        InstancePathId,
        SerialNumberId,
        PID,
        VID,
        DeviceEncryptionStateId,
        GroupId,
    }
}
'@
#>

<#
Add-Type -Language CSharp -TypeDefinition @'
namespace CWJ.Modules.CWJMDEDeviceControl
{
    public enum MatchType
    {
        MatchAny
        MatchAll
        MatchExcludeAny
        MatchExcludeAll
    }
}
'@
#>




<#

Type          Option Value  Enum                          Description
------------  ------------  ----------------------------  -----------
Allow                    0  Nothing                       nothing
Allow                    4  DisableAuditAllowedDenied     disable AuditAllowed and AuditDenied for this entry. If Allow occurs and the AuditAllowed setting is configured, events aren't generated.
Deny                     0  Nothing                       nothing
Deny                     4  DisableAuditDenied            disable                  AuditDenied for this Entry. If Block occurs and the AuditDenied is setting configured, the system doesn't show notifications.
AuditAllowed             0  Nothing                       nothing
AuditAllowed             1  Nothing                       nothing
AuditAllowed             2  SendEvent                     send event
AuditDenied              0  Nothing                       nothing
AuditDenied              1  ShowNotification              show notification
AuditDenied              2  SendEvent                     send event
AuditDenied              3  ShowNotificationAndSendEvent  show notification and send event


Type          Option Value  Enum                          Description
------------  ------------  ----------------------------  -----------
Allow                    0  Nothing                       nothing
Deny                     0  Nothing                       nothing
AuditAllowed             0  Nothing                       nothing
AuditDenied              0  Nothing                       nothing

AuditAllowed             1  Nothing                       nothing
AuditDenied              1  ShowNotification              show notification

AuditAllowed             2  SendEvent                     send event
AuditDenied              2  SendEvent                     send event

AuditDenied              3  ShowNotificationAndSendEvent  show notification and send event

Allow                    4  DisableAuditAllowedDenied     disable AuditAllowed and AuditDenied for this entry. If Allow       occurs and the AuditAllowed             setting is configured, audit events aren't generated.
Deny                     4  DisableAuditDenied            disable                  AuditDenied for this entry. If       Block occurs and the              AuditDenied setting is configured, the system doesn't show notifications.


                                     +-------------- applies to --------------+
                                     |                                        |
value  name                          | Allow  Deny  AuditAllowed  AuditDenied |
-----  ----------------------------  | -----  ----  ------------  ----------- |
    0  Nothing
    1  ShowNotification                                                X
    2  SendEvent                                         X             X
    3* ShowNotificationAndSendEvent                                    X
    4  DisableAudit(Allowed)?Denied      X     X

#>



