:::::::::::::::::::::::::::::::::::::
:: Bot Kick Script                 ::
:: Original Script by RAWRwins254  ::
:: Modifications by Zetacon/Danneh ::
:: Kicks unauthorized bots from    ::
:: an IRC channel.                 ::
:: All Rights Reserved             ::
:::::::::::::::::::::::::::::::::::::

;Instructions for Use:
;1. To turn on/off/view status of the script: !botkicker switch [on|off|status]
;2. To set a custom kick message: !botkicker set kickmsg kickmsghere, replacing "kickmsghere" with your kick message.
;3. To set a custom ban message: !botkicker set banmsg banmsghere, replacing "banmsghere" with your ban message.
;4. To set ban notification to channel/nick of a ban: !botkicker set nickchan nickorchan, replacing nickorchan with a desired nick or channel.
;5. To set exceptions: !botkicker set exception nick, replacing "nick" with the desired nick.

on *:TEXT:!botkicker *:#:{
  if (!$2) { msg $chan Error: !botkicker [switch|set] }
  if ($2 == switch) {
    if (!$3) { msg $chan Error: !botkicker switch [on|off|status] }
    if ($3 == on ) {
      set % [ $+ [ $chan ] $+ ] .botkicker.switch on
      msg $chan Bot Kicker is now ON.
      HALT
    }
    if ($3 == off) {
      set % [ $+ [ $chan ] $+ ] .botkicker.switch on
      msg $chan Bot Kicker is now OFF.
      HALT
    }
    if ($3 == status) {
      msg $chan Bot Kicker is currently % [ $+ [ $chan ] $+ ] .botkicker.switch $+ .
      HALT
    }
  }
  if ($2 == set) {
    if (!$2) { msg $chan Error: !botkicker set [kickmsg|banmsg|parameters|exceptions|nickchan] [text] }
    if ($3 == kickmsg) {
      set % [ $+ [ $chan ] $+ ] .botkicker.kickmsg $4-
      msg $chan Bot Kicker kickmsg set to " $+ % [ $+ [ $chan ] $+ ] .botkicker.kickmsg $+ ".
      HALT
    }
    if ($3 == banmsg) {
      set % [ $+ [ $chan ] $+ ] .botkicker.banmsg $4-
      msg $chan Bot Kicker banmsg set to " $+ % [ $+ [ $chan ] $+ ] .botkicker.kickmsg $+ ".
      HALT
    }
    if ($3 == parameters) {
      if ($4 == b) {
        set % [ $+ [ $chan ] $+ ] .botkicker.parameters b
        msg $chan Bot Kicker set to ban all unauthorized bots entering the channel.
        HALT
      }
      if ($4 == kb) {
        set % [ $+ [ $chan ] $+ ] .botkicker.parameters kb
        msg $chan Bot Kicker set to kick on the first entry into the channel and ban on the second entry.
        HALT
      }
      if ($4 == kkb) {
        set % [ $+ [ $chan ] $+ ] .botkicker.parameters kkb
        msg $chan Bot Kicker set to kick on the first two entries and ban on the third entry.
        HALT
      }
    }
    if ($3 == exceptions) {
      if ($istok(% [ $+ [ $chan ] $+ ] .botkicker.exceptions,$4,124)) {
        msg $chan $4 is already within the exception's for $+($chan,.)
      }
      else {
        set % [ $+ [ $chan ] $+ ] .botkicker.exceptions $addtok(% [ $+ [ $chan ] $+ ] .botkicker.exceptions,$4,124)
        msg $chan $4 has been added to the exception's list for $+($chan,.)
      }
    }
    if ($3 == nickchan) {
      set % [ $+ [ $chan ] $+ ] .botkicker.nickchan $4
      msg $chan Bot Kicker set to notify % [ $+ [ $chan ] $+ ] .botkicker.nickchan of all bot bans.
      HALT
    }            
  }
} 

On *:JOIN:#: { 
  if (% [ $+ [ $chan ] $+ ] .botkicker.switch == off) { HALT }
  if (% [ $+ [ $chan ] $+ ] .botkicker.switch == on) {
    if (*bot* iswm $nick) || (*bot* iswm $address($nick,2)) && ($nick != $me) {
      if ($istok(% [ $+ [ $chan ] $+ ] .botkicker.exceptions,$nick,124)) { HALT }
      else {
        inc %counter. [ $+ [ $nick ] $+ ] . [ $+ [ $chan ] ]
        inc %counter. [ $+ [ $address($nick,2) ] $+ ] . [ $+ [ $chan ] ]
        if (% [ $+ [ $chan ] $+ ] .botkicker.parameters == b) {
          mode $chan +b $address($nick,2)
          msg $chan % [ $+ [ $chan ] $+ ] .botkicker.banmsg
          kick $chan $nick % [ $+ [ $chan ] $+ ] .botkicker.kickmsg
          msg % [ $+ [ $chan ] $+ ] .botkicker.nickchan $nick has been banned in $+($chan,.)
        }
        elseif (% [ $+ [ $chan ] $+ ] .botkicker.parameters == kb) {
          if (%counter. [ $+ [ $nick ] $+ ] . [ $+ [ $chan ] ] == 1) { kick $chan $nick % [ $+ [ $chan ] $+ ] .botkicker.kickmsg }
          elseif (%counter. [ $+ [ $nick ] $+ ] . [ $+ [ $chan ] ] == 2) {
            mode $chan +b $address($nick,2)
            msg $chan % [ $+ [ $chan ] $+ ] .botkicker.banmsg
            kick $chan $nick % [ $+ [ $chan ] $+ ] .botkicker.kickmsg
            msg % [ $+ [ $chan ] $+ ] .botkicker.nickchan $nick has been kick/banned in $+($chan,.)
          }
          elseif (% [ $+ [ $chan ] $+ ] .botkicker.parameters == kkb) {
            if (%counter. [ $+ [ $nick ] $+ ] . [ $+ [ $chan ] ] == 1) || (%counter. [ $+ [ $nick ] $+ ] . [ $+ [ $chan ] ] == 2) { kick $chan $nick % [ $+ [ $chan ] $+ ] .botkicker.kickmsg }
            elseif (%counter. [ $+ [ $nick ] $+ ] . [ $+ [ $chan ] ] == 3) {
              mode $chan +b $address($nick,2)
              msg $chan % [ $+ [ $chan ] $+ ] .botkicker.banmsg
              kick $chan $nick % [ $+ [ $chan ] $+ ] .botkicker.kickmsg
              msg % [ $+ [ $chan ] $+ ] .botkicker.nickchan $nick has been kicked twice and banned in $+($chan,.)
            }
          }
        }
      }
    }
  }
}
