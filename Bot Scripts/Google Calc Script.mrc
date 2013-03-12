on $*:TEXT:/^[!@]gcalc\s(.*)/Si:#: {
  if ($sock(GoogleCalc)) { msg $chan Please wait til current search is over.. }
  elseif (!$regml(2)) { msg $chan Please use a calculation to check.. Syntax: [!@](gcalc|calc) equasion }
  else {
    sockopen GoogleCalc www.google.com 80
    sockmark GoogleCalc $+(/search?client=opera&rls=en&q=,$replace($regml(2),$chr(32),$chr(43)),&sourceid=opera&ie=utf-8&oe=utf-8&channel=suggest) $iif($left($1,1) == !,notice $nick,msg $chan) $+(,$regml(1),) Answer:
  }
}
on *:SOCKOPEN:GoogleCalc: {
  tokenize 32 $sock($sockname).mark
  if ($sockerr) { $2-3 Error connecting to server.. Please try again.. }
  else {
    var %a = sockwrite -n $sockname
    %a GET $1 HTTP/1.1
    %a Host: $sock($sockname).addr
    %a $crlf
  }
}
on $*:SOCKREAD:GoogleCalc: {
  tokenize 32 $sock($sockname).mark
  var $+(%,$sockname) | sockread $+(%,$sockname)
  if ($regex(GoogleCalc,$+(%,$sockname),/<b>(.*?) = (.*?)<\/b><\/h2>/Si)) {
    $2- $regml(GoogleCalc,1) = $regml(GoogleCalc,2)
    .sockclose $sockname
  }
}   
; https://www.google.co.uk/search?client=opera&rls=en&q=380+GBP+in+USD&sourceid=opera&ie=utf-8&oe=utf-8&channel=suggest
