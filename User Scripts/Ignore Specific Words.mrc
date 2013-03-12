menu channel,status {
  &Ignore Words Setup:dialog $iif($dialog(ignspecword),-v,-m ignspecword) ignspecword
}
dialog ignspecword {
  title "Ignore Specific Words!!"
  size -1 -1 125 102
  option dbu
  box "Currently Added Words:", 3, 3 3 79 71
  list 4, 7 11 70 58, size autovs extsel
  button "Add Word", 5, 85 6 37 12
  button "Rem Word", 6, 85 22 37 12
  button "Rem Selected", 7, 85 38 37 12
  button "Rem All", 8, 85 54 37 12
  check "Replace with <censored>", 10, 7 77 79 7
  button "Ok", 9, 46 87 37 12
  menu "File", 1
  item "Exit", 2, 1, ok
}
on *:DIALOG:ignspecword:*:*: {
  if ($devent == init) {
    if (%wordlist != $null) { didtok $dname 4 44 %wordlist }
    if (%censor != $null) { did -c $dname 10 }
  }
  if ($devent == sclick) {
    if ($did == 5) { set %wordlist $addtok(%wordlist,$$?="Please enter a word to ignore:",44) | reloadwords }
    if ($did == 6) {
      if ($did(4).sel == $null) { noop $input(Please select a ingored word to remove!,o,Error!) }
      else { set %wordlist $remtok(%wordlist,$did($dname,4).seltext,44) | did -r $dname 4 | reloadwords }
    }
    if ($did == 7) {
      if ($did(4).sel == $null) { noop $input(Please select some ignored words to remove!,o,Error!) }
      else {
        var %a = 1
        while (%a <= $did($dname,4,0).sel) {
          set %wordlist $remtok(%wordlist,$did($dname,4,$did($dname,4,%a).sel).text,44)
          inc %a
        }
        .timerwords 1 1 reloadwords
      }
    }
    if ($did == 8) { unset %wordlist | noop $input(All current ignored words have been erased!,o,Success!) | did -r $dname 4 }
    if ($did == 9) { dialog -x $dname }
    if ($did == 10) { 
      ; Use <censored> checkbox
      if ($did(10).state == 1) {
        set %censor on
      }
      else {
        unset %censor
      }
    }
  }
}
alias -l reloadwords {
  if (%wordlist != $null) { did -r ignspecword 4 | didtok ignspecword 4 44 %wordlist }
}
on ^*:TEXT:*:*:{
  IgnoreWords Text $1-
}
on ^*:ACTION:*:*:{
  IgnoreWords Action $1-
}
on ^*:NOTICE:*:*:{
  IgnoreWords Notice $1-
}
alias -l IgnoreWords {
  var %InputType $1
  var %InputText $2-
  if (!%censor) {
    ; Default - Block whole message
    var %wordst = $calc($pos(%InputText,$chr(32),0) + 1)
    var %count = 1
    var %checkwords = 0
    while (%count <= %wordst) {
      var %word = $remove($gettok(%InputText,%count,32),$chr(44),!,.,?,;,-,_)
      if ($istok(%wordlist,%word,44)) { var %checkwords = 1 | break }
      inc %count
    }
    if (%checkwords == 1) { echo $iif(%InputType == Notice,-s,$iif($target == $me,$nick,$target)) %InputType from $nick is blocked! | haltdef }
  }
  else {
    ; Use <censored>
    ; Swap word,word2,word3 for word|word2|word3
    var %regextokenswap $+(/,$chr(44),/g)
    var %regexwords $regsubex(%wordlist,%regextokenswap,$chr(124))
    ; Check if there is anything to censor
    if ($len(%regexwords) > 0) {
      ; Substitute -whole- words that match the ignore list
      var %regexpattern $+(/\b,$chr(40),%regexwords,$chr(41),\b/g)
      var %censored $regsubex(%InputText,%regexpattern,<censored>)
      if (%censored) { 
        if (%InputType == Action) {
          echo $color(action) -tlbf $iif($chan,$chan,$nick) * $nick %censored
          haltdef 
        }
        elseif (%InputType == Notice) {
          echo $color(Notice) -st $+(-,$nick,-) %censored 
          haltdef 
        }
        else {
          echo -tlbf $iif($target == $me,$nick,$target) $+(<,,$cnick($nick).color,$left($nick(#, $nick, a, r).pnick, 1) $+ $nick,,>) %censored 
          haltdef 
        }
      }
    }
  }
}
