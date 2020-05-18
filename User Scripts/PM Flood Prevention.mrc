; PM flood prevention by Phil
; Ignores a user for 10 seconds when they flood you with 3 lines in 2 seconds

on *:TEXT:*:?:{
  set -u2 %pmflood. [ $+ [ $network $+ . $+ $nick ] ] $calc(%pmflood. [ $+ [ $network $+ . $+ $nick ] ] + 1)

  if (%pmflood. [ $+ [ $network $+ . $+ $nick ] ] == 3) {
    ignore -pu10 $address($nick, 2)
    close -m $nick
    msg $nick PM flood detected. You have been ignored for 10 seconds.
  }
}
