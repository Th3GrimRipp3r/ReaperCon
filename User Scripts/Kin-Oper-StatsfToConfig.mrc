; Kin's Stats f to Config

; USAGE: /StatsfToConfig

; Creates a window buffer with all network spamfilters returned from /stats f
; formatted in the UnrealIRCD config file format.
; Tested on Unreal3.2.10.1

; For support, changes, or fixes, please visit:
; #ReaperCon at irc.GeekShed.net

; 2014-01-25 v1.2 - Minor error message improvements
; 2014-01-18 v1.1 - Bugfixes & Specify ban-time only for: shun gline zline gzline 
; 2014-01-18 v1.0 - Start

; ---- Customization Identifiers

alias -l Kin.StatsfToConfig.Timeout.Seconds { return 16 }

; ---- Alias

alias StatsfToConfig {
  ; ---- Check if a previous backup is already in progress (anti-flood)
  if ($group(#Kin.StatsfToConfig).status == on) && ($timer(Kin.StatsfToConfig.Timeout)) {
    echo 5 -tag Stats f backup already in progress!
    return
  }
  if (%Kin.StatsfToConfig.AntiFlood) {
    echo 5 -tag Error - May be used only once every 20 seconds.
    return
  }
  set -eu20 %Kin.StatsfToConfig.AntiFlood 1

  ; ---- Request spamfilter list from network
  .enable #Kin.StatsfToConfig
  .timerKin.StatsfToConfig.Timeout 1 $Kin.StatsfToConfig.Timeout.Seconds Kin.StatsfToConfig.Timeout
  window -e2 @Kin.StatsfToConfig
  !stats f
}

; ---- Events

#Kin.StatsfToConfig off

raw 229:*: {
  var %config $2
  var %target $3
  var %action $4
  var %ban-time $7
  var %reason $replace($regsubex(underscorereplace,$8,/(_(?!_))/g,$chr(32)),__,_)
  var %regex $10-

  aline @Kin.StatsfToConfig spamfilter $chr(123)
  aline @Kin.StatsfToConfig $chr(9) $+ regex $qt(%regex) $+ ;
  aline @Kin.StatsfToConfig $chr(9) $+ target $chr(123) $Kin.Spamfilter.TargetFlag2String(%target) $chr(125) $+ ;
  aline @Kin.StatsfToConfig $chr(9) $+ action %action $+ ;
  aline @Kin.StatsfToConfig $chr(9) $+ reason $qt(%reason) $+ ;
  if ($istok(shun gline zline gzline,%action,32)) {  
    aline @Kin.StatsfToConfig $chr(9) $+ ban-time %ban-time $+ s;
  }
  aline @Kin.StatsfToConfig $chr(125) $+ ;
  aline @Kin.StatsfToConfig $crlf
}

raw 219:*: {
  .disable #Kin.StatsfToConfig
  .timerKin.StatsfToConfig.Timeout off
  editbox @Kin.StatsfToConfig /savebuf @Kin.StatsfToConfig spamfilterconfig.txt
}

#Kin.StatsfToConfig end

; ---- Functions

alias -l Kin.StatsfToConfig.Timeout {
  echo 4 -tag Timeout waiting $Kin.StatsfToConfig.Timeout.Seconds seconds for stats f response - BACKUP INCOMPLETE
  .disable #Kin.StatsfToConfig
}

alias -l Kin.Spamfilter.TargetFlag2String {
  var %out
  if (c isincs $1) { %out = %out channel; }
  if (p isincs $1) { %out = %out private; }
  if (n isincs $1) { %out = %out private-notice; }
  if (N isincs $1) { %out = %out channel-notice; }
  if (P isincs $1) { %out = %out part; }
  if (q isincs $1) { %out = %out quit; }
  if (d isincs $1) { %out = %out dcc; }
  if (a isincs $1) { %out = %out away; }
  if (t isincs $1) { %out = %out topic; }
  if (u isincs $1) { %out = %out user; }
  if (!%out) { return - }
  return %out
}
