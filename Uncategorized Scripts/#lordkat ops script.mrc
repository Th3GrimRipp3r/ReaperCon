;::::::::::::::::::::::::::::::::::::::::::::::::::::
;:: #Lordkat Op Script                             ::
;:: Written by Zetacon                             ::
;:: Contributions by Kin & Danneh                  ::
;:: For Use by the #Lordkat Channel Operators Only ::
;:: All Rights Reserved                            ::
;::::::::::::::::::::::::::::::::::::::::::::::::::::

;--------Variables--------

on 1:START:{
  lk.setvars
}

alias lk.setvars {
  set %lk.akick.setby ( $+ $me $+ : $asctime(mm/dd/yy) $+ )
}


;--------Aliases--------

alias normasctime { 
  return $asctime($calc($1 - (%timezonecorrection.cur.sec + $daylight)), $2 )
}

alias f2 {
  mode #lordkat +m
}

alias f3 {
  mode #lordkat -m
}

alias lkban {
  if ($1 ison #lordkat) {
    if ( ($2) || ($2 == $null) ) {
      mode #lordkat +b $address($1,2)
    }
    else {
      mode #lordkat -b $address($1,2)
    }
  }
  else {
    echo -ta $1 is not currently on $chan $+ .
  }
}

alias lkmute {
  if ($1 ison #lordkat) {
    if ( ($2) || ($2 == $null) ) {
      mode #lordkat +bb ~q: $+ $address($$1,2) ~n: $+ $address($$1,2)
    }
    else {
      mode #lordkat -bb ~q: $+ $address($$1,2) ~n: $+ $address($$1,2)
    }
  }
  else {
    echo -ta $1 is not currently on $chan $+ .
  }
}

alias lkkb {
  /lkban $1 $true
  kick #lordkat $1-
}

alias lkakick {
  if ($1 ison #lordkat) {
    set %lk.akick.reason $2-
    cs akick #lordkat add $address($$1,2) %lk.akick.reason %lk.akick.setby
  }
  else {
    echo -ta $1 is not currently on $chan $+ .
  }
}


;--------Justin.tv Aliases--------

alias lkjtvclear {
  if ($server == irc.justin.tv) {
    if ($me isop $chan) {
      msg $chan .clear
      echo -ta You have cleared the chat.
    }
    else {
      echo -ta You are not a moderator on this channel.
    }
  }
}

alias lkjtvpurge {
  if ($server == irc.justin.tv) {
    if ($me isop $chan) {
      kick # $1
      mode # -b $1
      echo -ta $1's messages have been purged.
    }
    else {
      echo -ta You are not a moderator on this channel.
    }
  }
}

alias lkjtvtimeout {
  if ($server == irc.justin.tv) {
    if ($me isop $chan) {
      /kick # $1
      echo -ta $1 has been given a timeout.
    }
    else {
      echo -ta You are not a moderator on this channel.
    }
  }
}

alias lkjtvban {
  if ($server == irc.justin.tv) {
    if ($me isop $chan) {
      mode #lordkat +b $1
      echo -ta $1 has been banned.
    }
    else {
      echo -ta You are not a moderator on this channel.
    }
  }
}

alias lkjtvunban {
  if ($server == irc.justin.tv) {
    if ($me isop $chan) {
      mode # -b $1
      echo -ta $1 has been unbaned.
    }
    else {
      echo -ta You are not a moderator on this channel.
    }
  }
}


;--------Popup Menus--------

menu nicklist {
  $iif(!$istok(~|&|@|%,$left($nick(#,$me).pnick,1),124),$style(2)) #Lordkat Operator Script
  .Nick - $1:noop
  .Host - $address($$1,2):noop
  .Full - $address($$1,5):noop
  .Echo Address:echo -ta $address($$1, 5)
  .Whois:/whois $$1
  .NickServ Info:/ns INFO $$1 ALL
  .-
  .Discipline
  ..Unmute:/lkmute $$1 $false
  ..Allow Nick-Change:/mode #lordkat -b ~n: $+ $address($$1,2)
  ..Unban:/lkban $1 $false
  ..-
  ..Mute:/lkmute $$1 $true
  ..No Nick-Change:/mode #lordkat +b ~n: $+ $address($$1,2)
  ..Ban:/lkban $1 $true
  ..Kick (y?):/kick #lordkat $$1 $input(Enter a Reason:,e,Reason!)
  ..Kick-Ban (y?):/lkkb $$1 $input(Enter a Reason:,e,Reason!)
  ..-
  ..Swift Kick:/kick #lordkat $$1
  ..Swift Kick-Ban:/lkkb $$1
  ..Swift Kick - Bad Nickname:/kick #lordkat $$1 Return when you have a better nickname.
  ..Swift Kick - Flood or Spam:/kick #lordkat $$1 No spam or flooding.
  ..Swift Kick - Behave:/kick #lordkat $$1 Behave.
  ..Swift Kick-Ban - No thanks:/lkkb $$1 No thanks.
  ..-
  ..Akick:/lkakick $$1 $input(Enter a Reason:,e,Reason!)
  .-
  .JTV
  ..Purge User Messages:/lkjtvpurge $$1
  ..Timeout User:/lkjtvtimeout $$1
  ..Ban User:/lkjtvban $$1
  ..Unban User:/lkjtvunban $$1
}

menu nicklist,channel {
  $iif(!$istok(~|&|@|%,$left($nick(#,$me).pnick,1),124),$style(2)) #Lordkat Operator Script
  .Moderate Room:/f2
  .Unmoderate Room:/f3
  .Botnet Emergency (no join):/mode #lordkat +mi
  .Clear Emergency:/mode #lordkat -mi
  .-
  .Speak as HAL9000:/msg BotServ SAY #lordkat $input(What do you want HAL9000 to say?,e,Input Request!)
  .Emote as HAL9000:/msg BotServ ACT #lordkat $input(What do you want HAL9000 to emote?,e,Input Request!)
  .-
  .JTV
  ..Clear Chat:/lkjtvclear
  ..-
  ..Connect to JTV chat:/server -ma lordkat.jtvirc.com 6667 $input(What is your JTV Password?,e,Input Request) -i $input(What is your JTV Nickname?,e,Input Request) -j #lordkat
}
