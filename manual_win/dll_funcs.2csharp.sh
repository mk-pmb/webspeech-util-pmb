#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function dll_funcs2csharp () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m "$BASH_SOURCE"/..)"
  cd "$SELFPATH" || return $?
  ( <<<'using System;
    using System.Text;
    using System.Runtime.InteropServices;

    public class LogoxWebSpeech4Api {
    ' sed -re 's~^\s+~~'
    <clean/logoxdll.html "$FUNCNAME"_core | sed -re 's~^\s*\S~    &~'
    echo '}'
  ) >dll_funcs.cs
  return 0
}


function dll_funcs2csharp_core () {
  sed -nre '
    s~\s+~ ~g;s~ $~~;s~^ ~~
    s~</?[bip]>~\L&\E~ig
    \:^<b>(CString|[A-Z]{2,8}|\S+ WINAPI|)</b> <b>:{
      s~</?[bip]>~~g
      s~^~// orig: ~p
      s~^[^:]+: ~~p
    }' | ../csharp-util/cfuncdecl.2dllimport.sed | sed -re '
    s~"some.dll"~"Logox4.dll"~g
    s~(UnmanagedType\.LP)T(Str)~\1\2~g
    '
}










[ "$1" == --lib ] && return 0; dll_funcs2csharp "$@"; exit $?
