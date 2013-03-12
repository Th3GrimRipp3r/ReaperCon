menu * {
  Short URL's:shrinkurl
}

dialog shrink_dia {
  title "Short URL Dialog by GrimReaper"
  size -1 -1 126 62
  option dbu
  edit "", 4, 4 4 117 10, autohs
  button "TinyURL", 5, 4 17 37 12
  button "Clear All", 6, 44 17 37 12
  button "L0p.us", 7, 84 17 37 12
  text "", 8, 4 32 117 10
  button "Clipboard", 9, 23 45 37 12
  button "Close", 10, 64 45 37 12
  menu "File", 1
  item "Clear All", 2, 1
  item "Exit", 3, 1
}

on *:DIALOG:shrink_dia:menu:2,3: {
  if ($did == 2) {
    did -r $dname 4,8
  }
  if ($did == 3) {
    dialog -x shrink_dia shrink_dia
  }
}

on *:DIALOG:shrink_dia:sclick:5,6,7,9,10: {
  if ($did == 5) {
    did -r $dname 8
    set %tinyurl1 $did($dname,4).text
    sockopen tinyurl tinyurl.com 80
  }
  if ($did == 6) {
    did -r $dname 8,4
  }
  if ($did == 7) {
    did -r $dname 8
    set %Lop.url $did($dname,4).text
    sockopen lop www.l0p.us 80
  }
  if ($did == 9) {
    clipboard $did($dname,8).text
  }
  if ($did == 10) {
    dialog -x shrink_dia shrink_dia
  }
} 

on *:SockOpen:lop*: {
  if ($sockerr) { did -a shrink_dia 8 Error connecting to l0p.us }
  else {
    sockwrite -nt lop GET $+(/api-make.php?alias=&url=,%Lop.url) HTTP/1.1
    sockwrite -n lop Host: www.l0p.us
    sockwrite -n lop $crlf
  }
}
on *:SockRead:lop*: {
  var %read | sockRead  %read
  if (http://* iswm %read) {
    did -a shrink_dia 8 %read
    unset %Lop.*
  }
}

on *:sockopen:tinyurl*: {
  sockwrite -n $sockname GET /create.php?url= $+ %tinyurl1 HTTP/1.0
  sockwrite -n $sockname Host: tinyurl.com
  sockwrite -n $sockname user-agent: Mozilla/??
  sockwrite -n $sockname Connection: Keep-Alive
  sockwrite -n $sockname $crlf
}
on 1:sockread:tinyurl*: {
  :nextread
  if ($sockerr > 0) return
  sockread %temp
  if ($sockbr == 0) return

  if (<blockquote><b>* iswm %temp && $left($replace(%tinyurl1,&,&amp;),15) !isin %temp) {
    set %tinyurl2 $remove($gettok(%temp,2,60),b>)
    did -a shrink_dia 8 $remove(%tinyurl2,preview.)
    unset %tinyurl*
  }
  goto nextread
}

alias -l shrinkurl {
  if (!$dialog(shrink_dia)) { dialog -m shrink_dia shrink_dia }
  else { dialog -v shrink_dia shrink_dia }
}
