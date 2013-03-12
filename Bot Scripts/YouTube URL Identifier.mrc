; ********** YOUTUBE TITLE SCRIPT BY DANNEH AND ZETACON ****************************
on *:text:*youtube.com/watch?v=*:#SPUNet,#Hell,#GrimsBot,#Twizted-Reality: {
  if (!$sock(youtube)) {
    .unset %ytube*
    noop $regex($strip($1-),http:\/\/.*youtube.*\/watch\?v=(.{11})&?.*)
    sockopen youtube www.youtube.com 80 | sockmark youtube msg # $regml(1)
  }
}
on *:sockopen:youtube: {
  sockwrite -n $sockname GET $+(/watch?v=,$gettok($sock(youtube).mark,3,32)) HTTP/1.0
  sockwrite -n $sockname Host: www.youtube.com
  sockwrite -n $sockname $crlf
  sockwrite -n $sockname User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12 ( .NET CLR 3.5.30729)
  sockwrite -n $sockname $crlf

}
on *:sockread:youtube: {
  var %x | sockread %x
  if ($regex(%x,<meta name="title" content="(.+)">)) { set %ytubetitle $regml(1) }
  elseif (<span class="watch-view-count"> isin %x) { set %ytubeviewson on }
  elseif (%ytubeviewson == on) { set %ytubeviews %x | unset %ytubeviewson }
  ;elseif (<span id="eow-date-short" class="watch-video-date" isin %x) { set %date.found on }
  ;elseif (%date.found == on) { set %ytubedate %x | unset %date.found }
  elseif ($regex(%x,<span id="eow-date" class="watch-video-date" >(.*?)<\/span>)) { set %ytubedate $regml(1) }
  elseif ($regex(%x,<span class="likes">(.*?)<\/span> likes.*?<span class="dislikes">(.*?)<\/span> dislikes)) { set %ytubelike $regml(1) | set %ytubedislike $regml(2) }
  elseif ($regex(%x,<a id="watch-username" class="inline-block" rel="author" href=".*?"><strong>(.*?)<\/strong><\/a>)) || ($regex(%x,<a href="\/user\/.*?" class="yt-user-name author" rel="author" dir="ltr">(.*?)<\/a>)) { set %ytubeuser $regml(1) }
}
on *:sockclose:youtube: {
  $gettok($sock(youtube).mark,1-2,32) ( $+ 1,0You0,4Tube $+ ) 14Title:7 $replace(%ytubetitle,&#39;,$chr(39),&amp;,$chr(38),&quot;,$chr(34)) $+  14Views:10 $remove(%ytubeviews,<strong>,</strong>) $+  ( $+ %ytubelike likes / %ytubedislike dislikes) 14By:10 %ytubeuser $+  {14Uploaded on:10 %ytubedate $+  $+ }
}
; ************************************************
