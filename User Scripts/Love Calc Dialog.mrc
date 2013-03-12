alias lovecalc dialog -mdrv love love

dialog love {
  Title "The Love Calculator"
  size -1 -1 150 70
  option dbu
  edit "Person 1", 1, 10 10 60 10
  edit "Person 2", 2, 80 10 60 10
  button "Calculate", 3, 50 30 50 12
  edit "0%", 4, 60 50 30 10, read
}
on *:dialog:love:sclick:3:did -o love 4 1 $+($love($did(1),$did(2)),%)
alias love return $round($randompercent($asccount($+($1,$$2))),1)
alias -l randompercent return $calc(($sin($$1) + 1) / 2 * 100)
alias -l asccount {
  var %a = 1, %t
  while (%a <= $len($$1)) {
    %t = $calc(%t + $asc($lower($mid($1,%a,1))))
    inc %a
  }
  return %t
}
