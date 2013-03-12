menu channel {
  Port Checker:dialog $iif($dialog(port_check),-v,-m port_check) port_check
}

dialog port_check {
  title "Port Checker by Danneh"
  size -1 -1 115 90
  option dbu
  text "Hostname:", 1, 3 3 26 8
  edit "", 2, 31 2 82 10
  text "Port:", 6, 3 15 12 8
  edit "", 7, 31 14 81 10
  edit "", 8, 3 28 109 41, read multi return center
  button "Check", 9, 14 74 37 12
  button "Close", 10, 62 74 37 12
  menu "File", 3
  item "Clear All", 4, 3
  item "Close", 5, 3, ok
}

on *:DIALOG:port_check:menu:4: {
  did -r $dname 2,7,8
}

on *:DIALOG:port_check:sclick:9,10: {
  if ($did == 9) {
    if ($sock(pc)) { .sockclose pc | did -ra $dname 8 Socket was in use, Please try again. }
    if ($did(2)) {
      did -ra $dname 8 Checking address $qt($iif($did(7) != $null,$+($did(2),$chr(58),$did(7)),$+($did(2),$chr(58),80))) Please wait..
      .sockopen pc $iif($did(7) != $null,$+($did(2),$chr(32),$did(7)),$+($did(2),$chr(32),80))
      set %pc.timeout 5
      .timerpc1 0 1 pc.timeout
    }
  }
  if ($did == 10) { dialog -x $dname }
}
alias pc.timeout {
  if (%pc.timeout <= 0) {
    did -ra port_check 8 Could not connect to $qt($iif($did(port_check,7) != $null,$+($did(port_check,2),$chr(58),$did(port_check,7)),$+($did(port_check,2),$chr(58),80)))
    .sockclose pc
    .timerpc1 off
  }
  else { dec %pc.timeout }
}
on *:SOCKOPEN:pc: {
  if ($sockerr) { did -ra port_check 8 Could not connect to $qt($iif($did(port_check,7) != $null,$+($did(port_check,2),$chr(58),$did(port_check,7)),$+($did(port_check,2),$chr(58),80))) }
  else { did -ra port_check 8 Connected succesfully to $qt($iif($did(port_check,7) != $null,$+($did(port_check,2),$chr(58),$did(port_check,7)),$+($did(port_check,2),$chr(58),80))) }
  .sockclose pc
  .timerpc1 off
}
