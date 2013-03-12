menu * {
  AutoJoin/Connect:mircstart
}

dialog autoconnect1 {
  title "Autojoin/Connect"
  size -1 -1 101 110
  option dbu
  button "Ok", 1, 13 95 37 12
  button "Cancel", 2, 53 95 37 12
  button "Add", 3, 13 81 37 12
  button "Delete", 4, 53 81 37 12
  box "Network List:", 5, 3 3 95 75
  list 6, 7 11 87 62, sort size vsbar
}
dialog autoconnect2 {
  title "Autojoin by Danneh & Zetacon"
  size -1 -1 109 103
  option dbu
  button "Ok", 1, 15 87 37 12
  button "Cancel", 4, 59 87 37 12
  text "Network:", 5, 3 3 22 8
  edit "", 6, 29 2 77 10
  text "Server:", 7, 2 17 18 8
  edit "", 8, 29 16 77 10
  text "NickName:", 9, 2 31 25 8
  edit "", 10, 29 30 77 10
  text "Password:", 11, 2 45 25 8
  edit "", 12, 29 44 77 10, pass
  button "Add", 13, 15 72 37 12
  button "Del", 14, 59 72 37 12
  text "Channels:", 15, 2 59 24 8
  edit "", 16, 29 58 77 10, autohs
  menu "File", 2
  item "Exit", 3, 2
}
alias -l mircstart {
  $iif($dialog(autoconnect1),dialog -v,dialog -m autoconnect1) autoconnect1
}
on *:DIALOG:autoconnect2:menu:3: {
  dialog -x autoconnect2 autoconnect2
  dialog -m autoconnect1 autoconnect1
}
on *:DIALOG:autoconnect1:sclick:1,2,3,4,6: {
  if ($did == 1) || ($did == 2) {
    dialog -x autoconnect1 autoconnect1
  }
  if ($did == 3) {
    dialog -x autoconnect1 autoconnect1
    dialog -m autoconnect2 autoconnect2
  }
}
