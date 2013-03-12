menu channel,menubar {
  Xbox Live Statistics:dialog $iif($dialog(xbl_stats),-v,-m xbl_stats) xbl_stats
}
dialog xbl_stats {
  title "Xbox Live Gamertag Statistics by Danneh"
  size -1 -1 157 153
  option dbu
  text "Search:", 3, 3 3 19 8
  edit "", 4, 24 2 97 10, autohs
  button "Search", 5, 123 1 31 12
  text "", 6, 3 15 151 8, center
  box "GamerTag Statistics:", 7, 3 26 151 124, hide
  icon 8, 7 34 50 50
  text "GamerTag:", 9, 62 34 27 8, hide
  text "", 10, 62 43 88 8, hide
  text "GamerScore:", 11, 62 52 31 8, hide
  text "", 12, 62 61 88 8, hide
  text "Bio:", 13, 62 77 9 8, hide
  text "", 14, 7 88 143 57, hide
  menu "File", 1
  item "Exit", 2, 1, ok
}

on *:DIALOG:xbl_stats:sclick:5: {
  if ($did(4) == $null) { noop $input(Please enter a Gamertag to search for!,o,Error!) }
  else {
    did -r $dname 8,10,12,14
    sockopen xbl_stats live.xbox.com 80
    sockmark xbl_stats $+(sockwrite -nt xbl_stats|did -ra $dname|/en-GB/profile?gamertag=|$replace($did(4),$chr(32),$+($chr(37),20)))
    did -ra $dname 6 Connecting to http://live.xbox.com..
  }
}

on *:SOCKOPEN:xbl_stats: {
  tokenize 124 $sock(xbl_stats).mark
  if ($sockerr) { $2 6 Could not connect to http://live.xbox.com | .sockclose $sockname }
  else {
    did -ra xbl_stats 6 Connected to xbox live.. Gathering stats..
    did -v xbl_stats 7,9-14
    $1 GET $+($3,$4) HTTP/1.1
    $1 Host: $sock(xbl_stats).addr
    $1 $crlf
  }
}

on *:SOCKREAD:xbl_stats: {
  tokenize 124 $sock(xbl_stats).mark
  var %xbl_stats | sockread %xbl_stats
  if ($regex(%xbl_stats,/<div class="gamerscore">(.*?)<\/div>/)) { $2 12 $regml(1) }
  if ($regex(%xbl_stats,/<img class="gamerpic" src="(.*?)" alt=".*?" \/>/)) { 
    if (!$isdir(GamerPics)) { mkdir GamerPics }
    if ($WshVbscriptDownload($regml(1), $+(GamerPics\,$4,.jpg))) { did -g xbl_stats 8 $+(GamerPics\,$4,.jpg) }
  }
}

alias -l WshVbscriptDownload {
  var %comname $+(WshVbscriptDownload,$ticks,$r(1,1000))
  .comopen %comname MSScriptControl.ScriptControl
  if ($com(%comname)) {
    var %Success $com(%comname,language,4,string,vbscript)
    inc %Success $Execute(%comname,Set MicrosoftXmlhttp = CreateObject("Microsoft.Xmlhttp"))
    inc %Success $Execute(%comname,$+(MicrosoftXmlhttp.Open "GET",$chr(44),$qt($1),$chr(44),False))
    inc %Success $Execute(%comname,MicrosoftXmlhttp.Send)
    if ($evaluate(%comname,MicrosoftXmlhttp.Status)) {
      inc %Success $Execute(%comname,set AdodbStream = CreateObject("Adodb.Stream"))
      inc %Success $Execute(%comname,AdodbStream.type = 1)
      inc %Success $Execute(%comname,AdodbStream.open)
      inc %Success $Execute(%comname,AdodbStream.write MicrosoftXmlhttp.responseBody)
      ;$iif(!$isid,echo 04 -sat Downloading $1 $bytes($evaluate(%comname,AdodbStream.Size)).suf)
      inc %Success $Execute(%comname,AdodbStream.savetofile $+($qt($2),$chr(44),2))
      inc %Success $Execute(%comname,AdodbStream.close)
      if (%Success != 10) echo -st *error* WshVbscriptDownload Download Failed!
      else {
        $iif(!$isid,echo 09 -sat Download $1 Complete)
        var %return 1
      }
    }
    .comclose %comname
    return %return
  }
}
alias -l Execute return $com($1,executestatement,3,bstr,$2-)
alias -l Evaluate {
  noop $com($1,eval,3,bstr,$2-)
  return $com($1).result
}
