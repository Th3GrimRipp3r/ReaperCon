
; TomCoyoteWilson aka Coyote` of Geekshed IRC 
; #IamAddictedToIrc on irc.geekshed.net
; Bans one nick/host in multiple rooms:
; whether they have just left or are still on

; Syntax: banner <nickname>
; Syntax: debanner <nickname>
; SET Your channels up in the next section
; it is set for 4 channels, if you don't need
; 4, remark out what you don't need with a ;
; make sure you do likewise throughout the script
; if you need more rooms, follow the same pattern
on *:start: {
  set -e %banchan1 #channel1
  set -e %banchan2 #channel2
  set -e %banchan3 #channel3
  set -e %banchan4 #channel4
}
alias banner {
  wwb $1
  .timer 1 4 wib $1
}
alias wwb {
  set %whowas.chan $chan
  set %whowas.nick $1
  enable #wwb
  whowas $1
}

alias wib {
  set %whowas.chan $chan
  set %whowas.nick $1
  enable #wwb
  whois $1
}

#wwb off
raw 311:*:{
  if ($2 == %whowas.nick) {
    mode %banchan1 +b *!*@ $+ $4
    mode %banchan2 +b *!*@ $+ $4
    mode %banchan3 +b *!*@ $+ $4
    mode %banchan4 +b *!*@ $+ $4
    unset %whowas.*
    disable #wwb
  }
}

raw 318:*:{
  disable #wwb
}

raw 314:*:{
  if ($2 == %whowas.nick) {
    mode %banchan1 +b *!*@ $+ $4
    mode %banchan2 +b *!*@ $+ $4
    mode %banchan3 +b *!*@ $+ $4
    mode %banchan4 +b *!*@ $+ $4
    disable #wwb
  }
}

raw 369:*:{
  disable #wwb
}
#wwb end
###############################################
alias debanner {
  dewwb $1
  .timer 1 4 dewib $1
}
alias dewwb {
  set %whowas.chan $chan
  set %whowas.nick $1
  enable #dewwb
  whowas $1
}

alias dewib {
  set %whowas.chan $chan
  set %whowas.nick $1
  enable #dewwb
  whois $1
}

#dewwb off
raw 311:*:{
  if ($2 == %whowas.nick) {
    mode %banchan1 -b *!*@ $+ $4
    mode %banchan2 -b *!*@ $+ $4
    mode %banchan3 -b *!*@ $+ $4
    mode %banchan4 -b *!*@ $+ $4
    unset %whowas.*
    disable #dewwb
  }
}

raw 318:*:{
  disable #dewwb
}

raw 314:*:{
  if ($2 == %whowas.nick) {
    mode %banchan1 -b *!*@ $+ $4
    mode %banchan2 -b *!*@ $+ $4
    mode %banchan3 -b *!*@ $+ $4
    mode %banchan4 -b *!*@ $+ $4
    disable #dewwb
  }
}

raw 369:*:{
  disable #dewwb
}
#dewwb end
