menu * {
  mIRC calculator:mirccalc
}

alias -l mirccalc {
  $iif($dialog(calculator),dialog -v,dialog -m calculator) calculator
}

dialog calculator {
  title "mIRC Calculator"
  size -1 -1 100 92
  option dbu
  edit "", 1, 3 3 94 10, right
  button "7", 5, 3 32 20 12
  button "8", 6, 25 32 20 12
  button "9", 7, 47 32 20 12
  button "/", 8, 71 32 25 12
  button "*", 9, 71 47 25 12
  button "-", 10, 71 62 25 12
  button "+", 11, 71 77 25 12
  button "4", 12, 3 47 20 12
  button "5", 13, 25 47 20 12
  button "6", 14, 47 47 20 12
  button "1", 15, 3 62 20 12
  button "2", 16, 25 62 20 12
  button "3", 17, 47 62 20 12
  button "0", 18, 3 77 20 12
  button ".", 19, 25 77 20 12
  button "=", 20, 47 77 20 12
  button "Mem +", 21, 3 17 20 12
  button "Mem -", 22, 25 17 20 12
  button "Mem R", 23, 47 17 20 12
  button "C", 24, 71 17 25 12
  menu "File", 2
  item "Clear", 3, 2
  item "Exit", 4, 2
}

on *:DIALOG:calculator:sclick:5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24: {
  if ($did == 5) { did -a $dname 1 7 }
  if ($did == 6) { did -a $dname 1 8 }
  if ($did == 7) { did -a $dname 1 9 }
  if ($did == 8) { did -a $dname 1 / }
  if ($did == 9) { did -a $dname 1 * }
  if ($did == 10) { did -a $dname 1 - }
  if ($did == 11) { did -a $dname 1 + }
  if ($did == 12) { did -a $dname 1 4 }
  if ($did == 13) { did -a $dname 1 5 }
  if ($did == 14) { did -a $dname 1 6 }
  if ($did == 15) { did -a $dname 1 1 }
  if ($did == 16) { did -a $dname 1 2 }
  if ($did == 17) { did -a $dname 1 3 }
  if ($did == 18) { did -a $dname 1 0 }
  if ($did == 19) { did -a $dname 1 . }
  if ($did == 20) {
    if (!$did($dname,1).text) { noop $input(Please enter a Calculation.,o) }
    else {
      did -ra $dname 1 $calc($did($dname,1).text)
    }
  }
  if ($did == 21) { set %calcmem $did($dname,1).text }
  if ($did == 22) { unset %calcmem }
  if ($did == 23) { did -ra $dname 1 %calcmem }
  if ($did == 24) { did -r $dname 1 }
}

on *:DIALOG:calculator:menu:3,4: {
  if ($did == 3) { did -r $dname 1 }
  if ($did == 4) { dialog -x calculator calculator }
}
