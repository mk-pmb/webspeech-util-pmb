#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-

s~\s+~ ~g;s~^ ~~;s~ $~~
/^[^A-Za-z]/b

s~^~\a~
s~(\a\S+ )(WINAPI) ~<\2> \1~
s~\a([A-Za-z0-9]+) ([A-Za-z0-9]+) ?\(~<returns:\1> <name:\2> (\a, ~
s~\a, *void ?(\))~\a\1~
: parse_args
  s~(\a,)\s*~\1 ~
  s~(\a, unsigned) ([A-Za-z0-9_]+)~\1_\2~
  s~(\a, [A-Za-z0-9_]+) ?\*~\1_ptr~
  s~\a, ([A-Za-z0-9_]+) ([A-Za-z0-9]+)~\
    <arg><type:m:\1> <type:a:\1> \2,\a~
t parse_args
s~\a ?\) ?;?$~\n)~

s~^~[DllImport("some.dll"<diOpt>)]\n~
/<WINAPI>/{
  s~<WINAPI> ?~~
  # s~<diOpt>~, CallingConvention=CallingConvention.Winapi&~
  # ^-- not required: it's the default
}
s~<diOpt>~~

s~<returns:(\S+)> ~<ret><type:m:\1>\npublic static extern <type:r:\1> ~
s~<ret><type:m:(void|bool)>\n~~i
s~<ret>(<type:m:\S+>)~[return: MarshalAs(UnmanagedType.\1)]~g

s~(<type:[arm]):(HWND)>~\1:HANDLE>~g
s~<arg><type:m:HANDLE> <type:a:\S+> ~IntPtr ~g
s~<arg>(<type:m:\S+>) ~[param: MarshalAs(UnmanagedType.\1)]\n    ~g

s~(<type:[arm]):(WPARAM)>~\1:UINT_PTR>~g
s~<type:m:(U)?INT_PTR>~Sys\1Int~g
s~<type:[ar]:(U)?INT_PTR>~\L\1int\E~g

s~<type:r:(void)>~\L\1\E~ig
s~<type:[ar]:(bool)>~\L\1\E~ig
s~<type:[ar]:((u)(nsigned_|)|)(int|long)>~\L\2\Eint~ig
s~<type:[ar]:(LPC?T?STR)>~string~ig
s~<type:a:((unsigned_|)char_ptr)>~StringBuilder~ig

s~<type:m:(bool)>~Bool~ig
s~<type:m:((unsigned |)(dword|uint|long)(32|))>~U4~ig
s~<type:m:(L?PC?TSTR)>~LPTStr~ig
s~<type:m:((unsigned_|)char_ptr)>~LPStr~ig

s~ +<\r>~~g
s~<name:(\S+)> ~\1~
s~,?\s*\)$~);\n~


s~\a~\n\n<!!>\n\n~g
