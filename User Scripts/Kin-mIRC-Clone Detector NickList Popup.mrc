; Kin's Clone List and Clone Detector for Nick List Popup Menu
; Hosted at https://github.com/Th3GrimRipp3r/ReaperCon
; Requires mIRC v7.x or greater
; For help, support, and customization, visit:
; irc.GeekShed.net #ReaperCon

; ---- Popup Usage
; Right-click any nickname to test for clones.
; If the nickname's host has more than one connection known to your client
; the nicklist popup will display a list of all clone nicks, i.e.:
;     Kin has 3 CLONES Kin Kinny Kith
; Selecting the clone list from the popup menu will copy the list of all
; clone nicks and idents to the clipboard, in the format:
;     Clones of <Kin> from @Kin.vhost [3] Kin!Kin Kinny!Kinny Kith!Kith

; ---- Identifier Usage
; Returns $null if there are no clones, or no matching host.
; Echo the list of clones by hostmask:
;    /echo -ag $Kin.CloneList(Kin.vhost)       ;-> Kin Kinny Kith
;    /echo -ag $Kin.CloneList(Kin.vhost,ident) ;-> Kin!Kin Kinny!Kinny Kith!Kith
;    /echo -ag $Kin.CloneList(Kin.vhost,full)  ;-> Kin!Kin@Kin.vhost Kinny!Kinny@Kin.vhost Kith!Kith@Kin.vhost
; Echo the list of clones by nickname:
;    /echo -ag $Kin.CloneListByNick(Kin)       ;-> Kin Kinny Kith
;    /echo -ag $Kin.CloneListByNick(Kin,ident) ;-> Kin!Kin Kinny!Kinny Kith!Kith
;    /echo -ag $Kin.CloneListByNick(Kin,full)  ;-> Kin!Kin@Kin.vhost Kinny!Kinny@Kin.vhost Kith!Kith@Kin.vhost
; Check a nick for clone nicknames, and echo the result:
;    /echo -ag $Kin.CloneList.Detect(Kin)      ;-> Kin has 3 CLONES Kin Kinny Kith

; ---- History
; 2014-02-18 v1.1 - Dynamic popup submenus, to split long clone lists across multiple lines
; 2014-02-17 v1.0 - Start

; ---- Alternative Installation
; You can further customize the order/location of the Clone List in your Popup Menu:
;    - Click "Popups" in the Script Editor (Alt-R)
;    - Select "View" from the menu
;    - Choose "Nick List"
;    - Paste these two lines at your desired location, or use as a sub menu:
;         $Kin.CloneList.Selection($$1):noop
;         $submenu($Kin.CloneList.Menu($1))
;    - Disable the duplicate menu nicklist items on line 50-51, by adding a ';' in front of the lines:
;         ; $Kin.CloneList.Selection($$1):noop
;         ; $submenu($Kin.CloneList.Menu($1))

; ---- Customization
alias -l MaxMenuLength { return 92 }

; ---- Popup Menu
menu nicklist {
  $Kin.CloneList.Selection($$1):noop
  $submenu($Kin.CloneList.SubMenu($1))
}

; ---- Dynamic Menu
alias Kin.CloneList.Selection { set -e %Kin.CloneList.Sel $1 }
alias Kin.CloneList.SubMenu {
  if ($1 == begin) { if (%Kin.CloneList.Sel) { set -e %Kin.CloneList.List $Kin.CloneList.Detect($v1) | return } }
  if ($1 == end) { unset %Kin.CloneList.* | return }
  if (!%Kin.CloneList.List) { return }
  ; -- Show as many clones as we can, up to the maximum length
  var %head $gettok(%Kin.CloneList.List,1-4,32), %list $iif($1 > 1,…), %max $calc($iif($MaxMenuLength isnum 36-384,$v1,92) - $len(%head)), %x 5
  while ($gettok(%Kin.CloneList.List,%x,32)) { var %t %list $v1 | if ($len(%t) > %max) { break } | %list = %t | inc %x }
  ; -- Reserve the remaining clones for the next line
  if ($gettok(%Kin.CloneList.List,%x $+ -,32)) { set -e %Kin.CloneList.List %head $v1 | %list = %list … }
  else { unset %Kin.CloneList.List }
  if (%list) { return %head %list $+ :Kin.CloneList.Clipboard %Kin.CloneList.Sel }
}
on *:START: { unset %Kin.CloneList.* }

; ---- Identifier
alias Kin.CloneList { var %h $1, %p $2 | return $regsubex(CloneList,$str(.,$ial(*!*@ $+ %h,0)),/./g,$Kin.CloneList.Prop(*!*@ $+ %h,%p,\n) $+ $chr(32)) }
alias Kin.CloneListByNick { return $Kin.CloneList($gettok($ial($$1,1),2,64),$2) }
alias Kin.CloneList.Detect { var %m $gettok($ial($1,1),2,64), %c $ial(*!*@ $+ %m,0) | if (%c) && (%c > 1) { return $1 has %c CLONES $Kin.CloneList(%m) } }
alias Kin.CloneList.Clipboard { var %l $Kin.CloneList($gettok($ial($1,1),2,64),ident)) | clipboard Clones of $+(<,$1,>) from @ $+ $gettok($ial($1,1),2,64) $+($chr(91),$numtok(%l,32),$chr(93)) %l }

alias -l Kin.CloneList.Prop { if ($2 == full) { return $ial($1,$3) } | elseif ($2 == ident) { return $gettok($ial($1,$3),1,64) } | else { return $ial($1,$3).nick } }
