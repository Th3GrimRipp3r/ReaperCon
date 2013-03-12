on *:TEXT:*:#:{
  if ($1 == !Ping) || ($1 == !Time) || ($1 == !Version) {
    if (%master.switch == off) { HALT }
    if (%master.switch == on) {
      if (% [ $+ [ $chan ] $+ ] .ctcp.switch == off) { HALT }
      if (% [ $+ [ $chan ] $+ ] .ctcp.switch == on) { 
        if (!$2) {
          set %ctcp.chan $chan
          set %ctcp.nick $nick
          set %ctcp.cmd $remove($1,!)
          ctcp %ctcp.nick %ctcp.cmd
        }
        else {
          set %ctcp.chan $chan
          set %ctcp.nick $2
          set %ctcp.cmd $remove($1,!)
          ctcp %ctcp.nick %ctcp.cmd
        }
      }
    }
  }
}

on *:CTCPREPLY:$($+(%ctcp.cmd,*)):{
  if (%master.switch == off) { HALT }
  if (%master.switch == on) {
    if (% [ $+ [ $chan ] $+ ] .ctcp.switch == off) { HALT }
    if (% [ $+ [ $chan ] $+ ] .ctcp.switch == on) {
      if ($nick == %ctcp.nick) {
        if (%ctcp.cmd == Ping) { msg %ctcp.chan %ctcp.nick $+ 's ping reply is: $+($duration($calc($ctime - $2-)),.) }
        if (%ctcp.cmd == Time) { msg %ctcp.chan It is $2- at the place where %ctcp.nick lives. }
        if (%ctcp.cmd == Version) { msg %ctcp.chan %ctcp.nick is using: $+($2-,.) }
      }
    }
  }  
  unset %ctcp.*
}
