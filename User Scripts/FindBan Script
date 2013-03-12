alias findban {
  if (%findban.on) && (!$?!="The findban variables are still set. Are you sure you want to start it again?") return
  var %chan $iif(#* iswm $1,$1,$chan)
  if ($me !ison %chan) {
    echo 14 -ag Findban: 4ERROR: You're not on channel %chan
    return
  }
  unset %findban.*
  set -e %findban.on %chan
  !whois $iif(#* iswm $1,$2,$1)
}
raw 311:*: {
  if (%findban.on) {
    set -e %findban.address $+($2,!,$3,@,$4)
    set -e %findban.name $replace($6-,$chr(32),_)
  }
}
raw 378:*: {
  if (%findban.on) {
    set -e %findban.host $+($gettok(%findban.address,1,64),@,$gettok($6,-1,64))
    set -e %findban.ip $+($gettok(%findban.address,1,64),@,$7)
  }
}
raw 379:*:if (%findban.on) set -e %findban.umode $6
raw 319:*:if (%findban.on) set -e %findban.rooms $regsubex($3-,/(?<!\S)[^#]+/g,)
raw 318:*: {
  if (%findban.on) {
    echo 14 -ag Findban: $+(--=,$chr(123),Using GrimReaper's ban finder on $v1 for $2,$chr(125),=--)
    var %chan $v1, %a 1, %b $ibl(%chan,0)
    if ($chan(%chan).ibl) {
      while (%a <= %b) {
        var %mask $ibl(%chan,%a), %mask2 $gettok(%mask,-1,58)
        if ((~c:* iswm %mask) && ($wildtok(%findban.rooms,%mask2,0,32))) || ((~r:* iswm %mask) && (%mask2 iswm %findban.name)) || ($wildtok(%findban.address %findban.host %findban.ip,%mask2,1,32)) {
          echo 14 -ag Findban:6 %mask by6 $gettok($ibl(%chan,%a).by,1,33) - $duration($calc($ctime - $ibl(%chan,%a).ctime)) ago.
        }
        inc %a
      }
    }
    else echo 14 -ag Findban: 4ERROR: Internal ban list for %chan hasn't loaded. Please type /mode %chan +b and try again.
    var %m $gettok($chan(%chan).mode,1,32)
    if (i isincs %m) echo 14 -ag Findban:6 %chan is set to invite-only.
    if (%findban.umode) {
      if (R isincs %m) && (r !isincs %findban.umode) echo 14 -ag Findban:6 Only registered users are allowed in %chan $+ .
      if (z isincs %m) && (z !isincs %findban.umode) echo 14 -ag Findban:6 Only SSL users are allowed in %chan $+ .
      if (O isincs %m) && (o !isin %findban.umode) echo 14 -ag Findban:6 Only IRCops are allowed in %chan $+ .
      if (A isincs %m) && (a !isin %findban.umode) echo 14 -ag Findban:6 Only IRCop admins are allowed in %chan $+ .
    }
    echo 14 -ag Findban: End of results.
    unset %findban.*
  }
}
