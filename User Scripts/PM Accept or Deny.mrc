on *:OPEN:?:{ 
  if (%PM.Enable) {
    set %pm.nick $nick
    dialog -m PM_dia PM_dia
    dialog -t PM_dia PM with $nick
    .msg $nick Please wait while I accept/Deny your PM
    did -a PM_dia 6 $nick
    did -a PM_dia 8 $address($nick,2)
    did -a PM_dia 10 $1-
  }
}

menu * {
  PM Dialog
  .$iif(%PM.Enable,$style(2)) On:set %PM.Enable on
  .$iif(!%PM.Enable,$style(2)) Off:unset %PM.Enable
}

dialog PM_dia {
  title ""
  size -1 -1 127 58
  option dbu
  button "Accept", 1, 2 44 37 12
  button "Deny", 2, 44 44 37 12
  button "Ignore", 3, 87 44 37 12
  text "A query has been opened, Please select an option:", 4, 2 2 123 8
  text "Nick:", 5, 2 12 12 8
  edit "", 6, 18 11 107 10, read
  text "Address/Host:", 7, 2 22 35 8
  edit "", 8, 39 21 86 10, read autohs
  text "Message:", 9, 3 32 25 8
  edit "", 10, 30 31 95 10, read autohs
}

on *:DIALOG:PM_dia:init:*: {
}

on *:DIALOG:PM_dia:sclick:1-3: {
  if ($did == 1) { .msg $did(6).text *** 4Your PM has been accepted, You may continue to speak *** | dialog -x PM_dia PM_dia | .unset %pm.nick }
  if ($did == 2) { .msg $did(6).text *** 7I am sorry %pm.nick $+ , Your PM has been rejected.. Please try again later. *** | dialog -x PM_dia PM_dia | close -m %pm.nick | .unset %pm.nick }
  if ($did == 3) { .msg $did(6).text *** 12Sorry %pm.nick $+ , I have denied your PM and placed you on ignore for 5 minutes. *** | dialog -x PM_dia PM_dia | ignore -pu300 %pm.nick | close -m %pm.nick | .unset %pm.nick }
}
