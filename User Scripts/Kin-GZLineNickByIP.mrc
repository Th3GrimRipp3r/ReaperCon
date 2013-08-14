; GZline a nickname by it's IP address
;   - Can handle more than 1 nickname waiting for a userIP response from server
;     good if multiple nicknames need to be corrected all at once

; Usage: /GZLineNickByIP nick

; 2013-08-13 v1.3 Fix $remtok bug
; 2013-08-13 v1.2 Check if the same nick is already waiting, to keep from spamming /userip unnecessarially
; 2013-08-13 v1.1 Add timeout timer if there is too much lag

; ----- Config

alias -l GZLineNickByIP.Timeout { return 18 }
alias -l GZLineNickByIP.GZLine.Length { return 1d }
alias -l GZLineNickByIP.GZLine.Reason { return Mass nick highlight detected, GZlined for 1 day. }

; ----- Alias

alias GZLineNickByIP {
  var %nick $1
  var %skip $false

  if ($istok(%GZLineNickByIP,%nick,32)) { %skip = $true }
  set -e %GZLineNickByIP $addtok(%GZLineNickByIP,%nick,32)

  .enable #GZLineNickByIP
  .timerGZLineNickByIP 1 $GZLineNickByIP.Timeout GZLineNickByIPTimeout

  if (%skip = $true) { return }
  !userip %nick
}

; ---- Events

on *:START:{ .disable #GZLineNickByIP }

#GZLineNickByIP off
raw 340:*:{
  var %pat /^([^=]+)=([+-])([^@]+)@(.*)$/
  if ($regex(GZLineNickByIP,$2,%pat)) {
    var %nick $regml(GZLineNickByIP,1)
    var %heregone $regml(GZLineNickByIP,2)
    var %ident $regml(GZLineNickByIP,3)
    var %IP $regml(GZLineNickByIP,4)

    if ($istok(%GZLineNickByIP,%nick,32)) {
      set -e %GZLineNickByIP $remtok(%GZLineNickByIP,%nick,0,32)
      if (o isincs $gettok($usermode,1,32)) {
        gzline *@ $+ %IP $GZLineNickByIP.GZLine.Length $GZLineNickByIP.GZLine.Reason
      }
      if (!%GZLineNickByIP) { GZLineNickByIPTimeout }
    }
  }
}
#GZLineNickByIP end

alias -l GZLineNickByIPTimeout {
  unset %GZLineNickByIP
  .disable #GZLineNickByIP
  .timerGZLineNickByIP off
}
