::::::::::::::::::::::::::::::::::::::::::
:: Defcon Script                        ::
:: Version 1.0.0                        ::
:: Written by Zetacon.                  ::
:: This script is written for the Hooch ::
:: mIRC bot only.                       ::
:: All Rights Reserved.                 ::
::::::::::::::::::::::::::::::::::::::::::

on *:TEXT:!defcon *:#:{
  if ($nick isop $chan || $nick ishop $chan) {
    if ($3 == 5) { 
      mode $chan -m
      mode $chan -R
      mode $chan -i
      mode $chan -s
      msg $chan Channel has been returned to normal status. Have a nice day.
      HALT		  
    } 
    if ($3 == 4) {
      mode $chan +m
      msg $chan Channel set to DefCon 4. Voiced users may continue to chat until the current attack has subsided. 
      HALT
    }
    if ($3 == 3) {
      mode $chan +m
      mode $chan +R
      msg $chan Channel set to DefCon 3. Please do not attempt to change your nick. Voiced users may continue to chat until the current attack has subsided. 
      HALT
	}
    if ($3 == 2) {
      mode $chan +m
      mode $chan +R
      mode $chan +i
      msg $chan Channel set to DefCon 2. Due to the severity of the attack, we ask that you remain patient until the attack has subsided. Thanks for your understanding. 
      HALT
    }
    if ($3 == 1) {
      mode $chan +m
      mode $chan +R
      mode $chan +i
      mode $chan +s
      msg $chan Channel set to DefCon 1. Sorry folks. We hoped it didn't have to come to this.
      HALT
	}
  }
}