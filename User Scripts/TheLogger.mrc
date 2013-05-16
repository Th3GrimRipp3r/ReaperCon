; Version 1.2 Who banned script by Phil
; and the concept of Cheiron's Kick and Ban logger combined and 
; Modified by Tom Wilson
; This script notifies you which users a ban affects when one is set
; 
; Modified to open two windows @bans and @kicks to track time and such
; After first kick and ban, right click on those new windows and turn logging on
; If researching a kick or ban, look at the time stamp and search to that time
; in the room that logged it
####
; Highlight Logger by TomCoyote Version 1.2
; Go to your Address Book, Click on Highlight Tab
; Add, then put the nicks you want to Log into one line
; Separated by a comma (,) as in Nick1,Nick2,Nick3,$me
; and it will work regardless if Enable Highlight 
; box is Checkmarked or not.
; After first highlight has been recorded, a new window
; will open called @highlights, Right click on the window
; tab and choose LOG (on) if you want to keep a record
####
; TomCoyote NoticeLogger v.1.2
; collaborated on this script <Danneh>
; This is to help track where those 
; pesky notices come from if you are in
; multiple rooms/servers
####
; Clone Logger by TomCoyote
; This version opens a separate window to track 
; clones. Thus if needed you can search them easily.
; you can right click on the Clone window it 
; opens and choose to Log
; the results if needed
####


on *:start: {
  .timer 1 8 window -De[2]k[0]m @Clones
  .timer 1 6 window -De[2]k[0]m @Quits
  .timer 1 5 window -De[2]k[0]m @bans
  .timer 1 4 window -De[2]k[0]m @kicks
  .timer 1 3 window -De[2]k[0]m @notice
  .timer 1 2 window -De[2]k[0]m @highlights
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
  if ($highlight($1- $lf)) && !$($+(%,highlightflood,.,$nick),2) {
    set -u10 $+(%,highlightflood,.,$nick) on
    window -De[2]k[0]m @highlights
    echo @highlights $timestamp 9,1 $network ---- $nick  has highlighted you in 7,1 # : 9,1 $nick : ----7,1 $1-  
  }
}
on *:action:*:#: {
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

  }
}
;End Clone Logger ------


ctcp 1:tcwbklver:ctcpreply $nick tcwbklver $+($chr(84),$chr(111),$chr(109),$chr(67),$chr(111),$chr(121),$chr(111),$chr(116),$chr(101)) WhoBanKick Logger script version 1.2
; window -De[2]k[0]m @Quits
