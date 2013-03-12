#highlight on
on *:TEXT:*:#: {
  if (%hl.enable == on) {
    if ($istok(%hl.chan.halts,$chan,44)) { HALT }
    else {
      if ($istok(%hl.names,$1-,44)) || ($me isincs $1-) {
        if (%hl.tips) { noop $tip(Highlight,Highlight,You have been highlighted! $crlf $+ Network: $network $crlf $+ Nick: $nick $crlf $+ Time: $time(hh:nn tt) $crlf $+ Channel: $chan,5,,,,) }
        if (%hl.window) { 
          .window @highlight. [ $+ [ $network ] ]
          aline @highlight. [ $+ [ $network ] ] Highlight by $nick at $time(hh:nn tt) on $chan $+ : $1-
        }
        if (%hl.beeps) { .beep 5 | window -g2 $chan }
      }
    }
  }
}
#highlight end

menu @highlight.* {
  -
  Clear Window:clear
  -
}

ctcp 1:hlmngr:.ctcpreply $nick hlmngr Highlight Manager V 1.0 by GrimReaper & Zetacon.

menu * {
  Highlight Manager V 1.0:highlightmanager
}

dialog hlmanager {
  title "Highlight Manager"
  size -1 -1 134 189
  option dbu
  box "Highlights:", 3, 2 2 64 99
  list 4, 5 11 57 86, size
  box "Options:", 5, 68 2 64 99
  button "Add HL", 6, 71 12 27 12
  button "Del HL", 7, 102 12 27 12
  button "Edit HL", 8, 71 27 27 12
  button "Test $tip", 9, 102 27 27 12
  button "Ok", 10, 71 85 27 12
  button "Cancel", 11, 102 85 27 12
  check "Enable Highlights?", 12, 71 42 53 10
  check "Windows?", 13, 71 52 50 10
  check "$tip Windows?", 14, 71 62 50 10
  check "Flash and Beeps?", 15, 71 72 50 10
  box "Ignored Channels:", 16, 2 103 64 84
  list 17, 5 111 58 72, size
  box "Channel Options:", 18, 68 103 64 84
  button "Add Channel", 19, 71 112 58 12
  button "Edit Channel", 20, 71 127 58 12
  button "Delete Channel", 21, 71 142 58 12
  button "Test", 22, 71 164 58 12
  menu "File", 1
  item "Close", 2, 1
}

on *:DIALOG:hlmanager:init:*: {
  if (!%hl.enable) { did -b $dname 6,7,8,9,13,14,15 }
  if (%hl.enable) {
    did -c $dname 12
    if (%hl.window) { did -c $dname 13 }
    if (%hl.tips) { did -c $dname 14 }
    if (%hl.beeps) { did -c $dname 15 }
    var %a = 1
    while (%a <= $numtok(%hl.names,44)) {
      did -a $dname 4 $gettok(%hl.names,%a,44)
      inc %a
    }
    var %b = 1
    while (%b <= $numtok(%hl.chan.halts,44)) {
      did -a $dname 17 %gettok(%hl.chan.halts,%b,44)
      inc %b
    }
  }
}

on *:DIALOG:hlmanager:sclick:6-15,19-22: {
  if ($did == 12) {
    if ($did(12).state == 0) { unset %hl.enable | did -r $dname 4 | did -b $dname 6-9,13-15 | .disable #highlights }
    if ($did(12).state == 1) {
      .enable #highlights
      did -e $dname 6-9,13-15
      set %hl.enable on
      var %a = 1
      while (%a <= $numtok(hl.names,44)) {
        did -a $dname 4 $gettok(%hl.names,%a,44)
        inc %a
      }
      if (%hl.window) { did -c $dname 13 }
      if (%hl.tips) { did -c $dname 14 }
      if (%hl.beeps) { did -c $dname 15 }
    }
  }
  if ($did == 13) {
    if ($did(13).state == 0) { unset %hl.window }
    if ($did(13).state == 1) { set %hl.window on }
  }
  if ($did == 14) {
    if ($did(14).state == 0) { unset %hl.tips }
    if ($did(14).state == 1) { set %hl.tips on }
  }
  if ($did == 15) {
    if ($did(15).state == 0) { unset %hl.beeps }
    if ($did(15).state == 1) { set %hl.beeps on }
  }
  if ($did == 6) {
    did -r $dname 4
    set %hl.names $addtok(%hl.names,$$?="Please enter a highlight word:",44)
    var %a = 1
    while (%a <= $numtok(%hl.names,44)) {
      did -a $dname 4 $gettok(%hl.names,%a,44)
      inc %a
    }
  }
  if ($did == 7) {
    if (!$did(4).sel) { noop $input(Please select a word to delete.,owu,Error!) }
    else {
      unset %hl.names
      did -d $dname 4 $did(4).sel
      var %a = 1
      while (%a <= $did(4).lines) {
        set %hl.names $addtok(%hl.names,$did($dname,4,%a).text,44)
        inc %a
      }
    }
  }
  if ($did == 8) {
    if (!$did(4).sel) { noop $input(Please select a nick to edit.,owu,Error!) }
    else {
      set %hl.names $deltok(%hl.names,$did(4).sel,44)
      set %hl.names $addtok(%hl.names,$$?="Please enter a new highlight:",44)
      .timerhls 1 2 refreshhls
    }
  }
  if ($did == 9) {
    if (!%hl.tips) { noop $input(Please enable Highlight Tips.,o) }
    else {
      if ($me isop $active) {
        var %a = 1
        while (%a <= $did(4).lines) {
          bs say $active $did($dname,4,%a).text
          inc %a
        }
      }
    }
  }
  if ($did == 10) || ($did == 11) {
    dialog -x hlmanager hlmanager
  }
  if ($did == 19) {
    set %hl.chan.halts $addtok(%hl.chan.halts,$$?="Please enter a Channel name to ignore:",44)
    did -r $dname 17
    set -u4 %a 1
    while (%a <= $numtok(%hl.chan.halts,44)) {
      did -a $dname 17 $gettok(%hl.chan.halts,%a,44)
      inc %a
    }
  }
  if ($did == 20) {
    if (!$did(17).sel) { noop $input(Please select a Channel to edit.,owu,Error!) }
    else {
      set %hl.chan.halts $deltok(%hl.chan.halts,$did(17).sel,44)
      set %hl.chan.halts $addtok(%hl.chan.halts,$$?="Please enter a new Channel:",44)
      .timerhls 1 2 refreshchans
    }
  }
  if ($did == 21) {
    if (!$did(17).sel) { noop $input(Please select a Channel to delete.,owu,Error!) }
    else {
      unset %hl.chan.halts
      did -d $dname 17 $did(17).sel
      var %a = 1
      while (%a <= $did(17).lines) {
        set %hl.chan.halts $addtok(%hl.chan.halts,$did($dname,17,%a).text,44)
        inc %a
      }
    }
  }
  if ($did == 22) {
    .msg BotServ say $did(17,1) $did(4,1)
  }
}

on *:DIALOG:hlmanager:menu:2: {
  dialog -x hlmanager hlmanager
}

alias -l refreshhls {
  did -r hlmanager 4
  var %a = 1
  while (%a <= $numtok(%hl.names,44)) {
    did -a hlmanager 4 $gettok(%hl.names,%a,44)
    inc %a
  }
}

alias -l refreshchans {
  did -r hlmanager 17
  var %a = 1
  while (%a <= $numtok(%hl.chan.halts,44)) {
    did -a hlmanager 17 $gettok(%hl.chan.halts,%a,44)
    inc %a
  }
}


alias -l highlightmanager {
  dialog $iif($dialog(hlmanager),-v,-m hlmanager) hlmanager
}
