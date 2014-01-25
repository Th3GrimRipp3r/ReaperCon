; Tom's TreeBar or Switchbar menu Quick Switcher
; TomCoyote AKA Coyote` of Geekshed IRC network
; #IamAddictedToIrc

menu menubar,status {  
  Treebar Or Switchbar
  .Switchbar ( $+ $iif($switchbar == 1,ON,OFF) $+ ) or Treebar ( $+ $iif($treebar == 1,ON,OFF) $+ ):
  ..(Toggle):.toggletreeswitch
  .Switchbar ( $+ $iif($switchbar == 1,ON,OFF) $+ ):
  ..$iif($switchbar == 1,$style(1)) -Toggle Off/On - Currently ( $+ $iif($switchbar == 1,ON,OFF) $+ ):.switchbara
  .Treebar ( $+ $iif($treebar == 1,ON,OFF) $+ ):
  ..$iif($Treebar == 1,$style(1)) -Toggle Off/On - Currently ( $+ $iif($treebar == 1,ON,OFF) $+ ):.treebara
 }
alias -l switchbara {
  if ($switchbar == 1) {
    .switchbar off
  }
  else {
    .switchbar on
  }
}
alias -l treebara {
  if ($treebar == 1) {
    .treebar off
  }
  else {
    .treebar on
  }
}
alias -l toggletreeswitch { 
  if ($switchbar == 1) { 
    .switchbar off 
    .treebar on 
  } 
  else { 
    .treebar off 
    .switchbar on
  } 
}
