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

on owner:text:!spam*:#:{
  if (!$3) { msg $chan commands are !spam on #channel / !spam off #channel / !spam set number / !srooms }
  elseif ($2 == on) && ($istok(%spamchan,$3,44)) {
    msg $chan My Spam Protection Is Already On For $3 
  }
  elseif ($2 == on) {
    set %capschan $addtok(%capschan,$3,44)
    msg $chan My Spam Protection Is Now ON In $3 
  }
  elseif ($2 == off) && (!$istok(%capschan,$3,44)) {
    msg $chan My Spam Protection Is Already OFF For $3 
  }
  elseif ($2 == off) {
    set %capschan $remtok(%capschan,$3,1,44)
    msg $chan My Spam Protection Is Now OFF In Room $3  
  }
}

on owner:text:!crooms:#:{ 
  if (!%capschan) { msg $chan My Spam Protection Is NOT ON In Any Room's }
  else { msg $chan My Spam Protection Is On In Room's %capschan }
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