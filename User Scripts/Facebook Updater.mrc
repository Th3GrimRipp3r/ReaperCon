menu menubar,channel,query,status {
  Facebook Update:dialog $iif($dialog(facebook),-v,-m facebook) facebook
}
dialog facebook {
  title "Facebook Status Updater by Danneh"
  size -1 -1 125 115
  option dbu
  text "Username:", 4, 3 3 26 8
  edit "", 5, 31 2 91 10, autohs
  text "Password:", 6, 3 14 25 8
  edit "", 7, 31 13 91 10, pass autohs
  box "Status:", 8, 3 35 119 50
  edit "", 9, 6 43 112 38, multi return autovs
  text "", 10, 3 88 119 8, center
  button "Setup", 11, 5 99 37 12
  button "Update", 12, 44 99 37 12
  button "Ok/Cancel", 13, 83 99 37 12, ok cancel
  check "Remember Me", 14, 31 24 50 10
  menu "File", 1
  item "Clear Status", 2, 1
  item "Clear Vars",3, 1
  item "Close", 15, 1, cancel
}

on *:DIALOG:facebook:menu:2,3: {
  if ($did == 2) {
    did -rf $dname 9
  }
  if ($did == 3) { 
    unset %fburl %fbc1 %fbc2 %fbc3 %fbc4 %cookie %fburl1 %fbv1 %fbv2
  }
}

on *:DIALOG:facebook:init:*: {
  if ((%fbuser) && (%fbpass)) {
    did -a $dname 5 %fbuser
    did -a $dname 7 %fbpass
    did -c $dname 14
    did -f $dname 9
  }
  if (%fburl1) { did -h $dname 11 }
}

on *:DIALOG:facebook:sclick:11,12,14: {
  if ($did == 11) {
    sockclose fbsetup
    sockopen fbsetup m.facebook.com 80
    sockmark fbsetup $+($did(5),$chr(170),$did(7))
    did -ra $dname 10 ---- Starting Facebook Script ----
  }
  if ($did == 12) {
    var %a = 1
    while (%a <= $did($dname,9).lines) {
      set %fbupdate $addtok(%fbupdate,$did(facebook,9,%a),32)
      inc %a
    }
    sockclose fbupdate
    sockopen fbupdate m.facebook.com 80
    sockmark fbupdate $+($did(5),$chr(170),$did(7),$chr(170),%fbupdate)
  }
  if ($did(14).state == 0) { unset %fbuser %fbpass }
  if ($did(14).state == 1) { set %fbuser $did(5) | set %fbpass $did(7) }
}

on *:sockopen:fbsetup: {
  tokenize 170 $sock(fbsetup).mark
  var %data $+(email=,$1,&pass=,$2,&login=Log_in)
  var %fbtype sockwrite -nt $sockname
  %fbtype POST /login.php?http HTTP/1.1
  %fbtype Host: m.facebook.com
  %fbtype Content-Type: application/x-www-form-urlencoded
  %fbtype Content-Length: $len(%data) 
  %fbtype $crlf $+ %data
}
on *:sockread:fbsetup: {
  var %fb | sockread %fb
  if $regex(%fb,Location: http://m.facebook.com/(.*)) {
    did -ra facebook 10 ---- Retrieving cookies ----
    set %fburl / $+ $regml(1)
  }
  if $regex(%fb,Set-Cookie: L=(.*) path=/; domain=.facebook.com; httponly) {
    set %fbc1 cur_max_lag= $+ $regml(1)
  }
  if $regex(%fb,Set-Cookie: datr=(.*) expires=.*) {
    set %fbc2 datr= $+ $regml(1)
  }
  if $regex(%fb,Set-Cookie: m_user=(.*) expires=.* path=/; domain=.facebook.com; httponly) {
    set %fbc3 m_user= $+ $regml(1)
  }
  if $regex(%fb,Set-Cookie: W=(.*) path=/; domain=.facebook.com) {
    set %fbc4 made_write_conn= $+ $regml(1)
  }
  .sockclose fbsetup2
  sockopen fbsetup2 m.facebook.com 80
}

on *:sockopen:fbsetup2: {
  var %fbtype sockwrite -nt $sockname
  %fbtype GET %fburl HTTP/1.1
  %fbtype Host: m.facebook.com
  set %cookie $+(%fbc1,;,$chr(32),%fbc2,;,$chr(32),%fbc3,;,$chr(32),%fbc4)
  %fbtype Cookie: %cookie
  %fbtype $crlf 
}

on *:sockread:fbsetup2: {
  var %f2
  sockread %f2
  if $regex(%f2,action="\/a\/(.*)"><input type="hidden") {
    set %fburl1 $+(/a/,$regml(1))
  }
  if $regex(%f2,name="fb_dtsg" value="(.*)" autocomplete="off" \/><input type="hidden") {
    set %fbv1 fb_dtsg= $+ $regml(1)
  }
  if $regex(%f2,name="post_form_id" value="(.*)" /><input type="hidden") {
    set %fbv2 post_form_id= $+ $regml(1)
    .sockclose fbsetup2
    .sockclose fbsetup
    did -ra facebook 10 ---- All information stored. ----
    .timer 1 1 did -r facebook 10
    did -h facebook 11
  }
}

on *:sockopen:fbupdate: {
  tokenize 170 $sock(fbupdate).mark
  var %data $+(%fbv1,&,%fbv2,&status=,$3-,&update=Share)
  var %fbtype sockwrite -nt $sockname
  %fbtype POST %fburl1 HTTP/1.1
  %fbtype Host: m.facebook.com
  %fbtype Cookie: %cookie
  %fbtype Content-Type: application/x-www-form-urlencoded
  %fbtype Content-Length: $len(%data)
  %fbtype User-Agent: $+(mIRC/,$version)
  %fbtype $crlf $+ %data
  did -ra facebook 10 ---- Status updated ----
  .timer 1 1 did -r facebook 10
  .unset %fbupdate
}
