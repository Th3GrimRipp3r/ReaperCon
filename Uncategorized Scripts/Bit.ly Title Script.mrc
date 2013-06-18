; ------- Event

on *:text:*:*: {
  if (!$regex(findhash,$1-,/bit(?:ly\.com|\.ly)\/(\S+)/)) { return }
  BitLYCheck $regml(findhash,1) !echo -t $iif($chan,$chan,$nick)
}

; ------- Alias

alias BitLYCheck {
  var %hash $$1
  var %callback $iif($2-,$v1,echo -tag)

  if ($sock(BitLYCheck)) { return }
  .timerBitLYCheckTimeout 1 8 .sockclose BitLYCheck
  unset %BitLYCheck.*

  sockopen BitLYCheck bitly.com 80
  sockmark BitLYCheck %hash %callback
}

; ------- Callback

alias -l BitLYCheck.Found {
  var %hash $1
  var %callback $2-
  if (%BitLYCheck.Title) && (%BitLYCheck.LongURL) {
    .timerBitLYCheckTimeout off
    .sockclose BitLYCheck
    %callback 11(4Bit.ly11) $+(bit.ly/,%hash) => %BitLYCheck.LongURL $iif(%BitLYCheck.Title != no title,$+(",%BitLYCheck.Title,"))
    unset %BitLYCheck.*
  }
}

; ------- Socket

on *:sockopen:BitLYCheck: {
  if ($sockerr > 0) { sockclose $sockname | halt }
  sockwrite -n $sockname GET $+(/,$gettok($sock($sockname).mark,1,32),+) HTTP/1.1
  sockwrite -n $sockname Host: $sock($sockname).addr
  sockwrite -n $sockname Connection: close
  sockwrite -n $sockname $crlf
}

on *:sockread:BitLYCheck: {
  if ($sockerr > 0) { .sockclose $sockname | halt }

  sockread %blylinkh

  if ($regex(%blylinkh,/id="bitmark_title_link"[^<>]*title="([^"]*)"/)) {
    set -e %BitLYCheck.Title $iif($regml(1),$v1,no title)
  }
  if ($regex(%blylinkh,/id="bitmark_long_url"[^<>]*href="([^"]*)"/)) {
    set -e %BitLYCheck.LongURL $regml(1)
  }

  if (%BitLYCheck.Title) && (%BitLYCheck.LongURL) {
    BitLYCheck.Found $gettok($sock($sockname).mark,1,32) $gettok($sock($sockname).mark,2-,32)
  }
}

on *:sockclose:BitLYCheck: {
  BitLYCheck.Found $gettok($sock($sockname).mark,1,32) $gettok($sock($sockname).mark,2-,32)
}
