::::::::::::::::::::::::::::::::::::::::::::::
; Bot Status Level Add/Remove Script by 
; TomCoyote ( Tom Coyote Wilson
;  aka Coyote` on Geekshed.net IRC network )
; Set yourself as a User in the bot first
; User level (*1000) or higher. Then in PM or
; Room you can use this script to add/del
; users ( 
; !status ADD Level (?? or higher)  NICK 
; or !status Del Nick
; eg; !status add 19 NoNeYa
; eg; !status del NoNeYa 
; This adds in the form of:
; 19:NoNeYa!*lucifer@i.am.addicted.to.irc
; http://pastebin.com/xPtiYGtq
:::::::::::::::::::::::::::::::::::::::::::::
on *:start:{
  ; Set your administrator use level, the lowest level that you want someone to use this command
  ; as in lower than 999 can't use it
  set -e %adminst 999
  ; set the minimum level of user you will be adding on the next line
  set -e %levelst 19
}

on *:TEXT:!status*:#:{
  if (%levelst == $null) { msg $chan please restart mirc to set the defaults | halt }
  if (%adminst == $null) { msg $chan please restart mirc to set the defaults | halt }
  if ($ulevel < %adminst) { msg $chan $nick Who the Friggin' heck do you think you are? Bite me! | .ignore -cu10 $nick | halt }
  else {
    if ($2 == del) { goto del }
    if ($3 !isnum) || ($3 < %levelst) { 
      msg $chan Invalid Command. Syntax is !status ADD Level ( $+ %levelst or higher)  NICK or !status Del Nick
      HALT
    }
    if ($4 != $ial($4,1).nick) { msg $chan $4 is not online at this time, please try again later | halt }
    if ($2 == add) {
      var %4  $4
      if ($3 isnum) && ($3 >= %levelst) {
        if ($4 isin $ulist($address(%4,1))) { msg $chan $4 Is already in the User list, you must Delete to change | halt }
        guser $3 $4
        msg $chan $4 has been added to my list at level $3 $+ .
        halt
      }
      :del
      if ($2 == del) {
        if ($3 !== $null) {
          var %3 $3
          if ($3 !isin $ulist($address(%3,1))) { msg $chan $3 Is Not in the user list | halt }
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
  if ($ulevel < %adminst) { msg $nick Who the Friggin' heck do you think you are? Bite me! | .ignore -cu10 $nick | halt }
  else {
    if ($2 == del) { goto del }
    if ($3 !isnum) || ($3 < %levelst) { 
      msg $nick Invalid Command. Syntax is !status ADD Level (%levelst or higher)  NICK or !status Del Nick
      HALT
    }

    if ($4 != $ial($4,1).nick) { msg $nick $4 is not online at this time, please try again later | halt }
    var %4  $4

    if ($2 == add) {
      if ($3 isnum) && ($3 >= %levelst) {
        if ($4 isin $ulist($address(%4,1))) { msg $nick $4 Is already in the User list, you must Delete to change | halt }


        guser $3 $4
        msg $nick $4 has been added to my list at level $3 $+ .
        halt
      }
      :del
      if ($2 == del) {
        if ($3 !== $null) {
          var %3 $3

          if ($3 !isin $ulist($address(%3,1))) { msg $nick $3 Is Not in the user list | halt }

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
