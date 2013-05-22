on *:text:*:*: {
  if (bit.ly isin $1-) {
    if ($sock(BitLYCheck)) { .sockclose BitLYCheck }
    set %blylinkchan $iif($chan,$chan,$nick)
    sockmark BitLYCheck $gettok($matchtok($1-,http://,1,32),2,47) $gettok($matchtok($1-,http://,1,32),3,47)
    sockopen BitLYCheck $gettok($matchtok($1-,http://,1,32),2,47) 80
    halt
  }
}

on *:sockopen:BitLYCheck: {
  if ($sockerr > 0) { sockclose $sockname | halt }
  sockwrite -n $sockname GET / $+ $gettok($sock(BitLYCheck).mark,2,32) HTTP/1.1
  sockwrite -n $sockname Host: $sock(BitLYCheck).addr
  sockwrite -n $sockname $crlf
}

on *:sockread:linkchecker: {
  if ($sockerr > 0) { .sockclose $sockname | halt }
  sockread %blylinkh
  if ($regex(%blylinkh,/<title>(.*?)<\/title>) {
    echo -t %blylinkchan 13 $+ $regml(1)
    unset %bly*
    .sockclose $sockname
    halt
  }
}
