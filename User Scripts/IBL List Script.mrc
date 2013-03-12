menu channel,menubar {
  Ban List Dialog:iblstart
}
dialog ibllist {
  title "Ban List Dialog by Danneh/GrimReaper"
  size -1 -1 211 137
  option dbu
  box "List of bans:", 1, 3 3 137 131
  list 2, 7 11 128 106, multsel check result
  box "Ban Information:", 3, 143 3 64 51
  text "Set by:", 4, 147 11 18 8
  text "", 5, 147 21 56 8
  text "Date set:", 6, 147 31 23 8
  text "", 7, 147 41 56 8
  button "CheckAll", 8, 143 57 64 12
  button "Remove", 9, 143 72 64 12
  button "Remove Selected", 10, 143 87 64 12
  button "Remove All", 11, 143 102 64 12
  button "Ok/Cancel", 12, 156 118 37 12, ok cancel
  text "", 13, 7 122 128 8
}
on *:DIALOG:ibllist:init:*: {
  if ($ibl($active,0) != 0) {
    var %a = 1
    while (%a <= $ibl($active,0)) {
      did -a $dname 2 $ibl($active,%a)
      inc %a
    }
    did -a $dname 13 Total entries on $+($active,$chr(58)) $ibl($active,0)
    noop $input(All entries have been added..,o,Success!)
  }
  else {
    noop $input(There are no entries for $+($active,.),o,Closing Dialog!)
    dialog -x $dname
  }
}
on *:DIALOG:ibllist:sclick:2,8-11: {
  var %a
  if ($did == 2) {
    if ($did($dname,2,0).sel == 1) {
      did -ra $dname 5 $ibl($active,$did($dname,2).sel).by
      did -ra $dname 7 $ibl($active,$did($dname,2).sel).date
    }
    elseif ($did($dname,2,0).sel >= 2) {
      did -ra $dname 5 Multiple Entries
      did -ra $dname 7 Multiple Entries
    }
    elseif ($did($dname,2,0).sel == 0) {
      if ($did($dname,5) != $null) && ($did($dname,7) != $null) {
        did -r $dname 5,7
      }
    }
  }
  if ($did == 8) {
    %a = 1
    while (%a <= $did($dname,2).lines) {
      if ($did(8).text == CheckAll) {
        did -s $dname 2 %a
      }
      elseif ($did(8).text == UnCheckAll) {
        did -l $dname 2 %a
      }
      inc %a
    }
    if ($did(8).text == CheckAll) {
      did -ra $dname 8 UnCheckAll
    }
    elseif ($did(8).text == UnCheckAll) {
      did -ra $dname 8 CheckAll
    }
  }
  if ($did == 9) {
    if ($did($dname,2,0).sel == 1) {
      mode $active -b $did($dname,2,$did($dname,2).sel).text
      did -d $dname 2 $did($dname,2).sel
      .timer 1 1 refreshibl
    }
  }
  if ($did == 10) {
    %a = 0
    var %bans
    while ($did($dname,2,0).csel > 0) {
      %bans = %bans $did($dname,2,$did($dname,2,1).csel).text
      did -d $dname 2 $did($dname,2,1).csel
      inc %a
      if (%a == $modespl) {
        mode $active - $+ $str(b,%a) %bans
        %bans = $null
        %a = 0
      }
    }
    if (%bans) {
      mode $active - $+ $str(b,%a) %bans
    }
    .timer 1 1 refreshibl
  }
  if ($did == 11) {
    %a = 0
    var %bans
    while ($did($dname,2).lines > 0) {
      %bans = %bans $did($dname,2,1).text
      did -d $dname 2 1
      inc %a
      if (%a == $modespl) {
        mode $active - $+ $str(b,%a) %bans
        %bans = $null
        %a = 0
      }
    }
    if (%bans) {
      mode $active - $+ $str(b,%a) %bans
    }
    .timer 1 1 refreshibl
  }
}
alias iblstart {
  if ($me !ison $active) {
    return 
  }
  if (!$chan($active).ibl) {
    .enable #IBLList
    .timerIBLListTimeout 1 8 ibltimeout
    mode $active +b
  }
  else {
    ibldialog 
  }
}
alias ibldialog {
  dialog $iif($dialog(ibllist),-v,-m ibllist) ibllist
}
alias -l refreshibl {
  did -ra ibllist 13 Total entries on $+($active,$chr(58)) $ibl($active,0)
}
#IBLList off
raw 368:*: {
  HALTDEF
  .timerIBLListTimeout off 
  .disable #IBLList 
  ibldialog
}
#IBLList end
alias ibltimeout {
  .disable #IBLList
  ibldialog 
}
