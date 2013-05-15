; Kin mod v10 - 2013-04-21 1:49

alias nets {
  var %ctr = 0
  var %tot = $scon(0)

  if ($$1 == n) {
    while (%ctr < %tot) {
      inc %ctr

      var %out $null
      if ($scon(%ctr).status == connected) {
        %out = %out 7Connected To:4 $scon(%ctr).NetworkOrServer
        %out = %out 7As:4 $scon(%ctr).me $+ 
      }
      else {
        if ($scon(%ctr).NetworkOrServer) {
          %out = %out 7Currently not connected to:4 $v1 $+ .
        }
      }
      if (%out) { say 3* %out }
    }
  }
  elseif ($$1 == c) {
    while (%ctr < %tot) {
      inc %ctr

      var %out $null
      if ($scon(%ctr).status == connected) {
        %out = %out 7Connected To:4 $scon(%ctr).NetworkOrServer
        %out = %out 8( $+ 7In12 $scon(%ctr).chanz $+ 8)
        %out = %out 7As:4 $scon(%ctr).me $+ 
      }
      else {
        if ($scon(%ctr).NetworkOrServer) {
          %out = %out 7Currently not connected to:4 $v1 $+ .
        }
      }
      if (%out) { say 3* %out }
    }
  }
  elseif ($$1 == S) {
    while (%ctr < %tot) {
      inc %ctr

      var %out $null
      if ($scon(%ctr).status == connected) {
        %out = %out 7Connected To:4 $scon(%ctr).NetworkOrServer
        %out = %out 7As:4 $scon(%ctr).me $+ 
      }
      else {
        if ($scon(%ctr).NetworkOrServer) {
          %out = %out 7Currently not connected to:4 $v1 $+ .
        }
      }
      if (%out) { say 3* %out }
    }
  }
  elseif ($$1 == o) {
    while (%ctr < %tot) {
      inc %ctr

      var %out $null
      if ($scon(%ctr).status == connected) {
        %out = %out 7Connected To:4 $scon(%ctr).NetworkOrServer
        %out = %out 7As:4 $scon(%ctr).me $+ 
        if ($scon(%ctr).oline) && ($scon(%ctr).oline != Null) {
          %out = %out $+(8,$chr(40),7) $+ Oline Status:12 $scon(%ctr).oline $+ $+(8,$chr(41)))
        }
      }
      else {
        if ($scon(%ctr).NetworkOrServer) {
          %out = %out 7Currently not connected to:4 $v1 $+ .
        }
      }
      if (%out) { say 3* %out }
    }
  }
}

alias NetworkOrServer {
  var %NetOrSrv $network
  if (!%NetOrSrv) {
    %NetOrSrv = $server
  }
  return %NetOrSrv
}

alias -l chanz {
  var %channelcounter = 1
  while (%channelcounter <= $chan(0)) { 
    if (s isincs $chan(%channelcounter).mode) || (O isincs $chan(%channelcounter).mode) || (A isincs $chan(%channelcounter).mode) || (p isincs $chan(%channelcounter).mode) { inc %channelcounter 1 }
    else { var %channeltotal = %channeltotal $chan(%channelcounter) $+ $chr(32)) | inc %channelcounter 1 }
  }
  return %channeltotal
}

alias oline {
  if (!%oline [ $+ [ $network ] ]) { return Null }
  else { return %oline [ $+ [ $network ] ] }
}

;on *:CONNECT: {
;  .timer 1 5 whois $me
;}

;raw 313:*:{ set %oline [ $+ [ $network ] ] $5 $6 }
