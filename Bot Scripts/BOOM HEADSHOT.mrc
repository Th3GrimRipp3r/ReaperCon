::::::::::::::::::::::::::::::::::::
:: BOOM HEADSHOT                  ::
:: By GrimReaper/Danneh & Zetacon ::
:: Rather useless, just something ::
:: to pass time.                  ::
:: All Rights Reserved            ::
::::::::::::::::::::::::::::::::::::

on *:TEXT:!headshot*:#:{
  if (!$2) {
    var %headnick = $nick
  }
  else {
    var %headnick = $2-
  }
  var %headshot = $rand(1,2)
  if (%headshot == 1) {
    .timer 1 1 describe $chan loads a turret into a bazooka.
    .timer 1 4 describe $chan aims the bazooka at $+(%headnick,.)
    .timer 1 8 kick $chan %headnick BOOM HEADSHOT!
  }
  if (%headshot == 2) {
    .timer 1 1 describe $chan loads up a sawnoff shotgun.
    .timer 1 4 describe $chan aims the shotgun at $+(%headnick,.)
    .timer 1 8 msg $chan Darn, The shotgun appears to be jammed, %headnick got lucky this time..
  }
}
