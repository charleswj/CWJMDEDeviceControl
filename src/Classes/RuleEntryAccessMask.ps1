Add-Type -Language CSharp -TypeDefinition @'
//using System
namespace CWJ.Modules.CWJMDEDeviceControl
{
    //[Flags]
    public enum RuleEntryAccessMask
    {
        None             = 0,
        DeviceRead       = 1,
        DeviceWrite      = 2,
        DeviceExecute    = 4,
        DeviceAll        = DeviceRead | DeviceWrite | DeviceExecute,
        FileRead         = 8,
        Read             = DeviceRead | FileRead,
        FileWrite        = 16,
        Write            = DeviceWrite | FileWrite,
        FileExecute      = 32,
        Execute          = DeviceExecute | FileExecute,
        FileAll          = FileRead | FileWrite | FileExecute,
        DeviceAndFileAll = DeviceAll | FileAll,
        Print            = 64,
        All              = DeviceAndFileAll | Print,
    }
}
'@