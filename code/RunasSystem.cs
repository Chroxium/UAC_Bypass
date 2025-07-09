using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.ServiceProcess;
using System.Threading;

public class TrustedInstallerService : ServiceBase {
    [DllImport("kernel32.dll")] static extern uint WTSGetActiveConsoleSessionId();
    [DllImport("advapi32.dll", SetLastError=true)] static extern bool OpenProcessToken(IntPtr h, uint a, out IntPtr t);
    [DllImport("advapi32.dll", SetLastError=true)] static extern bool DuplicateTokenEx(IntPtr e, uint a, IntPtr na, int l, int t, out IntPtr n);
    [DllImport("advapi32.dll", SetLastError=true)] static extern bool SetTokenInformation(IntPtr t, int c, ref uint v, uint s);
    [DllImport("userenv.dll", SetLastError=true)] static extern bool CreateEnvironmentBlock(out IntPtr e, IntPtr t, bool i);
    [DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Unicode)] static extern bool CreateProcessAsUser(IntPtr t, string a, string c, IntPtr pa, IntPtr ta, bool i, uint f, IntPtr e, string d, ref STARTUPINFO si, out PROCESS_INFORMATION pi);

    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
    public struct STARTUPINFO {
        public int cb; public string lpReserved, lpDesktop, lpTitle;
        public int x, y, xs, ys, xc, yc, fa, fl;
        public short w, cr2;
        public IntPtr r2, si, so, se;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct PROCESS_INFORMATION {
        public IntPtr hp, ht;
        public uint pid, tid;
    }

    private string _command;

    public TrustedInstallerService(string command) {
        _command = command;
    }

    protected override void OnStart(string[] args) {
        new Thread(() => {
            try {
                uint sid = WTSGetActiveConsoleSessionId();
                IntPtr t; if (!OpenProcessToken(Process.GetCurrentProcess().Handle, 0xF01FF, out t)) return;
                IntPtr d; if (!DuplicateTokenEx(t, 0xF01FF, IntPtr.Zero, 2, 1, out d)) return;
                if (!SetTokenInformation(d, 12, ref sid, 4)) return;

                IntPtr env; CreateEnvironmentBlock(out env, d, false);
                var si = new STARTUPINFO { cb = Marshal.SizeOf(typeof(STARTUPINFO)), lpDesktop = "winsta0\\default" };
                PROCESS_INFORMATION pi;
                CreateProcessAsUser(d, null, _command, IntPtr.Zero, IntPtr.Zero, false, 0x400, env, null, ref si, out pi);
            } catch {}
            Thread.Sleep(2000); Environment.Exit(0);
        }).Start();
    }

    protected override void OnStop() {}

    public static void Main(string[] args) {
        string exeToRun = args[0];
        Run(new TrustedInstallerService(exeToRun));
    }
}