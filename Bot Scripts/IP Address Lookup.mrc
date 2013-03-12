on *:exit:{
  if ($file(whois).shortfn) .remove $v1
}
on *:sockclose:w...*:{
  var %- = $gettok($sock($sockname).mark,2,124)
  .play -cl8 %- whois 2000 
  var %w = 10
  while (%w <= 19) { 
    .play $+(-cl,%w) %- whois 2000 
    inc %w 
  }
}
on *:text:$($iif(!track* iswm $strip($1),$1)):*:{
  if ($file(whois).shortfn) write -c $v1 
  if ($regex($strip($2),/((\d{1,3}\.){3}\d{1,3})/S)) { 
    var %ipinfo = $regml(1)
    if ($play(#)) || ($play($nick)) { 
      .notice $nick Please wait until I've finished the IP lookup! 
      halt 
    }
    .msg $iif(#,#,$nick) Please wait while I fetch the IP info...
    var %w $+(w...,$r(1,$ticks)) 
    sockopen %w www.fr2.cyberabuse.org 80
    sockmark %w $+(%ipinfo,|,$iif(#,#,$nick)) 
    halt 
  }
  .notice $nick That's not an IP address. Syntax: !track <IP>
}
on *:sockread:w...*:{
  if ($sockerr) { 
    $gettok($sock($sockname).mark,2,124) * Error Reading Website! 
    halt 
  }
  var %whois 
  sockread %whois 
  if (error isin %whois) { 
    .msg $gettok($sock($sockname).mark,2,124) Invalid IP Address! 
    halt 
  }
  if ($regex(%whois,/(.*)<br>/)) {
    write whois .msg $gettok($sock($sockname).mark,2,124) $&
      $regsubex($regml(1),/<[^>]*>|%.*|whois server/gi,)
  }
}
on *:sockopen:w...*:{
  if ($sockerr) { 
    $gettok($sock($sockname).mark,2,124) * Error Connecting to Website! 
    halt 
  }
  var %? = sockwrite -nt $sockname
  var %?? = $+(IP=,$gettok($sock($sockname).mark,1,124),&OK=OK&OK=OK&dns=OK)
  %? POST /whois/?page=whois_server HTTP/1.1 
  %? Host: $sock($sockname).addr
  %? Referer: $+(http://,$sock($sockname).addr,/whois/?page=whois_server)
  %? Content-Type: application/x-www-form-urlencoded 
  %? Connection: close 
  %? Content-Length: $len(%??) 
  %? $+($crlf,%??)
}

