; Work In Progress

; ----------------------------------------------------------------
; Tab Fail Fix - Advanced Tab Complete
; KinKinnyKith - Kin "Kinny" Kith
; #ReaperCon #mIRC #Script-Help #Bots - IRC.GeekShed.Net
; Hosted at http://reapercon.googlecode.com
; 2011-02-18
; v2.2 Debug Version
; ----------------------------------------------------------------
; "Tab fail" occurs when there is more than one nickname matching the user's input for autocompletion,
; and a chatter expects a recently active nickname in the channel to match,
; but tab complete matches to another nickname higher in the nicklist order.
;
; mIRC's tab complete selects matching nicknames in the order of $nick(#,num)
; which sorts by nickname prefix first, then alphabetically.
;
; "Tab Fail Fix" looks for a matching nickname on the active channel window,
; and halts the default tab complete if it differs from mIRC's first suggestion,
; but permits the usual tab complete function thereafter, if the user doesn't like our first suggestion.
;
; Note: This script has no effect if the "Tab key changes editbox focus" option is enabled.
; ----------------------------------------------------------------
; Features:
;  ) Overrides the first tabcomp suggestion with a matching nickname that appears on the channel window
;  ) Suggests once, then permits normal cycling of tabcomp suggestions, until message input or another word is tabcompleted
; ----------------------------------------------------------------
; To-Do
;  ) Bug: %strRight is pulling in too much whitespace when there is trailing text on a tab complete
;  ) Extra (repeated) whitespace is not preserved with /editbox
;      Whitepsace could be properly handled with a &binvar, but ultimately
;      we would lose that whitespace when overriding suggestions to /editbox 
;      An improvement would be to strip repeated whitespace, and handle the editbox text as a tokenized string
;      instead of managing cursor position
;  ) Extra whitespace throws off the word suggestion
;  ) Add an in-channel warning if a suggestion is overrided, or separate option to warn only without tabcomp override
; ----------------------------------------------------------------

; -------- Debug Reporting ---------------------------------------
alias -l TabComp.Debug { return | TabComp.Report $1- }
alias -l TabComp.Report { if (!$window(@TabComp)) { /window -ne2 @TabComp | /log on @TabComp -f \logs\ $+ @TabComp $+ .log } | !echo @TabComp $timestamp TabComp: $1- }
; ---- PopUps ----------------------------------------------------
menu status,channel {
  $iif($group(#Kin.TabComp).status == on,$style(1)) Kin's Tab Complete Fix v2.2 is $iif($group(#Kin.TabComp).status == on,Enabled.,Disabled.)
  .Turn $iif($group(#Kin.TabComp).status == on,Off,On) : TabComp.Toggle
}
alias -l TabComp.Toggle {
  if ($group(#Kin.TabComp).status == on) { TabComp.Debug Disabled | unset %TabComp.Pattern | unset %TabComp.Fixing | TabComp.Clear | .disable #Kin.TabComp }
  else { .enable #Kin.TabComp | TabComp.Debug Enabled }
}
#Kin.TabComp off
; ---- Tab Complete ----------------------------------------------
on ^*:TABCOMP:#: {
  var %window $target, %mircline $1-, %editboxline $editbox(%window,0), %cursorpos $calc($editbox(%window).selstart - 1), %inputlen $len(%editboxline)
  TabComp.Debug Cursor: %cursorpos Edit: %editboxline mIRC: %mircline L: $len($editbox(%window,0)) LA: $len(%editboxline) MA: $len(%mircline)

  ; ---- Strip repeat spaces to test for difference
  ; Compensate for whitespace differences in the tokenized input, the current editbox text, and what we will output with editbox (which strips spaces)
  var %oldlen = $len(%editboxline)
  %editboxline = $regsubex(%editboxline,/\s+/g,$chr(32))
  var %newlen = $len(%editboxline)
  %cursorpos = $calc(%cursorpos - (%oldlen - %newlen))
  if (%mircline == %editboxline) { return }

  ; ---- Find word being completed
  var %l %cursorpos, %r %cursorpos
  inc %r
  while (%l > 0) {
    ; Find left word bound
    if ($mid(%editboxline,%l,1) == $chr(32)) { inc %l | break }
    dec %l
  }
  while (%r <= %inputlen) {
    ; Find right word bound
    if ($mid(%editboxline,%r,1) == $chr(32)) { break }
    inc %r
  }
  ; Split message
  var %strLeft $iif(%l > 0,$mid(%editboxline,1,$calc(%l - 1))), %strWord $mid(%editboxline,%l,$calc(%r - %l)), %strRight $iif(%r < %inputlen,$mid(%editboxline,%r,$calc(%inputlen - %r + 1)))
  TabComp.Debug TabComp: L: %l R: %r Len: %inputlen Left: $len(%strLeft) %strLeft Word: $len(%strWord) %strWord Right: $len(%strRight) %strRight

  ; ---- If word is a channel, identifier, or variable, do nothing
  if ($left(%strWord,1) isin #&$%) { return }

  ; ---- If we already made our first suggestion to fix tab fail, do nothing (alternatively, continue making suggestions)
  if (%TabComp.Fixing iswm %strWord) { return }
  else { unset %TabComp.Fixing }

  ; ---- Is the word a nickname on the channel
  %strWord = %strWord $+ $chr(42)
  var %n 0, %x $nick(%window,0), %nickz
  while (%x) {
    if (%strWord iswm $nick(%window,%x)) {
      %nickz = $addtok(%nickz,$v2,32)
      inc %n 
    }
    dec %x
  }

  ; ---- Is there more than one possible nickname on the channel
  if (%n < 2) { return }
  TabComp.Debug Possible nick matches: %nickz
  %nickz = $replace(%nickz,$chr(124),\ $+ $chr(124))
  TabComp.Debug Nick Pattern: $replace(%nickz,$chr(32),$chr(124))

  ; ---- Limit Lines to look back in the Channel Window
  var %wndlines $line(%window,0), %startline, %range
  if (%wndlines > 40) { 
    %startline = $calc(%wndlines - 40)
    %range = %startline $+ - $+ %wndlines 
  }

  ; ---- Find Nick Mentions in Channel Window
  TabComp.Clear 
  ;set -e %TabComp.Pattern /\b( $+ $replace(%strWord,$chr(42),\S+) $+ )\b/Si
  set -e %TabComp.Pattern /\b( $+ $replace(%nickz,$chr(32),$chr(124)) $+ )\b/Si
  /filter $iif(%range,-bgkr,-bgk) $iif(%range,$v1) %window TabCompNickSearch %TabComp.Pattern
  unset %TabComp.Pattern

  ; ---- Process Matches
  var %matches $TabComp.Count Matches, %lastnick $TabComp.Pop
  TabComp.Debug Found %matches Matches
  TabComp.Debug Last was %lastnick $len(%lastnick)
  if (%matches < 1) { return }

  ; ---- Editbox
  set -e %TabComp.Fixing %strWord
  var %editnick %strLeft %lastnick, %editpos $len(%editnick)
  inc %editpos
  if (!%strRight) { %editpos = 0 }
  TabComp.Debug editbox $+(-b,%editpos,e,%editpos) %window %editnick %strRight
  %editnick = %editnick %strRight
  TabComp.Debug mirc: $len($1-) $1- suggest: $len(%editnick) $replace(%editnick,$chr(32),x) $iif($left(%editnick,1) == $chr(32),space) R: $left(%editnick,1)
  if (%editnick != $1-) {
    TabComp.Report Overriding nick completion to %lastnick out of possible %nickz due to recent channel match
    editbox $+(-b,%editpos,e,%editpos) %window %editnick
    TabComp.Clear   
    halt
  }
  else { TabComp.Debug Nick completition not overrided, same suggestion }
}
alias TabCompNickSearch { if ($regex($1-,%TabComp.Pattern)) { TabComp.Push $regml(1) | TabComp.Debug Found Match: $regml(1) | TabComp.Debug Matched Line: $1- } }
; -------- Cleanup Events ----------------------------------------
on *:input:#: { if (%TabComp.Fixing) { unset %TabComp.Fixing | TabComp.Debug Sent Message - Clear | TabComp.Clear } }
on *:active:#: { if (%TabComp.Fixing) { unset %TabComp.Fixing | TabComp.Debug Switched Channel - Clear | TabComp.Clear } }
;on *:disconnect: { if (%TabComp.Fixing) { unset %TabComp.Fixing | TabComp.Debug Disconnected - Clear | TabComp.Clear } }
; -------- Hash Stack --------------------------------------------
alias -l TabComp.Clear { if ($hget(TC)) { hfree TC } }
alias -l TabComp.Make { if (!$hget(TC)) { hmake TC 8 | hadd TC Element 0 } }
alias -l TabComp.Count { if ($hget(TC)) { return $hget(TC,Element) } }
alias -l TabComp.Push { TabComp.Make | var %el $hget(TC,Element) | inc %el | hadd TC Element %el | hadd TC $+(n,%el) $1 | TabComp.Debug Pushed $1 }
alias -l TabComp.Pop { if ($hget(TC)) { var %el $hget(TC,Element) | var %dat $hget(TC,$+(n,%el)) | if (%dat > 0) { dec %el | hadd TC Element %el | TabComp.Debug Popped %dat | return %dat } } }
#Kin.TabComp end

