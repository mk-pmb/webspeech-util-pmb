#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function dll_funcs2csharp () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m "$BASH_SOURCE"/..)"
  cd "$SELFPATH" || return $?
  ( <<<'using System;
    using System.Runtime.InteropServices;

    public class LogoxWebSpeech4Api {
    ' sed -re 's~^\s+~~'
    <clean/logox4ocx.html "$FUNCNAME"_core | sed -re 's~^\s*~    &&~'
    echo '}'
  ) >dll_funcs.cs
  return 0
}


function dll_funcs2csharp_core () {
  sed -nre '
    s~\s+~ ~g;s~ $~~;s~^ ~~
    s~</?(b|p|i)>~\L&\E~ig
    \:^<b>(CString|[A-Z]{2,8})</b> <b>:p
    ' | sed -re '
    s~<b>(, |)(CString|LPCT?STR)</b>~\1string~g
    s~<b>(, |)(VOID|LONG|BOOL|SHORT)( ?\*|)</b>~\1\a=\3\L\2\E~g
    s~\a= ?\*([a-z]+ )~ref \1~g
    s~\a=~~g
    s~<b>\) </b><p>$~)~
    s~</?i>~~g
    s~^(\S+) <b>([A-Za-z]+)\(</b>~\1 \2(~g
    s~\(void \)~()~
    s~\b(App)lication(Name)\b~\1\2~g
    p
    s~^~  return :~
    s~^(  )return :void ~\1~
    s~^(  return ):[a-z]+ ~\1~
    s~^  return ~&Logox~
    s~(\(|, )(ref |)[a-z]+ ~\1\2~g
    ' | sed -re '
    /^\S/N
    s~^(\S+) ([^\n]*)~[DllImport("Logox4.dll")]\
      private static extern \1 Logox\2;\
      public static \1 \2 {~
    s~(^|\n) {6}~\1~g
    s~$~;\n}\n~
    /\(\) \{\n/{
      s~\{\s+~{ ~
      s~\s+\}~ }~
    }
    s~(long SamplesPerSec|string FileName), ~\1,\n  ~g
    s~ ref short p(Day|Hour),~\n &~g
    s~(\n  [^\n]+\)) \{~\1\n{~
    '
}










[ "$1" == --lib ] && return 0; dll_funcs2csharp "$@"; exit $?
