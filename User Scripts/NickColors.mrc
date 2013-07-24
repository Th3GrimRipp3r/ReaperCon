; ----------------------------------------------------------------
; Kin's Alternating Nick Colors
; Kin "Kinny" Kith
; #ReaperCon #mIRC #Script-Help #Bots - IRC.GeekShed.Net
; https://github.com/Th3GrimRipp3r/ReaperCon
; http://code.google.com/p/reapercon/
; 2012-03-23
; v1.8
; ----------------------------------------------------------------
; A stylizer to color nicknames in channel messages, assigning the
; same same color to the same nickname, and different colors for
; different users.
; ----------------------------------------------------------------
; Features
;  ) Enable / Disable
;  ) Select from 3 Methods:
;      -First 3 letters (Same color for: Kin, Kin|Away, Kin2)
;      -Last letter
;      -Hostmask (for nicks in the IAL after /who #channel)
;  ) Popup Menu for configuration
;  ) Generate an example list of all nicks in a channel with their
;      colors in a custom window
;  ) Warning for Theme or Style Script conflict
; ----------------------------------------------------------------
; Inspired from a request by supson in ##mIRC on freenode
; ----------------------------------------------------------------
; Note - Resolving Style Conflicts
;   Multiple style scripts each generate their own echo.
;   If you see duplicate messages or a style conflict warning:
;     a) Locate and disable the other theme or style script
;     b) Select "Order" from the "File" menu in Script Editor
;          to arrange script priority
;     c) Add this to other script events: if ($halted) { return }
; ----------------------------------------------------------------
; History
; ----------------------------------------------------------------
; 2013-07-24 v1.8 Add color to the nick in nicklist during event.
; 2013-07-23 v1.7 Included option to use $site during event,
;     instead of depending on the internal address list.
; 2013-07-23 v1.6 As noted by catalase in #ReaperCon on GeekShed:
;     The nick coloring is incompatible with native nick coloring
;     in the address book.  Added a fix to prioritize user 
;     assigned address book coloring before random colors.
; ----------------------------------------------------------------

; -------- PopUps ------------------------------------------------
menu status,channel {
  $iif($group(#Kin.NickColors).status == on,$style(1)) Kin's Nick Colors is $iif($group(#Kin.NickColors).status == on,Enabled.,Disabled.)
  .Turn $iif($group(#Kin.NickColors).status == on,Off,On): $iif($group(#Kin.NickColors).status == on,.disable,.enable) #Kin.NickColors
  .$iif(%Kin.NickColors.StyleConflict,Multiple style scripts detected - Styling disabled.):unset %Kin.NickColors.StyleConflict
  .-
  .$iif(((%Kin.NickColors.Type != 2) && ($v1 != 3) && ($v1 != 4)),$style(1)) Color by Nickname's first 3 letters:set %Kin.NickColors.Type 1
  .$iif(%Kin.NickColors.Type == 2,$style(1)) Color by Nickname's last letter:set %Kin.NickColors.Type 2
  .$iif(%Kin.NickColors.Type == 3,$style(1)) Color by Hostmask:set %Kin.NickColors.Type 3
  .$iif(%Kin.NickColors.Type == 4,$style(1)) Color by Site:set %Kin.NickColors.Type 4
  .-
  .$iif($menutype == channel,See the colors of all nicknames in #):ColorNicknames #
}

; -------- Events ------------------------------------------------
#Kin.NickColors off

on ^*:TEXT:*:#: { Kin.NickColors.Event normal $1- | HALTDEF }
on ^*:ACTION:*:#: { Kin.NickColors.Event action $1- | HALTDEF }

alias -l Kin.NickColors.Event {
  if ($halted) { set -e %Kin.NickColors.StyleConflict $true | return }
  var %color $cnick($nick($chan,$nick).pnick).color
  if (!%color) { %color = $ColorFromNick($nick,$site) }
  var %nickstyled 
  if ($1 == normal) {
    %nickstyled = $+($chr(3),%color,<,$left($nick($chan,$nick,a,r).pnick,1),$nick,>,$chr(15))
  }
  else {
    %nickstyled = * $+($chr(3),%color,$nick,$chr(15))
  }
  !echo $color($1) -tbflm $chan %nickstyled $2-
  cline -lm %color $chan $nick($chan,$nick)
}

#Kin.NickColors end

; -------- Coloring Aliases --------------------------------------
alias -l ColorFromNick {
  ; ---- Chooses between coloring methods
  if (%Kin.NickColors.Type == 2) { return $ColorFromNick.LastLetter($1) }
  elseif (%Kin.NickColors.Type == 3) { return $ColorFromNick.Hostmask($1) }
  elseif (%Kin.NickColors.Type == 4) { $iif($2,return $ColorFromSite($2),return $ColorFromNick.Hostmask($1)) }
  else { return $ColorFromNick.First3($1) }
}

; -------- Example Alias -----------------------------------------
alias ColorNicknames {
  ; Parameter: #Channel
  ; Colors each nickname of the specified channel in a custom window, and lists the used color values of the entire population.
  ; Used to test color variety between nick color methods
  if ($me !ison $1) { return }
  if (!$window(@NickColors)) { /window -ne2 @NickColors }
  var %chan $1, %ix $nick(%chan,0), %nums, %colornum, %nick, %addressbooknum
  !echo @NickColors Coloring %ix nicknames from channel %chan using method $iif(%Kin.NickColors.Type,$v1,1)
  while (%ix) {
    %nick = $nick(%chan,%ix)
    %colornum = $ColorFromNick(%nick)
    %addressbooknum = $cnick($nick($1,%nick).pnick).color
    !echo @NickColors $+($chr(3),%colornum,<,%nick,>,$chr(15)) number %colornum $iif(%addressbooknum,..but is found in address book so colored as $+($chr(3),%addressbooknum,<,%nick,>,$chr(15)))
    %nums = $addtok(%nums, %colornum,44)
    dec %ix
  }
  !echo @NickColors Color values used: $sorttok(%nums,44,n)
}

; -------- Coloring Methods --------------------------------------
alias -l ColorFromNick.First3 {
  ; Parameter: Nickname
  ; Returns: Integer 2-12
  ; Method: Hash of first 3 letters of nickname
  var %nick $1, %nick3 $left(%nick,3), %nick2 $right(%nick3,2), %hash3 $hash($md5(%nick3),3), %hash2 $hash($md5(%nick2),2), %hash4 $hash($md5(%nick3),4)
  var %colornum $calc(%hash3 + %hash2 + 2)
  return %colornum
}
alias -l ColorFromNick.LastLetter {
  ; Parameter: Nickname
  ; Returns: Integer 2-14
  ; Method: Mapped to last letter of nickname
  var %nick $1
  return $calc($iif(($int($calc(($asc($lower($right(%nick,1))) - 97) / 2)) >= 0) && ($v1 < 12),$v1,12) + 2)
}
alias -l ColorFromNick.Hostmask {
  ; Parameter: Nickname
  ; Returns: Integer 2-12,13
  ; Method: Hash of the full site hostmask, or 13 if the nick's mask is not populated in the IAL
  var %site $remove($address($1,2),*!*@)
  if (!%site) { return 13 }
  var %hash3 $hash($md5(%site),3), %hash2 $hash($md5(%site),2)
  var %colornum $calc(%hash3 + %hash2 + 2)
  return %colornum
}
alias -l ColorFromSite {
  ; Parameter: Site
  ; Returns: Integer 2-12
  ; Method: Hash of the full site hostmask
  var %site $1
  if (!%site) { return 13 }
  var %hash3 $hash($md5(%site),3), %hash2 $hash($md5(%site),2)
  var %colornum $calc(%hash3 + %hash2 + 2)
  return %colornum
}
