; TomCoyote NoticeLogger v.1.0
; collaborated on this script <Danneh>
; This is to help track where those 
; pesky notices come from if you are in
; multiple rooms/servers



on $*:NOTICE:/(.+)/Si:*:{
  var %note = 1
  while (%note <= $comchan($nick,0)) {
    var %noted = $addtok(%noted,$comchan($nick,%note),32)
    inc %note
  }
  if ($istok(HostServ|NickServ|MemoServ|BotServ|OperServ|ChanServ,$nick,124)) { HALT }
  if ($chr(35) iswm $chan) {
    window -De @notice
    echo @notice $timestamp $+(,$network,) ---- $nick has Noticed you in 7,1 $chan : 9,1 $v2  $addtok(%noted,$comchan($nick,%note),32)  : ---- $regml(1)
  }
  else {
    window -De @notice
    echo @notice $timestamp $+(,$network) ---- 9,1 $v2 ::: $nick 7,1  $addtok(%noted,$comchan($nick,%note),32) has Noticed you:9,1 $+(,$v2,:) >>  ---- 7,1 $regml(1)
  }
}
