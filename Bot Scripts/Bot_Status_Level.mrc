::::::::::::::::::::::::::::::::::::::::::::::
; Bot Status Level Add/Remove Script by
; TomCoyote ( Tom Coyote Wilson
;  aka Coyote` on Geekshed.net IRC network )
; Set yourself as a User in the bot first
; User level 1000 or higher. Then in PM or
; Room you can use this script to add/del
; users (
; !status ADD Level (19 or higher)  NICK
; or !status Del Nick
; This adds in the form of:
; 19:NoNeYa!*lucifer@i.am.addicted.to.irc
; http://pastebin.com/xPtiYGtq
:::::::::::::::::::::::::::::::::::::::::::::
 
 
on *:TEXT:!status*:#:{
  if ($ulevel < 999) { msg $chan $nick Who the Friggin' heck do you think you are? Bite me! | .ignore -cu10 $nick | halt }
  else {
 
    if ($2 == del) { goto del }
    if ($3 !isnum) || ($3 < 19) {
      msg $chan Invalid Command. Syntax is !status ADD Level (19 or higher)  NICK or !status Del Nick
      HALT
    }
    if ($2 == add) {
      if ($3 isnum) && ($3 >= 19) {
        guser $3 $4
        msg $chan $4 has been added to my list at level $3 $+ .
        halt
      }
      :del
      if ($2 == del) {
        if ($3 !== $null) {
          ruser $3 $+ !
          msg $chan $3 has been deleted from my User list.
          halt
        }
        if ($2 == $null) {
          msg $chan Invalid Command. Syntax is !status ADD Level NICK or !status Del Nick
          HALT
        }
        else {
          msg $chan Invalid Command. Please try again.
        }
      }
    }
 
  }
}
;#### Query
 
on *:TEXT:!status*:?:{
  if ($ulevel < 999) { msg $nick Who the Friggin' heck do you think you are? Bite me! | .ignore -cu10 $nick | halt }
  else {
    if ($2 == del) { goto del }
    if ($3 !isnum) || ($3 < 19) {
      msg $nick Invalid Command. Syntax is !status ADD Level (19 or higher)  NICK or !status Del Nick
      HALT
    }
    if ($2 == add) {
      if ($3 isnum) && ($3 >= 19) {
        guser $3 $4
        msg $nick $4 has been added to my list at level $3 $+ .
        halt
      }
      :del
      if ($2 == del) {
        if ($3 !== $null) {
          ruser $3 $+ !
          msg $nick $3 has been deleted from my User list.
          halt
        }
        if ($2 == $null) {
          msg $nick Invalid Command. Syntax is !status ADD Level NICK or !status Del Nick
          HALT
        }
        else {
          msg $nick Invalid Command. Please try again.
        }
      }
    }
 
  }
 
}
 
alias -l opchk if (!$nick(#,$nick,~)) { .notice $nick You are not allowed to use this command | halt }
;(!$nick(#,$nick,~&@%+))
