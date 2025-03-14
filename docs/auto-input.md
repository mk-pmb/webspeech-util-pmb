
Automatic input
===============

Currently there seems to be [no easy way to buy a license key](license-key.md),
so you might want to try and automate one of the free input methods that ship
with the default WebSpeech install:

* The browser bar for MSIE, or
* the speech preview provided in WebSpeech's control panel dialog.

It's feasible for both.

All voices installed by WebSpeech also work in the
[Logox 4 Demo App](logox4demo.md).



Basics
------

* `xdotool` can simulate mouse and keyboard input.
  * It provides a command to type arbitrary text, but that might be tricky
    or even unreliable for some characters.
    (At least some old version some years ago had trouble with keyboard
    layout differences on my system.)
  * It's probably easier to just type the "paste from clipboard" shortcut,
    having prepared the clipboard with a tool like `xclip`.

* `xvfb` can provide a separate virtual X display that won't interfere
  with your interactive X session. It's also handy for running X programs
  on computers that don't have graphics output in the first place.
  * Lower graphics (size/colorspace) = less RAM cost.
    If you control an app entirely via keyboard, a laughably tiny screen might
    suffice.
    You could also try using a tiny screen and then moving the window so the
    relevant parts become visible, unless either the app or a window manager
    try to be overly clever in protecting you from yourself.



MSIE + WebSpeech bar
====================

This was my preferred method when I used the old wine v1.8,
where WebSpeech ran very stable in MSIE 6.
Unfortunately, with more recent versions of wine,
IE6 started to crash on startup more often than not.
It might work for you though, so give it a try before downgrading wine.
In case you're able to debug the crash, please share your fix
(open an issue or PR to improve this guide).


Setup
-----

As far as I can remember, installation was mostly easy:

1. Configure wine to act as Windows 2000.
1. Make sure you run all WebSpeech related stuff in 32-bit wine mode.
    Nowadays in the age of 64-bit computing, this means make sure to
    have `WINEARCH=win32` set in your environment.
    * Also if wine runs too verbosely, try `WINEDEBUG=fixme-all,err-all`
1. `winetricks --unattended ie6`
1. `wine WebSpeech4.exe /silent`

The most trouble was reviewing MSIE's settings because my preferences
differed a lot from the defaults.


Method
------

Preparation:

1. Load a placeholder HTML file from disk into MSIE via `file://` protocol.
  * To easily and reliably address the window via `xdotool`,
    start the title of the document with a unique identifier,
    so it will become part of the window title.

Read some text:

1. Update the HTML file on disk.
1. Raise and focus the MSIE window.
1. Press F5 (refresh) and wait some fraction of a second.
    * If predicting the load time is too sloppy for your taste,
      you can put an image tag at the end of the HTML which notifies
      a local web server, or go even fancier with JavaScript.
1. Press F9 (read aloud).
    * To abort reading, press Esc.



Control Panel Applet
====================

Use this method if you cannot or don't want to start MSIE 6,
e.g. because it crashes or to save memory.


Setup
-----

* Basically, as above; in fortunate circumstances you might be able to skip
  installing MSIE.
* The only reason to install MSIE, or even just to trick the WebSpeech setup
  into thinking MSIE were available, is to make the setup not give up early,
  complaining about how MSIE isn't installed and therefor it won't bother
  installing WebSpeech.
* There may even be other ways to extract the files, independent of the
  regular installer procedure.
  * not `cabextract` v1.4 though: `no valid cabinets found`
  * `unzip cannot find zipfile directory in […]`
  * `p7zip Version 9.20 […] Can not open file as archive`


Method
------

Preparation:

1. Open the WebSpeech control panel applet, e.g. with
    `wine control.exe 'C:\Program Files\Common Files\WebSpeech.4.0\LgxIEControl.cpl'`

1. Adjust the voice selection as necessary.
    * Caveat: The dropdown shares the same hotkey (Alt+S) with the
      "Speechfonts (online)" link next to it.
      * To reliably focus the dropdown, press Alt+L, Alt+S.
      * Press Alt+S once more to reliably trigger the link.

1. Adjust the sliders as necessary.
    * To help you set the sliders via virtual keyboard instead of virtual
      clicking, the [`logox-webspeech4-cpl-facts` node package][npm-lgxfacts]
      has the numbers and data about slider ranges, precision and hotkeys.

Read some text:

* Focus the text input box: Alt+R, Tab, Tab.
* This also selects the text in it, so you can directly replace it
  with Ctrl+V.
* To speak the text: Alt+E
* Esc closes the window.
  * Closing the window is the only way I could find to abort speaking.

















  [npm-lgxfacts]: https://github.com/mk-pmb/logox-webspeech4-cpl-facts-js
