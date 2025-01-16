Add-Type -Language CSharp -TypeDefinition @'
namespace CWJ.Modules.CWJMDEDeviceControl
{
    public enum PrimaryId
    {
        //None,
        RemovableMediaDevices,
        CdRomDevices,
        WpdDevices,
        PrinterDevices,
    }
}
'@