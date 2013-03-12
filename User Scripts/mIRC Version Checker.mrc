menu channel,nicklist,status {
  mIRC Version Check:dialog $iif($dialog(mirccheck),-v,-m mirccheck) mirccheck
}
dialog mirccheck {
  title "mIRC Version Check!!"
  size -1 -1 122 63
  option dbu
  text "", 3, 3 3 116 24, center
  button "Ok/Cancel", 5, 43 47 39 12, cancel
  button "Check", 6, 18 31 39 12
  button "Run mIRC.com", 7, 68 31 39 12, hide
  menu "File", 1
  item "Exit", 2, 1, ok
}
on *:DIALOG:mirccheck:init:*: {
  did -a $dname 3 Please select Check to see whether you have the Up-To-Date version of mIRC!
}
on *:DIALOG:mirccheck:sclick:6,7: {
  if ($did == 6) {
    did -ra $dname 3 Connecting to http://www.mIRC.com/ to check latest version!
    sockopen mirccheck1 www.mirc.com 80
    sockmark mirccheck1 /get.html $version did -ra $dname 3
  }
  if ($did == 7) { //run http://www.mirc.com/get.html }
}
on *:SOCKOPEN:mirccheck1: {
  tokenize 32 $sock(mirccheck1).mark
  if ($sockerr) { $3- Unable to connect to the server! }
  else {
    var %a = sockwrite -n $sockname
    %a GET $1 HTTP/1.0
    %a Host: $sock($sockname).addr
    %a $crlf
  }
}
on *:SOCKREAD:mirccheck1: {
  tokenize 32 $sock($sockname).mark
  var %mirccheck | sockread %mirccheck
  if ($regex(%mirccheck,/The latest version of mIRC is <strong>mIRC v(.*?)<\/strong>/Si)) {
    if ($2 < $regml(1)) { $3- Please click on "Run mIRC.com" to update your mIRC! Your version is $+($2,$chr(44)) The latest version is $regml(1) | did -v mirccheck 7 }
    elseif ($2 == $regml(1)) { $3- Your mIRC is up to date.. No need to update! }
  }
}
