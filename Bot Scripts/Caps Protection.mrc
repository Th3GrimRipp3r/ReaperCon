::::::::::::::::::::::::::::::::::::::::::::
:: Caps Protection                        ::
:: Version 1.0.4                          ::
:: Written by Napa182                     ::
:: Modifications by Zetacon               ::
:: This script uses a three strike system ::
:: for anyone using excessive caps.       ::
:: All Rights Reserved.                   ::
::::::::::::::::::::::::::::::::::::::::::::

on *:TEXT:!caps *:#:{
  if ($nick isop $chan || $nick ishop $chan) {
    if (!$3) { msg $chan commands are !caps on #channel / !caps off #channel / !caps set number / !caps status }
    elseif ($2 == on) && ($istok(%capschan,$3,44)) {
      msg $chan My Caps Protection is already ON for $3 $+ . 
    }
    elseif ($2 == on) {
      set %capschan $addtok(%capschan,$3,44)
      msg $chan My Caps Protection is now ON in $3  $+ .
    }
    elseif ($2 == off) && (!$istok(%capschan,$3,44)) {
      msg $chan My Caps Protection is already OFF for $3 $+ .
    }
    elseif ($2 == off) {
      set %capschan $remtok(%capschan,$3,1,44)
      msg $chan My Caps Protection is now OFF in $3 $+ .
    }
    elseif ($2 == set) {
      set %capskicker $3
      msg $chan Caps Protection: Warn/Kick/Ban now set for $3 $+ % Caps.
    }
    elseif ($2 == status) {
      if (!%capschan) { msg $chan My Caps Protection is currently NOT ON in any channels. }
      else { msg $chan My Caps Protection is ON in %capschan }
    }
  }  
}

on *:TEXT:*:%capschan: {
  if ($nick isop $chan || $nick ishop $chan) { 
    HALT 
  }
  else {
    if ($nick(#,$nick,vr)) && ($len($1-) > 5) {
      var %percent $calc($regex($1-,/[A-Z]/g)/$len($1-)*100)
      if (%percent > %capskicker) {
        inc $+(%,caps,.,$nick,.,$chan)
        if ($($+(%,caps,.,$nick,.,$chan),2) == 1) { 
		  msg $chan Caps Detected: $nick - The use of caps to speak is strictly forbidden here. $round(%percent,0) $+ % of your message was in caps. 
		}
        if ($($+(%,caps,.,$nick,.,$chan),2) == 2) { 
		  kick $chan $nick Final warning on the use of caps. $round(%percent,0) $+ % of your message was in caps. Next time, it's a ban. 
		} 
        if ($($+(%,caps,.,$nick,.,$chan),2) == 3) { 
		  ban -ku600 # $nick 2 BANNED! The use of caps is strictly forbidden. $round(%percent,0) $+ % of your message was in caps. If you feel this ban is in error, that's just too bad. | unset $+(%,caps,.,$nick,.,$chan) 
		}
      }
    }
  }
}
