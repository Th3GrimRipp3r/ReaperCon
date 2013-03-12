menu * {
  Access/XOP System:accessdialog
}

dialog accessdia {
  title "mIRC Access Dialog by GrimReaper"
  size -1 -1 148 113
  option dbu
  box "Userlist:", 3, 3 25 70 69
  list 4, 6 33 63 57, size multsel
  box "Access Setup:", 5, 75 3 70 37
  edit "", 6, 121 12 20 10
  text "Access Number:", 7, 77 13 39 8
  button "Add", 8, 77 25 15 12
  button "Del", 9, 94 25 15 12
  box "XOP Setup:", 10, 75 41 70 53
  text "Add:", 11, 77 48 12 8
  button "SOP", 12, 77 57 15 12
  button "AOP", 13, 94 57 15 12
  button "HOP", 14, 111 57 15 12
  button "VOP", 15, 128 57 15 12
  text "Delete:", 16, 77 71 18 8
  button "SOP", 17, 77 80 15 12
  button "AOP", 18, 94 80 15 12
  button "HOP", 19, 111 80 15 12
  button "VOP", 20, 128 80 15 12
  button "Ok", 21, 14 97 37 12, ok
  button "Cancel", 22, 56 97 37 12, cancel
  text "Channel:", 23, 3 3 22 8
  edit "", 24, 27 2 46 10, autohs
  button "Get List", 25, 20 13 37 12
  button "Sync", 26, 98 97 37 12
  menu "File", 1
  item "Exit", 2, 1
}


on *:DIALOG:accessdia:init:*: {
  if ($active == Status Window) { HALT }
  else {
    did -a $dname 24 $active
    var %a = 1
    while (%a <= $nick($active,0)) {
      did -a $dname 4 $nick($active,%a)
      inc %a
    }
  }
}

on *:DIALOG:accessdia:sclick:4,8,9,12-15,17-20,25,26: {
  if ($did == 4) {
    if ($left($nick($did(24),$did(4).seltext).pnick,1) == ~) { did -ra $dname 6 9999 }
    elseif ($left($nick($did(24),$did(4).seltext).pnick,1) == &) { did -ra $dname 6 10 }
    elseif ($left($nick($did(24),$did(4).seltext).pnick,1) == @) { did -ra $dname 6 5 }
    elseif ($left($nick($did(24),$did(4).seltext).pnick,1) == %) { did -ra $dname 6 4 }
    elseif ($left($nick($did(24),$did(4).seltext).pnick,1) == +) { did -ra $dname 6 3 }
    else { did -ra $dname 6 0 }
  }    
  if ($did == 8) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(6)) { noop $input(Please enter a Access Number!,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else { 
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {      
        .msg ChanServ access $did(24) ADD $did($dname,4,$did($dname,4,%a).sel).text $did(6) 
        inc %a
      }
    }
  }
  if ($did == 9) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else { 
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ access $did(24) DEL $did($dname,4,$did($dname,4,%a).sel).text 
        inc %a
      }
    }
  }
  if ($did == 12) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else { 
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ SOP $did(24) ADD $did($dname,4,$did($dname,4,%a).sel).text 
        mode $did(24) -vhq $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text
        inc %a
      }
    }
  }
  if ($did == 13) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else { 
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ AOP $did(24) ADD $did($dname,4,$did($dname,4,%a).sel).text 
        mode $did(24) -vhaq $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text
        inc %a
      }
    }
  }
  if ($did == 14) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else { 
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ HOP $did(24) ADD $did($dname,4,$did($dname,4,%a).sel).text
        mode $did(24) -voaq $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text
        inc %a
      }
    }
  }
  if ($did == 15) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else { 
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ VOP $did(24) ADD $did($dname,4,$did($dname,4,%a).sel).text
        mode $did(24) -hoaq $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text
        inc %a
      }
    }
  }
  if ($did == 17) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else {
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ SOP $did(24) DEL $did($dname,4,$did($dname,4,%a).sel).text
        mode $did(24) -ao $did($dname,4,$did($dname,4,%a).sel).text $did($dname,4,$did($dname,4,%a).sel).text
        inc %a
      }
    }
  }
  if ($did == 18) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else {
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ AOP $did(24) DEL $did($dname,4,$did($dname,4,%a).sel).text 
        mode $did(24) -o $did($dname,4,$did($dname,4,%a).sel).text
        inc %a
      }
    }
  }
  if ($did == 19) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else { 
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ HOP $did(24) DEL $did($dname,4,$did($dname,4,%a).sel).text
        mode $did(24) -h $did($dname,4,$did($dname,4,%a).sel).text
        inc %a
      }
    }
  }
  if ($did == 20) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    elseif (!$did(4).seltext) { noop $input(Please select a Nick!,o) }
    else {
      var %a = 1
      while (%a <= $did($dname,4,0).sel) {
        .msg ChanServ VOP $did(24) DEL $did($dname,4,$did($dname,4,%a).sel).text
        mode $did(24) -v $did($dname,4,$did($dname,4,%a).sel).text
        inc %a
      }
    }
  }
  if ($did == 25) {
    if (!$did(24)) { noop $input(Please enter a channel to gather nick's from.,o) }
    else {
      did -r $dname 4
      var %a = 1
      while (%a <= $nick($did(24),0)) {
        did -a $dname 4 $nick($did(24),%a)
        inc %a
      }
    }
  }
  if ($did == 26) {
    if (!$did(24)) { noop $input(Please enter a channel name.,o) }
    else {
      .msg ChanServ sync $did(24)
      noop $input(Channel list has been sync'd.,o)
    }
  }
}

alias -l accessdialog { dialog $iif($dialog(accessdia),-v,-m accessdia) accessdia }
