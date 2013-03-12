menu nicklist {
  Mass Modes:nicklistmass
}

alias nicklistmass {
  if ($me isop $chan) {
    var %prefix = $$?="+ or - mode?", %mode = $$?="Which mode would you like applied?", %counter = 1, %nicks = $snick($active)
    while (%counter <= $numtok(%nicks,44)) {
      var %mnick = $addtok(%mnick,$gettok(%nicks,%counter,44),32)
      if ($numtok(%nicks,32) == $modespl) {
        mode $chan %prefix $+ $str(%mode,$numtok(%mnick,32)) %mnick
        %mnick = ""   
      }
      inc %counter
    }
    if (%mnick) mode $chan %prefix $+ $str(%mode,$numtok(%mnick,32)) %mnick
  }
}
