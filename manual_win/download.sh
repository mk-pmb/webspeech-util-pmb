#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function download_all () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m "$BASH_SOURCE"/..)"
  cd "$SELFPATH" || return $?
  mkdir -p wayback || return $?

  local LIST=(
    logox4intro.htm
    logox4ocx.htm
    logox4speechtags.htm
    logox4speechtagsafx.htm
    logox4speechtagsintonation.htm
    logox4speechtagssampa.htm
    logoxdll.htm
    logox-styles.css
    nav.html
    sapi5speechtags.htm
    )
  local ITEM=
  for ITEM in "${LIST[@]}"; do
    download_one_orig "$ITEM" || return $?
  done

  mkdir -p clean || return $?
  for ITEM in wayback/{logox,nav,sapi}*.htm{,l}; do
    [ -f "$ITEM" ] || continue
    clean_one_orig "$ITEM" || return $?
  done

  return 0
}


function download_one_orig () {
  local FN="$1"
  local DEST="wayback/$FN"
  [ -f "$DEST" ] && return 0
  local SAVE="wayback/tmp.$FN"
  >"$SAVE" || return $?
  wget -O "$SAVE" -c "http://web.archive.org/web/99fw_/$(
    )http://www.logox.de:80/support/manual/win/$FN" || return $?
  mv --verbose --no-target-directory -- "$SAVE" "$DEST" || return $?
  return 0
  # sed -rf cleanup.sed -- "$BFN".tmp >"$BFN".html || return $?
}


function clean_one_orig () {
  local ORIG="$1"
  local CLEAN="$(basename "$ORIG")"
  [ "${CLEAN##*.}" == htm ] && CLEAN+='l'
  CLEAN="clean/$CLEAN"
  echo "$CLEAN <-{fix}-- $ORIG"
  sed -rf cleanfix.sed -- "$ORIG" >"$CLEAN" || return $?
}










download_all "$@"; exit $?
