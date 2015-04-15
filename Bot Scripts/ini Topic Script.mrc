on *:TEXT:!*:#: {
  if ($nick isop $chan) {
    if ($1 == !update) {
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
    if ($1 == !topic) {
      if ($topini(update) == on) {
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
    if ($1 == !divider) {
      if ($topini(update) == on) {
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
    if ($1 == !owner) {
      if ($topini(update) == on) {
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
	if ($1 == !verb) {
      if ($topini(update) == on) {
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
    if ($1 == !status) {
      if ($topini(update) == on) {
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
    if ($1 == !static) {
      if ($topini(update) == on) {
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