menu channel,status,menubar {
  Battlefield 3 Statistics:dialog $iif($dialog(BF3_Stats),-v,-m BF3_Stats) BF3_Stats
}

dialog BF3_Stats {
  title "BF3 Statistics by GrimReaper"
  size -1 -1 103 170
  option dbu
  combo 4, 2 2 100 50, size drop
  edit "", 5, 2 15 60 10, autohs
  button "Search", 6, 64 14 37 12
  box "Statistics:", 7, 2 27 100 141
  text "Rank:", 8, 5 37 14 8
  text "Score:", 9, 5 48 16 8
  text "Time:", 10, 5 59 13 8
  text "Score/Minute:", 11, 5 70 34 8
  text "Rank Score:", 12, 5 81 29 8
  text "Kills:", 13, 5 92 11 8
  text "Deaths:", 14, 5 103 19 8
  text "K/D Ratio:", 15, 5 114 25 8
  text "Accuracy:", 16, 5 125 24 8
  text "Rounds Played:", 17, 5 136 38 8
  text "Rounds Finished:", 18, 5 147 41 8
  text "Skill:", 19, 5 158 11 8
  text "", 20, 23 37 77 8, right
  text "", 21, 25 48 75 8, right
  text "", 22, 22 59 78 8, right
  text "", 23, 44 70 56 8, right
  text "", 24, 39 81 61 8, right
  text "", 25, 21 92 79 8, right
  text "", 26, 29 103 71 8, right
  text "", 27, 36 114 64 8, right
  text "", 28, 33 125 67 8, right
  text "", 29, 47 136 53 8, right
  text "", 30, 49 147 51 8, right
  text "", 31, 22 158 78 8, right
  menu "File", 1
  item "Clear all", 2, 1
  item "Exit", 3, 1
}

on *:DIALOG:BF3_Stats:init:*: {
  didtok $dname 4 124 PC|Xbox 360|Playstation 3
}
on *:DIALOG:BF3_Stats:sclick:6: {
  if ($did(5) == $null) && ($istok(PC|Xbox 360|Playstation 3,$did(4).seltext,124)) { noop $input(Please enter a Username to Search for..,o,Error!) }
  elseif ($did(5) != $null) && (!$istok(PC|Xbox 360|Playstation 3,$did(4).seltext,124)) { noop $input(Please select a Platform from the Drop Down..,o,Error!) }
  elseif ($did(5) == $null) && (!$istok(PC|Xbox 360|Playstation 3,$did(4).seltext,124)) { noop $input(Please select a Platform and Enter a Username.,o,Error!) }
  else {
    var %a = $+(/stats_,$iif($did(4).seltext == PC,PC,$iif($did(4).seltext == Xbox 360,360,PS3)),$did(5))
    sockopen BF3_Stats bf3stats.com 80
    sockmark BF3_Stats %a did -ra $dname
  }
}
on *:SOCKOPEN:BF3_Stats: {
  tokenize 32 $sock(BF3_Stats).mark
  if ($sockerr) { noop $input(There was an Error connecting to BF3Stats.com..,o,Error!) }
  else {
    var %a = sockwrite -nt $sockname
    %a GET $1 HTTP/1.0
    %a Host: $sock(BF3_Stats).addr
    %a User-Agent: Opera 9.3
    %a $crlf
  }
}
on *:SOCKREAD:BF3_Stats: {
  tokenize 32 $sock(BF3_Stats).mark
  var %BF3_Stats | sockread %BF3_Stats
  if ($regex(%BF3_Stats,/<dt>Rank<\/dt><dd>(.*?)<\/dd>/Si)) { $2- 20 $regml(1) }
}
