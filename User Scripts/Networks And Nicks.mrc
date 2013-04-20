alias nets {
  if ($$1 == n) {
    var %ctr = 0 | var %tot = $scon(0)
    while (%ctr < %tot) {
      inc %ctr | say 3* $iif($scon(%ctr).status == connected,7Connected To:4 $scon(%ctr).network 7As:4 $scon(%ctr).me $+ ,7Currently not connected to:4 $scon(%ctr).network $+ .)
    }
  }
  elseif ($$1 == c) {
    var %ctr = 0 | var %tot = $scon(0)
    while (%ctr < %tot) {
      inc %ctr | say 3* $iif($scon(%ctr).status == connected,7Connected To:4 $scon(%ctr).network 8( $+ 7In12 $scon(%ctr).chanz $+ 8) 7As:4 $scon(%ctr).me $+ ,7Currently not connected to:4 $scon(%ctr).network $+ .)
    }
  }
  elseif ($$1 == S) {
    var %ctr = 0 | var %tot = $scon(0)
    while (%ctr < %tot) {
      inc %ctr | say 3* $iif($scon(%ctr).status == connected,7Connected To:4 $scon(%ctr).server 7As:4 $scon(%ctr).me $+ ,7Currently not connected to:4 $scon(%ctr).network $+ .)
    }
  }
  elseif ($$1 == o) {
    var %ctr = 0 | var %tot = $scon(0)
    while (%ctr < %tot) {
      inc %ctr | say 3* $iif($scon(%ctr).status == connected,7Connected To:4 $scon(%ctr).network 7As:4 $scon(%ctr).me $iif($scon(%ctr).oline != Null,$chr(40) $+ Oline Status: $scon(%ctr).oline $+ $chr(41)),7Currently not connected to:4 $scon(%ctr).network $+ .)
    }
  }
}

alias -l chanz {
  var %channelcounter = 1
  while (%channelcounter <= $chan(0)) { 
    if (s isincs $chan(%channelcounter).mode) || (O isincs $chan(%channelcounter).mode) || (A isincs $chan(%channelcounter).mode) || (p isincs $chan(%channelcounter).mode) { inc %channelcounter 1 }
    else { var %channeltotal = %channeltotal $chan(%channelcounter) $+ $chr(32)) | inc %channelcounter 1 }
  }
  return %channeltotal
}

alias -l oline {
  if (!%oline [ $+ [ $network ] ]) { return Null }
  else { return %oline [ $+ [ $network ] ] }
}

;on *:CONNECT: {
;  .timer 1 5 whois $me
;}

;raw 313:*:{ set %oline [ $+ [ $network ] ] $5 $6 }
