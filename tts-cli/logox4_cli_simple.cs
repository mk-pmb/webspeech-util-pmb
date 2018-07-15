using System;
using System.Threading;
using System.Collections.Generic;
using lgx = Logox4SpeechApi;
using cpl = LogoxWebSpeech4Cpl;

namespace Logox4CliSimple {

  class Program {
    public static Queue<string> readLnInputQ = null;
    public static string inputBuffer = "";
    public const uint errNoSuchFont = 0xFFFFFFFF;

    public static bool fail(string why) {
      Console.Error.WriteLine("-ERR {0}", why);
      Environment.Exit(3);
      return false;
    }

    public static string nullStr(string s, string d = "") {
      return (s == null ? d : s);
    }

    public static string getEnv(string varname) {
      return nullStr(Environment.GetEnvironmentVariable(varname));
    }

    [STAThread]
    static void Main(string[] cliArgs) {
      readLnInputQ = new Queue<string>(cliArgs);
      if (!lgx.LogoxInitialize()) { fail("init"); }
      sendLicense(getEnv("LOGOX_LICKEY"));
      lgx.LogoxNotifyModeLocal();
      while (true) { cmdPrompt(); }
    }

    static bool sendLicense(string licenseKey) {
      if (licenseKey == null) { return false; }
      licenseKey = licenseKey.Trim();
      if (licenseKey == "") { return false; }
      if (lgx.LogoxLicense(licenseKey)) { return true; }
      /* If that failed, the server wasn't able to even *receive* our key.
        lgx.LogoxLicense() will *NOT* indicate whether the key is legit.

        When using an invalid key, each(!) attempt to speak some text will
        result in a message box and an audio announcement, both in German,
        saying something like "This program is not authorized to use Logox.
        Please tell G-DATA about this! Click ok to continue anyway." – and
        it will read the text only after OK was clicked.
      */
      return fail("license_fubar");
    }

    public static string readLn(string ifNull = "") {
      if (readLnInputQ.Count > 0) { return readLnInputQ.Dequeue(); }
      string ln = Console.ReadLine();
      if (ln == null) { return ifNull; }
      return ln.TrimEnd();
    }

    public static bool sayOk(string msg) {
      Console.WriteLine("+OK {0}", msg);
      return true;
    }

    public static bool sayNay(string msg) {
      Console.WriteLine("-ERR {0}", msg);
      return true;
    }

    public static bool cmdPrompt() {
      //Console.Error.Write("> ");
      string cmd = readLn(null);
      if (cmd == null) {
        sayNay("input channel ended");
        Environment.Exit(0);
      }
      if (cmd == "") { return true; }
      if (cmd[0] != '.') { inputBuffer += cmd + "\n"; return true; }
      cmd = cmd.Substring(1);
      if (cmd == "quit") {
        Console.WriteLine("+OK goodbye!");
        Environment.Exit(0);
      }
      if (cmd == "") { cmd = "noop"; }
      if (cmd == "noop") { return sayOk("still alive!"); }
      if (cmd == "clear") {
        inputBuffer = "";
        return sayOk("fresh");
      }
      if (cmd == "lickey") {
        if (sendLicense(readLn())) { return sayOk("sent"); }
        return sayNay("no data");
      }
      if (cmd == "dump") {
        Console.WriteLine("+OK >> {0} ", inputBuffer.Length);
        Console.WriteLine("{0} ", inputBuffer);
        Console.WriteLine("<<");
        return true;
      }
      if (cmd == "reinit") { return reinitLogox("fresh"); }
      if (cmd == "speak") {
        lgx.LogoxSpeak(inputBuffer, 0);
        return sayOk("speaking");
      }
      if (cmd == "stop") {
        lgx.LogoxStop();
        return sayOk("stopped");
      }
      if (cmd == "sleep") {
        Thread.Sleep((int)(double.Parse(readLn("0")) * 1e3));
        return sayOk("slept");
      }
      if (cmd == "cpl") {
        cpl.showDialogInNewThread();
        return sayOk("launched");
      }
      if (cmd == "cpl.modal") {
        cpl.showDialogModalClean();
        return reinitLogox("finished");
      }
      if (cmd == "cpl.test") {
        if (!cpl.testDialog()) {
          return sayNay("applet window did not appear");
        }
        return reinitLogox("test passed");
      }
      if (cmd == "base64utf8") { return convert_base64utf8(); }
      if (cmd == "base64ansi") { return convert_base64ansi(); }
      if (cmd == "font_alias") { return setFontByAlias(); }
      if (cmd == "stats") { return showStats(); }
      if (cmd == "fonts") { return listFonts(); }
      double slider = getSliderByName(cmd);
      if (!double.IsNaN(slider)) { return cmdSlider(cmd, slider); }
      return sayNay("unknown_command " + cmd);
    }

    public static bool reinitLogox(string msg) {
      if (!lgx.LogoxInitialize()) { return sayNay("reinit failed"); }
      if (msg == null) { return true; }
      return sayOk(msg);
    }

    public static bool convert_base64utf8() {
      byte[] bytes = System.Convert.FromBase64String(inputBuffer);
      inputBuffer = System.Text.Encoding.UTF8.GetString(bytes);
      return true;
    }

    public static bool convert_base64ansi() {
      byte[] bytes = System.Convert.FromBase64String(inputBuffer);
      inputBuffer = System.Text.Encoding.GetEncoding(1252).GetString(bytes);
      return true;
    }

    public static bool cmdSlider(string name, double val) {
      string upd = readLn();
      if (upd != "") { setSliderByName(name, double.Parse(upd)); }
      Console.WriteLine("+OK {0}", val);
      return true;
    }

    public static bool setSliderByName(string name, double val) {
      if (name == "vol_db") {
        lgx.LogoxSetLocalVolume((int)(val * 10.0));
        return true;
      }
      if (name == "speed_pr") {
        lgx.LogoxSetLocalSpeed((int)val);
        return true;
      }
      if (name == "pitch_hz") {
        lgx.LogoxSetLocalPitch((int)(val * 10.0));
        return true;
      }
      if (name == "inton_pr") {
        lgx.LogoxSetLocalIntonation((int)val);
        return true;
      }
      if (name == "rough_hz") {
        lgx.LogoxSetLocalRoughness((int)(val * 10.0));
        return true;
      }
      return false;
    }

    public static double getSliderByName(string name) {
      if (name == "vol_db") { return lgx.LogoxGetLocalVolume() / 10.0; }
      if (name == "speed_pr") { return lgx.LogoxGetLocalSpeed(); }
      if (name == "pitch_hz") { return lgx.LogoxGetLocalPitch() / 10.0; }
      if (name == "inton_pr") { return lgx.LogoxGetLocalIntonation(); }
      if (name == "rough_hz") { return lgx.LogoxGetLocalRoughness() / 10.0; }
      return double.NaN;
    }

    public static bool setFontByAlias() {
      string alias = readLn();
      uint nFont = lgx.LogoxFindFontAlias(alias);
      if (nFont == errNoSuchFont) { return sayNay("font_not_found"); }
      lgx.LogoxSetLocalFont(nFont);
      return sayOk("font_selected");
    }

    public static byte[] splitLong(long n) {
      return new byte[]{
        (byte)((n >> 24) & 0xFF),
        (byte)((n >> 16) & 0xFF),
        (byte)((n >> 8) & 0xFF),
        (byte)(n & 0xFF),
      };
    }

    public static bool showStats() {
      Console.WriteLine(":version: {0}",
        String.Join(".", splitLong(lgx.LogoxDLLVersion())));
      Console.WriteLine(":nFonts: {0}", lgx.LogoxGetNumberOfFonts());
      return sayOk("end");
    }

    public static bool listFonts() {
      uint nFonts = lgx.LogoxGetNumberOfFonts();
      for (uint idx = 0; idx < nFonts; idx += 1) {
        Console.WriteLine(":{0}.name: {1}", idx,
          lgx.LogoxGetFontName(idx));
        Console.WriteLine(":{0}.uuid: {1}", idx,
          lgx.LogoxGetFontUUID(idx));
        Console.WriteLine(":{0}.alias: {1}", idx,
          lgx.LogoxGetFontAlias(idx));
        Console.WriteLine(":{0}.date: {1}", idx,
          lgx.LogoxGetFontDate(idx));
        Console.WriteLine(":{0}.version: {1}", idx,
          lgx.LogoxGetFontVersion(idx));
        Console.WriteLine(":{0}.flags: 0x{1}", idx,
          Convert.ToString(lgx.LogoxGetFontFlags(idx), 16).PadLeft(8, '0'));
      }
      return sayOk("end");
    }










  }
}
