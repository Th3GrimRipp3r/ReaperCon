menu channel,status {
  Client Information:dialog $iif($dialog(clientstat),-v,-m clientstat) clientstat
}
dialog clientstat {
  title "Client Status by Danneh/GrimReaper"
  size -1 -1 122 63
  option dbu
  button "Ok", 3, 42 48 37 12
  text "Current Nickname:", 4, 3 3 45 8
  text "", 5, 50 3 69 8
  text "Current Server:", 6, 3 12 38 8
  text "", 7, 43 12 76 8
  text "Connected Servers:", 8, 3 21 48 8
  text "", 9, 53 21 66 8
  text "SSL Ready:", 10, 3 30 28 8
  text "", 11, 33 30 86 8
  menu "File", 1
  item "Exit", 2, 1, ok
}
on *:DIALOG:clientstat:init:*: {
  var %constats
  if ($sslready == $true) { did -a $dname 11 $sslready }
  elseif ($sslready == $false) { did -a $dname 11 $sslready }
  did -a $dname 5 $me
  did -a $dname 7 $server
  contest
}
on *:DIALOG:clientstat:sclick:3: { dialog -x $dname }
alias -l contest {
  var %a = 1
  while (%a <= $scon(0)) {
    if ($scon(%a).status == Connected) {
      inc %constats
      inc %a
    }
    else { inc %a }
  }
  did -a $dname 9 $+(%constats,$chr(47),$scon(0))
  unset %constats
}
