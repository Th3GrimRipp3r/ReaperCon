menu channel,status,menubar,query {
  $iif(o !isincs $usermode,$style(2)) Spamfilter Dialog:spamfilterdialog
}
alias -l spamfilterdialog { dialog $iif($dialog(spam_dia),-v,-m spam_dia) spam_dia }
dialog spam_dia {
  title "Spamfilter Dialog By Danneh.."
  size -1 -1 266 309
  option dbu
  list 1, 2 2 262 119, size extsel hsbar vsbar
  button "Refresh", 2, 149 123 37 12
  button "Rem Sel", 3, 79 123 37 12
  button "Rem All", 4, 3 123 37 12
  text "Total Spamfilters:", 5, 194 125 42 8
  text "", 6, 239 125 12 8
  box "Type:", 7, 2 137 262 50
  check "c = Channel Msg", 8, 11 145 50 10
  check "p = Private Msg", 9, 109 145 50 10
  check "n = Private Notice", 10, 200 145 54 10
  check "N = Channel Notice", 11, 11 158 57 10
  check "P = Part Msg", 12, 109 158 50 10
  check "q = Quit Msg", 13, 200 158 50 10
  check "d = DCC", 14, 109 171 50 10
  box "Action:", 15, 2 190 262 50
  check "Kill", 16, 11 199 50 10
  check "Shun", 17, 11 212 50 10
  check "Kline", 18, 109 199 50 10
  check "Gline", 19, 109 212 50 10
  check "Zline", 20, 200 199 50 10
  check "GZline", 21, 200 212 50 10
  check "TempShun (Only shun's current session)", 22, 11 225 106 10
  box "Options:", 23, 2 243 262 50
  text "Regex (Text to catch on):", 24, 6 252 63 8
  edit "", 25, 71 251 189 10
  text "Reason (Please use _ and not spaces):", 26, 6 265 94 8
  edit "", 27, 103 264 157 10
  text "TKL Time (The - is for BLOCK and KILL):", 28, 6 278 94 8
  combo 29, 103 277 157 50, size drop
  button "Ok", 30, 114 295 37 12, ok
  button "Cancel", 31, 168 295 37 12, cancel
  button "Add Filter", 32, 60 295 37 12
  check "Block", 33, 200 225 50 10
  menu "File", 34
  menu "Options", 35, 34
  item "Clear Spamfilter", 36, 35
  item "Exit", 37, 34
}
on *:DIALOG:spam_dia:init:*: {
  didtok $dname 29 124 -|15m|30m|45m|1h|3h|5h|1d|3d|5d|30d|60d
  var %a = G
  Spamfilterlist
  .timerspamlist 1 5 loadbuf -o spam_dia 1 spamlist.txt
  .timerhsbar 1 6 did -z spam_dia 1
}
on *:dialog:spam_dia:menu:35,36: {
  if ($did == 35) {
    did -r $dname 1,6,25,27
    did -u $dname 8-14,16-22
  }
  if (did == 36) {
    dialog -x $dname
  }
}
on *:DIALOG:spam_dia:sclick:2-4,8-14,16-22,32: {
  if ($did == 2) {
    did -r $dname 1,6
    write -c spamlist.txt
    Spamfilterlist
    .timerspamlist 1 5 loadbuf -o spam_dia 1 spamlist.txt
  }
  if ($did == 3) {
    if ($did($dname,1,0).sel == 1) {
      spamfilter del $gettok($did(spam_dia,1).seltext,2,32) $gettok($did(spam_dia,1).seltext,3,32) $gettok($did(spam_dia,1).seltext,6,32) $gettok($did(spam_dia,1).seltext,7,32) $gettok($did(spam_dia,1).seltext,9-,32)
    }
    else {
      var %a = 1
      while (%a <= $did(spam_dia,1,0).sel) {
        spamfilter del $gettok($did(spam_dia,1,$did(spam_dia,1,%a).sel).text,2,32) $gettok($did(spam_dia,1,$did(spam_dia,1,%a).sel).text,3,32) $gettok($did(spam_dia,1,$did(spam_dia,1,%a).sel).text,6,32) $gettok($did(spam_dia,1,$did(spam_dia,1,%a).sel).text,7,32) $gettok($did(spam_dia,1,$did(spam_dia,1,%a).sel).text,9-,32)
        inc %a
      }
    }
  }
  if ($did == 4) {
    var %a = 1
    while (%a <= $did($dname,1).lines) {
      spamfilter del $gettok($did($dname,1,%a),2,32) $gettok($did($dname,1,%a),3,32) $gettok($did($dname,1,%a),6,32) $gettok($did($dname,1,%a),7,32) $gettok($did($dname,1,%a),9-,32)
      inc %a
    }
  }
  if ($did == 32) {
    if ($did(25) == $null) || ($did(27) == $null) || ($did(29) == $null) { noop $input(Please fill in ALL required fields.,o) | HALT }
    else {
      if ($did(8).state == 1) { set -u10 %type %type $+ c }
      if ($did(9).state == 1) { set -u10 %type %type $+ p }
      if ($did(10).state == 1) { set -u10 %type %type $+ n }
      if ($did(11).state == 1) { set -u10 %type %type $+ N }
      if ($did(12).state == 1) { set -u10 %type %type $+ P }
      if ($did(13).state == 1) { set -u10 %type %type $+ q }
      if ($did(14).state == 1) { set -u10 %type %type $+ d }
      if ($did(33).state == 1) { set -u10 %action block }
      if ($did(16).state == 1) { set -u10 %action kill }
      if ($did(17).state == 1) { set -u10 %action shun }
      if ($did(18).state == 1) { set -u10 %action kline }
      if ($did(19).state == 1) { set -u10 %action gline }
      if ($did(20).state == 1) { set -u10 %action zline }
      if ($did(21).state == 1) { set -u10 %action gzline }
      if ($did(22).state == 1) { set -u10 %action tempshun }
      spamfilter add %type %action $did(29).text $did(27).text $did(25).text
      noop $input(Desired spamfilter has been added.,o)
    }
  }
}
on *:dialog:spam_dia:close:*:{ 
  write -c spamlist.txt
}
alias Spamfilterlist {
  .enable #spamlist 
  .stats f
} 

#spamlist off
raw 229:*:{ 
  write spamlist.txt $2- 
  haltdef 
  did -ra spam_dia 6 $lines(spamlist.txt)
} 
raw 219:*:{ 
  .disable #spamlist 
  haltdef 
}
#spamlist end
