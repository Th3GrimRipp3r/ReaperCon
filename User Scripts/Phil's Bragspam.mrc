;  Status Bragging Script 
;  Version: 1.0
;  by: Helio - Modified by Phil
;  
;  note: all stats have there own identifiers.
;        Feel free to edit the bragspam alias
;        to your own liking.
;
;  To Do: 
;        Refining the $rpower alias
;          ie, taking out botserv bots,
;              logical duplicates, 
;              etc..
;
;

alias brag {
  if (%brag.originalcid != $null) {
    echo -a 4BragSpam is seemingly currently running. If this isn't the case type /unset % $+ brag.*
  }
  else {
    set %brag.originalcid $cid
    runlusers
  }
}

alias doBragOut {
  if ($1 != $null) {    
    set %brag.out I am on $rchans ( $+ $rsecret secret/private or op3r/admin only $+ ) channels, across $rnets networks. I have $rolines olines, $rprefix(~) owners, $rprefix(&) admins, $rprefix(@) ops, $rprefix(%) halfops and $rprefix(+) voices. I have channel level powers over $rpower people and network level powers over $1 people. Oh... and my e-penis is $duration($uptime(system,3)) $+ .
    scid %brag.originalcid
    msg $active %brag.out
    unset %brag.*
  }
  else {
    echo -a This alias should be called with network power as a param. Use /brag instead.
  }
}

; Get number of networks
alias rnets {
  set %brag.counter 1
  set %brag.nets 0

  while (%brag.counter <= $scon(0)) {
    /scon %brag.counter 
    if ($status == connected) {
      inc %brag.nets
    }
    inc %brag.counter
  }

  return %brag.nets
}

; Get total number of channels
alias rchans {
  set %brag.total 0
  set %brag.counter 1 
  while (%brag.counter <= $scon(0)) {
    /scon %brag.counter
    if ($status == connected) {
      set %brag.total $calc(%brag.total + $chan(0))
    }
    inc %brag.counter
  }
  return %brag.total
}

; Get number of instances when your nick has a certain prefix
; Syntax e.g. $rprefix(@)
alias rprefix {
  set %brag.prefixCount 0
  set %brag.counter 1 
  while (%brag.counter <= $scon(0)) { 
    /scon %brag.counter
    if ($status == connected) {
      set %brag.scounter 1
      while (%brag.scounter <= $chan(0)) {
        if ($left($nick($chan(%brag.scounter),$me).pnick,1) == $1) inc %brag.prefixCount
        inc %brag.scounter
      }
    }
    inc %brag.counter
  }
  return %brag.prefixCount
}

; Get the number of people you have channel level power over globally
alias rpower {
  set %brag.power 0
  set %brag.counter 1 

  while (%brag.counter <= $scon(0)) { 
    /scon %brag.counter
    if ($status == connected) {
      set %brag.scounter 1
      while (%brag.scounter <= $chan(0)) {
        if ($left($nick($chan(%brag.scounter),$me).pnick,1) == ~) {
          inc %brag.power $rpowerchan($chan(%brag.scounter), ~&@%+, ~&@%+)
        }
        elseif ($left($nick($chan(%brag.scounter),$me).pnick,1) == &) {
          inc %brag.power $rpowerchan($chan(%brag.scounter), @%+, ~&@%+)
        }
        elseif ($left($nick($chan(%brag.scounter),$me).pnick,1) == @) {
          inc %brag.power $rpowerchan($chan(%brag.scounter), @%+, ~&@%+)
        }
        elseif ($left($nick($chan(%brag.scounter),$me).pnick,1) == %) {
          inc %brag.power $rpowerchan($chan(%brag.scounter), +, ~&@%+)
        }

        inc %brag.scounter
      }
    }
    inc %brag.counter
  }

  return %brag.power
}

; Get the number of people you have channel level power over in a certain channel
; Syntax e.g. $rpowerchan(#phil, @%+, ~&@%+)
; The above gets the number of people who have @ % + or no prefix (i.e. if the first char is not in ~&@%+)
alias rpowerchan {
  set %brag.powerchan 0
  set %brag.rpccounter 1

  while (%brag.rpccounter <= $nick($1, 0)) {
    if ($nick($1, %brag.rpccounter) != $me) {
      if ($left($nick($1,%brag.rpccounter).pnick,1) isin $2 || $left($nick($1,%brag.rpccounter).pnick,1) !isin $3) {
        inc %brag.powerchan
      }
    }

    inc %brag.rpccounter
  }

  return %brag.powerchan
}

; Get number of secret, private and oper/admin only channels
alias rsecret {
  set %brag.secret 0
  set %brag.counter 1

  while (%brag.counter <= $scon(0)) { 
    /scon %brag.counter 
    if ($status == connected) {
      set %brag.scounter 1
      while (%brag.scounter <= $chan(0)) {
        if ((s isincs $chan(%brag.scounter).mode) || (O isincs $chan(%brag.scounter).mode) || (A isincs $chan(%brag.scounter).mode) || (p isincs $chan(%brag.scounter).mode)) {
          inc %brag.secret
        }
        inc %brag.scounter
      }
    }
    inc %brag.counter
  }
  return %brag.secret
}

; Get number of olines
alias rolines {
  set %brag.olines 0
  set %brag.counter 1

  while (%brag.counter <= $scon(0)) {
    /scon %brag.counter

    if ($status == connected) {
      if (o isincs $usermode) {
        inc %brag.olines
      }
    }

    inc %brag.counter
  }

  return %brag.olines
}

; Run an lusers on all networks where you have an oline
alias runlusers {
  set %brag.lcounter 1
  set %brag.expectedResponses 0
  set %brag.gotResponses 0
  set %brag.netpowerusers 0

  .enable #braglusers

  ; Timer to disable braglusers after 10 seconds just in case something goes tits up
  .timerdisablebraglusers 1 10 .disable #braglusers

  while (%brag.lcounter <= $scon(0)) {
    /scon %brag.lcounter

    if ($status == connected) {
      if (o isincs $usermode) {
        inc %brag.expectedResponses
        lusers
      }
    }

    inc %brag.lcounter
  }

  if (%brag.expectedResponses == 0) {
    doBragOut 0
    .disable #braglusers
  }
}

#braglusers off
raw 251:*:{ halt }
raw 252:*:{ halt }
raw 253:*:{ halt }
raw 254:*:{ halt }
raw 255:*:{ halt }
raw 265:*:{ halt }
raw 266:*:{
  set %brag.netpowerusers $calc(%brag.netpowerusers + $5)
  inc %brag.gotResponses

  if (%brag.gotResponses == %brag.expectedResponses) {
    doBragOut %brag.netpowerusers
    .disable #braglusers
    .timerdisablebraglusers off
  }

  halt
}
#braglusers endon *:start: { unset %countednets | set %olinecount 0 }
