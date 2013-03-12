;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Random Kick message script  ;;
;; Made by GrimReaper          ;;
;; All Rights Reserved         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Directions
1. Make a file in your $mircdir Called kickmsg.txt, then add some random kick messages to it

alias k {
  var %a = $lines(kickmsg.txt)
  var %b = $r(1,%a)
  kick $chan $$1 $read(kickmsg.txt,%b)
}
