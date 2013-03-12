; Swear nick warn script by Phil
; Modified by GrimReaper and Zetacon for use with Hooch
; Warns a user for having a swear word in their nickname
; Kicks the user after 60 seconds if they don't change their nick
; Requires a file of swear words (each on its own line) in the mirc.exe directory
; with a name of swear-words.txt
; Replace all instances of #bots with the desired channel

To change:
- Allow each channel to have their own respective list.
- Allow each channel to have their own warning message.
- Allow each channel to have their own kick message.
- Perhaps eliminate the "thank you" message?
- Enable a kick, kick, ban method and perhaps allow users to change.


on *:JOIN:#:{
  if (%master.switch == off) { HALT }
  if (%master.switch == on) {
    if (% [ $+ [ $chan ] $+ ] .swearnick.switch == off) { HALT }
    if (% [ $+ { $chan ] $+ ] .swearnick.switch == on) {
      if ($snw.containsSwear($nick) == 1) {
        msg $chan $nick $+ : Your nickname contains a swear word. If you do not change your nickname within 60 seconds you shall be kicked.
        if ($timer(snw $+ $network $+ snw $+ $nick $+ snw) == $null) {
          .timersnw $+ $network $+ snw $+ $nick $+ snw 1 60 kick $chan $nick
        }
      }
    }
  }
}

on *:PART:#:{
  if (%master.switch == off) { HALT }
  if (%master.switch == on) {
    if (% [ $+ [ $chan ] $+ ] .swearnick == off) { HALT }
    if (% [ $+ [ $chan ] $+ ] .swearnick == on) {
      if ($timer(snw $+ $network $+ snw $+ $nick $+ snw) != $null) {
        .timersnw $+ $network $+ snw $+ $nick $+ snw off
      }
    }
  }
}

on *:NICK:{
  if (%master.switch == off) { HALT }
  if (%master.switch == on) {
    if (% [ $+ [ $chan ] $+ ] .swearnick == off) { HALT }
    if (% [ $+ [ $chan ] $+ ] .swearnick == on) {
      if ($newnick ison $chan) {
        if ($snw.containsSwear($newnick) == 1) {
          msg $chan $newnick $+ : Your nickname contains a swear word. If you do not change your nickname within 60 seconds you shall be kicked.
          if ($timer(snw $+ $network $+ snw $+ $newnick $+ snw) == $null) {
            .timersnw $+ $network $+ snw $+ $newnick $+ snw 1 60 kick #bots $newnick
          }
        }
        else {
          if ($timer(snw $+ $network $+ snw $+ $nick $+ snw) != $null) {
            .timersnw $+ $network $+ snw $+ $nick $+ snw off
            msg $chan Thanks $newnick
          }
        }
      }
    }
  }
}

alias snw.containsSwear {
  set %snw.i 1

  while (%snw.i <= $lines(swear-words.txt)) {
    if ($read(swear-words.txt, %snw.i) isin $1-) {
      return 1
    }

    inc %snw.i
  }

  return 0
}