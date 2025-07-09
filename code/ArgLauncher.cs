using System;
using System.Diagnostics;

class ArgLauncher
{
    static void Main()
    {
        var psi = new ProcessStartInfo
        {
            FileName = "%%EXE%%",
            Arguments = "%%ARGS%%",
            UseShellExecute = false,
            CreateNoWindow = %%HIDDEN%%
        };
        Process.Start(psi);
    }
}
