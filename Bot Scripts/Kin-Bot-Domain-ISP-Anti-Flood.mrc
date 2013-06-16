; -------- Configuration
alias -l Kin.ISPFlood.Lines { return 10 }
alias -l Kin.ISPFlood.Seconds { return 5 }

; -------- Description
; Kin's Domain/ISP Anti-flood
; 2013-06-16
; #script-help irc.geekshed.net

; A simple anti-flood script for individual channel messages that keeps track
; by domain or ISP, and sets a ban on that domain if one, or many, users from
; the same domain flood the channel with messages.

; This anti-flood method counts the timestamps of channel messages events,
; instead of using timers.

; -------- History
; 2013-06-16 v1.3 Description, and fix to ensure the minimum variable clear time is greater than the flood period
; 2013-06-16 v1.2 Bug fixes in $gettok too few params, and $var($+(%Kin.
; 2013-06-16 v1.1 Fix to keep the anti-flood channel specific
; 2013-06-16 v1.0 Request by light irc.geekshed.net #Script-Help

; -------- Events
on @*:TEXT:*:#:{ Kin.ISPFlood.Event }
on @*:ACTION:*:#:{ Kin.ISPFlood.Event }

; -------- Alias
alias -l Kin.ISPFlood.Event {
  if ($nick isop $chan) || ($nick ishop $chan) { return }

  var %flood_lines $iif($Kin.ISPFlood.Lines isnum,$Kin.ISPFlood.Lines,10)
  var %flood_seconds $iif($Kin.ISPFlood.Seconds isnum,$Kin.ISPFlood.Seconds,5)
  var %clearvar_seconds $calc(%flood_seconds + 5)

  var %domain $remove($mask($fulladdress,4),*!*@*.)

  ; ---- If this domain was recently banned, do not try to flood the server with more bans
  if ($var($+(Kin.DomainFlood.,$chan,%domain),1).value == BANNED) { return }

  ; ---- Add this event to the timestamp list
  set $+(-eu,%clearvar_seconds) %Kin.DomainFlood. $+ $chan $+ %domain $var($+(Kin.DomainFlood.,$chan,%domain),1).value $ctime

  ; ---- Remove old timestamps beyond the period of interest
  var %ix 1
  var %imax $numtok($var($+(Kin.DomainFlood.,$chan,%domain),1).value,32)
  var %oldtime $calc($ctime - %flood_seconds)
  while (%imax) {
    var %eventtime $gettok($var($+(Kin.DomainFlood.,$chan,%domain),1).value,%imax,32)
    if (%eventtime < %oldtime) {
      ; -- Remove old timestamp
      set $+(-eu,%clearvar_seconds) %Kin.DomainFlood. $+ $chan $+ %domain $deltok($var($+(Kin.DomainFlood.,$chan,%domain),1).value,%imax,32)
    }
    dec %imax
  }

  ; ---- Check if flooding
  var %linecount $numtok($var($+(Kin.DomainFlood.,$chan,%domain),1).value,32)
  if (%linecount > %flood_lines) {
    ; -- Ban Domain for flooding
    !mode $chan +b *!*@*. $+ %domain
    ; -- Unset timestamps to prevent flooding the server with bans if the server is delayed
    set $+(-eu,%clearvar_seconds) %Kin.DomainFlood. $+ $chan $+ %domain BANNED
  }
}
