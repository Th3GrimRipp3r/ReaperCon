menu channel,menubar {
  $iif($dialog(DamDevilQDB),Quote Database Script Open Already!,DamDevil Quote Database) $+ :dialog $iif($dialog(DamDevilQDB),-v,-m DamDevilQDB) DamDevilQDB
}
dialog DamDevilQDB {
  title "DamDevil Quote Database by Peer"
  size -1 -1 238 167
  option dbu
  list 1, 3 14 232 131, size
  button "Randomize", 2, 55 151 37 12
  button "Show Channel", 3, 99 151 37 12
  button "Ok/Cancel", 4, 143 151 37 12, ok cancel
  text "", 5, 4 4 230 8
}
on *:DIALOG:DamDevilQDB:sclick:2-4: {
  if ($did == 2) { 
    did -r $dname 1,5
    sockopen DamDevilQDB quote.damdevil.org 80
    sockmark DamDevilQDB $+(did -ra $dname,|,did -a $dname,|,/index.php?p=random)
  }
}
on *:SOCKOPEN:DamDevilQDB: {
  tokenize 124 $sock(DamDevilQDB).mark
  if ($sockerr) { $1 5 Error: Could not connect to the server.. | .sockclose $sockname }
  else {
    var %a = sockwrite -n $sockname
    %a GET $3 HTTP/1.1
    %a Host: $sock(DamDevilQDB).addr
    %a $crlf
  }
}
on *:SOCKREAD:DamDevilQDB: {
  tokenize 124 $sock(DamDevilQDB).mark
  var %DamDevilQDB | sockread %DamDevilQDB
  if ($regex(%DamDevilQDB,/<p class="qtitle"><a href=".\/\?.*?"><b><u>(.*?)<\/u><\/b><\/a>/)) { $1 5 Quote Number: $regml(1) }
  elseif ($regex(%DamDevilQDB,/<p class="quote">(.*?)</p> { 
    $2 1 $replace(%DamDevilQDB,&lt;,$chr(60),&gt;,$chr(62),<br />,$crlf)
  }
  elseif (</p> isin %DamDevilQDB) { .sockclose $sockname }
}
