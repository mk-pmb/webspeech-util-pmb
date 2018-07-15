#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function wsrs_test () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELF="$(readlink -m "$BASH_SOURCE")"
  local PROG="$(basename "$SELF" .test.sh)"

  local -A TTS
  source "$HOME"/.config/speech-util-pmb/tts-util.rc

  export WINEPREFIX="${TTS[logox4:wpfx]}"
  [ -n "$LOGOX_LICKEY" ] || export LOGOX_LICKEY="$(
    grep -oPe '^\w\S+' -m 1 -- "$WINEPREFIX"/license.logox4.txt)"

  export WINEARCH=win32
  [ -n "$WINEDEBUG" ] || export WINEDEBUG=fixme-all
  env | grep -Pe '^(WINE|logox_)' | LANG=C sort

  [ -f Logox4.dll ] || ln --symbolic --no-target-directory -- "$WINEPREFIX$(
    )/dosdevices/c:/Program Files/Common Files/Logox.4.0/Logox4.dll"

  mcs "$PROG".cs lib/*.cs || return $?
  <"${SELF%.test.sh}.input.txt" wine "$PROG".exe || return $?

  return 0
}










wsrs_test "$@"; exit $?
