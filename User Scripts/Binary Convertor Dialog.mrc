menu channel,menubar,status {
  Binary Convertor:dialog $iif($dialog(Bin_Conv),-v,-m Bin_Conv) Bin_Conv
}

dialog Bin_Conv {
  title "Binary Convertor v1.0"
  size -1 -1 162 119
  option dbu
  box "Text:", 1, 2 2 158 50
  box "Binary:", 2, 2 53 158 50
  button "Convert", 3, 63 105 37 12
  edit "", 4, 5 10 152 39, multi
  edit "", 5, 5 61 152 39, multi
  menu "File", 6
  item "Reset", 7, 6
  item "Exit", 8, 6, ok
}

on *:DIALOG:Bin_Conv:SCLICK:3: {
  if ($did(4) == $null) {
    var %multiline $regsubex(multiline,$str(.,$did(5).lines),/(.)/g,$did(5,\n))
    var %filterbinary $regsubex(filterbinary,%multiline,/([^01])/g,)
    if (!%filterbinary) { noop $input(Please use Binary numbers in the Binary box.,Error!,o) }
    else {
      did -ra $dname 4 $regsubex(binarytoascii,%filterbinary,/([01]{8})/g,$chr($base(\1,2,10)))
    }
  }
  elseif ($did(5) == $null) {
    var %multiline $regsubex(multiline,$str(.,$did(4).lines),/(.)/g,$did(4,\n) $+ $crlf)
    did -ra $dname 5 $left($regsubex(asciitobinary,%multiline,/(.)/sg,$binary2ascii(\1)),-8)
  }
}

on *:DIALOG:Bin_Conv:MENU:7: {
  did -r $dname 4
  did -r $dname 5
}

alias -l binary2ascii {
  var %bin $base($asc($1),10,2)
  return $str(0,$calc( 8 - $len(%bin) )) $+ %bin
}
