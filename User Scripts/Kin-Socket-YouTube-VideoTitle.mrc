; Kin's YouTube Video Title in Local Echo for mSL / mIRC
; KinKinnyKith irc.GeekShed.net #ReaperCon

; A simple, local echo of the title of YouTube videos seen linked in a message.

; 2013-03-25 v1.0 

; --------- Events

on *:TEXT:*:#:{
  ; Skip if already busy looking up a video
  if ($sock(Kin.YouTubeID.GetTitle)) { return } 

  ; Regex to snag video ID
  if ($regex(YouTubeID,$1-,/(?:youtu(?:\.be\/|be\.com(?:\/v\/|\S+?[?&]v=)))(\S{11})/)) {
    var %id $regml(YouTubeID,1)
    var %callback !echo $iif($chan,$v1,$nick)
    Kin.YouTubeID.GetTitle %id %callback
  }
}

; -------- Alias

alias Kin.YouTubeID.GetTitle {
  var %timeoutseconds 12

  var %sock Kin.YouTubeID.GetTitle, %ID $1, %callback $2-
  if (!%callback) || (!$istok(say msg echo notice describe,$replace($gettok(%callback,1,32),!,),32)) { %callback = !echo -ta }

  ; Simple check to see if a legitimate YouTube Video ID was passed to the alias
  if ($len($1) != 11) { return }

  Kin.YouTubeID.GetTitle.Timeout 

  .hadd -m %sock Host gdata.youtube.com
  .hadd %sock ID %ID
  .hadd %sock Path /feeds/api/videos/ $+ %ID $+ ?v=2&prettyprint=false&alt=atom&fields=title
  .hadd %sock Callback %callback
  .timerKin.YouTubeID.GetTitle.Timeout 1 %timeoutseconds Kin.YouTubeID.GetTitle.Timeout
  sockopen %sock $hget(%sock,Host) 80
}

alias -l Kin.YouTubeID.GetTitle.Timeout {
  sockclose Kin.YouTubeID.GetTitle
  .timerKin.YouTubeID.GetTitle.Timeout off
  if $hget(Kin.YouTubeID.GetTitle) { .hfree Kin.YouTubeID.GetTitle }
}

alias -l Kin.YouTubeID.GetTitle.Close {
  var %sock $1
  var %callback $hget(%sock,Callback), %ID $hget(%sock,ID), %title $hget(%sock,Title)
  if (%title) && (%callback) { 
    %callback (YouTube) $+($chr(3),05,%id,$chr(15)) => $+($chr(3),07,%title,$chr(15)) <=
  }
  Kin.YouTubeID.GetTitle.Timeout  
}

; -------- Socket

on *:SOCKOPEN:Kin.YouTubeID.*: {
  var %host $hget($sockname,Host), %path $hget($sockname,Path)

  sockwrite -nt $sockname GET %path HTTP/1.0
  sockwrite -nt $sockname HOST: %host
  sockwrite -nt $sockname $crlf
}

on *:SOCKREAD:Kin.YouTubeID.*: {
  if ($sockerr) { !echo -tsg 04Socket Error in SOCKREAD - $sock($sockname).wserr -  $sock($sockname).wsmsg | .sockclose $sockname | halt }

  var %SR
  while ($sock($sockname).rq) {
    sockread -f %SR
    if ($regex($sockname,%SR,/<title>([^>]+)<\/title>/i)) {
      .hadd -m $sockname Title $regml($sockname,1)
      Kin.YouTubeID.GetTitle.Close $sockname
    }
  }
}

on *:SOCKCLOSE:Kin.YouTubeID.*: { Kin.YouTubeID.GetTitle.Close $sockname }
