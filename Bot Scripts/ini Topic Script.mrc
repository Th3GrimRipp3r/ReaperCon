on $*:TEXT:/^\.(update|topic|divider|owner|verb|status|static|prepend)( |$)/Si:#: {
  if ($nick !isop $chan) { return }

  var %item $regml(1)

  if (%item == update) {
    if ($2 != on) && ($2 != off) {
      msg $chan Please select whether you'd like to update all networks or single networks, !update on/off.
    }
    else {
      writeini -n Topics.ini $chan %item $2
      msg $chan I will $iif($2 == on,now,not) update all channel topics.
    }
    return
  }

  if (%item == prepend) {
    if (!$istok(on|off|custom,$2,124)) {
      msg $chan Please select whether you'd like to have the Prepend "Topic:" on or off, !prepend on/off/custom.
    }
    elseif ($2 == on) {
      writeini -n Topics.ini $chan %item Topic:
    }
    elseif ($2 == off) {
      remini Topics.ini $chan %item
    }
    elseif ($2 == custom) {
      if (!$3) { msg $chan Please enter a custom Prepend you would like to use.. !prepend custom <custom prepend>. }
      else {
        writeini -n Topics.ini $chan %item $3-
      }
    }
  }

  ; The remaining commands update one of the items in topics.ini
  if ($istok(topic|divider|owner|verb|status|static,%item,124)) {
    writeini -n Topics.ini $chan %item $2-
  }

  var %update $false
  if ($ini(Topics.ini,$chan,update)) && ($readini(Topics.ini,$chan,update) == on) {
    %update = $true
  }

  var %cmd topic $chan
  ; If update for all networks is "on", send the /topic to all connected networks, instead of just this one network
  if (%update == $true) {
    %cmd = scon -at1 %cmd
  }

  ; Perform the topic command
  %cmd $topini(prepend) $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
}

alias -l topini {
  return $readini(Topics.ini,n,$chan,$1)
}
