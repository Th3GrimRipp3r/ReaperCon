;::::::::::::::::::::::::::::::::::::::
;:: Nick Follow Script               ::
;:: Concept by CCMike                ::
;:: Implementation by Danneh         ::
;:: Allows a nick to be followed for ::
;:: moderation purposes.             ::
;::::::::::::::::::::::::::::::::::::::

menu channel,nicklist,query {
  Nick Follow
  .$iif($istok($iniread(Following, Users),$$1,124),$style(2)) Follow $$1:writeini $iif($iniread(Following, Users),-n) NickFollow.ini Following Users $addtok($iniread(Following, Users),$$1,124)
  .Open Setup Dialog:dialog $iif($dialog(nickfollow),-v,-m nickfollow) nickfollow
}
dialog nickfollow {
  title "Nick Follow by Danneh & Zetacon"
  size -1 -1 125 92
  option dbu
  box "Selected Nicks:", 1, 3 3 119 23
  combo 2, 7 11 110 48, size drop
  box "", 3, 3 28 119 45, hide
  text "Color Select:", 4, 6 35 31 8, hide
  combo 5, 40 33 77 50, size drop, hide
  check "Send as Highlight?", 6, 6 46 54 10, hide
  check "Logging Window?", 7, 61 46 56 10, hide
  button "Save and Exit", 8, 20 76 37 12
  button "Exit", 9, 64 76 37 12, ok cancel
  button "Remove", 10, 42 58 37 12, hide
  menu "File", 11
  item "Exit", 12, 11, ok
}

on *:DIALOG:nickfollow:init:*: {
  didtok $dname 5 124 1 - Black|2 - Blue|3 - Green|4 - Red|5 - Brown|6 - Purple|7 - Orange|8 - Yellow|9 - Light Green|10 - Teal|11 - Light Cyan|12 - Light Blue|13 - Pink|14 - Grey|15 - Light Grey
  if ($iniread(Following, Users)) {
    didtok $dname 2 124 $iniread(Following, Users)
  }
}
on *:DIALOG:nickfollow:sclick:2,5-10: {
  if ($did == 2) {
    did -u $dname 6,7
    did -v $dname 3-7,10
    did -c $dname 5 $iniread($did(2), Color)
    if ($iniread($did(2), HLWin)) { did -c $dname 6 }
    if ($iniread($did(2), LogWin)) { did -c $dname 7 }
  }
  if ($did == 5) { writeini $iif($iniread($did(2), Color),-n) NickFollow.ini $did(2) Color $did(5) }
  if ($did == 6) {
    if ($did(6).state == 0) { remini NickFollow.ini $did(2) HLWin }
    if ($did(6).state == 1) { writeini NickFollow.ini $did(2) HLWin On }
  }
  if ($did == 7) {
    if ($did(7).state == 0) { remini NickFollow.ini $did(2) LogWin }
    if ($did(7).state == 1) { writeini NickFollow.ini $did(2) LogWin On }
  }
  if ($istok(8|9,$did,124)) { dialog -x $dname }
  if ($did == 10) {
    var %a = $remtok($iniread(Following, Users),$did(2),124)
    remini NickFollow.ini Following Users
    remini NickFollow.ini $did(2)
    did -r $dname 2
    if (%a != $null) {
      writeini NickFollow.ini Following Users %a
    }
    reloadusers
  }
}
alias -l iniread { return $readini(NickFollow.ini, $1, $$2) }
alias -l nickcol { return $+(,$gettok($iniread($$1, Color),1,45)) }
alias -l reloadusers {
  did -h nickfollow 3-7,10
  if ($iniread(Following, Users) != $null) {
    .timer 1 1 didtok nickfollow 2 124 $iniread(Following, Users)
  }
}
on ^*:TEXT:*:#: {
  if ($istok($iniread(Following, Users),$nick,124)) {
    echo -t $chan $nickcol($nick) $+(<,$nick,>) $1-
    HALTDEF
    if ($iniread($nick, LogWin) == On) {
      window @LogWin. [ $+ [ $nick ] ]
      aline @LogWin. [ $+ [ $nick ] ] $chan - $time - $1-
    }
    if ($iniread($nick, HLWin) == On) {
      .beep 5
      window -g2 $chan
    }
  }
}
