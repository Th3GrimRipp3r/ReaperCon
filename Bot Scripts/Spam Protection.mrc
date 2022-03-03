:::::::::::::::::::::::::::::::::::::::::::
:: Spam Protection                       ::
:: Version 1.0.0                         ::
:: Written by Napa182                    ::
:: Recreation by Zetacon (Original could ::
:: no longer be found)                   ::
:: This script has a three strike system ::
:: for posting spam in a channel.        ::
:: All Rights Reserved.                  ::
:::::::::::::::::::::::::::::::::::::::::::

alias owner { auser owner $address($1,2) }

on owner:TEXT:!spam *:#: {
  if (!$3) { msg $chan commands are !spam on #channel / !spam off #channel / !spam set number / !srooms }
  elseif ($2 == on) && ($istok(%spamchan,$3,44)) {
    msg $chan My Spam Protection is already ON for $3 $+ .  
  }
  elseif ($2 == on) {
    set %spamchan $addtok(%spamchan,$3,44)
    msg $chan My Spam Protection is now ON in $3 $+ .
  }
  elseif ($2 == off) && (!$istok(%spamchan,$3,44)) {
    msg $chan My Spam Protection is already OFF for $3 $+ . 
  }
  elseif ($2 == off) {
    set %spamchan $remtok(%spamchan,$3,1,44)
    msg $chan My Spam Protection is now OFF in $3 $+ .  
  }
}

on owner:TEXT:!crooms:#:{ 
  if (!%spamchan) { msg $chan My Spam Protection Is NOT ON In Any Room's }
  else { msg $chan My Spam Protection Is On In Room's %spamchan }
}

on *:TEXT:*:#: { 
  elseif ($nick($chan,$nick,vr)) {
    if ($regex($strip($1-),/\b(?:http|www|com|org|net)\b/i)) {
	  inc $+(%,spam,$nick)
      if ($($+(%,spam,$nick),2) == 1) { 
	    msg $chan Spam Protection: $nick - Spamming/Advertising is not allowed in this channel. 
	  }
      if ($($+(%,spam,$nick),2) == 2) { 
	    kick $chan $nick Spam Protection: Spam/Advertising is not permitted in $chan $+ . 
	  }
      if ($($+(%,spam,$nick),2) == 3) { 
	    mode $chan +b $address($nick,2) 
		kick $chan $nick Spam Protection: Spam/Advertising is not permitted in $chan $+ . 
		unset $+(%,spam,$nick)	  
	  }
    }
  }
}