;----------------------------------------------------------------------------
; * Name    :    DNS
; * Author  :    Radien (brandon)
;                IRC: channel #damdevil in irc.damdevil.org
;                Web: http://code.google.com/p/itechnet
; * Version :    0.1
; * Date    :    May 13th, 2011
; * Notes   :    Type /dns IP/website/ircserver/nick to see all entries for
;                Given target.
;----------------------------------------------------------------------------

;dns: $dns(%n) nick: $dns(%n).nick 4addr: $dns(%n).addr ip: $dns(%n).ip
on *:DNS:{
  var %n = $dns(0)
  echo -ati2l -  -[Found %n address(es)]-
  while (%n > 0) {
    echo -ati2l - $dns(%n) $+ 's IP is: $dns(%n).ip Address: $dns(%n).addr
    dec %n
  }
  echo -ati2l - End Of /dns
  halt
}

