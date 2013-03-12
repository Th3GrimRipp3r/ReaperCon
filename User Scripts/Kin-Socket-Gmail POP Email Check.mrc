; ----------------------------------------------------------------
; Gmail New Mail Notification - mSL mIRC SSL POP Email
; KinKinnyKith - Kin "Kinny" Kith
; #ReaperCon #mIRC #Script-Help #Bots - IRC.GeekShed.Net
; Hosted at http://reapercon.googlecode.com
; 2012-05-12
; v1.2 Debug Version
; ----------------------------------------------------------------
; Very basic framework to check Gmail to see if you have new mail.
; Can be extended for error handling, and polling on a timer when
;  I get another hour to play with it. 8)
; Horribly basic menu interface to set account and password, but
;  sufficient for the task to demonstrate the socket.
; Requires SSL: $sslready must be $true
; ----------------------------------------------------------------
; 2012-05-12 v1.2 - Cleanup for Repo
; 2012-05-12 v1.1 - POPMail.Report to check tokens for new mail, menu.
; 2012-05-12 v1.0 - Quick Script
; ----------------------------------------------------------------

on *:LOAD: { /set %Kin.POPMail.Debug Enabled | POPEmail.EchoDebug Debugging Enabled }
on *:UNLOAD: { /unset %Kin.POPMail.* }

menu query,channel,status,menubar,@* {
  Kin's Gmail Check
  .Check:POPMail.Check Gmail
  .-
  .$iif(%Kin.POPMail.Address,$style(1)) Set Username:/set %Kin.POPMail.Address $encode($input(Gmail Username?,oe),m)
  .$iif(%Kin.POPMail.Password,$style(1)) Set Password:/set %Kin.POPMail.Password $encode($input(Gmail Password?,oe),m)
  .-
  .$iif(%Kin.POPMail.Debug,$style(1)) Turn Debugging $iif(%Kin.POPMail.Debug,Off,On):POPMail.Debug
}
alias -l POPMail.Debug { if (%Kin.POPMail.Debug) { /unset %Kin.POPMail.Debug } | else { /set %Kin.POPMail.Debug Enabled } }
alias -l POPEmail.EchoWnd { if (!$window($1)) { /window -ne2 $1 | /log on $1 -f \logs\ $+ $1 $+ .log } | !echo $1 $timestamp (Gmail- $+ $Kin.POPMail.Address $+ ) $2- }
alias -l POPEmail.Echo { POPEmail.EchoWnd @GMail $1- }
alias -l POPEmail.EchoDebug { if (%Kin.POPMail.Debug) { POPEmail.EchoWnd @GMail Debug -> $1- } }

alias -l Kin.POPMail.Address { return $decode(%Kin.POPMail.Address,m) }
alias -l Kin.POPMail.Password { return $decode(%Kin.POPMail.Password,m) }

alias POPMail.Check {
  if (!%Kin.POPMail.Address) || (!%Kin.POPMail.Password) { POPEmail.Echo 13Set your address AND password first please | return }
  POPEmail.Echo 03Checking Gmail
  /sockclose POPEMail
  /sockopen -e POPEMail pop.gmail.com 995
  .timerPOPEmailTimeout 1 12 /sockclose POPEMail
}
alias POPMail.Close {
  POPEmail.Echo 05Closing Gmail
  /sockwrite -n POPEMail QUIT
  .timerPOPEmailTimeout 1 12 /sockclose POPEMail
}
alias POPMail.Report {
  var %outmsg %Kin.POPMail.Sock.New total emails.
  var %ix 1, %iy $numtok(%Kin.POPMail.Sock.Tokens,32), %temptok, %inew 0
  while (%ix <= %iy) {
    %temptok = $gettok(%Kin.POPMail.Sock.Tokens,%ix,32)
    if (!$istok(%Kin.POPMail.Tokens,%temptok,32)) {
      /set %Kin.POPMail.Tokens $addtok(%Kin.POPMail.Tokens,%temptok,32)
      if ($len(%Kin.POPMail.Tokens) > 3400) { /set %Kin.POPMail.Tokens $deltok(%Kin.POPMail.Tokens,1-2,32) }
      POPEmail.EchoDebug 13Found a new message.
      inc %inew
    }
    inc %ix
  }
  if (%inew > 0) {
    %outmsg = %outmsg %inew new messages.
  }
  else {
    %outmsg = %outmsg No new messages.
  }
  POPEmail.Echo 04 %outmsg
  /unset %Kin.POPMail.Sock.New
  /unset %Kin.POPMail.Sock.Tokens
}

on *:SOCKOPEN:POPEMail: {
  if ($sockerr) { POPEmail.Echo 4Socket Error - $sockname - ErrNum: $sock($sockname).wserr Message: $sock($sockname).wsmsg | .sockclose $sockname | halt }
  POPEmail.EchoDebug 03Socket Open $sockname
  .timerPOPEmailTimeout off
}
on *:SOCKCLOSE:POPEMail: {
  POPEmail.EchoDebug 05Socket Close $sockname
  .timerPOPEmailTimeout off
  POPMail.Report
}

on *:SOCKREAD:POPEMail: {
  if ($sockerr) { POPEmail.Echo 4Socket Error - $sockname - ErrNum: $sock($sockname).wserr Message: $sock($sockname).wsmsg | .sockclose $sockname | halt }
  POPEmail.EchoDebug 14Socket Read $sockname

  /var %POPSock
  /sockread %POPSock
  if (%POPSock) { POPEmail.EchoDebug %POPSock }

  if (!%POPEmail.State) {
    ; Authorization State
    if ($regex(%POPSock,/^\+OK\b.*?\bready\b/i)) {
      POPEmail.EchoDebug 07OK Sending Username
      /sockwrite -n $sockname USER $Kin.POPMail.Address
    }
    elseif ($regex(%POPSock,/^\+OK\ssend\sPASS/i)) {
      POPEmail.EchoDebug 07OK Sending Password
      /sockwrite -n $sockname PASS $Kin.POPMail.Password
    }
    elseif ($regex(%POPSock,/^\+OK\sWelcome/i)) {
      POPEmail.EchoDebug 07OK Checking List
      /set %POPEmail.State STAT
      /sockwrite -n $sockname STAT
    }
  }
  else {
    ; Transaction State
    if (%POPEmail.State == STAT) {
      if ($regex(%POPSock,/^\+OK\s(\d+)\s(\d+)/i)) {
        POPEmail.EchoDebug 07OK $regml(1) new messages
        /set %Kin.POPMail.Sock.New $regml(1)
        /set %POPEmail.State LIST
        /sockwrite -n $sockname LIST
      }
    }
    elseif (%POPEmail.State == LIST) {
      if ($regex(%POPSock,/^(\d+)\s(\d+)/i)) {
        POPEmail.EchoDebug 07Message $regml(1) size $regml(2)
      }
      elseif ($regex(%POPSock,/^\./i)) {
        POPEmail.EchoDebug 07End of messages
        /set %POPEmail.State UIDL
        /sockwrite -n $sockname UIDL
      }
    }
    elseif (%POPEmail.State == UIDL) {
      if ($regex(%POPSock,/^(\d+)\s(\S+)/i)) {
        POPEmail.EchoDebug 07Message $regml(1) ID $regml(2)
        /set %Kin.POPMail.Sock.Tokens $addtok(%Kin.POPMail.Sock.Tokens,$regml(2),32)
      }
      elseif ($regex(%POPSock,/^\./i)) {
        POPEmail.EchoDebug 07End of messages
        /unset %POPEmail.State
        /sockwrite -n $sockname QUIT
      }
    }
  }
}
