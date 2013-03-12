alias away {
  if (!$1) { echo -a Invalid Command. Please try again. | HALT }
  if ($1 == back) {
    echo -a Returned from away.
    unset %away
  }
  else {
    set %away $1-
    echo -a Away Message set to: " $+ $1- $+ ".
  }
}

on *:TEXT:$(* $+ $me $+ *):#:{
  if ($network == GeekShed) {
    if ($chan == #duncsweb-ops) {
      msg $chan Sorry $nick $+ , I am currently away or unavailable. Reason: %away $+ . Please PM me and I will get back to you when I return.
    }
    if ($chan == #Hooch) {
      msg $chan Sorry $nick $+ , I am currently away or unavailable. Reason: %away $+ . Need help with Hooch? Please address your question to this channel and someone will be with you shortly.
    } 
    if ($chan == #Zetacon) {
      msg $chan Sorry $nick $+ , I am currently away or unavailable. Reason: %away $+ . Need help with Hooch? Please join #Hooch and a staff member will be with you shortly.
    }
    else {
      HALT
    }
  }
}
