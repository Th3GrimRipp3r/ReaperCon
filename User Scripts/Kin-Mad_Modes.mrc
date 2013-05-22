; Kin Mad Modes for Blizzardo1
; 2013-05-13 GeekShed #Script-Help

; 2012-05-22 v1.2 Added madban
; 2012-05-19 v1.1 Updated to work for half-ops too, with the help of Bliz suggesting $nick($chan,$me,@%)
; 2013-05-13 v1.0

; --------

; MadBan - Bans a nick on all channels you are joined to as hop or greater
; example: /madban Kin

; MadChan - Sets the same channel mode on all channels you are joined to as hop or greater
; example: /madchan +MNR

; MassMode - Sets / Removes modes to all nicknames on the active channel that you are joined to as hop or greater (currently just +v -v)
; example (use from an active channel window): /massmode +v

; -------- Aliases

alias madban {
  var %banmask $address($$1,2)
  if (!%banmask) { echo -ag Cannot find $1 $+ 's hostmask | return }

  var %chans $regsubex(madban,$str(.,$chan(0)),/./g,$iif($nick($chan(\n),$me,$remove($prefix,+)),$+($chr(32),$chan(\n)),))
  var %ix 1
  var %max $numtok(%chans,32)
  while (%ix <= %max) {
    !mode $gettok(%chans,%ix,32) +b %banmask
    inc %ix
  }
}

alias madchan {
  var %mode $$1
  if (!$regex(madchan,%mode,/^([-+])/)) { return }

  ; var %chans $regsubex(madchan,$str(.,$chan(0)),/./g,$iif($me isop $chan(\n),$+($chr(32),$chan(\n)),))
  var %chans $regsubex(madchan,$str(.,$chan(0)),/./g,$iif($nick($chan(\n),$me,$remove($prefix,+)),$+($chr(32),$chan(\n)),))

  var %ix 1
  var %max $numtok(%chans,32)
  while (%ix <= %max) {
    !mode $gettok(%chans,%ix,32) %mode
    inc %ix
  }
}

alias massmode {
  var %chan $active
  if (!%chan) || ($me !ison %chan) { echo -ag MassMode -> Error. Not on channel | return }
  if (!$nick(%chan,$me,$remove($prefix,+))) { echo -ag MassMode -> Error. Not an op | return }

  if (!$regex(mm,$1,/^([+-])([v])$/)) { return }
  var %dir $regml(mm,1), %mode $regml(mm,2)

  var %nicks $regsubex($str(.,$nick(%chan,0)),/./g,$+($chr(32),$nick(%chan,\n)))
  var %ix 1
  var %max $modespl
  while ($nick(%chan,%ix)) {
    !mode %chan $+(%dir,$str(%mode,%max)) $gettok(%nicks,$+(%ix,-,$calc(%ix + %max)),32)
    inc %ix %max
  }
}
