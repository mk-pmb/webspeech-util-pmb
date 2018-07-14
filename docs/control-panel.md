
Windows Control Panel API
=========================

Basics
------

In old versions of windows, control panel dialogs weren't
meant to be full-fledged applications. Instead, the windows control panel
provided a host program (`control.exe`) and would invite the applets
(`*.cpl`) to run inside of it.

  * __Roll your own applet:__
    Implement the [CPlApplet interface][msdn-cplapplet] in a DLL,
    then rename that DLL to `*.cpl`.

  * __Roll your own host:__
    Write a program that imports the `CplApplet` procedure from a DLL
    and send the expected messages according to the
    [CPlApplet interface spec][msdn-cplapplet].






  [msdn-cplapplet]: https://msdn.microsoft.com/en-us/library/windows/desktop/cc144199(v=vs.85).aspx
