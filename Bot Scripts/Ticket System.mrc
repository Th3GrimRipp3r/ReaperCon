::::::::::::::::::::::::::::::::::
:: Support Ticket System        ::
:: Concept by Zetacon           ::
:: Code written by Peer & Kin   ::
:: All Rights Reserved          ::
::::::::::::::::::::::::::::::::::

on $*:TEXT:/^!b(sreqhelp|request|assign|read|finish|status)( |$)/Si:#CHANNELHERE:{
  if ($regml(1) == sreqhelp) {
    .timer 1 1 msg $chan $nick $+ , please wait while a list of instructions are PM'd to you...
    .timer 1 3 msg $nick Please use the following syntax to request a BotServ bot:
    .timer 1 5 msg $nick !brequest <Nick> <Ident> <Host> <Realname>
    .timer 1 7 msg $nick Replace <Nick> with the Nick you wish to have,
    .timer 1 9 msg $nick Replace <Ident> with the ident you want your BotServ bot to have,
    .timer 1 11 msg $nick Replace <Host> with the desired host you want your BotServ bot to have,
    .timer 1 13 msg $nick Finally, replace <Realname> with a real name for your BotServ bot.
  }
  elseif ($regml(1) == request) {
    if (!$2) || (!$3) || (!$4) || (!$5) { msg $chan * ERROR: Incorrect Syntax.. !brequest <Nick> <Ident> <Host> <Realname> }
    else {
      Something goez here.. But my head is starting to hurtz D:
    }
  }
}



Notes:
!brequest <Nick> <Ident> <Host> <Realname> to request a BotServ bot, as noted above.
Tickets
- Sent to #BotServ-req "Ticket <generated number> has been created type !bread <generated number> for more info.
- Ticket information would show up in a PM, whether triggered in channel or in a PM.
- Can be numbered one to infinity or be labeled as a date.
Netadmins would have the following commands:
- !bassign <oper nick> <ticket> <-- Allows us to assign tickets to other staff
Opers would have the following commands:
- !basssign <ticket> <-- Assigns ticket to self
- !bread <ticket> <-- Allows any ticket to be read.
- !bfinish <ticket> <-- Completes ticket (Can only be done by assigned person or netadmins)
- !bstatus <status> <ticket> <-- Changes the status of the ticket.
Security - Authentication can be one or more of the following
- Password authentication
- Oper verification (Scans /whois for Oper insignia)
- Pin authentication (Could be used for limited sessions)
Logged events
- Successful/Failed authentication (Dependent on which authentication method is chosen)
- Completed tickets (Logged to a separate file)


How the Ticket will be Displayed:
---BotServ Request Ticket #<number>---------
Requested by: $nick
Date: <Date the request was entered>
BotServ Name: <name>
Ident: <ident>
Host: <host>
Real Name: <real name>
--------------------------------------------
