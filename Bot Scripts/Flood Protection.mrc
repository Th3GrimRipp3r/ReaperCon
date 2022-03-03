:::::::::::::::::::::::::::::::::::::::
:: Flood Protection                  ::
:: Version 1.0.0                     ::
:: Written by Napa182                ::
:: Modifications by Zetacon          ::
:: This script is a three strike     ::
:: system for flooding in a channel. ::
:: All Rights Reserved.              ::
:::::::::::::::::::::::::::::::::::::::

alias owner { 
  auser owner $address($1,2) 
}

on owner:TEXT:!flood *:#: {
  if (!$3) { 
    msg $chan commands are !flood on #channel / !flood off #channel / !listrooms 
  }
  elseif ($2 == on) && ($istok(%floodchan,$3,44)) {
    msg $chan My Flood Protection is already ON for $3 $+ . 
  }
  elseif ($2 == on) {
    set %floodchan $addtok(%floodchan,$3,44)
    msg $chan My Flood Protection is now ON in $3 $+ .
  }
  elseif ($2 == off) && (!$istok(%floodchan,$3,44)) {
    msg $chan My Flood Protection is already OFF for $3 $+ . 
  }
  elseif ($2 == off) {
    set %floodchan $remtok(%floodchan,$3,1,44)
    msg $chan My Flood Protection is now OFF in $3 $+ .  
  }
}

on owner:TEXT:!listrooms:#:{ 
  if (!%floodchan) { 
    msg $chan My Flood Protection is NOT ON in any channels. 
  }
  else { 
    msg $chan My Flood Protection is ON in the following channels: %floodchan 
  }
}

on !*:TEXT:*:%floodchan: {
  if ($nick(#,$nick,oh)) { 
    HALT 
  }
  else {
    inc -u2 $+(%,flood,.,$chan,.,$nick)
    if ($($+(%,flood,.,$chan,.,$nick),2) >= 5) {
      inc $+(%,floodd,.,$chan,.,$nick) 
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 2) { 
	    msg $chan Flooding Detected: $nick - Flooding is not permitted in this channel.
	  }
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 5) { 
	    kick $chan $nick Flooding Detected: Flooding is not permitted in this channel. Continue flooding and you will be banned.  
	  }
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 8) { 
	    ban -ku600 # $nick 2 BANNED! Flooding is not permitted in this channel. This ban is not appealable.
		unset $+(%,floodd,.,$chan,.,$nick) 
	  }
    }
  }
}

on !*:ACTION:*:%floodchan: {
  if ($nick(#,$nick,oh)) {
    HALT
  }
  else {
    inc -u2 $+(%,flood,.,$chan,.,$nick)
    if ($($+(%,flood,.,$chan,.,$nick),2) >= 5) {
      inc $+(%,floodd,.,$chan,.,$nick) 
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 2) { 
	    msg $chan Flooding Detected: $nick - Flooding is not permitted in this channel.
	  }
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 5) { 
	    kick $chan $nick Flooding Detected: Flooding is not permitted in this channel. Continue flooding and you will be banned. 
	  }
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 8) { 
	    ban -ku600 # $nick 2 BANNED! Flooding is not permitted in this channel. This ban is not appealable.
		unset $+(%,floodd,.,$chan,.,$nick) 
	  }
    }
  }
}