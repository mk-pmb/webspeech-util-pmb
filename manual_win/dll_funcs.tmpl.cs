using System;
using System.Text;
using System.Runtime.InteropServices;

public class Logox4SpeechApi {

    [DllImport("Logox4.dll")]
    [return: MarshalAs(UnmanagedType.U4)]
    public static extern uint LogoxGetFontUUID(
        [param: MarshalAs(UnmanagedType.U4)]
        uint nIndex,
        byte[] pUUID,
        [param: MarshalAs(UnmanagedType.U4)]
        uint nBytes);
    public static Guid LogoxGetFontUUID(uint nIndex) {
        uint length = 16;
        byte[] pUUID = new byte[length];
        LogoxGetFontUUID(nIndex, pUUID, length);
        return new Guid(pUUID);
    }

}
