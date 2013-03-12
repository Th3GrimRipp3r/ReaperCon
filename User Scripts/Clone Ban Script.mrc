on @*:BAN:#: {
  if ($istok(~q:|~n:,$banmask,124)) { HALT }
  else {
    var %bannum = 1
    while (%bannum <= $nick($chan,0)) {
      if ($banmask !iswm $address($nick($chan,%bannum),5)) { inc %bannum }
      else {
        set %bannicks $addtok(%bannicks,$nick($chan,%bannum),44)
        inc %bannum
      }
    }
  }
}
on @*:KICK:#: {
  if ($istok(%bannicks,$knick,44)) {
    var %a = 1
    while (%a <= $numtok(%bannicks,44)) {
      kick $chan $gettok(%bannicks,%a,44) You have been banned.
      inc %a
    }
  }
}
