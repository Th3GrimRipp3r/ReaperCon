menu channel,menubar,status {
  F-Key Assignment:dialog $iif($dialog(FKey_Setup),-v,-m FKey_Setup) FKey_Setup
}
dialog FKey_Setup {
  title "F-Key Function Setup by Danneh"
  size -1 -1 153 171
  option dbu
  tab "Normal", 1, 3 3 146 149
  text "F1:", 4, 7 20 8 8, tab 1
  edit "", 5, 19 19 128 10, tab 1
  text "F2:", 6, 7 31 8 8, tab 1
  edit "", 7, 19 30 128 10, tab 1
  text "F3:", 8, 7 42 8 8, tab 1
  edit "", 9, 19 41 128 10, tab 1
  text "F4:", 10, 7 53 8 8, tab 1
  edit "", 11, 19 52 128 10, tab 1
  text "F5:", 12, 7 64 8 8, tab 1
  edit "", 13, 19 63 128 10, tab 1
  text "F6:", 14, 7 75 8 8, tab 1
  edit "", 15, 19 74 128 10, tab 1
  text "F7:", 16, 7 86 8 8, tab 1
  edit "", 17, 19 85 128 10, tab 1
  text "F8:", 18, 7 97 8 8, tab 1
  edit "", 19, 19 96 128 10, tab 1
  text "F9:", 20, 7 108 8 8, tab 1
  edit "", 21, 19 107 128 10, tab 1
  text "F10:", 22, 7 119 11 8, tab 1
  edit "", 23, 19 118 128 10, tab 1
  text "F11:", 24, 7 130 11 8, tab 1
  edit "", 25, 19 129 128 10, tab 1
  text "F12:", 26, 7 141 11 8, tab 1
  edit "", 27, 19 140 128 10, tab 1
  tab "Shift", 2
  text "F1:", 29, 7 20 8 8, tab 2
  edit "", 30, 19 19 128 10, tab 2
  text "F2:", 31, 7 31 8 8, tab 2
  edit "", 32, 19 30 128 10, tab 2
  text "F3:", 33, 7 42 8 8, tab 2
  edit "", 34, 19 41 128 10, tab 2
  text "F4:", 35, 7 53 8 8, tab 2
  edit "", 36, 19 52 128 10, tab 2
  text "F5:", 37, 7 64 8 8, tab 2
  edit "", 38, 19 63 128 10, tab 2
  text "F6:", 39, 7 75 8 8, tab 2
  edit "", 40, 19 74 128 10, tab 2
  text "F7:", 41, 7 86 8 8, tab 2
  edit "", 42, 19 85 128 10, tab 2
  text "F8:", 43, 7 97 8 8, tab 2
  edit "", 44, 19 96 128 10, tab 2
  text "F9:", 45, 7 108 8 8, tab 2
  edit "", 46, 19 107 128 10, tab 2
  text "F10:", 47, 7 119 11 8, tab 2
  edit "", 48, 19 118 128 10, tab 2
  text "F11:", 49, 7 130 11 8, tab 2
  edit "", 50, 19 129 128 10, tab 2
  text "F12:", 51, 7 141 11 8, tab 2
  edit "", 52, 19 140 128 10, tab 2
  tab "Ctrl", 3
  text "F1:", 53, 7 20 8 8, tab 3
  edit "", 54, 19 19 128 10, tab 3
  text "F2:", 55, 7 31 8 8, tab 3
  edit "", 56, 19 30 128 10, tab 3
  text "F3:", 57, 7 42 8 8, tab 3
  edit "", 58, 19 41 128 10, tab 3
  text "F4:", 59, 7 53 8 8, tab 3
  edit "", 60, 19 52 128 10, tab 3
  text "F5:", 61, 7 64 8 8, tab 3
  edit "", 62, 19 63 128 10, tab 3
  text "F6:", 63, 7 75 8 8, tab 3
  edit "", 64, 19 74 128 10, tab 3
  text "F7:", 65, 7 86 8 8, tab 3
  edit "", 66, 19 85 128 10, tab 3
  text "F8:", 67, 7 97 8 8, tab 3
  edit "", 68, 19 96 128 10, tab 3
  text "F9:", 69, 7 108 8 8, tab 3
  edit "", 70, 19 107 128 10, tab 3
  text "F10:", 71, 7 119 11 8, tab 3
  edit "", 72, 19 118 128 10, tab 3
  text "F11:", 73, 7 130 11 8, tab 3
  edit "", 74, 19 129 128 10, tab 3
  text "F12:", 75, 7 141 11 8, tab 3
  edit "", 76, 19 140 128 10, tab 3
  button "Save And Exit", 28, 58 156 37 12
}
on *:DIALOG:FKey_Setup:sclick:28: { dialog -x $dname }
