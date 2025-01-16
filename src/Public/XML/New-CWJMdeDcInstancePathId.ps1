function New-CWJMdeDcInstancePathId
{
    [CmdletBinding()]
    param(
        [int]
        $NumberOfDevices = 0,

        [string]
        $TestDevicePrefix = 'USBSTOR\DISK&VEN_CWJ&PROD_CWJ&REV_0000\',

        [Parameter()]
        [Alias('AllowMyDevice')]
        [switch]
        $IncludeMyDevice,

        [Parameter()]
        [string]
        $MyDevice = 'USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE&REV_1100\0375017020006333&0',

        [Parameter()]
        [ValidateSet('Top','Middle','Bottom')]
        [string]
        $MyDeviceLocation = 'Middle'
    )

    if($PSBoundParameters.ContainsKey('IncludeMyDevice'))
    {        
        if($MyDeviceLocation -eq 'Top'   ){$MyDeviceEntryNumber=1}
        if($MyDeviceLocation -eq 'Middle'){$MyDeviceEntryNumber=[math]::Round($NumberOfDevices/2+1, [System.MidpointRounding]::ToZero)}
        if($MyDeviceLocation -eq 'Bottom'){$MyDeviceEntryNumber=$NumberOfDevices}
    }

    $Devices = [System.Collections.Generic.List[string]]::new()

    for($i=1 ; $i -le $NumberOfDevices ; $i++)
    {
        if($i -eq $MyDeviceEntryNumber)
        {
            $Devices.Add($MyDevice)
        }
        else
        {
            $Devices.Add(('{0}{1:000000000000}' -f $TestDevicePrefix, $i))
        }
    }

    $Devices
}