;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                Blizzeta Remote               ;;
;;              Written by Blizzardo1           ;;
;;                 Copyright 2013               ;;
;;                                              ;;
;;             For use with GeekShed            ;;
;;        Can be used with other servers        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

var %AwayMessage = Away: BRB
var %OPERNick = YourOLoginNick

var %YourNick = NickHere
var %NickServPass = SuperSecretPass
var %OperServPass = SuperSecretPass

var %AwaySuffix = |Away
var %AwayNick = $me $+ %AwaySuffix

on *:load: {  echo -a Blizzeta Core loaded! }
on *:unload: {  echo -a Blizzeta Core unloaded! }

on *:kick:#: { !aline -hp @PartsJoins $fulldate 4User Kicked: 00 $+ 12 $+ $knick 7by $nick 7in 9 $+ $chan 10on 3 $+ $server $+ 9( $+ $network $+ ) 5( $+ $1- $+ ) }
on *:join:#: {
  !aline -hp @PartsJoins $fulldate 11User Join: 00 $+ 12 $+ $nick ( $+ $fulladdress $+ ) 10in 7 $+ $chan 10on 3 $+ $server $+ 9( $+ $network $+ );
  operscan
}

on *:part:#: { !aline -hp @PartsJoins $fulldate 10User Part: 00 $+ 12 $+ $nick ( $+ $fulladdress $+ ) 10in 7 $+ $chan 10on 3 $+ $server $+ 9( $+ $network $+ ) 10( $+ $1- $+ ) }
on *:quit: { !aline -hp @PartsJoins $fulldate 5User Quit: 00 $+ 12 $+ $nick ( $+ $fulladdress $+ ) 10on 3 $+ $server $+ 9( $+ $network $+ ) 5( $+ $1- $+ ) }

 ; This alias performs a special /WHO request, making it easy to catch the result.
 ; The number '123' is used to catch the reply, this can be any number 0-999,
 ; but it must be the same here and in the raw event below.
 alias operscan {
   .who * o%nt,123
 }

 ; This raw event catches the special /WHO request made by the alias above.
 raw 354:& 123 &:{
   if ($comchan($3,0)) && ($comchan($me,0)) {
     opercolor $3
   }
   haltdef
 }

 ; This local alias sets the color for a given nick on all the common channels.
 alias -l opercolor {
   var %t = $comchan($1,0), %c = 1
   while (%c <= %t) {
     cline -m 9 $comchan($1,%c) $1
     inc %c
   }
 }

 ; This raw event catches normal /WHO replies,
 ; probably done by other scripts to update the IAL.
 ; The * in the flags part indicates the user is an IRC Operator.
 raw 352:*:{
  haltdef
   if (* isin $7) && ($comchan($6,0)) && ($comchan($me,0)) {
     opercolor $6
   }
  !aline -hp @Operscan $fulldate 11User Scanned: 00 $+ 12 $+ $6 for Opermode using $5 $+ . User is 3 $+ $8 hops away.
}

;END WHO
raw 315:*: {
  haltdef
  !aline -hp @Operscan $fulldate 11END SCAN for 11 $+ $network
}

; Short Mode command
; md(Mode[], Nick[])
alias MD { /mode $active $1 $2- }

; Short NickServ Group command
; grp()
alias grp { /ns group %YourNick %NickServPass }

; Short NickServ Identify Command
; id()
alias id { /ns identify %NickServPass }

; Sets ChanServ XOP on or off
; xop(Mode[On,Off])
alias xop { /cs set $active XOP $1 }

; Sets ChanServ SOP on a given User
; sop(Action[Add,Del], Nick)
alias sop { /cs sop $active $1 $2 }

; Sets ChanServ AOP on a given User
; aop(Action[Add,Del], Nick)
alias aop { /cs aop $active $1 $2 }

; Sets ChanServ HOP on a given User
; hop(Action[Add,Del], Nick)
alias hop { /cs hop $active $1 $2 }

; Sets ChanServ VOP on a given User
; vop(Action[Add,Del], Nick)
alias vop { /cs vop $active $1 $2 }

; Synchronises the $active channel
; sync()
alias sync { /cs sync $active }

; If services won't give you your nick back, this forces services to release it
; takeover()
alias takeover { ns release $1 %NickServPass }

; SUB Alias for SetAwayMessage(Message)
alias SAM {
  SetAwayMessage $1-
}

; Sets your Global Away Message
; SetAwayMessage(Message)
alias SetAwayMessage {
  %AwayMessage = $1-
  echo -a Away Message set as " $+ %AwayMessage $+ "
}

; SUB Routine for aaway(Message)
; Sets a Global away with given AwayMessage
alias saway {
  aaway %AwayMessage
}

; Sets your Status to away on all open connections
; aaway(Message)
alias aaway {
  if ((!$away)) {
    scon -at1 /away $1-
    scon -at1 /tnick %AwayNick
    echo 8 -at * Away: $1-
  }
  elseif ($away) {
    echo 8 -at * Away Time: $duration($awaytime)
    scon -at1 /away
    scon -at1 /nick $remove($me, %AwaySuffix)
    echo 8 -at * Back from: $awaymsg
  }
  else { echo 10 -at * It appears you errored somewhere in the script }
}


; Captures all Higlights by $me
on *:TEXT:*:#: {
  if ($me isin $1- || Optional isin $1- || Optional2 isin $1-) {
    if (!@Highlight) {
      window -hw2 @Highlight
    }
    aline -hp @Highlight $fulldate 4Text Highlight: 00 $+ $1- 10by 12 $+ $nick 10in 7 $+ $chan 10on 3 $+ $server $+ 9( $+ $network $+ )
  }
}

; Captures all Highlights by Action by $me
on *:ACTION:*:#: {
  if ($me isin $1- || Optional isin $1- || Optional2 isin $1-) {
    if (!@Highlight) {
      window -hw2 @Highlight
    }
    aline -hp @Highlight $fulldate 10Action Highlight: 00 $+ $1- 10by 12 $+ $nick 10in 7 $+ $chan 10on 3 $+ $server $+ 9( $+ $network $+ )
  }
}

; Captures your Usermode set on a given network
on *:usermode: { echo -a $nick sets mode $$1 on $network }

; Allows a user to speak to you if you wish, although there is a better script for this if you wish to obtain it
; Allow(Nick)
alias Allow {
  umode2 -D
  notice $$1 You are now free to message me! Available Window is 15 minutes by default, however can be revoked access at any given time to my discretion. Be wise.
  /.timer $+ $$1 1 900 Revoke $$1
}
; Disallows a user to speak to you if you wish, although there is a better script for this if you wish to obtain it
; Revoke(Nick)
alias Revoke {
  umode2 +D
  notice $$1 Window is now Closed, Any other chat after this message can no longer be heard. If you want to PM me again, Just ask again :)
}

; Global Kick - Kicks one person from any channel you're OP on
; GloKick(Nick, Reason)
alias GloKick {
    var %a = $comchan($nick,0)
    while (%a) {
    $iif($me isop $chan,kick $chan $$1 $2-)
    dec %a
  }
}

; Kicks and Bans a given Person for a set amount of hours
; KickBan(Nick, Time[Hours], Reason)
alias KickBan {
  var %seconds = 3600 * $2
  var %bhost = $address($$1,2)
  var %hourstr = "SetHour(s)"
  var %bch = #
  if ($2 > 1 || $2 < 1) {
   %hourstr = hours
  }
  else if ($2 == 1) {
   %hourstr = hour
  }

  /mode # +b %bhost
  /kick # $$1 $3- $+ . This ban will be removed in $2 %hourstr
  /.timer $+ $$1 1 %seconds /mode %bch -b %bhost
}

; SUB Alias for PermaKickBan
; pkb(Nick, Reason)
alias pkb { PermaKickBan $$1 $2- }

; Permanently bans a given user
; PermaKickBan(Nick, Reason)
alias PermaKickBan {
  var %bchan = #
  var %bhost = $address($$1,2)
  /mode # +b %bhost
  /kick %bchan $$1 $2- This ban is Permanent!
}

; Unbans a User from the $active Channel you're on. Needs work.
; Unban(Nick)
alias Unban {
  var %bhost = $address($$1,2)
  /mode # -b %bhost
}

; SUB Alias for SilentNick(Nick)
alias Q { SilenceNick $$1 }

; SUB Alias for SilenceNickNoChange(Nick)
alias QN { SilenceNickNoChange $$1 }

; SUB Alias for UnSilenceAll(Nick)
alias UQ { UnSilenceAll $$1 }

; Silences a Person on the $Active channel
; SilenceNick(Nick)
alias SilenceNick {
  var %min = 15
  var %seconds = 60 * %min
  var %bchan = #
  var %bhost = $address($$1,2)
  /mode # +b ~q: $+ %bhost
  /.timerSilence $+ $$1 1 %seconds UnSilenceAll %bchan %bhost
}

; Silences a Person and prevents the person from changing nicks in the $Active channel
; SilenceNickNoChange(Nick)
alias SilenceNickNoChange {
  var %min = 15
  var %seconds = 60 * %min
  var %bchan = #
  var %bhost = $address($$1,2)
  /mode # +bb ~q: $+ %bhost ~n: $+ %bhost
  /.timerSilence $+ $$1 1 %seconds UnSilenceAll %bchan %bhost
}

; Removes Quiet and NoNickChange from a given user
; UnsilenceAll(Channel, Nick)
alias UnSilenceAll {
  var %bhost = $address($2,2)
  /mode $1 -bb ~q: $+ %bhost ~n: $+ %bhost
}

; SUB Alias for blockword(Word)
alias bw { blockword $1 }

; SUB Alias for unblockwork(Word)
alias ubw { unblockword $1 }

; Blocks a given word
; blockword(Word)
alias blockword { md b ~T:block:* $+ $1 $+ * }

; Unblocks a given word
; unblockword(Word)
alias unblockword { md -b ~T:block:* $+ $1 $+ * }

; Ignores a given Nick
; shutup(Nick)
alias shutup {
  /.ignore -pcntikd $address($$1,2)
  /echo -a 10Ignored 4 $+ $$1 $+ 2 using $address($$1,2) as the mask
}

; Unignores a given Nick
; release(Nick)
alias release {
  /.ignore -r $address($$1,2)
  /echo -a 10Unignored 4 $+ $$1 $+  2 with $address($$1,2) as the mask
}

; SUB Alias for ClearAll(Nick)
alias CA { ClearAll $$1 }

; Clears Bans, Ban Excempt, and Invite Excempt on a given Nick
; ClearAll(Nick)
alias ClearAll {
  var %n0 = $address($$1,2)
  /mode $active -beI %n0 %n0 %n0
  /msg $$1 %n0 has been cleared. Please try to rejoin $active $+ !
}

; Sends a Notice to all of your friendly staff on a given channel
; SNOTICE(Channel, Message)
alias SNOTICE { /notice @&~% $+ $1 $2- }

; Presents the Meaning of Life, the Universe, and Everything to the $active Channel
; MeaningOfLife()
alias MeaningOfLife {
  var %MOF = Question Life, the Universe and Everything
  say %MOF $+ , Well the Meaning of Life is $len(%MOF)
}

; Sends a Derp Slap to thyself
; sme()
alias sme { /me slaps $me with $me }

; Sends an annoying DERP to the $active Channel
; Derp()
alias Derp { /me is $me $+ , but how could $me run when $me is perched at $me $+ 's computer? $me must be really derpy because $me just hit $me with $me $+ , for $me is $me $+ , but $me can't hit $me $+ 's self because that would hurt $me $+ ! }

; Parts and reorganises your Channel list for a given server
; PJ()
alias PJ {
  partall Synchronising Channels
  ns update
}


; GLINES a given user by HOST                 [*OperCommand]
; GlineBan(Nick, Time[Format], Reason)
alias GlineBan {
  var %Format = $2
  var %bhost = $address($$1,2)
  /gline $$1 $3- $+ .
}

; Sends a Global Message to the given Server  [*OperCommand]
; global(Message)
alias global { /os global $1- }

; Allows you to Login to your Oper account    [*OperCommand]
; oLogin()
alias oLogin { /oper %OPERNick %OperServPass }


menu Channels List {
  Update NickServ: ns update
  Add $active to List: ns ajoin add $active
  Add all open channels to List: ns ajoin addall
  Remove $active from list: ns ajoin del $active
  Clear List: {
    .dialog -v,-md answer.system answer.system { set %chan $chan | set %msgnick $nick }
  }
}

menu channel,query,nicklist {
  Update NickServ: ns update
  AJOIN
  .Add $active to List: ns ajoin add $active
  .Add all open channels to List: ns ajoin addall
  .Remove $active from list: ns ajoin del $active
  .Clear List: {
    .dialog -v,-md answer.system answer.system { set %chan $chan | set %msgnick $nick }
  }

  Windows
  .Open All Windows: {
    /window -hw2k0 @Highlight
    /window -hw2k0 @PartsJoins
    /window -e1hw2k0 @Services
    /window -hw2k0 @Operscan
    /window -hw2k0 @Sockets
    /debug @Debug
  }
  .-
  .Open @Highlight:   /window -hw2k0 @Highlight
  .Open @PartsJoins:  /window -hw2k0 @PartsJoins
  .Open @Services:    /window -e1hw2k0 @Services
  .Open @Operscan:    /window -hw2k0 @Operscan
  .-
  .Open @Sockets:     /window -hw2k0 @Sockets
  .Open @Debug:       /debug @Debug
}

dialog answer.system {
  title "Confirm"
  size -1 -1 118 40
  option dbu
  button "Yes ", 1, 41 23 37 15, flat
  button "No ", 2, 79 23 37 15, flat
  text "Are you sure you want to clear AJOIN?", 3, 1 1 114 20
}

on *:dialog:answer.system:sclick:1: {
  .ns ajoin clear
  .dialog -x answer.system
}

on *:dialog:answer.system:sclick:2: {
  .notice $me Ajoin was not cleared
  .dialog -x answer.system
}

menu @Highlight,@PartsJoins,@Services,@Debug,@Sockets,@Operscan {
  Clear: /clear
  Close: /window -c $active
}
