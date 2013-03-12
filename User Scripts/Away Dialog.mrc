on *:TEXT:*:#: {
  if (%away.enable) {
    if ($me isincs $1-) {
      if (%away.msg) { 
        msg $chan I'm sorry $nick $+ , I am currently away: $awaymsg I have been away for: $duration($awaytime) Please leave a message and I'll get back to you. 
        window @away. $+ $network
        aline @away. $+ $network $nick in $chan at $time(hh:nn:ss tt) said: $1-
      }
    }
  }
}

menu * {
  Away Dialog:awaydia
}

menu @away.* {
  Clear Window:/clear
}

dialog awaydia {
  title "Away Dialog"
  size -1 -1 200 180
  option pixels
  tab "Set Away", 1, 0 0 199 150
  tab "Set Back", 12
  button "Ok", 4, 31 151 65 25, ok flat
  button "Cancel", 5, 103 151 65 25, cancel flat
  box "Away", 6, 6 27 184 110, tab 1
  edit "", 7, 72 41 110 20, autohs,  tab 1
  text "Away Nick:", 8, 12 42 55 17, tab 1
  text "Away Msg:", 9, 12 65 55 17, tab 1
  edit "", 10, 72 64 108 20, tab 1
  button "Set Away", 11, 65 111 65 25, tab 1
  box "Back", 13, 6 27 184 110, tab 12
  text "Back Nick:", 14, 12 42 55 17, tab 12
  edit "", 15, 72 41 110 20, autohs, tab 12
  button "Set Back", 16, 65 82 65 25, tab 12
  check "Away Message?", 17, 12 89 95 17, tab 1
  menu "File", 2
  item "Exit", 3, 2
}

on *:DIALOG:awaydia:init:*: {
  if (!%away.nick) && (!%back.nick) { 
    set %away.nick $$?="Please enter your away nick:"
    set %back.nick $$?="Please enter your normal nick:"
    did -a $dname 7 %away.nick
    did -a $dname 15 %back.nick
  }
  else {
    did -ra $dname 15 %back.nick
    did -ra $dname 7 %away.nick
  }
}

on *:DIALOG:awaydia:sclick:11,16: {
  if ($did == 11) {
    if (!$did($dname,10).text) {
      scon -a nick $did($dname,7).text
    }
    elseif (!$did($dname,7).text) {
      set %away.enable on
      set %away.msg on
      scon -a away $did($dname,10).text
    }
    else {
      if ($did(17).state == 0) {
        scon -a away $did($dname,10).text
        scon -a nick $did($dname,7).text
      }
      if ($did(17).state == 1) {
        scon -a away $did($dname,10).text
        scon -a nick $did($dname,7).text
        set %away.enable on
        set %away.msg on
      }
    }
  }
  if ($did == 16) {
    if ($away == $true) {
      scon -a away
      scon -a nick $did($dname,15).text
      unset %away.msg %away.enable
    }
    else {
      scon -a nick $did($dname,15).text
    }
  }
}

on *:DIALOG:awaydia:menu:3: {
  dialog -x awaydia awaydia
}

alias -l awaydia {
  $iif($dialog(awaydialog),dialog -v,dialog -m awaydia) awaydia
}
