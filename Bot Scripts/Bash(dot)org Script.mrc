;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bash.org Script By Danneh ;;
;; Server: irc.GeekShed.net  ;;
;; Channel: #Reapercon        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

menu channel {
  &Bash.org Setup:dialog $iif($dialog(bashdotorg),-v,-m bashdotorg) bashdotorg
}

dialog bashdotorg {
  title "Bash.org Setup"
  size -1 -1 170 151
  option dbu
  box "Channel Setup:", 3, 3 3 65 144
  button "Add", 4, 17 14 37 12
  button "Delete", 5, 17 32 37 12, disable
  button "Refresh", 6, 17 49 37 12, disable
  list 7, 7 66 56 76, size
  box "General Setup", 8, 74 3 92 71
  text "Trigger Setup:", 9, 79 13 35 8
  edit "", 10, 117 12 44 10
  text "First Color:", 11, 79 26 27 8
  edit "", 12, 109 25 52 10
  text "Second Color:", 13, 79 39 34 8
  edit "", 14, 115 38 46 10
  button "Help", 15, 100 55 37 12
  button "Ok/Save", 16, 78 80 37 12
  button "Cancel", 17, 125 80 37 12, cancel
  text "This Bash.org addon was created by GrimReaper and Zetacon of the GeekShed IRC Network.. Should you need to contact them about anything, Feel free to join irc.GeekShed.net channels: #Hell and #Zetacon", 18, 78 97 87 49
  menu "File", 1
  item "Exit", 2, 1, ok cancel
}

dialog bashdotorghelp {
  title "Bash.org Help"
  size -1 -1 170 97
  option dbu
  box "Help Sections:", 1, 3 3 62 72
  list 4, 7 11 53 60, size
  box "Information:", 5, 69 3 97 72
  text "", 6, 73 11 88 59
  button "Ok", 7, 42 80 37 12, ok
  button "Cancel", 8, 91 80 37 12, cancel
  menu "File", 2
  item "Close", 3, 2
}

on *:DIALOG:bashdotorghelp:init:*: {
  didtok $dname 4 124 Add|Delete|Refresh|Trigger|Color 1|Color 2|About|Thanks
}
on *:DIALOG:bashdotorghelp:sclick:4: {
  if ($did(4).seltext == Add) { did -ra $dname 6 The "Add" button is there to provide the use of adding another channel to the setup. All channels should start with $+($chr(35),$chr(46)) }
  if ($did(4).seltext == Delete) { did -ra $dname 6 The "Delete" button is for when you would like to delete a channel from the setup of the script. Thus, halting any further command being triggered. }
  if ($did(4).seltext == Refresh) { did -ra $dname 6 The "Refresh" button is there so that you can refresh the channel's that have been added to the setting config. }
  if ($did(4).seltext == Trigger) { did -ra $dname 6 The "Trigger" edit box is there for you to enter a command trigger to use, Any trigger can be used, Input it like !Bash or @bash depending on Preference. }
  if ($did(4).seltext == Color 1) { did -ra $dname 6 The "Color 1" section is for the main color choice that you would like to use, i.e. the main quote from Bash.org's database of quotes. }
  if ($did(4).seltext == Color 2) { did -ra $dname 6 The "Color 2" section is the setting for the "Bash Quote" text at the beginning of the quote. You can set this to whatever preference you like. }
  if ($did(4).seltext == About) { did -ra $dname 6 This Bash.org addon was created by GrimReaper and Zetacon of the GeekShed IRC Network.. Should you need to contact them about anything, Feel free to join irc.GeekShed.net channels: #Hell and #Zetacon. }
  if ($did(4).seltext == Thanks) { did -ra $dname 6 This Bash.org addon would not be possible without help from some people, Namingly FordLawnmower for help on all the regex section. A HUGE thanks to him. }
}
on *:DIALOG:bashdotorg:init:*: {
  if ($readini(bashdotorg.ini,settings,channels) != $null) {
    did -e $dname 5,6
    var %a = $readini(bashdotorg.ini,settings,channels), %b = 1
    while (%b <= $numtok(%a,44)) {
      did -a $dname 7 $gettok(%a,%b,44)
      inc %b
    }
  }
  did -a $dname 10 $readini(bashdotorg.ini,settings,trigger)
  did -a $dname 12 $readini(bashdotorg.ini,settings,color1)
  did -a $dname 14 $readini(bashdotorg.ini,settings,color2)
}
on *:DIALOG:bashdotorg:sclick:4-6,15,16: {
  if ($did == 4) {
    if ($readini(bashdotorg.ini,settings,channels) == $null) {
      writeini bashdotorg.ini settings channels $$?="Please enter a channel to add."
      refreshchanlist
      did -e $dname 5,6
    }
    else {
      var %c = $readini(bashdotorg.ini,settings,channels)
      writeini -n bashdotorg.ini settings channels $+(%c,$chr(44),$$?="Please enter a channel to add.")
      refreshchanlist
    }
  }
  if ($did == 5) {
    var %c = $remtok($readini(bashdotorg.ini,settings,channels),$did(7).seltext,44)
    remini bashdotorg.ini settings channels
    $iif(%c != $null,.timer 1 1 writeini bashdotorg.ini settings channels %c)
    $iif($readini(bashdotorg.ini,settings,channels) == $null,.timer 1 1 did -b $dname 5,6)
    .timer 1 1 dialog -x $dname
  }
  if ($did == 6) { refreshchanlist | .timer 1 1 noop $input(Refreshing of the channel list has been completed.,o,Refresh!) }
  if ($did == 15) { dialog $iif($dialog(bashdotorghelp),-v,-m bashdotorghelp) bashdotorghelp }
  if ($did == 16) {
    if ($did(10) == $null) || ($did(12) == $null) || ($did(14) == $null) { noop $input(Not all fields have been $+(filled,$chr(44)) Please fill in all field.,o,Error!) }
    else {
      $iif($readini(bashdotorg.ini,settings,trigger) == $null,writeini,writeini -n) bashdotorg.ini settings trigger $did(10)
      $iif($readini(bashdotorg.ini,settings,color1) == $null,writeini,writeini -n) bashdotorg.ini settings color1 $did(12)
      $iif($readini(bashdotorg.ini,settings,color2) == $null,writeini,writeini -n) bashdotorg.ini settings color2 $did(14)
    }
  }
}

alias -l refreshchanlist {
  did -r bashdotorg 7
  var %a = $readini(bashdotorg.ini,settings,channels), %b = 1
  while (%b <= $numtok(%a,44)) {
    did -a bashdotorg 7 $gettok(%a,%b,44)
    inc %b
  }
}
on *:TEXT:*:$($readini(bashdotorg.ini,settings,channels)): {
  if ($1 == $readini(bashdotorg.ini,settings,trigger)) {
    if ($sock($+(bash,$chan))) { msg $chan Please wait till the current search has finished. }
    else {
      set -u10 %bashchan $chan
      bashopen $iif(!$2,random,$2)
      .timerbash 1 4 msg $chan * Error: Bash quote number $+(",$2,") does not exist.
    }
  }
}
on *:SOCKOPEN:bash: {
  tokenize 32 $sock(bash).mark
  if ($sockerr) { $2-3 * Error: Can't connect to the server. }
  else {
    var %var = sockwrite -n $sockname
    %var GET $+(/?,$1) HTTP/1.0
    %var Host: bash.org
    %var $crlf
  }
}
on *:SOCKREAD:bash: {
  tokenize 32 $sock(bash).mark
  var %bashread | sockread %bashread
  if ($1 isnum) {
    if ((</p> isin %bashread) || (<br /> isin %bashread)) {
      $2- $RemovePrefix($replace($htmlfree(%bashread),$chr(9),$chr(32),$chr(10),$chr(32),&lt;,<,&gt;,>,&quot;,$chr(34),&nbsp;,$chr(160),&amp;,$chr(38)))
      .timerbash off
    }
    elseif (<td valign='top'></td></tr></table> isin %bashread) { .sockclose $sockname }
  }
  else {
    if ($regex(%bashread,/<b>#([\d]{1,})<\/b>/)) { sockclose $sockname | bashopen  $regml(1) }
  }
}
alias -l bashopen {
  sockopen bash bash.org 80
  sockmark bash $iif(!$1,random,$1) msg %bashchan $+($chr(3),$bashcol2,:,$chr(3),$bashcol1,[,$chr(3),$bashcol2,Bash,$chr(3),$bashcol1,],$chr(3),$bashcol2,:,$chr(3),$bashcol1)
  $iif($1 isnum,msg %bashchan Looking up Bash Quote $+($chr(3),$bashcol1,$chr(35),$chr(3),$bashcol2,$1,,$chr(3),...))
}
alias -l htmlfree { var %x, %i = $regsub($1-,/(^[^<]*>|<[^>]*>|<[^>]*$)/g,$null,%x), %x = $remove(%x, ) | return %x }
alias -l bashcol1 {
  return $readini(bashdotorg.ini,settings,color1)
}
alias -l bashcol2 {
  return $readini(bashdotorg.ini,settings,color2)
}
alias -l RemovePrefix { return $regsubex($1-,/(#(?:[\d]{1,})\s\+\((?:[\d]{1,})\)-\s\[X\])/i,$null) }
