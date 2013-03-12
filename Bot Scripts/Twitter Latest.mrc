on *:TEXT:!tlatest*:#: {
  .sockclose tlatest
  unset %Tlatestinfo %Tlatesthalt %tcontent %ttimestamp %tsentvia
  if ($2 == add) {
    if (!$3) { msg $chan * Error: Incorrect syntax: !tlatest add <twitter name> }
    elseif ($ini(Twitter.ini,Twitternames,$nick)) { msg $chan Your nick is already saved within my Database. Please use !tlatest on it's own. }
    else {
      writeini Twitter.ini Twitternames $nick $3-
      msg $chan Your name has been stored in my Database. You may continue to use !tlatest on it's own.
    }
  }
  if ($2 == del) {
    if (!$3) { msg $chan * Error: Please say your twitter name when using this command. }
    elseif (!$ini(Twitter.ini,Twitternames,$nick)) { msg $chan Your nick is not within my Database. Please use !tlatest add <Twitter name> OR !Tlatest <Twitter name>. }
    else {
      remini Twitter.ini Twitternames $nick
      msg $chan Twitter info for $3 has been removed from my Database.
    }
  }
  elseif (!$ini(Twitter.ini,Twitternames,$nick)) && (!$2) {
    msg $chan Sorry $+($nick,$chr(44)) Your Twitter name has not been stored in my Database. Please add it using !tlatest add <Twitter name>
  }
  elseif ($ini(Twitter.ini,Twitternames,$nick)) && (!$2) {
    sockopen tlatest twitter.com 80
    sockmark tlatest msg $chan $readini(Twitter.ini,Twitternames,$nick)
  }
  elseif ($sock(tlatest)) { .sockclose tlatest | msg $chan Please try again. }
  else {
    sockopen tlatest twitter.com 80
    sockmark tlatest msg $chan $2
  }
}
on *:SOCKOPEN:tlatest: {
  if ($sockerr) { $gettok($sock(tlatest).mark,1-2,32) Error connecting to server. }
  else {
    var %a = sockwrite -n $sockname
    %a GET / $+ $gettok($sock(tlatest).mark,3,32) HTTP/1.0
    %a Host: twitter.com
    %a $crlf
  }
}
on *:SOCKREAD:tlatest: {
  var %tlatest | sockread -fn %tlatest
  if (<span class="entry-content"> isin %tlatest) && (!%tcontent) { set %tcontent on | set %Tlatestinfo $addtok(%Tlatestinfo,$remove($htmlfree(%tlatest),$chr(9)),32) }
  elseif (<span class="published timestamp" isin %tlatest) && (!%ttimestamp) { set %ttimestamp on | set %Tlatestinfo $addtok(%Tlatestinfo,Sent: $htmlfree(%tlatest),32) }
  elseif (<span>via <a href=" isin %tlatest) && (!%tsentvia) { 
    set %tsentvia on
    set %Tlatestinfo $addtok(%Tlatestinfo,Sent via: $remove($htmlfree(%tlatest),via),32)
    $gettok($sock(tlatest).mark,1-2,32) $+(,$gettok($sock(tlatest).mark,3,32)) $+ 's Latest tweet: $replace(%Tlatestinfo,&lt;,$chr(60),&gt;,$chr(62),&quot;,$chr(34))
    .sockclose $sockname 
  }
}
