; TomCoyote of GeekshedIRC #iamaddictedtoirc
; Created 11-19-2013 URL: http://pastebin.com/3GsRXc9B
; Got tired of the normal Join, Part, Mode, Nick Change, and Quit messages in mIrc
; Here are mine
menu menubar,channel,status {
  JoinPartModeNickQuit:
  .$iif($group(#JPQ) == off,$style(3)) Off:.disable #JPQ | echo -a 4 (#JPQ) OFF
  .$iif($group(#JPQ) == on,$style(3)) On:.enable #JPQ | echo -a 7 (#JPQ) 9ON
}
#JPQ on
on ^1:JOIN:#:doitJPQ
on ^1:PART:#:doitJPQ $1-
on ^1:rawmode:*:doitJPQ $1-
on ^1:QUIT:doitJPQ $1-
on ^1:NICK:doitJPQ
alias -l doitJPQ {
  if $event = join { echo $chan 9  $time([mm:dd] [HH:nn:ss])    7 (( $+  9Join: 7 $nick  $+ ))  3( $+  ( $+ $address($nick,1) $+ )  $+ )  $1-  | haltdef }
  elseif $event = rawmode { echo $chan 9 $time([mm:dd] [HH:nn:ss]) Mode: 7 $nick  $+ 13)) 9sets mode(s):7  $1- | haltdef }
  elseif $event = part { echo $chan 4 $time([mm:dd] [HH:nn:ss])  13 ((Part: 7 $nick $+13)) 3(( $+ $address($nick,1) $+ )) 7,1 $1- | haltdef }
  elseif $event = nick { 
    var %n $comchan($newnick,0)
    while %n {
      echo $comchan($newnick,%n) 9,1 $time 7,1  $nick  --- 9,1is Transposed as 7,1  $newnick 
      dec %n
    }
    if (%n == 0) { goto end }
  }
  elseif $event = QUIT {
    var %q $comchan($nick,0)
    while %q {
      echo $comchan($nick,%q) 4 ( $+ $time $+ ) ( $+  Quit: 7 $nick  $+ 4) 3( $+  ( $+ $address($nick,1) $+ )  $+ )    9,1 $1-  4)
      dec %q
    }
    if (%q == 0) { goto end }
    :end
    haltdef
  }
} 
#JPQ end
