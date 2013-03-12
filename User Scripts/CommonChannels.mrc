; Compiled by TomCoyote 
; Common Channels Script
; Can show in different ways 
; and can be used singly per nick also
; Alternatives shown in Text Below

menu channel,menubar,nicklist,channel {
  CommonChannel:
  .ComChan $1:/com $1
  .ComChan ?Nick:/com $input(Enter Nick you want to check for Common Channels,e,Common Channels Check)
}

on *:JOIN:#: {
  if ($nick == $me) { halt }
  else {
    unset %lo1
    var %total = $comchan($nick,0), %x = 1
    while ( %x <= %total ) {
      set %lo1 %lo1 $+ , $+ $comchan($nick,%x)
      inc %x
    }
    /*
    You can turn off the next line if you don't want to have the common channels
    shown in the channels as the person joins by adding a semicolon in front of the line (;) 
    */
    echo -nmr $chan 9,1 $nick  is in the following common channels:9,1 $replace(%lo1,$chr(44),$chr(32))

    window -De @comchan
    /*
    You can turn off the next line if you don't want to have the common channels 
    logged as the person joins by adding a semicolon in front of the line (;) 
    */
    .timer 1 1  echo @comchan $network # 9,1 $nick 7,1 is in the following common channels:9,1 $replace(%lo1,$chr(44),$chr(32))
  }
}
alias /com {
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

    window -De @comchan
    /*
    You can turn off the next line if you don't want to have the common channels 
    logged when you use the menu to check a nick by adding a semicolon in front of the line (;) 
    */
    .timer 1 1  echo @comchan $network # 9,1 $1 7,1 is in the following common channels:9,1 $replace(%lo12,$chr(44),$chr(32))
  }
}
