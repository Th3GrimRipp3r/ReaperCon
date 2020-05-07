::::::::::::::::::::::::::::::::::::::::::
:: Obnoxious AutoJoin / Identify Script ::
:: Created by GrimReaper                ::
:: (No one else wants to take credit    ::
:: for this monster)                    ::
:: Reapercon Repository                 ::
:: All Rights Reserved                  ::
::::::::::::::::::::::::::::::::::::::::::

menu channel,status,menubar,nicklist {
  AutoJoin/Connect V 3.5:autojoinv3
}

dialog ajoin_dia1 {
  title "mIRC AutoJoin/Connect by Danneh"
  size -1 -1 119 139
  option dbu
  button "Add", 4, 2 124 37 12
  button "Edit", 5, 41 124 37 12
  button "Delete", 6, 80 124 37 12
  box "Networks and Nicks:", 7, 2 2 115 81
  list 8, 5 10 108 69, size
  box "Help", 9, 2 84 115 38
  text "", 10, 4 90 110 29
  menu "File", 1
  item "Exit", 2, 1
  menu "Help", 3
  item "About", 11, 3
}

dialog ajoin_dia2 {
  title "mIRC AutoJoin/Connect by Danneh"
  size -1 -1 119 180
  option dbu
  text "Network:", 1, 3 3 22 8
  text "Server:", 2, 3 14 18 8
  text "Nickname:", 3, 3 36 25 8
  text "NickServ Pass:", 4, 3 47 35 8
  text "Channels:", 5, 3 58 24 8
  check "Auto Identify?", 6, 3 140 50 10
  check "Autojoin Channels?", 7, 3 152 58 10
  button "Add", 8, 3 165 37 12
  button "Ok", 9, 41 165 37 12
  button "Cancel", 10, 79 165 37 12
  edit "", 11, 44 2 73 10
  edit "", 12, 44 13 73 10, autohs
  edit "", 13, 44 35 73 10
  edit "", 14, 44 46 73 10, pass autohs
  edit "", 15, 44 57 73 10, autohs
  check "Do you have an oline on this Network?", 16, 3 69 114 10
  text "Oper UID:", 17, 3 82 25 8, hide
  edit "", 18, 43 81 73 10, hide autohs
  text "Oper Password:", 19, 3 94 39 8, hide
  edit "", 20, 43 93 73 10, hide pass autohs
  text "Port Number:", 21, 3 25 32 8
  edit "", 22, 44 24 73 10, autohs
  check "Are you using a ZNC for the Connection?", 23, 3 105 114 10
  text "ZNC User/Net:", 24, 3 118 35 8, hide
  edit "", 25, 43 117 73 10, hide autohs
  text "ZNC Password:", 26, 3 130 37 8, hide
  edit "", 27, 43 129 73 10, hide pass autohs
}


dialog ajoin_dia3 {
  title "About mIRC AutoJoin/Connect"
  size -1 -1 119 61
  option dbu
  button "Ok", 2, 41 46 37 12
  text "This mIRC AutoJoin/Connect Dialog is the creation of Danneh, This is version 3.5 of the script.. If you can see anything that you would like to see improved within the script.. Please either join irc.GeekShed.net channel: #ReaperCon or #Hell.", 1, 3 3 113 40, center
}

on *:DIALOG:ajoin_dia1:menu:2,11: {
  if ($did == 2) { dialog -x ajoin_dia1 ajoin_dia1 }
  if ($did == 11) { $dialogopen(ajoin_dia3) }
}

on *:DIALOG:ajoin_dia3:sclick:2: {
  dialog -x ajoin_dia3 ajoin_dia3
}

on *:DIALOG:ajoin_dia1:init:*: {
  if ($ini(autojoin.ini,networks,0)) {
    var %a = 1, %z = $ini(autojoin.ini,networks,0)
    while (%a <= %z) {
      did -a $dname 8 $ini(autojoin.ini,networks,%a) - $readini(autojoin.ini,$ini(autojoin.ini,networks,%a),nick)
      inc %a
    }
  }
}

on *:DIALOG:ajoin_dia1:sclick:4-6: {
  if ($did == 4) {
    dialog -x ajoin_dia1 ajoin_dia1
    $dialogopen(ajoin_dia2)
  }
  if ($did == 5) {
    if (!$did($dname,8).sel) { noop $input(Please select a network to edit.,o,Error!) }
    else {
      set %editnetwork on
      set -u10 %ajoinnetsetup $did($dname,8).sel
      dialog -x ajoin_dia1 ajoin_dia1
      $dialogopen(ajoin_dia2)
      did -ra ajoin_dia2 8 Save Edit
      did -a ajoin_dia2 11 $ini(autojoin.ini,networks,%ajoinnetsetup)
      did -a ajoin_dia2 12 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),server)
      did -a ajoin_dia2 13 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),nick)
      did -a ajoin_dia2 14 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),password)
      did -a ajoin_dia2 15 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),channels)
      did -a ajoin_dia2 22 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),portnum)
      $iif($readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),aidentify) == on,did -c ajoin_dia2 6)      
      $iif($readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),ajoin) == on,did -c ajoin_dia2 7)
      if ($readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),oline) == on) {
        did -c ajoin_dia2 16
        did -v ajoin_dia2 17-20
        did -a ajoin_dia2 18 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),UID)
        did -a ajoin_dia2 20 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),operpass)
      }
      if ($readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),ZNCConn) == on) {
        did -c ajoin_dia2 23
        did -v ajoin_dia2 24-27
        did -a ajoin_dia2 25 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),ZNCUser)
        did -a ajoin_dia2 27 $readini(autojoin.ini,$ini(autojoin.ini,networks,%ajoinnetsetup),ZNCPass)
      }
    }
  }
  if ($did == 6) {
    remini autojoin.ini networks $gettok($did($dname,8).seltext,1,32)
    remini autojoin.ini servers $gettok($did($dname,8).seltext,1,32)
    remini autojoin.ini $gettok($did($dname,8).seltext,1,32)
    did -d $dname 8 $did($dname,8).sel
    noop $input(The selected Network has been deleted.,o)
  }
}

on *:DIALOG:ajoin_dia2:sclick:8-10,16,23: {
  if ($did == 8) {
    if (!$did(11).text) || (!$did(12).text) || (!$did(13).text) || (!$did(14).text) || (!$did(15).text) { noop $input(Please fill in all needed information.,o) }
    else {
      if (%editnetwork) {
        writeini -n autojoin.ini networks $did(11).text $did(11).text
        writeini -n autojoin.ini servers $did(11).text $did(12).text
        writeini -n autojoin.ini $did(11).text server $did(12).text
        writeini -n autojoin.ini $did(11).text nick $did(13).text
        writeini -n autojoin.ini $did(11).text password $did(14).text
        writeini -n autojoin.ini $did(11).text channels $did(15).text
        writeini -n autojoin.ini $did(11).text aidentify $iif($did($dname,6).state == 1,on,off)
        writeini -n autojoin.ini $did(11).text ajoin $iif($did($dname,7).state == 1,on,off)
        writeini -n autojoin.ini $did(11).text oline $iif($did($dname,16).state == 1,on,off)
        writeini -n autojoin.ini $did(11).text ZNCConn $iif($did($dname,23).state == 1,on,off)
        writeini -n autojoin.ini $did(11).text portnum $iif($did(22).text == $null,6667,$did(22).text)
        if ($did($dname,16).state == 1) {
          if ($did(18).text == $null) || ($did(20).text == $null) { noop $input(Please enter a UID and Password for your Oper!,o,Error!) }
          else {
            writeini -n autojoin.ini $did(11).text UID $did(18).text
            writeini -n autojoin.ini $did(11).text operpass $did(20).text
          }
        }
        if ($did($dname,23).state == 1) {
          if ($did(25).text == $null) || ($did(27).text == $null) { noop $input(Please enter Connection Information for your ZNC! $chr(91) $+ Example: User/Net: GrimReaper/DalNet Password: S0m3Cr4zyP455 $+ $chr(93),o,Error!) }
          else {
            writeini -n autojoin.ini $did(11).text ZNCUser $did(25).text
            writeini -n autojoin.ini $did(11).text ZNCPass $did(27).text
          }
        }
        dialog -x ajoin_dia2 ajoin_dia2
        $dialogopen(ajoin_dia1)
        unset %editnetwork
      }
      else {
        writeini autojoin.ini networks $did(11).text $did(11).text
        writeini autojoin.ini servers $did(11).text $did(12).text
        writeini autojoin.ini $did(11).text server $did(12).text
        writeini autojoin.ini $did(11).text nick $did(13).text
        writeini autojoin.ini $did(11).text password $did(14).text
        writeini autojoin.ini $did(11).text channels $did(15).text
        writeini autojoin.ini $did(11).text aidentify $iif($did($dname,6).state == 1,on,off)
        writeini autojoin.ini $did(11).text ajoin $iif($did($dname,7).state == 1,on,off)
        writeini autojoin.ini $did(11).text oline $iif($did($dname,16).state == 1,on,off)
        writeini autojoin.ini $did(11).text ZNCConn $iif($did($dname,23).state == 1,on,off)
        writeini autojoin.ini $did(11).text portnum $iif($did(22).text == $null,6667,$did(22).text)
        if ($did($dname,16).state == 1) {
          if ($did(18).text == $null) || ($did(20).text == $null) { noop $input(Please enter a UID and Password for your Oper!,o,Error!) }
          else {
            writeini autojoin.ini $did(11).text UID $did(18).text
            writeini autojoin.ini $did(11).text operpass $did(20).text
          }
        }
        if ($did($dname,23).state == 1) {
          if ($did(25).text == $null) || ($did(27).text == $null) { noop $input(Please enter Connection Information for your ZNC! $chr(91) $+ Example: User/Net: GrimReaper/DalNet Password: S0m3Cr4zyP455 $+ $chr(93),o,Error!) }
          else {
            writeini autojoin.ini $did(11).text ZNCUser $did(25).text
            writeini autojoin.ini $did(11).text ZNCPass $did(27).text
          }
        }
        dialog -x ajoin_dia2 ajoin_dia2
        $dialogopen(ajoin_dia1)
      }
    }
  }
  if ($did == 9) || ($did == 10) {
    dialog -x ajoin_dia2 ajoin_dia2
    $dialogopen(ajoin_dia1)
  }
  if ($did == 16) {
    if ($did(16).state == 0) { did -h $dname 17-20 }
    if ($did(16).state == 1) { did -v $dname 17-20 }
  }
  if ($did == 23) {
    if ($did(23).state == 0) { did -h ajoin_dia2 24-27 }
    if ($did(23).state == 1) { did -v ajoin_dia2 24-27 }
  }
}

on *:DIALOG:ajoin_dia1:mouse:*: {
  if ($did == 4) { did -ra $dname 10 Use the Add button to start your AutoJoin with Selected Network, Nickname, Channels, Server and your NickServ Password. }
  if ($did == 5) { did -ra $dname 10 Use the Edit button to edit your detail's within the AutoJoin file. It will overwrite previous information. }
  if ($did == 6) { did -ra $dname 10 Use the Delete button to remove a Network that you no longer join or wish to join from your AutoJoin Setup. }
  elseif (!$istok(4|5|6,$did,124)) { did -r $dname 10 }
}

on *:START: {
  if ($ini(autojoin.ini,networks,0)) {
    var %a = 1, %z $ini(autojoin.ini,networks,0)
    while (%a <= %z) {
      $iif(%a == 1,server,server -m) $iif($readini(autojoin.ini,$ini(autojoin.ini,networks,%a),server) != irc.twitch.tv,$+($readini(autojoin.ini,$ini(autojoin.ini,networks,%a),server),:,$readini(autojoin.ini,$ini(autojoin.ini,networks,%a),portnum)) $iif($readini(autojoin.ini,$ini(autojoin.ini,networks,%a),ZNCConn) == on,$+($readini(autojoin.ini,$ini(autojoin.ini,networks,%a),ZNCUser),:,$readini(autojoin.ini,$ini(autojoin.ini,networks,%a),ZNCPass))),$+($readini(autojoin.ini,$ini(autojoin.ini,networks,%a),server),:,$readini(autojoin.ini,$ini(autojoin.ini,networks,%a),portnum)) $readini(autojoin.ini,$ini(autojoin.ini,networks,%a),password) -i $readini(autojoin.ini,$ini(autojoin.ini,networks,%a),nick) -j $lower($readini(autojoin.ini,$ini(autojoin.ini,networks,%a),channels)))
      inc %a
    }
  }
}

on *:CONNECT: {
  if ($server == tmi.twitch.tv) { .raw CAP REQ :twitch.tv/membership twitch.tv/commands }
  if ($ini(autojoin.ini,networks,$network)) { 
    nick $readini(autojoin.ini,$network,nick)
    if ($readini(autojoin.ini,$network,oline) == on) {
      oper $readini(autojoin.ini,$network,UID) $readini(autojoin.ini,$network,operpass)
    }
  }
}
; Anope Services 1
on *:NOTICE:*This nickname is registered and protected.*:?:{
  if ($nick == NickServ) {
    if ($readini(autojoin.ini,$network,aidentify) == on) {
      .msg NickServ identify $readini(autojoin.ini,$network,password)
    }
  }
}
; Anope Services 2
on *:NOTICE:*This nick is owned by someone else. Please choose another.*:?:{
  if ($nick == NickServ) {
    if ($readini(autojoin.ini,$network,aidentify) == on) {
      .msg NickServ identify $readini(autojoin.ini,$network,password)
    }
  }
}
; Atheme Services
on *:NOTICE:*This nickname is registered. Please choose a different nickname*:?:{
  if ($nick == NickServ) {
    if ($readini(autojoin.ini,$network,aidentify) == on) {
      .msg NickServ identify $readini(autojoin.ini,$network,password)
    }
  }
}

on *:NOTICE:*Password accepted*:?:{ 
  if ($nick == NickServ) { 
    if ($readini(autojoin.ini,$network,ajoin) == on) {
      join $readini(autojoin.ini,$network,channels) 
    }
  }
}

RAW 433:*:{ 
  if ($2 == $readini(autojoin.ini,$network,nick)) {
    .msg NickServ GHOST $2 $readini(autojoin.ini,$network,password)
    var %token $network $+ $readini(autojoin.ini,$network,nick)
    if (!$istok(%AJoinNick,%token,32)) {
      .timer 1 1 nick $readini(autojoin.ini,$network,nick)
    }
    set -eu20 %AJoinNick $addtok(%AJoinNick,%token,32)
  }
}

alias -l autojoinv3 { $iif($dialog(ajoin_dia1),dialog -v,dialog -m) ajoin_dia1 ajoin_dia1 }
alias -l dialogopen { dialog $iif($dialog($1),-v,-m $1) $1 }
alias ajoin { return $readini(autojoin.ini,$network,$1) }
