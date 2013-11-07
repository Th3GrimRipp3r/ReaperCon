; TomCoyoteWilson Brag Script, 
; Can be used for bot or client
; !mchan and !vchan commands can be turned off
; via menu
; # opchk added at bottom, you can add/subtract 
; # user op statuses from this to allow ops to use the 
; # commands in the rooms (~&@%+) 
; # !brag off|on  and !mchan 
; # or in query(PM) !vchan
; Version Release 1.0

menu menubar,channel,status {
  TC Brag Script:
  .Echo Chans:
  ..All Chans:/echo -a 9 $mchanlist
  ..SP exclude/chan:/echo -a 7 $schanlist
  ..SP Include/chan:/echo -a 7 $includes(sp)
  ..Exclude Select :/echo -a 9 $mchanlist($$?="Enter a mode(s) you wish to exclude:")
  ..Include Select:/echo -a 9 $includes($$?="Enter a mode(s) you wish to Include:")
  .!brag !mchan !vchan:
  ..$iif(($group(#brags) == off) && ($group(#brag) == off),$style(3))) Off:.disable #brags | .disable #brag | echo -a 4 (!brag !mchan !vchan) OFF
  ..$iif(($group(#brags) == on) && ($group(#brag) == on),$style(3))) On:.enable #brags | .enable #brag | echo -a 7 (!brag !mchan !vchan) 9ON
  .!mchan !Vchan:
  ..$iif($group(#brag) == off,$style(3)) Off:.disable #brag | echo -a 4 (!mchan !vchan) OFF
  ..$iif($group(#brag) == on,$style(3)) On:.enable #brag | echo -a 7 (!mchan !vchan) 9ON
  .Brag Room:/mchan
}
#brags on
on *:TEXT:!brag *:#: {
  opchk 
  if ($2 == off) { .disable #brag | .notice $nick !mchan !vchan 4 OFF | halt }
  if ($2 == on) { .enable #brag | .notice $nick !mchan !vchan 9 ON | halt }
}
#brags end
#brag on
on *:TEXT:!vchan*:?: {
  antiflood
  var %schan $schanlist
  var %mchan $mchanlist
  if (%schan < $chan(0)) { var %secret $numtok(%mchan,32) - $numtok(%schan,32)
    msg $nick I am in %secret Secret or Private Channels and in $numtok(%schan,32) Regular Channels.
  }
}
on *:TEXT:!mchan:#: {
  opchk
  antiflood
  var %schan $schanlist
  var %mchan $mchanlist
  if (%schan < $chan(0)) { var %secret $numtok(%mchan,32) - $numtok(%schan,32)
    msg $chan $nick I am in %secret Secret or Private Channels and in $numtok(%schan,32) Regular Channels.
  }
}
#brag end
alias -l mchan {
  antiflood
  var %schan $schanlist
  var %mchan $mchanlist
  if (%schan < $chan(0)) { var %secret $numtok(%mchan,32) - $numtok(%schan,32)
    msg $active I am in %secret Secret or Private Channels and in $numtok(%schan,32) Regular Channels.
  }
}
alias -l mchanlist { 
  ; useage in script $mchanlist(s) or $mchanlist(sp) for secret or secret and private to be ruled
  ; out of the results or any other channel mode to be ruled out as a filter in the brackets, 
  ; no brackets for full channel list results of client connected Regex by Kin
  var %excludemodes $1 | return $regsubex(chanlist,$str(.,$chan(0)),/(.)/g,$+($chr(32),$iif($regex(chanmodetest,$gettok($chan(\n).mode,1,32),/[ $+ %excludemodes $+ ]/),,$chan(\n))))
}
alias -l schanlist { 
  ; useage in script $schanlist
  ; Regex by Kin
  return $regsubex(chanlist,$str(.,$chan(0)),/(.)/g,$+($chr(32),$iif($regex(chanmodetest,$gettok($chan(\n).mode,1,32),/[sp]/),,$chan(\n))))
}
alias -l includes {
  ; Usage: $includes(modes_to_include)
  ; Ex: $includes(s) ; Returns: List of all secret channels
  ; Ex: $includes(z) ; Returns: List of all +z channels
  var %includemodes $1, %excludemodes $2
  return $regsubex(includes,$str(.,$chan(0)),/(.)/g,$+($chr(32),$include($chan(\n),%includemodes)))
}
alias -l include {
  ; UsageEx: $include(#channel,modes-include)
  var %chan $1, %modes $gettok($chan(%chan).mode,1,32)
  var %includemodes $regsubex(modeclean,$2,/([^a-zA-Z])/g,)
  if (%includemodes) && (!$regex(include,%modes,/[ $+ %includemodes $+ ]/)) { return $null }
  return %chan
}
alias -l antiflood { if (!$($+(%,antiflood,.,$1),2)) { set -u5 $+(%,antiflood,.,$1),2)) on } | else { halt } }
alias -l opchk if (!$nick(#,$nick,~&)) { .notice $nick You are not allowed to use this command | halt }
; ##
; ## Thanks to Kin for his scripts/Regex which I borrowed from to make this script
ctcp 1:TCBrag:/notice $nick TCBrag 7 TCBrag script version 1.0 9 $+($chr(84),$chr(111),$chr(109),$chr(67),$chr(111),$chr(121),$chr(111),$chr(116),$chr(101)) (( http://pastebin.com/FCK8Jsfd ))
