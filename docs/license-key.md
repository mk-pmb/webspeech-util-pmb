
FAQ: WebSpeech license keys
===========================


* __Why a license key? Isn't WebSpeech freeware?__

  Somewhat. It wasn't meant to require a license key from the user who
  installs WebSpeech. You can install it without one, it won't even ask
  for a license key. The license key is meant to be required from
  content providers, i.e. website owners or software vendors
  who wanted to make WebSpeech work with their website or program.
  When you write your own program to access the `Logox4.dll`,
  WebSpeech can't know you wrote that yourself. To WebSpeech, you look
  like any random (commercial) software vendor who should need a license.


* __Can I use WebSpeech without a license key?__

  Partially:

  If you manage to make its toolbar work in Internet Explorer*,
  it will happily read text from `file://` URLs.
  (* originally MSIE 4, it also worked for me
  in MSIE 6 in Wine v1.8 pretending to be win2k.)

  If you'd prefer not to run MSIE (e.g. to save memory),
  you can use the WebSpeech control panel applet's voice preview
  (the "test" button at the bottom) as a light-weight (although very limited)
  reader program.

  For more details see [automatic input](auto-input.md)
  and just ignore the automation hints if you prefer manual mode.


* __What happens if I mistype the license key?__

  When using an invalid key, each(!) attempt to speak some text will
  result in a message box and an audio announcement, both in German,
  saying something like "This program is not authorized to use Logox.
  Please tell G-DATA about this! Click OK to continue anyway." – and
  it will read the text only after OK was clicked.

  * The dialog will not close before the audio announcement has finished
    playing. If you click "OK" earlier, the button will remain in "pressed"
    state until the window closes.
  * `LogoxSpeak()` will block the calling thread for as long as the dialog
    is showing. (With a valid license, it will return very quickly.)


* __Where can I get a license key?__

  Theoretically, from G-DATA. In June 2018 I called the phone number
  mentioned at the bottom of the "intro" page of the manual and it
  still worked. However, the sales agent couldn't arrange a deal for
  such old software, didn't even know who could. He recommended I
  contact G-DATA in writing, so my request could be relayed to someone
  in charge. Maybe I'll do that some other day.


* __I had a license key back in the days but I lost it. :-(
  Is it possible to recover it from my Logox-enabled application's binary?__

  Yes, wine might be able to recover it.
  Make sure you have the correct (intended) version of the binary,
  and you've verified you're allowed to recover that key.
  The software part then is quite easy:

  `WINEARCH=win32 WINEDEBUG=fixme-all,+snoop wine your-program.exe  |& grep -Fe 'LogoxLicense'`

  The `+snoop` debug option makes wine monitor function calls between native
  DLLs, which includes your program's `LogoxLicense` call to `Logox4.dll`.
  It should print at least one line that looks like
  `CALL Logox4.LogoxLicenseA(0000 "xxxxxxxxxxxxxxxx")`
  where the 0000 is some hex number and the text in quotes is your key.


* __Is it possible to automate the control panel applet's speech preview?__

  Yes, see [auto-input.md](auto-input.md).


* __How does the Logox server verify the license?__

  My current hypothesis is that it stores some flag or secret in the DLL
  instance that is local to the thread that called `LogoxLicense()`.
  It seems that a thread can call `LogoxLicense()` as often as it wants,
  and as soon as a valid license key is supplied, the authorization sticks.
  This means you can not undo the unlocking alter by just sending an invalid
  key. Beware of that if your code runs as part of another program (e.g.
  it's a DLL or a control panel applet) and you prefer to not share your
  authorization with the host program.
  The only way I found to avoid this sharing is to use an independent
  thread for all communication with the Logox server.





