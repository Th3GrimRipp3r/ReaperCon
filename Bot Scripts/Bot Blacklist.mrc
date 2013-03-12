alias loc return $iif($chan,$v1,$nick)

on @*:text:!blacklist *:*:{
  tokenize 32 $strip($1-)
  if ($2 == view) && ($ini(blacklist.ini,$chan,0)) {
    .msg $loc 4Displaying A List Of Blacklisted Nicks/Hosts For $loc $+ :
    var %a 1, %z $ini(blacklist.ini,$chan,0)
    while (%a <= %z) {
      msg $loc %a Nick: $ini(blacklist.ini,$chan,%a) Reason: $readini(blacklist.ini,$chan,$ini(blacklist.ini,$chan,%a))
      inc %a
    }
    .msg $chan End of list. %z entry(s) displayed.
  }
  elseif ($2 == view) && (!$ini(blacklist.ini,$chan,0)) {
    msg $loc Sorry $nick $+ , there is no-one on the blacklist for $chan $+ .
  }

  if ($2 == add) {
    if ($3) {
      writeini blacklist.ini $chan $3 $iif(!$4,Blacklisted from $chan $+ .,$4-)
      msg $chan " $+ $3 $+ " Added as a blacklisted nick by $nick $+ , With reason: $iif(!$4,Blacklisted from $chan $+ .,$4-) $+ 
    }
  }
  if ($2 == del) {
    if ($3) {
      if ($readini(blacklist.ini,$chan,$3)) {
        remini blacklist.ini $chan $3
        msg $chan Removed $3 from the blacklist.
      }
    }
    else {
      msg $chan 4No such blacklist entry.
      notice $nick To see the list of blacklisted Nick/Host Entries, type !Bl, !blacklist
    }
  }
}

on *:JOIN:#: {
  if ($readini(blacklist.ini,$chan,$nick)) {
    mode $chan +b $address($nick,2)
    kick $chan $nick $readini(blacklist.ini,$chan,$nick)
  }
}
