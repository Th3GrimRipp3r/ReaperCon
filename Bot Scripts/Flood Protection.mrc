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

on owner:text:!flood*:#:{
  if (!$3) { msg $chan commands are !flood on #channel / !flood off #channel / !listrooms }
  elseif ($2 == on) && ($istok(%protecchan,$3,44)) {
    msg $chan My Flood Protection Is Already On For $3 
  }
  elseif ($2 == on) {
    set %protecchan $addtok(%protecchan,$3,44)
    msg $chan My Flood Protection Is Now ON In $3 
  }
  elseif ($2 == off) && (!$istok(%protecchan,$3,44)) {
    msg $chan My Flood Protection Is Already OFF For $3 
  }
  elseif ($2 == off) {
    set %protecchan $remtok(%protecchan,$3,1,44)
    msg $chan My Flood Protection Is Now OFF In Room $3  
  }
}

on owner:text:!listrooms:#:{ 
  if (!%protecchan) { msg $chan My Flood Protection Is NOT ON In Any Room's }
  else { msg $chan My Flood Protection Is On In Room's %protecchan }
}

on *:load: { 
  echo 12 -a You Have Just Loaded Napa182's Flood Control. 
  echo 12 -a A Script0rs Inc. Production 
  echo -a 14,1(14,1¯15,1¯0,1¯0,1º $+($chr(171),$chr(164),$chr(88),$chr(167),$chr(199),$chr(174),$chr(238),$chr(254),$chr(116),$chr(48),$chr(174),$chr(167),$chr(88),$chr(164),$chr(187)) º0,1¯15,1¯14,1¯) $+ $chr(153)
}

on !*:text:*:%protecchan: {
  if ($nick(#,$nick,oh)) { halt }
  else {
    inc -u2 $+(%,flood,.,$chan,.,$nick)
    if ($($+(%,flood,.,$chan,.,$nick),2) >= 5) {
      inc $+(%,floodd,.,$chan,.,$nick) 
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 2) { msg $chan $nick Dont Flood This Room }
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 5) { kick $chan $nick flood Control 1 more time and it's a BAN!! }
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 8) { ban -ku600 # $nick 2 you were warned not to Flood In This Room. | unset $+(%,floodd,.,$chan,.,$nick) }
    }
  }
}
on !*:action:*:%protecchan: {
  if ($nick(#,$nick,oh)) { halt }
  else {
    inc -u2 $+(%,flood,.,$chan,.,$nick)
    if ($($+(%,flood,.,$chan,.,$nick),2) >= 5) {
      inc $+(%,floodd,.,$chan,.,$nick) 
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 2) { msg $chan $nick Dont Flood This Room }
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 5) { kick $chan $nick flood Control 1 more time and it's a BAN!! }
      if ($($+(%,floodd,.,$chan,.,$nick),2) == 8) { ban -ku600 # $nick 2 you were warned not to Flood In This Room. | unset $+(%,floodd,.,$chan,.,$nick) }
    }
  }
}