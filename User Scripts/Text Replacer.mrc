; I made it 1 rather than *
on 1:INPUT:*: {
  if (%RepText) {
    ; I commented out this line because it is not needed
    ; if ($left($$1,1) == /) { HALT }
    ; I made this an IF rather than an elseif,
    ; I also replaced the "/" with a readini, so that IF the client changes their command character,
    ; it will still work.
    if ($left($$1,1) != $readini(mirc.ini,text,commandchar)) {
      var %a = $numtok($1-,32), %b = 1, %c = $1-
      while (%b <= %a) {
        var %d = %d $replacecs($gettok(%c,%b,32),$left($gettok(%c,%b,32),1),$+(4,$left($gettok(%c,%b,32),1),14))
        inc %b
      }
      ; I moved this, because it was outside of your elseif statement...
      say %d
      HALT
    }
  }
}
menu channel,status,query {
  Word Rep $+([,$iif(%RepText,On,Off),]):$iif(%RepText,unset,set) %RepText 1 | noop $input($iif(%RepText,Word Replacer has been enabled!!,Word Replacer has been disabled!!),o,System!)
} 
