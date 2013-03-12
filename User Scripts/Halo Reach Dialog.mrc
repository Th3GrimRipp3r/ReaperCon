menu Channel,status,menubar {
  Halo Reach Stats:dialog $iif($dialog(haloreach),-v,-m haloreach) haloreach
}
dialog haloreach {
  title "Halo Reach Stats"
  size -1 -1 162 247
  option dbu
  text "Search:", 4, 3 3 19 8
  edit "", 5, 23 2 101 10
  button "Search", 6, 126 1 30 12
  box "Stats:", 7, 3 18 156 214
  text "Current:", 8, 6 26 21 8
  text "Next:", 10, 6 38 14 8
  text "Level Points:", 12, 6 50 31 8
  text "Games Played:", 14, 6 62 36 8
  text "Playtime:", 16, 6 74 22 8
  text "Kills:", 18, 6 86 11 8
  text "Deaths:", 9, 6 98 19 8
  text "Assists:", 11, 6 110 19 8
  text "Kill/Death:", 13, 6 122 25 8
  text "Kills/Game:", 15, 6 134 26 8
  text "Deaths/Game:", 17, 6 146 35 8
  text "Kills/Hour:", 19, 6 158 24 8
  text "Death/Hour:", 20, 6 170 30 8
  text "Medals:", 21, 6 182 19 8
  text "Medals/Game:", 22, 6 194 34 8
  text "Medals/Hour:", 23, 6 206 32 8
  link "", 24, 6 218 148 8
  text "", 25, 31 26 123 8
  text "", 26, 24 38 130 8
  text "", 27, 41 50 113 8
  text "", 28, 46 62 108 8
  text "", 29, 32 74 122 8
  text "", 30, 21 86 133 8
  text "", 31, 29 98 125 8
  text "", 32, 30 110 124 8
  text "", 33, 36 122 118 8
  text "", 34, 37 134 117 8
  text "", 35, 46 146 108 8
  text "", 36, 35 158 119 8
  text "", 37, 41 170 113 8
  text "", 38, 30 182 124 8
  text "", 39, 45 194 109 8
  text "", 40, 44 206 110 8
  button "Ok", 41, 63 234 37 12, ok
  menu "File", 1
  item "Clear", 2, 1
  item "Exit", 3, 1
}
on *:DIALOG:haloreach:sclick:6,24: {
  if ($did == 6) {
    if ($did(5).text == $null) { noop $input(Please enter a Gamertag to search.,o) }
    else {
      if ($sock(halor)) sockclose halor
      did -r $dname 24-40
      sockopen halor www.bungie.net 80
      sockmark halor $+(/stats/reach/careerstats/default.aspx?player=,$&
        $replace($did(5).text,$chr(32),$+(%,20)),&vc=3)
    }
  }
  if ($did == 24) { run $+(www.bungie.net/stats/reach/careerstats/default.aspx?player=,$replace($did(5).text,$chr(32),$+(%,20)),&vc=3) }
}
on *:sockopen:halor: {
  sockwrite -n halor GET $sock(halor).mark HTTP/1.1
  sockwrite -n halor Host: $+($sock(halor).addr,$str($crlf,2))
}
on *:sockread:halor: {
  var %halor | sockread %halor
  if ($regex(%halor,/<h1.+>(Not Found)<\/.+>/)) { 
    noop $input(Sorry Player $regml(1),o)
    sockclose halor
  }
  if ($regex(%halor,/<span.+>(.+)<\/span.+>(Next:.+)&nbsp;&nbsp;(.+)<\/span>/)) {
    did -a haloreach 25 $regml(1) 
    did -a haloreach 26 $remove($regml(2),Next:)
    did -a haloreach 27 $remove($regml(3),$chr(40),$chr(41))
  }
  if ($regex(%halor,/<li class=.+>(\d+)<\/li>/)) { did -a haloreach 28 $regml(1) }
  if ($regex(%halor,/<strong>(.+)<\/.+>(.+)<\/span><\/li>/)) {
    hinc -mu4 halor c 1
    if ($hget(halor,c) isnum 1-12) { hadd -mu4 halor $calc($hget(halor,c) +2) $regml(1) $regml(2) }
    if ($hget(halor,c) = 12) {
      var %a = 1
      var %b = $calc(%a + 2) 
      while (%a <= 12) {
        did -a haloreach $calc(28 + %a) $gettok($hget(halor,%b),2-,32)
        inc %a
        inc %b
      }
      did -a haloreach 24 Stats for: $did(haloreach,5).text
      sockclose halor
    }
  }
}
