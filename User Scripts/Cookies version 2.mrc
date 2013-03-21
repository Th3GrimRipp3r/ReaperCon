;----------------------------------------
; Cookies Script version 2.0 by Danneh
; Original script by Phil and Radien
;----------------------------------------
; Syntax for use /cookie <nick> <number>
;----------------------------------------

;----------------------------------------
; Changelog from Original:
;----------------------------------------
; 21/03/2013
; 
; Shortened the original code
; Replaced all %variables with an .ini
; Cleaned up the code
;----------------------------------------

alias cookies {
  if (!$1) || (!$2) { echo -at * Error: Incorrect syntax used: /cookies <nick> <amount> }
  elseif ($2 !isnum) { echo -at * Error: Incorrect syntax used: /cookies <nick> <amount> }
  else {
    if ($Cookini($1)) {
      writeini -n Cookies.ini Nicks $1 $calc($Cookread($1) + $2)
      .timer 1 1 describe $active gives $1-2 $+($Cookword($2),.) $1 has received $Cookread($1) $+($Cookword($Cookread($1)),.)
    }
    else {
      writeini Cookies.ini Nicks $1 $2
      .timer 1 1 describe $active gives $1-2 $+($Cookword($2),.) $1 has received $Cookread($1) $+($Cookword($Cookread($1)),.)
    }
  }
}

alias -l Cookini { return $ini(Cookies.ini,Nicks,$1) }
alias -l Cookread { return $readini(Cookies.ini,Nicks,$1) }
alias -l Cookword { return $iif($1 == 1,Cookie,Cookies) }
