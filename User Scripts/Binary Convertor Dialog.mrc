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
  edit "", 4, 5 10 152 39
  edit "", 5, 5 61 152 39
  menu "File", 6
  item "Reset", 7, 6
  item "Exit", 8, 6, ok
}

on *:DIALOG:Bin_Conv:SCLICK:3: {
  if ($did(4) == $null) {
    var %filterbinary $regsubex(filterbinary,$did(5),/([^01])/g,)
    if (!%filterbinary) { noop $input(Please use Binary numbers in the Binary box.,Error!,o) }
    else { did -ra $dname 4 $regsubex(binarytoascii,%filterbinary,/([01]{7})/g,$chr($base(\1,2,10))) }
  }
  elseif ($did(5) == $null) { did -ra $dname 5 $regsubex(asciitobinary,$did(4),/(.)/g,$base($asc(\1),10,2)) }
}
on *:DIALOG:Bin_Conv:MENU:7: {
  did -r $dname 4
  did -r $dname 5
}
