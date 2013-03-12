menu channel {
  Peak Script v1.1:peakdia
}

alias -l peakdia {
  $iif($dialog(multi_peak),dialog -v,dialog -m multi_peak) multi_peak
}

dialog multi_peak {
  title "Peak Dialog by Danneh"
  size -1 -1 144 122
  option dbu
  box "Peak Setup", 4, 2 20 140 100
  combo 5, 5 38 60 50, sort size
  text "Networks:", 6, 5 28 25 8
  button "Add", 7, 5 90 30 12
  button "Del", 8, 36 90 30 12
  combo 9, 78 38 60 50, size
  text "Channels:", 10, 78 28 24 8
  button "Add", 11, 78 90 30 12
  button "Del", 12, 109 90 30 12
  button "Ok", 13, 29 104 37 12, ok
  button "Cancel", 14, 78 104 37 12
  box "Master Switch:", 15, 2 2 63 17
  check "On/Off", 16, 16 8 36 10
  box "Setting:", 17, 79 2 63 17
  check "Op's Only Switch", 18, 82 8 59 10
  menu "File", 1
  item "Unset All", 2, 1
  item "Exit", 3, 1
}

on *:DIALOG:multi_peak:init:*: {
  var %a = $numtok(%peak.networks,44)
  while (%a) {
    did -a $dname 5 $gettok(%peak.networks,%a,44)
    dec %a
  }
  if (%peakmaster == on) {
    did -c $dname 16
  }
  if (%peakmaster == $null) {
    did -b $dname 5,7-9,11,12,18
  }
  if (%peakops == on) {
    did -c $dname 18
  }
}

on *:DIALOG:multi_peak:menu:2,3: {
  if ($did == 2) {
    unset %peak.*
    did -r $dname 5,9
  }
  if ($did == 3) {
    dialog -x multi_peak multi_peak
  }
}

on *:DIALOG:multi_peak:sclick:5,7,8,11,12,16,18: {
  if ($did == 5) {
    did -r $dname 9
    var %a = $numtok(%peak. [ $+ [ $did($dname,5).text ] ],44)
    while (%a) {
      did -a $dname 9 $gettok(%peak. [ $+ [ $did($dname,5).text ] ],%a,44)
      dec %a
    }
  }
  if ($did == 7) {
    if (!$did($dname,5).text) { noop $input(Please enter a Network to add for Peaks.,o) }
    elseif ($istok(%peak.networks,$did($dname,5).text,44)) { noop $input(The Network you entered is already setup for Peaks.,o) }
    else {
      set %peak.networks $addtok(%peak.networks,$did($dname,5).text,44)
      did -a $dname 5 $did($dname,5).text
    }
  }
  if ($did == 8) {
    if (!$did($dname,5).text) { noop $input(Please enter a Network to remove from Peaks.,o) }
    elseif (!$istok(%peak.networks,$did($dname,5).text,44)) { noop $input(The Network you wish to remove is not in the Peak setup.,o) }
    else {
      set %peak.networks $remtok(%peak.networks,$did($dname,5).text,44)
      did -r $dname 5
      var %a = $numtok(%peak.networks,44)
      while (%a) {
        did -a $dname 5 $gettok(%peak.networks,%a,44)
        dec %a
      }
      $iif(%peak.networks == $null,unset %peak.networks)
    }
  }
  if ($did == 11) {
    if (!$did($dname,5).text) { noop $input(Please select a Network to add channels to.,o) }
    elseif (!$did($dname,9).text) { noop $input(Please enter a channel to add to the Peak Setup.,o) }
    elseif ($istok(%peak. [ $+ [ $did($dname,5).text ] ],$did($dname,9).text,44)) { noop $input(The Selected channel name is already setup for Peaks.o) }
    else {
      set %peak. [ $+ [ $did($dname,5).text ] ] $addtok(%peak. [ $+ [ $did($dname,5).text ] ],$did($dname,9).text,44)
      did -a $dname 9 $did($dname,9).text
    }
  }
  if ($did == 12) {
    if (!$did($dname,5).text) { noop $input(Please select a Network to remove channels from.,o) }
    elseif (!$did($dname,9).text) { noop $input(Please enter a channel to remove from the Peak Setup.,o) }
    elseif (!$istok(%peak. [ $+ [ $did($dname,5).text ] ],$did($dname,9).text,44)) { noop $input(The Selected channel name is not in the setup for Peaks.o) }
    else {
      set %peak. [ $+ [ $did($dname,5).text ] ] $remtok(%peak. [ $+ [ $did($dname,5).text ] ],$did($dname,9).text,44)
      unset %peak. [ $+ [ $did($dname,5).text ] $+ ] . [ $+ [ $did($dname,9).text ] $+ ] .*
      did -r $dname 9
      var %a = $numtok(%peak. [ $+ [ $did($dname,5).text,44)
      while (%a) {
        did -a $dname 9 $gettok(%peak. [ $+ [ $did($dname,5).text ] ],%a,44)
        dec %a
      }
      $iif(%peak. [ $+ [ $did($dname,5).text ] ] == $null,unset %peak. [ $+ [ $did($dname,5).text ] ])
    }      
  }
  if ($did == 16) {
    if ($did(16).state == 0) { 
      unset %peakmaster
      noop $input(Peak script has been disabled.,o,Success!)
      did -b $dname 5,7-9,11,12,18
    }
    if ($did(16).state == 1) {
      set %peakmaster on
      noop $input(Peak script has been enabled.,o,Success!)
      did -e $dname 5,7-9,11,12,18
    }
  }
  if ($did == 18) {
    if ($did(18).state == 0) { 
      unset %peakops
      noop $input(Peak trigger now works for everyone.,o,Success!)
    }
    if ($did(18).state == 1) {
      set %peakops on
      noop $input(Peak trigger now works for Ops only.,o,Success!)
    }
  }
}

on *:JOIN:#: {
  if ($istok(%peak. [ $+ [ $network ] ],$chan,44)) {
    if (!%peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .peak) {
      set %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .peak $nick($chan,0)
      set %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .ctime $ctime
    }
    else {
      if ($nick($chan,0) <= %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .peak) { HALT }
      else {
        set %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .peak $nick($chan,0)
        msg $chan New Peak: %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .peak Last Peak: $duration($calc($ctime - %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .ctime)) ago.
        .timer 1 3 set %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .ctime $ctime
      }
    }
  }
}

on *:TEXT:!Peak:#: {
  if ($istok(%peak. [ $+ [ $network ] ],$chan,44)) {
    if (%peakops == on) {
      if ($nick isop $chan) {
        msg $chan Current Peak: %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .peak Peak Set: $duration($calc($ctime - %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .ctime)) ago.
      }
    }
    if (%peakops == $null) {
      msg $chan Current Peak: %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .peak Peak Set: $duration($calc($ctime - %peak. [ $+ [ $network ] $+ ] . [ $+ [ $chan ] $+ ] .ctime)) ago.
    }
  }
}
