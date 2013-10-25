:::::::::::::::::::::::::::::::::::::::::::
:: Bot Status Add/Remove Script          ::
:: Written by Zetacon                    ::
:: Support is available through          ::
::  irc.geekshed.net #Zetacon            ::
:: Add to your mIRC bot to create        ::
::  different statuses. You are more     ::
::  than welcome to change the statuses. ::
:: All Rights Reserved                   ::
:::::::::::::::::::::::::::::::::::::::::::


on *:TEXT:!status*:#:{
  if ($2 == add) {
    if ($3 == user) {
      auser user $4
      msg $chan $4 has been added to my User list.
    }
    if ($3 == operator) {
      auser operator $4
      msg $chan $4 has been added to my Operator list.
    }
    if ($3 == admin) {
      auser admin $4
      msg $chan $4 has been added to my Admin list.
    }
  }
  if ($2 == delete) {
    if ($3 == user) {
      ruser user $4
      msg $chan $4 has been deleted from my User list.
    }
    if ($3 == operator) {
      ruser operator $4
      msg $chan $4 has been deleted from my Operator list.
    }
    if ($3 == admin) {
      ruser admin $4
      msg $chan $4 has been deleted from my Admin list.
    }
  }
  if ($2 == $null) {
    msg $chan Invalid Command. Syntax is !status add/delete type nick
    HALT
  }
  else {
    msg $chan Invalid Command. Please try again.
  }
}
