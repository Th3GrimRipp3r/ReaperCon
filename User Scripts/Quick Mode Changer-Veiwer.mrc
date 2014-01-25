; Quick Mode Changer/Veiwer by TomCoyote ( Tom Coyote Wilson aka Coyote` on Geekshed.net IRC network )
; http://pastebin.com/xGWA1T5g
; Tom's Menu Quick Modes and Information

menu menubar,status {
  $me $+ 's User Modes 
  .$iif(((T isincs $usermode) && (D isincs $usermode) && (R isincs $usermode) && (p isincs $usermode)),+TDRp,-TDRp)) $iif(((T isincs $usermode) && (D isincs $usermode) && (R isincs $usermode) && (p isincs $usermode)),ON,OFF))
  ..$iif((p isincs $usermode) && (R isincs $usermode) && (T isincs $usermode) && (D isincs $usermode),$style(1))) $iif(((T isincs $usermode) && (D isincs $usermode) && (R isincs $usermode) && (p isincs $usermode)),Toggle -TDRp,Toggle +TDRp)) $iif(((T isincs $usermode) && (D isincs $usermode) && (R isincs $usermode) && (p isincs $usermode)),OFF,ON)) :/umode2 $iif(((T isincs $usermode) && (D isincs $usermode) && (R isincs $usermode) && (p isincs $usermode)),-TDRp,+TDRp)) 
  .$iif(T isincs $usermode,+T,-T) $iif(T isincs $usermode,ON,OFF)
  ..$iif((T isincs $usermode),$style(1)) $iif(T isincs $usermode,Toggle -T,Toggle +T) $iif(T isincs $usermode,OFF,ON):/umode2 $iif(T isincs $usermode,-T,+T)
  .$iif(D isincs $usermode,+D,-D) $iif(D isincs $usermode,ON,OFF)
  ..$iif((D isincs $usermode),$style(1)) $iif(D isincs $usermode,Toggle -D,Toggle +D) $iif(D isincs $usermode,OFF,ON):/umode2 $iif(D isincs $usermode,-D,+D)
  .$iif(R isincs $usermode,+R,-R) $iif(R isincs $usermode,ON,OFF)
  ..$iif((R isincs $usermode),$style(1)) $iif(R isincs $usermode,Toggle -R,Toggle +R) $iif(R isincs $usermode,OFF,ON):/umode2 $iif(R isincs $usermode,-R,+R)
  .$iif(p isincs $usermode,+p,-p) $iif(p isincs $usermode,ON,OFF)
  ..$iif((p isincs $usermode),$style(1)) $iif(p isincs $usermode,Toggle -p,Toggle +p) $iif(p isincs $usermode,OFF,ON):/umode2 $iif(p isincs $usermode,-p,+p)

  .$iif((T isincs $usermode),$style(3)) T - CTCPs:.
  .$iif((D isincs $usermode),$style(3)) D - PMs:.
  .$iif((R isincs $usermode),$style(3)) R PM/Not UserNR:.
  .$iif((p isincs $usermode),$style(3)) p - Hide Chan:.
  .$iif((z isincs $usermode),$style(3)) z - SSL $ssl:.
  .$iif((x isincs $usermode),$style(3)) x Hide IP:.
  .Echo $me Modes:/Echo -a $usermode
  .INformation:
  .. MenuBar ( $+ $iif($menubar == 1,ON,OFF) $+ ):.
  .. Toolbar ( $+ $iif($toolbar == 1,ON,OFF) $+ ):.
  .. Treebar ( $+ $iif($treebar == 1,ON,OFF) $+ ):.
  .. Switchbar ( $+ $iif($switchbar == 1,ON,OFF) $+ ):.
  .. Protect ( $+ $iif($Protect == $True,ON,OFF) $+ ):.
  .. Online Mirc ( $+ $uptime(mirc,1) $+ ):.
  .. Online System ( $+ $uptime(system,1) $+ ):.
  .. MiRc Portable ( $+ $iif($portable == $True,YES,NO) $+ ):.
  .. MiRc Locked ( $+ $iif($locked == $True,YES,NO) $+ ):.
}
