#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-

: read_all
$!{N;b read_all}

s~<script src="//archive\.org/includes/.* End Wayback Rewrite JS Include -->~~g
s~<!--\s+(FILE ARCHIVED ON)\s[^<>]+>~<!-- \1 -->~
s~<!-- FILE ARCHIVED ON -->\s*<!--\s*playback timings\s[^<>]+>~~

s~/web/[0-9]+[a-z]{0,3}_?/http://www\.logox\.de(:80|)/support/manual/win/~~g
s~/web/[0-9]+[a-z]{0,3}_?/http://www\.logox\.de(:80|)/~/~g
s~(\.htm)"~\1l"~g
s~\s*\n[\r\n]*~\n~g

s~(</head>\s*<frameset rows=")51(,\*")~\10\2~
s~(<frame src=")top\.html"~\1about:blank"~
s~</?(font)( [^<>]*|)>~~g
s~ background="grafik/nav3\.gif"~~g
s~(href=")logox-(styles.css")~\1../\2~

# ===== Fix double-encoded HTML =====
: fix_amps
  s~(\&)(amp;)*(#[0-9]+)([^0-9;])~\1\3;\4~g
  s~(\&)(amp;)+(([aeiou]uml|szlig|reg|quot);)~\1\3~ig
t fix_amps
s~(\&lt;|>)(/?([A-Z]+|H[1-6]|sup|p|br|$\
  )( (HREF|NAME)=[^&<> \n]*|))(\&gt;|>)~<\a\2>~g
s~<\a~<~g

s~(<a[^<>]*>)(<h1[^<>]*>)([^<>]*)(</h1>)(</a>)~\2\1\3\5\4~g
s~<h1><a name="([A-Za-z0-9_-]+)">([^<>]*)|$\
  ~<h1 id="\1">\2 <a class="goto-sect" href="#\1">\&para;~g

/<h1 id="__aaaFunktionen_des_(ActiveX_Controls|Logox_4_Servers)">/{
  s~<h3>([^<>]+)</h3>\s*<p>\s*(<menu compact>)|$\
    ~<chapter><h3>\1</h3>\n  \2~g
  s~(<p>\s*|)(</menu>)~\2</chapter>\n~g
  s~\s*<p>\s*(<chapter>)~\n\n<nav id="ocx-toc">\1~
  s~(</chapter>)\s*(<hr>)~\1\n</nav>\n\n\2~
  s~(<chapter><h3>)(Funktionen zu[rm]|Allgemeine?) ~\1~g
}

s~\s+(<br>)~\L\1\E~ig






s~\s*\n[\r\n]*~\n~g
s~\s*$~\n~
