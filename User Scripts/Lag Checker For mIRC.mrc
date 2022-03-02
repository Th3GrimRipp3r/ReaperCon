menu * {
  -
  Lag Checker
  .Check Lag Now:ping $ticks $+ :-9
  .Auto-Check Lag 3/33:.timerLag $+ $cid 0 33 ping $!ticks $!+ :3
  .Auto-Check Lag 9/99:.timerLag $+ $cid 0 99 ping $!ticks $!+ :9
  .Auto-Check Lag Off:.timerLag $+ $cid off
  .All Auto-Check Lag Off:.timerLag* off
  .-
}

on *:CONNECT:.timerLag $+ $cid 0 55 ping $!ticks

on ^*:PONG:{
  haltdef
  var %x = $gettok($2,2,58)
  var %Lag = $round($calc(($ticks - $gettok($2,1,58)) /1000),2)
  if !%x { %x = 5 }
  if %Lag > %x {
    beep 3
    return $tip(Lag,$me - $network,Lag %LaG seconds,9)
  }
}
