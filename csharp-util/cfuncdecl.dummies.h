// -*- coding: utf-8, tab-width: 2 -*-
UINT WINAPI DLLVersion(void);
BOOL WINAPI Init(void);
void WINAPI Quit(void);
BOOL WINAPI SendMsg(LPCTSTR szText, UINT nActionID);
BOOL WINAPI SaveMsg(LPCTSTR szFile, LPCTSTR szText, UINT nActionID);
UINT WINAPI GetTopic(LPTSTR pTopic, UINT nBufLen);
UINT WINAPI GetEmoteName(UINT nIndex, LPTSTR szName, UINT nBytes);
UINT WINAPI GetEmoteUUID(UINT nIndex, unsigned char* pUUID, UINT nBufLen);
long WINAPI GetVolume(void);
BOOL WINAPI SetVolume(long nVolume);
BOOL WINAPI SubscribeEmotes(HWND hxWnd, UINT nMsg, HANDLE hEvent);
BOOL WINAPI SubscribeAlert(HWND hWnd);
BOOL WINAPI SendAlert(UINT nMsg, WPARAM wParam);
