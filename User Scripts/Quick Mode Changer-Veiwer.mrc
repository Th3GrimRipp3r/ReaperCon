; Quick Mode Changer/Veiwer by TomCoyote ( Tom Coyote Wilson aka Coyote` on Geekshed.net IRC network )
; http://pastebin.com/xGWA1T5g
menu menubar,channel {
  $me Modes
  .TDRp
  ..$iif((p !isincs $usermode) && (R !isincs $usermode) && (T !isincs $usermode) && (D !isincs  $usermode),$style(3))) OFF:/umode2 -TDRp
  ..$iif((p isincs $usermode) && (R isincs $usermode) && (T isincs $usermode) && (D isincs $usermode),$style(3))) ON:/umode2 +TDRp
  .D
  ..$iif((D !isincs  $usermode),$style(3)) OFF:/umode2 -D
  ..$iif((D isincs $usermode),$style(3)) ON:/umode2 +D
  .T
  ..$iif((T !isincs $usermode),$style(3)) OFF:/umode2 -T
  ..$iif((T isincs $usermode),$style(3)) ON:/umode2 +T
  .R
  ..$iif((R !isincs $usermode),$style(3)) OFF:/umode2 -R
  ..$iif((R isincs $usermode),$style(3)) ON:/umode2 +R
  .p
  ..$iif((p !isincs $usermode),$style(3)) OFF:/umode2 -p
  ..$iif((p isincs $usermode),$style(3)) ON:/umode2 +p
  .$iif((T isincs $usermode),$style(3)) T - CTCPs:.
  .$iif((D isincs $usermode),$style(3)) D - PMs:.
  .$iif((R isincs $usermode),$style(3)) R PM/Not UserNR:.
  .$iif((p isincs $usermode),$style(3)) p - Hide Chan:.
  .$iif((z isincs $usermode),$style(3)) z - SSL $ssl:.
  .$iif((x isincs $usermode),$style(3)) x Hide IP:.
  .Echo $me Modes:/Echo -a $usermode
}
