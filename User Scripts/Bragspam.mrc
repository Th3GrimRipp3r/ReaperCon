;%%%%%%%%%%% BRAG SCRIPT %%%%%%%%%%%%%%%%%%%
;  Status Bragging Script 
;  Version: 1.0
;  by: Helio


alias bragspam {
  /say I am on $rchans  $+ $iif($rchans == 1,channel,channels) $chr(40) $+ $+(,$rsecret,) Either Secret $+ $chr(44) 0p3r Or Admin $+ $chr(41) $+ , across $rnets  $+ $iif($rnets == 1,network,networks) $+ . I have $rolinect  $+ $iif($rolinect == 1,oline,olines) $+ , $rowner  $+ $iif($rowner == 1,owner,owners) $+ , $radmins  $+ $iif($radmins == 1,admin,admins) $+ , $rops  $+ $iif($rops == 1,op,ops) $+ , $rhops  $+ $iif($rhops == 1,halfop,halfops) and $rvoice  $+ $iif($rvoice == 1,voice,voices) $+ . I have non-abusive power over $rpower people!!!!! My average is $rchanavg  $+ $iif($rchanavg == 1,user,user's) per channel!!!!
}


;   r* aliases
;    You can use these identifiers anywhere you want, they are global.
;    so if you only want your channel total, you can //say $rchans
;    etc
;


alias rchans {
  set %total 0
  set %counter 1 
  while (%counter <= $scon(0)) { 
    /scon %counter
    /set %chans $chan(0)
    set %total $calc(%total + %chans)
    inc %counter
  }
  return %total
}
alias rsecret {
  set %secret 0
  set %counter 1

  while (%counter <= $scon(0)) { 
    /scon %counter 
    set %scounter 1
    while (%scounter <= $chan(0)) {
      if ((s isincs $chan(%scounter).mode) || (O isincs $chan(%scounter).mode) || (A isincs $chan(%scounter).mode)) {
        inc %secret
      }
      inc %scounter
    }
    inc %counter
  }
  return %secret
}
alias rowner {
  set %owners 0
  set %counter 1
  while (%counter <= $scon(0)) {
    /scon %counter
    set %scounter 1
    while (%scounter <= $chan(0)) {
      if ($left($nick($chan(%scounter),$me).pnick,1) == ~) inc %owners
      inc %scounter
    }
    inc %counter
  }
  return %owners
}
alias radmins {
  set %admins 0
  set %counter 1
  while (%counter <= $scon(0)) {
    /scon %counter
    set %scounter 1
    while (%scounter <= $chan(0)) {
      if ($left($nick($chan(%scounter),$me).pnick,1) == &) inc %admins
      inc %scounter
    }
    inc %counter
  }
  return %admins
}
alias rops {
  set %ops 0
  set %counter 1 
  while (%counter <= $scon(0)) { 
    /scon %counter
    set %scounter 1
    while (%scounter <= $chan(0)) {
      if ($left($nick($chan(%scounter),$me).pnick,1) == @) inc %ops
      inc %scounter
    }
    inc %counter
  }
  return %ops
}
alias rpower {
  set %peeps 0
  set %counter 1 
  while (%counter <= $scon(0)) { 
    /scon %counter
    set %scounter 1
    while (%scounter <= $chan(0)) {
      if ($me isop $chan(%scounter)) set %peeps $calc(%peeps + $nick($chan(%scounter),0) - 1)
      if ($me ishop $chan(%scounter)) set %peeps $calc(%peeps + $nick($chan(%scounter),0) - 1)
      inc %scounter
    }
    inc %counter
  }
  return %peeps
}
alias rhops {
  set %hops 0
  set %counter 1 
  while (%counter <= $scon(0)) { 
    /scon %counter
    set %scounter 1
    while (%scounter <= $chan(0)) {
      if ($left($nick($chan(%scounter),$me).pnick,1) == %) inc %hops
      inc %scounter
    }
    inc %counter
  }
  return %hops
}
alias rvoice {
  set %voice 0
  set %counter 1 
  while (%counter <= $scon(0)) { 
    /scon %counter
    set %scounter 1
    while (%scounter <= $chan(0)) {
      if ($left($nick($chan(%scounter),$me).pnick,1) == +) inc %voice
      inc %scounter
    }
    inc %counter
  }
  return %voice
}

alias rchanavg {
  return $round($calc($rpower / $rchans),0)
}

raw 266:*:{

}
alias rnets {
  return $scon(0)
}

alias rtest {
  if ($regex($1-,(h?)i)) {
    echo -a Yes
  }
}

alias rolinect {
  set %rolines 0
  set %rcounter 1
  while (%rcounter <= $scon(0)) {
    /scon %rcounter
    if ($status == connected) {
      if (o isincs $usermode) {
        inc %rolines
      }
    }
    inc %rcounter
  }
  return %rolines
}
