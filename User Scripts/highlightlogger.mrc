; Highlight Logger by TomCoyote
; Go to your Address Book, Click on Highlight Tab
; Add, then put the nicks you want to Log into one line
; Separated by a comma (,) as in Nick1,Nick2,Nick3,$me
; and it will work regardless if Enable Highlight 
; box is Checkmarked or not.
; After first highlight has been recorded, a new window
; will open called @highlights, Right click on the window
; tab and choose LOG (on) if you want to keep a record

on *:text:*:#:{
  if ($highlight($1- $lf)) && !$($+(%,highlightflood,.,$nick),2) {
    set -u10 $+(%,highlightflood,.,$nick) on
    window -De @highlights
    echo @highlights $timestamp 9,1 $network ---- $nick  has highlighted you in 7,1 # : 9,1 $nick : ---- $1-  
  }
}
on *:action:*:#:{
  if ($highlight($1- $lf)) && !$($+(%,highlightflood,.,$nick),2) {
    set -u10 $+(%,highlightflood,.,$nick) on
    window -De @highlights
    echo @highlights $timestamp 9,1 $network --- $nick  has taken action on you in 7,1 # 9,1 $nick : ------ $1- 
  }
}
