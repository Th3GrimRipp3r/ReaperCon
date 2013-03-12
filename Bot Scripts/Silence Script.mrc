on $*:TEXT:/^[+-@](sil|mute)( |$)/iS:#: { 
  if ($nick isop $chan) || ($nick ishop $chan) {
    if ($left($1,1) == +) { 
      if ($istok(%silchans,$2,44)) { msg $chan $2 is already listed in the Silence Chan list.. | HALT }
      else {
        set %silchans $addtok(%silchans,$2,44)
        msg $chan $2 has been added to the Silence Chan list. 
      }
    }
    if ($left($1,1) == -) {
      if (!$istok(%silchans,$2,44)) { msg $chan $2 is not listed in the Silence Chan list.. | HALT }
      else {
        set %silchans $remtok(%silchans,$2,44)
        msg $chan $2 has been removed from the Silence Chan list.
      }
    }
    if ($left($1,1) == @) {
      if ($istok(%silchans,$chan,44)) {
        if ($me isop $chan) || ($me ishop $chan) {
          if (!$2) { msg $chan Please select a nick.. }
          elseif (!$3) { modecheck1 $$2 # }
          else { 
            modecheck2 $$2 # $$3
            msg # $$2 $+ , You have been silenced for $$3 $iif($$3 == 1,minute.,minutes.)
          }
        }
        else { .notice $nick I can't complete the task, as I currently do not have Halfop/Op status. }
      }
    }
  }
}
alias -l modecheck1 {
  if ($left($nick(#,$1).pnick,1) == ~) { mode $$2 -qov+b $str($+($$1,$chr(32)),3) $+(~q:,$address($$1,2)) }
  elseif ($left($nick(#,$1).pnick,1) == &) { mode $$2 -aov+b $str($+($$1,$chr(32)),3) $+(~q:,$address($$1,2)) }
  elseif ($left($nick(#,$1).pnick,1) == @) { mode $$2 -ov+b $str($+($$1,$chr(32)),2) $+(~q:,$address($$1,2)) }
  elseif ($left($nick(#,$1).pnick,1) == %) { mode $$2 -hv+b $str($+($$1,$chr(32)),2) $+(~q:,$address($$1,2)) }
  elseif ($left($nick(#,$1).pnick,1) == +) { mode $$2 -v+b $$1 $+(~q:,$address($$1,2)) }
  elseif (!$istok(~|&|@|%|+,$left($nick(#,$$1).pnick,1),124)) { mode $$2 +b $+(~q:,$address($$1,2)) }
}
alias -l modecheck2 {
  if ($left($nick(#,$1).pnick,1) == ~) { mode $$2 -qov+b $str($+($$1,$chr(32)),3) $+(~q:,$address($$1,2)) | .timer 1 $calc($$3 * 60) mode $$2 +qov-b $str($+($$1,$chr(32)),3) $+(~q:,$address($$1,2)) }
  elseif ($left($nick(#,$1).pnick,1) == &) { mode $$2 -aov+b $str($+($$1,$chr(32)),3) $+(~q:,$address($$1,2)) | .timer 1 $calc($$3 *60) mode $$2 +aov-b $str($+($$1,$chr(32)),3) $+(~q:,$address($$1,2)) }
  elseif ($left($nick(#,$1).pnick,1) == @) { mode $$2 -ov+b $str($+($$1,$chr(32)),2) $+(~q:,$address($$1,2)) | .timer 1 $calc($$3 * 60) mode $$2 +ov-b $str($+($$1,$chr(32)),2) $+(~q:,$address($$1,2)) }
  elseif ($left($nick(#,$1).pnick,1) == %) { mode $$2 -hv+b $str($+($$1,$chr(32)),2) $+(~q:,$address($$1,2)) | .timer 1 $calc($$3 * 60) mode $$2 +hv-b $str($+($$1,$chr(32)),2) $+(~q:,$address($$1,2)) }
  elseif ($left($nick(#,$1).pnick,1) == +) { mode $$2 -v+b $$1 $+(~q:,$address($$1,2)) | .timer 1 $calc($$3 * 60) mode $$2 +v-b $$1 $+(~q:,$address($$1,2)) }
  elseif (!$istok(~|&|@|%|+,$left($nick(#,$$1).pnick,1),124)) { mode $$2 +b $+(~q:,$address($$1,2)) | .timer 1 $calc($$3 * 60) mode $$2 -b $+(~q:,$address($$1,2)) }
}
