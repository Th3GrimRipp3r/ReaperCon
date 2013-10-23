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
; Added CloneScan Right Click | Can now turn off individual sections via right click menu
; and Menubar Also can turn Off/On All Logging Now )
; Version 2.4 TheLogger.mrc
;#######################################################################################

;Start TheLogger ---

on *:start: {
  ; If you have some nicks you don't want to log on every time they call your nicks
  ; use the pattern(s) below to stop them on channel text and action for the HighLight Log
  set -e %hinick Cindy` Cindy Chillsy 
  ;#######

  .timer 1 1 window -De[2]k[0]m @HighLights 
  .timer 1 2 window -De[2]k[0]m @Notice
  .timer 1 4 window -De[2]k[0]m @Bans
  .timer 1 5 window -De[2]k[0]m @Kicks
  .timer 1 8 window -De[2]k[0]m @Quits
  .timer 1 10 window -De[2]k[0]m @Clones
  .timer 1 12 window -De[2]k[0]m @ComChan
}


menu channel,menubar,status,@TheLogger {
  -
  TheLogger:
  .Logging  
  ..All Logging
  ...$iif(($group(#COMCHANCLONE) == off) && ($group(#NOTICE) == off) && ($group(#HIGHLIGHT) == off) && ($group(#BANLOG) == off) && ($group(#KICKLOG) == off) && ($group(#QUITLOG) == off),$style(3))) Off:{ .disable #COMCHANCLONE | .disable #NOTICE | .disable #HIGHLIGHT | .disable #BANLOG | .disable #KICKLOG | .disable #QUITLOG | .echo -a 4(All Logging Off success) }
  ...$iif(($group(#COMCHANCLONE) == on) && ($group(#NOTICE) == on) && ($group(#HIGHLIGHT) == on) && ($group(#BANLOG) == on) && ($group(#KICKLOG) == on) && ($group(#QUITLOG) == on),$style(3))) On:{ .enable #COMCHANCLONE | .enable #NOTICE | .enable #HIGHLIGHT | .enable #BANLOG | .enable #KICKLOG | .enable #QUITLOG | .echo -a 4(All Logging On success) }
  ..Quits
  ...$iif($group(#QUITLOG) == off,$style(3)) Off:.disable #QUITLOG | echo -a 4 (#QUITLOG) Logging OFF
  ...$iif($group(#QUITLOG) == on,$style(3)) On:.enable #QUITLOG | echo -a 12 (#QUITLOG) Logging ON
  ..Kicks
  ...$iif($group(#KICKLOG) == off,$style(3)) Off:.disable #KICKLOG | echo -a 4 (#KICKLOG) Logging OFF
  ...$iif($group(#KICKLOG) == on,$style(3)) On:.enable #KICKLOG | echo -a 12 (#KICKLOG) Logging ON 
  ..Bans
  ...$iif($group(#BANLOG) == off,$style(3)) Off:.disable #BANLOG | echo -a 4 (#BANLOG) Logging OFF
  ...$iif($group(#BANLOG) == on,$style(3)) On:.enable #BANLOG | echo -a 12 (#BANLOG) Logging ON
  ..Highlights
  ...$iif($group(#HIGHLIGHT) == off,$style(3)) Off:.disable #HIGHLIGHT | echo -a 4 (#HIGHLIGHT) Logging OFF
  ...$iif($group(#HIGHLIGHT) == on,$style(3)) On:.enable #HIGHLIGHT | echo -a 12 (#HIGHLIGHT) Logging ON
  ..Notices
  ...$iif($group(#NOTICE) == off,$style(3)) Off:.disable #NOTICE | echo -a 4 (#NOTICE) Logging OFF
  ...$iif($group(#NOTICE) == on,$style(3)) On:.enable #NOTICE | echo -a 12 (#NOTICE) Logging ON
  ..Commonchan&Clones
  ...$iif($group(#COMCHANCLONE) == off,$style(3)) Off:.disable #COMCHANCLONE | echo -a 4 (#COMCHANCLONE) Logging OFF
  ...$iif($group(#COMCHANCLONE) == on,$style(3)) On:.enable #COMCHANCLONE | echo -a 12 (#COMCHANCLONE) Logging ON
  CloneScan:
  .Clonescan #:/clone #
  .Clonescan ?Chan:/clone $input(Enter #Chan #Chan,e,Clonescan)
}

menu channel,menubar,nicklist {
  CommonChannel:
  .ComChan $1:/com $1
  .ComChan ?Nick:/com $input(Enter Nick you want to check for Common Channels,e,Common Channels Check)

}

#QUITLOG on
on 1:QUIT: { 
  window -De[2]k[0]m @Quits
  echo @Quits [Quit Tracker]9,1 $timestamp $network -- 7,1  $nick --4,1 $address($nick,1) -- Quit:9,1 $1- 
}
#QUITLOG end
#KICKLOG on
on *:kick:#:{ 
  window -De[2]k[0]m @kicks
  echo @kicks [Kick Tracker]9,1 $timestamp $network -- $nick  kicked 7,1 $knick  from 9,1 $chan  -- kick 9,1 $1- 
}
#KICKLOG end
#BANLOG on
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
#BANLOG end
#HIGHLIGHT on
;Start Highlight Logger ----
on *:text:*:#: {
  if ($istok(%hinick,$nick,32)) { halt }
  if ($highlight($1- $lf)) && !$($+(%,highlightflood,.,$nick),2) {
    set -u10 $+(%,highlightflood,.,$nick) on
    window -De[2]k[0]m @highlights
    echo @highlights $timestamp 9,1 $network -- $nick  HighLighted you 7,1 # : 9,1 $nick : --7,1 $1-  
  }
}
on *:action:*:#: {
  if ($istok(%hinick,$nick,32)) { halt }
  if ($highlight($1- $lf)) && !$($+(%,highlightflood,.,$nick),2) {
    set -u10 $+(%,highlightflood,.,$nick) on
    window -De[2]k[0]m @highlights
    echo @highlights $timestamp 9,1 $network -- $nick  has taken action on you 7,1 # 9,1 $nick : --7,1 $1- 
  }
}
;End Highlight Logger ----
#HIGHLIGHT end
#NOTICE on
;Start Notice Logger ---
on $*:NOTICE:/(.+)/Si:*:{
  var %note = 1
  while (%note <= $comchan($nick,0)) {
    var %noted = $addtok(%noted,$comchan($nick,%note),32)
    inc %note
  }
  if ($istok(HostServ|NickServ|MemoServ|BotServ|OperServ|ChanServ,$nick,124)) { HALT }
  if ($chr(35) iswm $chan) {
    window -De @Notice
    echo @notice $timestamp $+(,$network,) -- $nick has Noticed you 7,1 $chan : 9,1 $v2  $addtok(%noted,$comchan($nick,%note),32)  : -- $regml(1)
  }
  else {
    window -De[2]k[0]m @notice
    echo @Notice $timestamp $+(,$network) -- 9,1 $v2 ::: $nick 7,1  $addtok(%noted,$comchan($nick,%note),32) has Noticed you:9,1 $+(,$v2,:) >>  -- 7,1 $regml(1)
  }
}
;End Notice Logger ---
#NOTICE end
#COMCHANCLONE on
;Start Clone Logger ---
on *:Join:#: {
  ; Remark out the next two lines if you want the network ops 
  ; of those servers showing as clones of each other or change to 
  ; match the network you want to not show as clones
  if (($address($nick,2) = *!*@geekshed.net)) halt
  if (($address($nick,2) = *!*@ipocalypse.net)) halt
  ;#########
  var %host_to_search_for = $address($nick,2)
  var %number_from_that_host = $ialchan(%host_to_search_for,$chan,0)
  if (%number_from_that_host > 1) {
    var %count = 0
    unset %clones
    :loop
    inc %count
    var %clones = %clones $ialchan(%host_to_search_for,$chan,%count).nick
    if (%count < %number_from_that_host) { goto loop }
    echo -t $chan 8(Clones Detected) 0 %count 7Clones From 8 $address($nick,2) [[ %clones ]]  
    window -De[2]k[0]m @Clones
    echo @Clones $timestamp $network $chan 8(Clones Detected) 0 %count 7Clones From 8 $address($nick,2) [[ %clones ]]  
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
  ;echo -nmr $chan 9,1 $nick  is in ComChans:9,1 $replace(%lo1,$chr(44),$chr(32))

  /*
  You can turn off the next two lines if you don't want to have the common channels 
  logged as the person joins by adding a semicolon in front of the lines (;) 
  */
  window -De[2]k[0]m @comchan
  .timer 1 1  echo @comchan $timestamp $network # 9,1 $nick 7,1 is in ComChans:9,1 $replace(%lo1,$chr(44),$chr(32))
}
#COMCHANCLONE end
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
    echo -nmr $chan 9,1 $1  is in ComChans:9,1 $replace(%lo12,$chr(44),$chr(32))

    /*
    You can turn on the next two lines if you want to have the common channels 
    logged when you use the menu to check a nick by removing the semicolon in front of the lines (;) 
    */
    ; window -De[2]k[0]m @comchan
    ; .timer 1 1  echo @comchan $timestamp $network # 9,1 $1 7,1 is in ComChans:9,1 $replace(%lo12,$chr(44),$chr(32))
  }
}
; End ComChannel Logger
; Start Clonescan Room
alias clone {
  if ($1 !== $chan) {
    echo -a 7This command must be used for a CHANNEL not a name, use # 
    halt
  }
  .who $chan
  set %cloneloopi 1
  set %checkedcloners ,
  set %clonesfound $false
  while (%cloneloopi <= $nick($chan,0)) {
    set %cloneloopj $calc(%cloneloopi + 1)
    var %clonednicks
    while (%cloneloopj <= $nick($chan,0)) {
      ;## in this next line if you want to exclude network ops from being detected as clones etc, 
      ;## follow the pattern as in "&& ($address($nick($chan, %cloneloopj),2) != *!*@geekshed.net)"
      if (($address($nick($chan, %cloneloopi),2) == $address($nick($chan, %cloneloopj),2)) && ($address($nick($chan, %cloneloopj),2) != *!*@geekshed.net) && (, $+ $nick($chan, %cloneloopj) $+ , !isin %checkedcloners)) {
        set %clonednicks %clonednicks $nick($chan, %cloneloopj)
        set %checkedcloners %checkedcloners $+ $nick($chan, %cloneloopj) $+ ,
      }
      inc %cloneloopj 1
    }
    if ($len(%clonednicks) != 0) {
      echo -a 4 $chan -- $nick($chan, %cloneloopi) ( $+ $address($nick($chan, %cloneloopi), 2) $+ ) Clones: %clonednicks $+ 
      window -De[2]k[0]m @Clones
      echo @Clones $timestamp 4 $chan -- $nick($chan, %cloneloopi) 0  7Clones From 8 4 $+ $nick($chan, %cloneloopi) ( $+ $address($nick($chan, %cloneloopi), 2) $+ ) [[  %clonednicks   ]]  
      set %clonesfound $true
    }
    unset %clonednicks
    inc %cloneloopi 1
  }
  if (%clonesfound == $false) {
    window -De[2]k[0]m @Clones
    echo -a 12No Clones Found In $chan $+ 
    echo @Clones $timestamp 4 $chan -- 12No Clones Found In $chan $+ 
  }  
  unset %cloneloopi
  unset %cloneloopj
  unset %clonednicks
  unset %checkedcloners
  unset %clonesfound
}
; End CloneScan Room ------
; #########################################################################
; Contributors of peices of code here and there are thanked and appreciated
; May your day shine brightly for helping with this tiny little bit of code
; Please don't ask for money or adulations of the highest degree, there is 
; None left as I sold it all for a new version of Dos 2.0 and Windows 3.1...
; Ohh, and a pack of Cigarrettes....
; #########################################################################

ctcp 1:TheLogger:/notice $nick TheLogger 7 TheLogger script version 2.4 9 $+($chr(84),$chr(111),$chr(109),$chr(67),$chr(111),$chr(121),$chr(111),$chr(116),$chr(101)) (( http://pastebin.com/1ZpgXfKT ))
;End TheLogger ---
