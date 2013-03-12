on *:TEXT:!BL*:#: {
  if ($nick == YOURNICKHERE) {
    if (!$2) { msg $chan * Error: Incorrect syntax used: !BL <Add/Del> <channelname> }
    elseif ($2 == Add) {
      if (!$3) { msg $chan * Error: Incorrect syntax used: !BL Add <channelname> }
      elseif ($istok(%blacklist. [ $+ [ $network ] ],$3,44)) {
        msg $chan * Error: This channel $+(,",$3,",) is already on my Channel Blacklist.
      }
      else {
        set %blacklist. [ $+ [ $network ] ] $addtok(%blacklist. [ $+ [ $network ] ],$3,44)
        msg $chan $3 has been added to my channel blacklist for $network $+ .
        $iif($me ison $3,.timer 1 1 part $3 Channel has been added to my blacklist.)
      }
    }
    elseif ($2 == Del) {
      if (!$3) { msg $chan * Error: Incorrect syntax used: !BL Del <channelname> }
      elseif (!$istok(%blacklist. [ $+ [ $network ] ],$3,44)) {
        msg $chan * Error: This channel $+(,",$3,",) is not currently on my Channel Blacklist.
      }
      else {
        set %blacklist. [ $+ [ $network ] ] $remtok(%blacklist. [ $+ [ $network ] ],$3,44)
        msg $chan $3 has been removed from my channel blacklist for $network $+ .
        $iif(%blacklist. [ $+ [ $network ] ] == $null,unset %blacklist. [ $+ [ $network ] ])
      }
    }
    elseif ($2 == List) {
      msg $chan $iif(%blacklist. [ $+ [ $network ] ] == $null,No channels are on my blacklist for $network $+ .,Current blacklist for $network $+ : %blacklist. [ $+ [ $network ] ])
    }
  }
}

on *:JOIN:#: {
  if ($istok(%blacklist. [ $+ [ $network ] ],$chan,44)) {
    part $chan Channel is blacklisted.
  }
}
