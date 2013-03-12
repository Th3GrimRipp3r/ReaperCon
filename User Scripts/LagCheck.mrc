; ----------------------------------------------------------------
; Kin's Lag Check
; KinKinnyKith - Kin "Kinny" Kith
; #ReaperCon #mIRC #Script-Help #Bots - IRC.GeekShed.Net
; http://code.google.com/p/reapercon/
; 2012-03-28
; v1.4
; ----------------------------------------------------------------
; One shot lag check alias.
; Great to see if you're still connected during those quiet times.
; Usage from any window: /lagcheck (or /lag if the optional alias is below)
; ----------------------------------------------------------------
; Usage
;  /lagcheck
;  /lag
; ----------------------------------------------------------------
; Features
;  ) Reports server lag in miliseconds
;  ) Timeout if no response
; ----------------------------------------------------------------
; Inspired from a request in #help on GeekShed
; ----------------------------------------------------------------
; History
; 2012-03-28 v1.4 Put intital echo on timer to reduce display spam for lag < 1sec
; 2012-03-24      Styling improvmenents
; 2012-03-20 v1.3 Unset global variable on timeout
; ----------------------------------------------------------------

; ---- Customization Identifiers
alias -l Timeout.Seconds { return 8 }
alias -l LagCheck.Echo { !echo -ag 10(IRC-Lag)14 $1- }

; ---- Optional alternative alias (conflicts with op3r command}
alias lag { LagCheck }

; ---- Aliases
alias LagCheck {
  if (!$server) {
    LagCheck.Echo Not connected to server.
    return
  }
  ; ---- Check if a previous lag check is already in progress (anti-flood)
  if ((%LagCheck.Ticks) || ($group(#LagCheck).status == on) || ($timer(LagCheck.Timeout))) {
    LagCheck.Echo Lag check already in progress!
    return
  }
  ; ---- Check lag
  .timerLagCheck.Progressing 1 1 LagCheck.Echo Checking lag...
  set -e %LagCheck.Ticks $ticks
  .enable #LagCheck
  .timerLagCheck.Timeout 1 $Timeout.Seconds LagCheck.Timeout
  .raw PING : $+ $ctime Lag Check
}

; ---- Aliases
alias -l LagCheck.Timeout {
  .disable #LagCheck
  unset %LagCheck.Ticks
  LagCheck.Echo 04Timeout14 waiting $Timeout.Seconds seconds for ping response from10 $server
}
#LagCheck off
on ^*:PONG: {
  ; ---- Check for our pong
  if ($3- != Lag Check) { return }
  ; ---- Cleanup
  .timerLagCheck.Progressing off
  .timerLagCheck.Timeout off
  .disable #LagCheck
  ; ---- Calculate ping delay and stylize
  var %ms $calc($ticks - %LagCheck.Ticks), %style
  unset %LagCheck.Ticks
  if (%ms < 1000) { %style = 03 }
  elseif (%ms < 2000) { %style = 06 }
  elseif (%ms < 3000) { %style = 07 }
  elseif (%ms < 4000) { %style = 05 }
  else { %style = 04 }
  ; ---- Report
  LagCheck.Echo $iif(%style,$+(%style,%ms,ms14),%ms $+ ms) lag to10 $server
  HALT
}
#LagCheck end
