; Kin's Multi-Channel Message Window
; For matthijs186 #Script-Help irc.geekshed.net

; 2013-11-02 v1.4 Permit /me action messages
; 2013-11-02 v1.3 Update side-list with new channels on join
; 2013-11-02 v1.1 Add multi-channel messaging
; 2013-11-02 v1.0 Populate custom window side-list with channels

; Creates a Desktop Style Custom Window
; populated with all joined channels in the side list box
; Text typed into the edit box is sent
; to 1 channel selected in side list

; Usage:
;     /Kin.MultiChanMsg

; Configuration --------------------------------

alias Kin.MultiChanMsg.WindowFont { return Trebuchet MS 13 }
alias Kin.MultiChanMsg.WindowType { return -Sl15e2 }
; alias Kin.MultiChanMsg.WindowType { return -Sdl15e0k0 }

alias Kin.MultiChanMsg.WindowName {
  return @Kin.MultiChanMsg. $+ $iif($network,$network,$server)
}

; Aliases --------------------------------

alias Kin.MultiChanMsg {
  Kin.MultiChanMsg.StartWindow
}

alias -l Kin.MultiChanMsg.StartWindow {
  if (!$window($Kin.MultiChanMsg.WindowName)) {
    window $Kin.MultiChanMsg.WindowType $Kin.MultiChanMsg.WindowName $Kin.MultiChanMsg.WindowFont
    Kin.MultiChanMsg.PopluateChannels $Kin.MultiChanMsg.WindowName
  }
}

alias -l AddToCustomWindowSideList { aline -l $1 $2 }

alias Kin.MultiChanMsg.PopluateChannels {
  var %window $1
  clear -l %window
  noop $regsubex(Kin.MultiChanMsg,$str(.,$chan(0)),/./g,$AddToCustomWindowSideList(%window,$chan(\n)))
}

; Events --------------------------------

on *:START: { Kin.MultiChanMsg.StartWindow }

on *:INPUT:@: {
  if ($active != $Kin.MultiChanMsg.WindowName) { return }
  if ($left($1,1) == /) && ($1 != /me) { return }

  var %selchan $sline($Kin.MultiChanMsg.WindowName,1)
  if (%selchan) && ($me ison %selchan) {
    if ($1 == /me) && ($2) {
      !echo $color(own) -t $Kin.MultiChanMsg.WindowName %selchan * $me $2-
      !describe %selchan $2-
    }
    else {
      !echo $color(own) -t $Kin.MultiChanMsg.WindowName %selchan $+(<,$left($nick(%selchan,$me,a,r).pnick,1),$me,>) $1-
      !msg %selchan $1-
    }
  }
  else {
    var %errmsg [Message not sent
    if (!%selchan) { %errmsg = %errmsg - No channel selected] }
    else { %errmsg = %errmsg - Not joined to selected channel] %selchan }
    !echo -t $Kin.MultiChanMsg.WindowName %errmsg %selchan $1-
  }
}

on *:JOIN:#: {
  if ($nick != $me) { return }
  Kin.MultiChanMsg.StartWindow
  if ($fline($Kin.MultiChanMsg.WindowName,$chan,0,1) > 0) { return }
  var %lastsel $sline($Kin.MultiChanMsg.WindowName,1)
  aline -l $Kin.MultiChanMsg.WindowName $chan
  if (%lastsel) {
    var %newsel $fline($Kin.MultiChanMsg.WindowName,%lastsel,1,1)
    if (%newsel > 0) {
      sline -l %newsel
    }
  }
}
on *:PART:#: {
  if ($nick != $me) { return }
  if (!$window($Kin.MultiChanMsg.WindowName)) { return }
  var %removeline $fline($Kin.MultiChanMsg.WindowName,$chan,1,1)
  if (%removeline > 0) {
    dline -l $Kin.MultiChanMsg.WindowName %removeline
  }
}

on *:QUIT: {
  if ($nick != $me) { return }
  if (!$window($Kin.MultiChanMsg.WindowName)) { return }
  clear -l $Kin.MultiChanMsg.WindowName
}
