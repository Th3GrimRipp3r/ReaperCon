menu status,channel,menubar {
  mIRC Start-up Creator:mircstartcreator
}

dialog startupdia {
  title "mIRC Start-Up Creator by GrimReaper"
  size -1 -1 134 67
  option dbu
  text "Network:", 1, 3 5 22 8
  edit "", 5, 28 4 102 10
  text "Server:", 6, 3 17 18 8
  edit "", 7, 28 16 102 10
  text "NickName:", 8, 3 29 25 8
  edit "", 9, 28 28 102 10
  text "Password:", 10, 3 41 25 8
  edit "", 11, 28 40 102 10, autohs
  button "Add", 12, 3 52 20 12
  button "Clear", 13, 30 52 20 12
  button "Create", 14, 57 52 20 12
  button "Ok", 15, 83 52 20 12, ok
  button "Cancel", 16, 109 52 20 12, cancel
  menu "File", 2
  item "Clear All", 3, 2
  item "Exit", 4, 2
}

on *:DIALOG:startupdia:menu:3,4: {
  if ($did == 3) { did -r $dname 5,7,9,11 | unset %start* }
  if ($did == 4) { dialog -x startupdia startupdia }
}

on *:DIALOG:startupdia:sclick:12,13,14: {
  if ($did == 12) {
    if (!$did(5)) || (!$did(7)) || (!$did(9)) || (!$did(11)) { noop $input(Please be sure ALL fields are filled.,o) }
    else {
      set %startnetwork %startnetwork $+ $did(5) $+ $chr(44)
      set %startserver %startserver $+ $did(7) $+ $chr(44)
      set %startnickname %startnickname $+ $did(9) $+ $chr(44)
      set %startpassword %startpassword $+ $did(11) $+ $chr(44)
    }
  }
  if ($did == 13) { 
    did -r $dname 5,7,9,11 
  }
  if ($did == 14) {
    .remove startup.txt
    write startup.txt on *:START: $chr(123)
    var %a = 1
    while (%a <= $numtok(%startserver,44)) {
      write startup.txt $iif(%a == 1,server,server -m) $gettok(%startserver,%a,44)
      inc %a
    }
    write startup.txt $chr(125)
    write startup.txt $crlf
    write startup.txt on *:CONNECT: $chr(123)
    var %a = 1
    while (%a <= $numtok(%startnetwork,44)) {
      write startup.txt if $chr(40) $+ $chr(36) $+ network == $gettok(%startnetwork,%a,44) $+ $chr(41) $chr(123) nick $gettok(%startnickname,%a,44) $chr(124) .msg NickServ identify $gettok(%startpassword,%a,44) $chr(125)
      inc %a
    }
    write startup.txt $chr(125)
    run startup.txt
  }
}

alias -l mircstartcreator {
  dialog $iif($dialog(startupdia),-v,-m startupdia) startupdia
}
