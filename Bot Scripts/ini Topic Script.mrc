on $*:TEXT:^/!(update|topic|divider|owner|verb|status|static)( |$)/Si:#: {
  if ($nick isop $chan) {
    if ($regml(1) == update) {
      if ($2 != on) || ($2 != off) { msg $chan Please select whether you'd like to update all networks or single networks, !update on/off }
      else {
        if (!$ini(Topics.ini,$chan,update)) {
          writeini Topics.ini $chan update $2
          msg $chan I will $iif($2 == on,now,not) update all channel topics.
        }
        else {
          writeini -n Topics.ini $chan update $2
          msg $chan I will $iif($2 == on,now,not) update all channel topics.
        }  
      }
    }
    if ($regml(1) == topic) {
      if ($readini(Topics.ini,$chan,update) == on) {
        if (!$ini(Topics.ini,$chan,topic)) {
          writeini Topics.ini $chan topic $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan topic $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
      else {
        if (!$ini(Topics.ini,$chan,topic)) {
          writeini Topics.ini $chan topic $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan topic $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
    }
    if ($regml(1) == divider) {
      if ($readini(Topics.ini,$chan,update) == on) {
        if (!$ini(Topics.ini,$chan,divider)) {
          writeini Topics.ini $chan divider $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan divider $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
      else {
        if (!$ini(Topics.ini,$chan,divider)) {
          writeini Topics.ini $chan divider $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan divider $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
    }
    if ($regml(1) == owner) {
      if ($readini(Topics.ini,$chan,update) == on) {
        if (!$ini(Topics.ini,$chan,owner)) {
          writeini Topics.ini $chan owner $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan owner $2-
          scon -a topic $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
      else {
        if (!$ini(Topics.ini,$chan,owner)) {
          writeini Topics.ini $chan owner $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan owner $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
    }
    if ($regml(1) == verb) {
      if ($readini(Topics.ini,$chan,update) == on) {
        if (!$ini(Topics.ini,$chan,verb)) {
          writeini Topics.ini $chan verb $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan verb $2-
          scon -a topic $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
      else {
        if (!$ini(Topics.ini,$chan,verb)) {
          writeini Topics.ini $chan verb $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan verb $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
    }
    if ($regml(1) == status) {
      if ($readini(Topics.ini,$chan,update) == on) {
        if (!$ini(Topics.ini,$chan,status)) {
          writeini Topics.ini $chan status $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan status $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
      else {
        if (!$ini(Topics.ini,$chan,status)) {
          writeini Topics.ini $chan status $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan status $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
    }
    if ($regml(1) == static) {
      if ($readini(Topics.ini,$chan,update) == on) {
        if (!$ini(Topics.ini,$chan,static)) {
          writeini Topics.ini $chan static $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan static $2-
          scon -a topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
      else {
        if (!$ini(Topics.ini,$chan,static)) {
          writeini Topics.ini $chan static $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
        else {
          writeini -n Topics.ini $chan static $2-
          topic $chan $topini(topic) $topini(divider) $topini(owner) $topini(verb) $topini(status) $topini(divider) $topini(static)
        }
      }
    }
  }
}
alias -l topini {
  return $readini(Topics.ini,$chan,$1)
}