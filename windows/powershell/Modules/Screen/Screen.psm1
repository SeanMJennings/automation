Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Display
{
    [StructLayout(LayoutKind.Sequential)]
    public struct DEVMODE
    {
        private const int CCHDEVICENAME = 0x20;
        private const int CCHFORMNAME = 0x20;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 0x20)]
        public string dmDeviceName;
        public short dmSpecVersion;
        public short dmDriverVersion;
        public short dmSize;
        public short dmDriverExtra;
        public int dmFields;
        public int dmPositionX;
        public int dmPositionY;
        public int dmDisplayOrientation;
        public int dmDisplayFixedOutput;
        public short dmColor;
        public short dmDuplex;
        public short dmYResolution;
        public short dmTTOption;
        public short dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 0x20)]
        public string dmFormName;
        public short dmLogPixels;
        public int dmBitsPerPel;
        public int dmPelsWidth;
        public int dmPelsHeight;
        public int dmDisplayFlags;
        public int dmDisplayFrequency;
        public int dmICMMethod;
        public int dmICMIntent;
        public int dmMediaType;
        public int dmDitherType;
        public int dmReserved1;
        public int dmReserved2;
        public int dmPanningWidth;
        public int dmPanningHeight;
    }

    [DllImport("user32.dll")]
    public static extern int EnumDisplaySettings(string lpszDeviceName, int iModeNum, ref DEVMODE lpDevMode);

    [DllImport("user32.dll")]
    public static extern int ChangeDisplaySettingsEx(string lpszDeviceName, ref DEVMODE lpDevMode, IntPtr hwnd, int dwflags, IntPtr lParam);
}
"@

function Set-LargestScreenResolution {
    param(
        [int]$Width,
        [int]$Height
    )

    Add-Type -AssemblyName System.Windows.Forms

    $screens = [System.Windows.Forms.Screen]::AllScreens | Sort-Object -Property @{Expression={$_.Bounds.Width * $_.Bounds.Height}} -Descending

    $largestScreen = $screens[0]
    $deviceName = $largestScreen.DeviceName

    $devMode = New-Object Display+DEVMODE
    $devMode.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf($devMode)
    [Display]::EnumDisplaySettings($deviceName, -1, [ref]$devMode)

    $devMode.dmPelsWidth = $Width
    $devMode.dmPelsHeight = $Height
    $devMode.dmFields = 0x180000

    [Display]::ChangeDisplaySettingsEx($deviceName, [ref]$devMode, [IntPtr]::Zero, 0, [IntPtr]::Zero)
}

function Set-HighResolution {
    Set-LargestScreenResolution -Width 3440 -Height 1440
}

function Set-LowResolution {
    Set-LargestScreenResolution -Width 2560 -Height 1440
}

Export-ModuleMember -Function Set-HighResolution, Set-LowResolution