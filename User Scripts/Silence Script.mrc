alias sil {
  if ($me isop $active) || ($me ishop $active) || (o isincs $usermode) {
    if (!$1) || (!$2) || ($2 !isnum) { echo -at * Error: Incorrect syntax used, /sil <nick> <timer in minutes> | HALT }
    elseif ($1) || ($2 isnum) {
      if ($2 > 60) { echo -at * Error: Please use a time that's between 1 and 60.. | HALT }
      elseif ($1 !ison $chan) { echo -at * Error: The user $+(",$1,") is not on $chan $+ , Halting the requesting silence.. | HALT }
      else {
        mode $chan +bb ~q: $+ $address($1,2) ~n: $+ $address($1,2)
        writeini Silence.ini $$1 chan $active
        if ($left($nick($active,$$1).pnick,1) == @) { writeini Silence.ini $1 status AOP | mode $active -o $1 }
        if ($left($nick($active,$$1).pnick,1) == %) { writeini Silence.ini $1 status HOP | mode $active -h $1 }
        if ($left($nick($active,$$1).pnick,1) == +) { writeini Silence.ini $1 status VOP | mode $active -v $1 }
        $iif($$1 isreg $active,writeini Silence.ini $1 status REG)
        .timer $+ $+($1,.,$network) 1 $calc($2 * 60) desil $1 $address($1,2) $chan
      }
    }
  }
}

on *:JOIN:#: {
  if ($ini(Silence.ini,$nick,chan)) {
    if ($readini(Silence.ini,$nick,status) == AOP) {
      mode $chan -o $nick
    }
    elseif ($readini(Silence.ini,$nick,status) == HOP) {
      mode $chan -h $nick
    }
    elseif ($readini(Silence.ini,$nick,status) == VOP) {
      mode $chan -v $nick
    }
  }
}

alias -l desil {
  if ($1 ison $3) {
    if ($readini(Silence.ini,$1,status) == AOP) { mode $$3 +o $1 | remini Silence.ini $1 }
    if ($readini(Silence.ini,$1,status) == HOP) { mode $$3 +h $1 | remini Silence.ini $1 }
    if ($readini(Silence.ini,$1,status) == VOP) { mode $$3 +v $1 | remini Silence.ini $1 }
    mode $3 -bb ~q: $+ $2 ~n: $+ $2
  }
  elseif ($1 !ison $3) { mode $3 -bb ~q: $+ $2 ~n: $+ $2 | remini Silence.ini $1 }
}
