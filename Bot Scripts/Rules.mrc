;############################
;## Rules Script by Danneh ##
;## All you need to setup  ##
;## is in your $mircdir    ##
;## Make a file called     ##
;## rules.txt and enter    ##
;## your rules there..     ##
;############################

on $*:TEXT:/^[!@]rules/S:#ReaperCon: {
  if (%rules [ $+ [ $nick ] ]) { HALT }
  else {
    var %a = $iif($left($1,1) == !,.notice $nick,msg $nick)
    var %b = 1
    while (%b <= $lines(rules.txt)) {
      %a $+(%b,:) $read(rules.txt,%b)
      .inc %b
    }
    %a End of rules.
    set -u300 %rules [ $+ [ $nick ] ] on
  }
}
