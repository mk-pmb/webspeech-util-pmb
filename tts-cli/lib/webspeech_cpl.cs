using System;
using System.Threading;
using System.Diagnostics;
using System.Runtime.InteropServices;

public enum cplAppletMessages : uint {
    CPL_INIT = 1,
    CPL_GETCOUNT = 2,
    CPL_INQUIRE = 3,
    CPL_SELECT = 4,
    CPL_DBLCLK = 5,
    CPL_STOP = 6,
    CPL_EXIT = 7,
    CPL_NEWINQUIRE = 8,
    CPL_STARTWPARMS = 9,
    CPL_SETUP = 200,
}

public class LogoxWebSpeech4Cpl {
    const string cplName = "LgxIEControl.cpl";
    public static IntPtr cplHwnd = IntPtr.Zero;
    //public static IntPtr cplHwnd = new IntPtr(0x00010200);
    public static Thread latestCplThread = null;

    // orig: LONG CPlApplet(HWND hwndCPl, UINT uMsg, LPARAM lParam1, LPARAM lParam2);
    [DllImport("LgxIEControl.cpl")]
    public static extern Int32 CPlApplet(
        IntPtr hwndCPl,
        UInt32 uMsg,
        Int32 lParam1,
        Int32 lParam2);

    private static void failed(string verb) {
      throw new Exception(cplName + " failed to " + verb);
    }

    private static void cpl(cplAppletMessages msg, bool want0, string verb) {
      int ret = CPlApplet(cplHwnd, (uint)msg, 0, 0);
      bool got0 = (ret == 0);
      if (got0 != want0) { failed(verb); }
    }

    public static void init() {
      cpl(cplAppletMessages.CPL_INIT, false, "init");
    }

    public static void start() {
      cpl(cplAppletMessages.CPL_STARTWPARMS, true, "start");
    }

    [STAThread]
    public static Thread showDialogInNewThread() {
      latestCplThread = new Thread(new ThreadStart(showDialogModal));
      latestCplThread.Start();
      return latestCplThread;
    }

    [STAThread]
    public static void showDialogModal() {
      Stopwatch firstLaunch = Stopwatch.StartNew();
      cpl(cplAppletMessages.CPL_DBLCLK, true, "show its dialog");
      firstLaunch.Stop();
      long msec = firstLaunch.ElapsedMilliseconds;
      if (msec < 500) {
        Console.Error.WriteLine("W: Control panel applet terminated "
          + "suspiciously quickly. Probably a stillbirth, let's try again.");
        cpl(cplAppletMessages.CPL_DBLCLK, true, "show its dialog again");
      }
    }

    public static void showDialogModalClean() {
      showDialogModal();
      try { LogoxWebSpeech4Cpl.stop(); } catch {}
      try { LogoxWebSpeech4Cpl.exit(); } catch {}
    }

    [STAThread]
    public static bool testDialog() {
      // stub!
      return false;
      //showDialogModalClean();
      // ^- 2018-06-20: Running it in our main thread seems more stable;
      //    for reasons unknown, the main(!) app seemed to sometimes crash
      //    when running the CPL in a side thread.
    }

    public static void stop() {
      cpl(cplAppletMessages.CPL_STOP, true, "stop");
    }

    public static void exit() {
      cpl(cplAppletMessages.CPL_EXIT, true, "exit");
    }

}
