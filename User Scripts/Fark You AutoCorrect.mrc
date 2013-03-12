menu channel {
  FYouAutoCorrect:dialog $iif($dialog(FYAC),-v,-m FYAC) FYAC
}

on *:SOCKOPEN:fyac.*:{
  if ($sockerr) { did -ra FYAC 3 Socket error: $sock($sockname).wsmsg  | halt }
  var %s = $gettok($sockname,2,46), %i sockwrite -nt $sockname
  if (%s == open) {
    %i GET /random HTTP/1.1
    %i Host: fyouautocorrect.com $+ $str($crlf,2)
  }
  elseif (%s == random) {
    %i GET $sock($sockname).mark HTTP/1.1
    %i Host: fyouautocorrect.com $+ $str($crlf,2)
  }
  elseif (%s == image) {
    %i GET $gettok($sockname,3-,46) HTTP/1.0
    %i Host: static.fyouautocorrect.com $+ $str($crlf,2)
  }
}

on *:SOCKREAD:fyac.*:{
  if ($sockerr) { did -a FYAC 3 Socket error: $sock($sockname).wsmsg  | halt }
  var %s = $gettok($sockname,2,46)
  if (%s == open) {
    var %a
    sockread %a
    if ($regex(%a,/The document has moved <a href="http:\/\/fyouautocorrect.com(.+?)">here<\/a>/i)) {
      sockopen fyac.random fyouautocorrect.com 80
      sockmark fyac.random $regml(1)
      sockclose $sockname
    }
  }
  elseif (%s == random) {
    var %a
    sockread %a
    if ($regex(%a,/<div class="imagewrap-view"><img width=".+" alt="(.+?)" src="http:\/\/(.+?)\/(.+?)"/i)) {
      sockopen $+(fyac.image./,$regml(3)) $regml(2) 80
      hadd -m FYAC ALT $regml(1)
      hadd -m FYAC Cur.Link $+($regml(2),/,$regml(3))
      sockclose $sockname
    }
  }
  elseif (%s == image) {
    if (!$sock($sockname).mark) {
      var %a
      sockread %a
      if (%a == $null) {
        sockmark $sockname 1
        hadd -m $sockname Start $ticks
      }
    }
    else {
      sockread &image
      hadd -m $sockname FName $+($regsubex($hget(FYAC, ALT),/[^a-z1-9]/gi,-),.jpg)
      bwrite $qt($+($mircdirFYouAutoCorrect\,$hget($sockname, FName))) -1 -1 &image
      var %kbs $calc(($sock($sockname).rcvd *1024) / ($ticks - $hget($sockname, Start)) /1000)
      did -ra FYAC 3 Size: $bytes($sock($sockname).rcvd).suf ( $+ $calc($ticks - $hget($sockname, Start)) $+ ms $+ ) $round(%kbs, 2) KB/s
    }
  }
}

on *:SOCKCLOSE:fyac.image./*:{
  did -g FYAC 2 $qt($+($mircdirFYouAutoCorrect\,$hget($sockname, FName)))
  .hfree -w $sockname *
}

dialog FYAC {
  title "FYouAutoCorrect"
  size -1 -1 475 487
  option pixels
  button "Randomize!", 1, 190 9 224 25
  icon 2, 1 54 489 350
  text "Loading...", 3, 37 447 290 25
  button "Copy link", 4, 337 442 85 25
  ;button "<", 5, 452 438 27 33
  ;button ">", 6, 496 437 27 33
  link "http://fyouautocorrect.com", 7, 10 10 150 150 
}

on *:DIALOG:FYAC:init:0:{
  if (!$isdir(FYouAutoCorrect)) mkdir FYouAutoCorrect
  sockopen fyac.open fyouautocorrect.com 80
}

on *:DIALOG:FYAC:sclick:1,4,7:{
  if ($did == 1) {
    sockopen fyac.open fyouautocorrect.com 80
  }
  elseif ($did == 4) {
    clipboard $+(http://,$hget(FYAC, Cur.Link))
    !did -ra FYAC 4 Link Copied
    .timerLC 1 1 if ($!dialog(FYAC)) did -ra FYAC 4 Copy Link
  }
  elseif ($did == 7) {
    url fyouautocorrect.com
  }
}

on *:DIALOG:FYAC:close:0:{
  noop $findfile($mircdirFYouAutoCorrect,*.*,0,.remove $1-)
  sockclose fyac*
}
