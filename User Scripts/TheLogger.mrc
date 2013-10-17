; TheLogger By TomCoyote ( Tom Coyote Wilson aka Coyote` on Geekshed.net IRC network )
; This script opens 7 windows (Highlights\Notice\Bans\Kicks\Quits\Clones\ComChan)
; As you are Highlighted in channels that action is logged via Network\Channel\User
; As you are Noticed on a network that action is logged via Network\Common Channels
; As a Ban happens it is logged via Banned\Hostmask\Channel\Network\Banner\Reason
; As a Kick happens it is logged via Kick\Channel\Network\Kicker\Reason
; As a Quit happens it is logged via Quit\Message\Nick\Host\Network
; As Clones detected they are logged via Network\Host\Channel\Nicks
; As ComChannels Are Detected they are logged via Network\Channel\Nick\ComCHannels
; Each window can be chosen at your leisure to right click on and choose to log or not
; As well you can right click on each window and choose to set the timestamp or not
; Version 2.0 TheLogger.mrc

on *:start: {
  .timer 1 1 window -De[2]k[0]m @HighLights 
  .timer 1 2 window -De[2]k[0]m @Notice
  .timer 1 4 window -De[2]k[0]m @Bans
  .timer 1 5 window -De[2]k[0]m @Kicks
  .timer 1 8 window -De[2]k[0]m @Quits
  .timer 1 10 window -De[2]k[0]m @Clones
  .timer 1 12 window -De[2]k[0]m @ComChan

}

;Start Who Banned - Quit - Kick Logger ---
on 1:QUIT: { 
  window -De[2]k[0]m @Quits
  echo @Quits [Quit Tracker]9,1 $timestamp $network ------- 7,1  $nick ---4,1 $address($nick,1) ---- Quit:9,1 $1- 
}
on *:kick:#:{ 
  window -De[2]k[0]m @kicks
  echo @kicks [Kick Tracker]9,1 $timestamp $network -- $nick  kicked 7,1 $knick  from 9,1 $chan  ---- kick 9,1 $1- 
}
on *:BAN:#:{
  unset %whoBanned.*
  set %whoBanned.i 1
  if ($left($banmask, 1) == ~) {
    set %whoBanned.banMask $mid($banMask, 4, $calc($len($banmask) - 3))
  }
  else {
    set %whoBanned.banMask $banmask
  }
  while (%whoBanned.i <= $nick($chan, 0)) {
    if (%whoBanned.banMask iswm $address($nick($chan, %whoBanned.i), 5)) {
      set %whoBanned.list %whoBanned.list $nick($chan, %whoBanned.i) $+ ,
    }
    inc %whoBanned.i
  }
  echo $chan 9,1 This ( $+ $banmask $+ ) ban affects:4,1 ( $+ $mid(%whoBanned.list, 0, $calc($len(%whoBanned.list) - 1)) $+ )
  window -De[2]k[0]m @bans
  echo @bans [Ban Tracker] 9,1 $timestamp $network -- $chan -- $nick set the ban $1- against user ban affects: 7,1( $+ $mid(%whoBanned.list, 0, $calc($len(%whoBanned.list) - 1)) $+ ) 
  unset %whoBanned.*
}
;End Who Banned - Quit - Kick Logger ---

;Start Highlight Logger ----
on *:text:*:#: {
  if ($nick == Chillsy) { halt }
  if ($nick == Cindy) { halt }
  if ($nick == Cindy`) { halt }

  if ($highlight($1- $lf)) && !$($+(%,highlightflood,.,$nick),2) {
    set -u10 $+(%,highlightflood,.,$nick) on
    window -De[2]k[0]m @highlights
    echo @highlights $timestamp 9,1 $network ---- $nick  has highlighted you in 7,1 # : 9,1 $nick : ----7,1 $1-  
  }
}
on *:action:*:#: {
  if ($nick == Cindy) { halt }
  if ($nick == Cindy`) { halt }


  if ($highlight($1- $lf)) && !$($+(%,highlightflood,.,$nick),2) {
    set -u10 $+(%,highlightflood,.,$nick) on
    window -De[2]k[0]m @highlights
    echo @highlights $timestamp 9,1 $network --- $nick  has taken action on you in 7,1 # 9,1 $nick : ------7,1 $1- 
  }
}

;End Highlight Logger ----

;Start Notice Logger ---
on $*:NOTICE:/(.+)/Si:*:{
  var %note = 1
  while (%note <= $comchan($nick,0)) {
    var %noted = $addtok(%noted,$comchan($nick,%note),32)
    inc %note
  }
  if ($istok(HostServ|NickServ|MemoServ|BotServ|OperServ|ChanServ,$nick,124)) { HALT }
  if ($chr(35) iswm $chan) {
    window -De @notice
    echo @notice $timestamp $+(,$network,) ---- $nick has Noticed you in 7,1 $chan : 9,1 $v2  $addtok(%noted,$comchan($nick,%note),32)  : ---- $regml(1)
  }
  else {
    window -De[2]k[0]m @notice
    echo @notice $timestamp $+(,$network) ---- 9,1 $v2 ::: $nick 7,1  $addtok(%noted,$comchan($nick,%note),32) has Noticed you:9,1 $+(,$v2,:) >>  ---- 7,1 $regml(1)
  }
}
;End Notice Logger ---

;Start Clone Logger ---
on *:Join:#: {
  ; Remark out the next two lines if you want the network ops of those servers showing
  if (($address($nick,2) = *!*@geekshed.net)) halt
  if (($address($nick,2) = *!*@ipocalypse.net)) halt
  ; echo -s test
  var %host_to_search_for = $address($nick,2)
  var %number_from_that_host = $ialchan(%host_to_search_for,$chan,0)
  ; echo -s test2
  if (%number_from_that_host > 1) {
    ;we have clones!
    ;first set up our vars and loop
    var %count = 0
    unset %clones
    :loop
    inc %count
    ;loop through every nick, adding the nicks to %clones
    var %clones = %clones $ialchan(%host_to_search_for,$chan,%count).nick
    if (%count < %number_from_that_host) { goto loop }
    echo -t $chan 8(Clones Detected) 0 %count 7Clones From 8 $address($nick,2) [[ %clones ]]  
    window -De[2]k[0]m @Clones
    echo @Clones $timestamp $network $chan 8(Clones Detected) 0 %count 7Clones From 8 $address($nick,2) [[ %clones ]]  
    ; echo -s test final
    goto comchan
  }



  ;End Clone Logger ------
  ;Start ComChannel Logger
  ;
  :comchan  
  ;---
  if ($nick == $me) { halt }
  unset %lo1
  var %total = $comchan($nick,0), %x = 1
  while ( %x <= %total ) {
    set %lo1 %lo1 $+ , $+ $comchan($nick,%x)
    inc %x
  }
  /*
  You can turn on the next line if you want to have the common channels
  shown in the channels as the person joins by removing the semicolon in front of the line (;) 
  */
  ;echo -nmr $chan 9,1 $nick  is in the following common channels:9,1 $replace(%lo1,$chr(44),$chr(32))

  /*
  You can turn off the next two lines if you don't want to have the common channels 
  logged as the person joins by adding a semicolon in front of the lines (;) 
  */
  window -De[2]k[0]m @comchan
  .timer 1 1  echo @comchan $timestamp $network # 9,1 $nick 7,1 is in the following common channels:9,1 $replace(%lo1,$chr(44),$chr(32))
}

menu channel,menubar,nicklist,channel {
  CommonChannel:
  .ComChan $1:/com $1
  .ComChan ?Nick:/com $input(Enter Nick you want to check for Common Channels,e,Common Channels Check)
}

alias com {

  if ($1 == $me) { halt }
  else {
    unset %lo12
    var %total = $comchan($1,0), %x = 1
    while ( %x <= %total ) {
      set %lo12 %lo12 $+ , $+ $comchan($1,%x)
      inc %x
    }
    /*
    You can turn off the next line if you don't want to have the common channels
    shown in the channel when you use the menu to check a nick by adding a semicolon in front of the line (;) 
    */
    echo -nmr $chan 9,1 $1  is in the following common channels:9,1 $replace(%lo12,$chr(44),$chr(32))

    /*
    You can turn off the next two lines if you want to have the common channels 
    logged when you use the menu to check a nick by removing the semicolon in front of the lines (;) 
    */
    ; window -De[2]k[0]m @comchan
    ; .timer 1 1  echo @comchan $timestamp $network # 9,1 $1 7,1 is in the following common channels:9,1 $replace(%lo12,$chr(44),$chr(32))
  }
}
;End ComChannel Logger

ctcp 1:TheLogger:/notice $nick TheLogger 7 TheLogger script version 2.0 9 $+($chr(84),$chr(111),$chr(109),$chr(67),$chr(111),$chr(121),$chr(111),$chr(116),$chr(101)) 
; window -De[2]k[0]m @Quits
