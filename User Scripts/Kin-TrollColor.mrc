; Kin's Troll Color
; 2013-05-15
; For Hikki

; A simple script to add one selected nickname
; to mIRC's Address Book's Nick Colors
; to be colored by nickname, ident, and site

; 2013-05-15 v1.0 Requested script

; ---- User Commands

alias addtroll { Kin.TrollColor.Cmd Add $$1- }
alias deltroll { Kin.TrollColor.Cmd Remove $$1- }

; ---- Popup Menu

menu nicklist {
  Kin's Troll Color
  .ADDTROLL $1 - Begin coloring $1 as a troll:Kin.TrollColor.Cmd Add $$1
  .DELTROLL $1 - Remove troll coloring from $1:Kin.TrollColor.Cmd Remove $$1
  .-
  .Nickname -> $1:noop
  .$iif($ial($1,1).user,Ident -> $+(*!,$v1,@*)):noop
  .$iif($ial($1,1).host,Site -> $+(*!*@,$v1)):noop
  .-
  .Open mIRC Address Book to the Nick Colors List:abook -l
  .Select Color
  ..$submenu($Kin.TrollColor.Colors($1))
}

; ---- Default Colors

alias Kin.TrollColor.Color { return $iif(%Kin.TrollColor.Color,$v1,8) }

alias -l Kin.TrollColor.Colors {
  if ($1 isin begin end) { return }
  var %colors White Black Navy Hunter Red Maroon Magenta Orange Yellow Green Aqua Cyan Blue Purple Grey Ivory
  var %current $gettok(%colors,$1,32)
  if (%current) {
    return $iif($Kin.TrollColor.Color == $calc($1 - 1),$style(1)) %current $+ :Kin.TrollColor.Pick $calc($1 - 1)
  }
}

alias -l Kin.TrollColor.Pick {
  set %Kin.TrollColor.Color $$1
}

; ---- Aliases

alias -l Kin.TrollColor.Cmd {
  var %badd $true
  if ($1 == Remove) {
    %badd = $false
  }

  var %nick $$2
  var %ident $ial(%nick,1).user
  var %site $ial(%nick,1).host

  var %out
  if ($Kin.TrollColor.CNick(%badd,%nick)) {
    var %res = $v1
    %out = %out $iif(%badd == $true,Now coloring,Removed coloring from) %res
  }
  if (%ident) {
    if ($Kin.TrollColor.CNick(%badd,$+(*!,%ident,@*))) {
      %out = %out and $v1
    }
  }
  if (%site) {
    if ($Kin.TrollColor.CNick(%badd,$+(*!*@,%site))) {
      %out = %out and $v1
    }
  }

  if (%out) {
    echo -g (Kin-TrollColor) %out
  }
}

alias -l Kin.TrollColor.CNick {
  if ($1 == $true) {
    .cnick -ans1 $$2 $Kin.TrollColor.Color
  }
  else {
    .cnick -r $$2
  }
  return $+($chr(3),$Kin.TrollColor.Color,$$2,$chr(15))
}
